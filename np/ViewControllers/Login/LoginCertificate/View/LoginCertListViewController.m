//
//  LoginCertListViewController.m
//  np
//
//  Created by Infobank2 on 10/12/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginCertListViewController.h"
#import "EccEncryptor.h"
#import "LoginUtil.h"
#import "LoginCertController.h"
#import "StatisticMainUtil.h"
#import "LoginSettingsViewController.h"
#import "StorageBoxUtil.h"
#import "MainPageViewController.h"
#import "CertManager.h"
#import "CustomerCenterUtil.h"
#import "BTWCodeguard.h"

@interface LoginCertListViewController ()

@end

@implementation LoginCertListViewController

@synthesize descLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@""];
    [self updateUI];
    [descLabel sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoCertCenter {
    [[[LoginUtil alloc] init] gotoCertCentre:self.navigationController];
}

- (IBAction)gotoLoginSettings {
    [[[LoginUtil alloc] init] gotoLoginSettings:self.navigationController];
}

#pragma mark - Certificate Verification
- (IBAction)clickOnCert:(UITapGestureRecognizer *)sender {
    
    LoginUtil * util = [[LoginUtil alloc] init];
    [util showSecureKeypadInParent:self topBar:@"공인인증서 로그인" title:@"비밀번호 입력"
                        textLength:20
                        doneAction:@selector(confirmPassword:) cancelAction:nil];
}

- (void)confirmPassword:(NSString *)pw {
    
    LoginUtil * util        = [[LoginUtil alloc] init];
    NSInteger failedTimes   = [util getCertPasswordFailedTimes];
    
    NSString * alertMessage = nil;
    NSInteger tag           = ALERT_DO_NOTHING;
    
    if (failedTimes >= 5) {
        
        alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 인증서 사용이 불가능합니다. 가까운 NH농협 영업점을 방문하셔서 공인 인증서 비밀번호를 재설정해주세요.";
        tag             = ALERT_GOTO_SELF_IDENTIFY;
        
    } else {
        
        [self startIndicator];
        
        EccEncryptor * ec   = [EccEncryptor sharedInstance];
        NSString * password = [ec makeDecNoPadWithSeedkey:pw];
        
        BOOL succeed = [self checkPasswordOfCert:password];
        
        
        if (succeed) {
            
            [util saveCertPasswordFailedTimes:0];
            
        } else {
            
            [self stopIndicator];
            
            failedTimes++;
            [util saveCertPasswordFailedTimes:failedTimes];
            if (failedTimes >= 5) {
                alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 인증서 사용이 불가능합니다. 가까운 NH농협 영업점을 방문하셔서 공인 인증서 비밀번호를 재설정해주세요.";
                tag             = ALERT_GOTO_SELF_IDENTIFY;
                
            } else {
                
                alertMessage = [NSString stringWithFormat:@"입력하신 비밀번호가 일치하지 않습니다.\n비밀번호를 확인하시고 이용해주세요.\n비밀번호 %d 회 오류입니다.", (int)failedTimes];
            }
        }
    }

    if (alertMessage) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                        delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alert.tag = tag;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_GOTO_SELF_IDENTIFY:
        {
            [[[LoginUtil alloc] init] saveCertPasswordFailedTimes:0];
            exit(0);
            break;
        }
        case ALERT_DO_NOTHING:
        {
            if (buttonIndex == 1) {
                [[[LoginUtil alloc] init] gotoCertCentre:self.navigationController];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Server Connection

- (BOOL)checkPasswordOfCert:(NSString *)password {
    
    CertInfo * certInfo = [[[LoginUtil alloc] init] getCertToLogin];
    [[CertManager sharedInstance] setCertInfo:certInfo];
    
    int rc = [[CertManager sharedInstance] checkPassword:password];
    
    if(rc == 0) {
        
        NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
        
        NSString * strTbs       = @"abc"; //서명할 원문
        NSString * user_id      = [prefs stringForKey:RESPONSE_CERT_UMS_USER_ID]; //@"150324104128890";
        NSString * crmMobile    = [prefs stringForKey:RESPONSE_CERT_CRM_MOBILE];;//@"01540051434";
        
        NSLog(@"user_id: %@", user_id);
        NSLog(@"crmMobile: %@", crmMobile);
        
        [[Codeguard sharedInstance] setAppName:@"NHSmartPush"];
        [[Codeguard sharedInstance] setAppVer:[CommonUtil getAppVersion]];
        [[Codeguard sharedInstance] setChallengeRequestUrl:[NSString stringWithFormat:@"%@CodeGuard/check.jsp", SERVER_URL]];
        NSString *token = [[Codeguard sharedInstance] requestAndGetToken];
        
        [[CertManager sharedInstance] setTbs:strTbs];
        NSString *sig = [CommonUtil getURLEncodedString:[[CertManager sharedInstance] getSignature]];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_LOGIN_CERT];
        
        NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
        [requestBody setObject:strTbs forKey:REQUEST_CERT_SSLSIGN_TBS];
        [requestBody setObject:sig forKey:REQUEST_CERT_SSLSIGN_SIGNATURE];
        [requestBody setObject:@"1" forKey:REQUEST_CERT_LOGIN_TYPE];
        
        [requestBody setObject:user_id forKey:@"user_id"];
        [requestBody setObject:crmMobile forKey:@"crmMobile"];
        
        NSString *bodyString = [CommonUtil getBodyString:requestBody];
        
        HttpRequest *req = [HttpRequest getInstance];
        [req setDelegate:self selector:@selector(certInfoResponse:)];
        [req requestUrl:url bodyString:bodyString token:token];
        
        return YES;
    }
    
    return NO;
}

- (void)certInfoResponse:(NSDictionary *)response {
    
    NSLog(@"response: %@", response);
    
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        NSDictionary * list     = (NSDictionary *)(response[@"list"]);
        NSArray * accounts      = (NSArray *)(list[@"sub"]);
        
        int numberOfAccounts    = (int)[accounts count];
        BOOL hasAccounts        = NO;
        
        if (numberOfAccounts > 0) {
            
            NSMutableArray * accountNumbers = [NSMutableArray array];
            for (NSDictionary * accountDic in accounts) {
                
                NSString * account = (NSString *)(accountDic[@"UMSA360101_OUT_SUB.account_number"]);
                if (account && ![account isEqualToString:@""]) {
                    [accountNumbers addObject:account];
                }
            }
            
            if ([accountNumbers count] > 0) {
                hasAccounts = YES;
                [[[LoginUtil alloc] init] saveAllAccounts:[accountNumbers copy]];
                [[[LoginUtil alloc] init] showMainPage];
            }
        }
        
        if (!hasAccounts) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"계좌목록 없습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
        }
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Refrest View
- (void)refreshView {
    
    CertInfo * certInfo = [[[LoginUtil alloc] init] getCertToLogin];
    
    if (certInfo) {
        
        self.certView.hidden = NO;
        
        NSDateFormatter * formatter = [StatisticMainUtil getDateFormatterWithStyle:@"yyyy/MM/dd"];
        self.certName.text      = [certInfo.subjectDN2 substringFromIndex:3];
        self.certIssuer.text    = certInfo.issuer;
        self.certType.text      = certInfo.policy;
        self.issueDate.text     = [formatter stringFromDate:certInfo.dtNotBefore];
        self.expiryDate.text    = [formatter stringFromDate:certInfo.dtNotAfter];
        
    } else {
        
        self.certView.hidden = YES;
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"등록된 공인인증서가 없습니다.\n공인인증센터로 이동하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        alert.tag = ALERT_DO_NOTHING;
        [alert show];
    }
}

- (void)updateUI {
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeNoticeTextField color:TEXT_FIELD_BORDER_COLOR_FOR_LOGIN_NOTICE];
}

#pragma mark - Footer

- (IBAction)gotoNB {
    [[CustomerCenterUtil sharedInstance] gotoNotice];
}

- (IBAction)gotoTelInquiry {
    [[CustomerCenterUtil sharedInstance] gotoTelEnquiry];
}

- (IBAction)gotoFAQ {
    [[CustomerCenterUtil sharedInstance] gotoFAQ];
}

@end
