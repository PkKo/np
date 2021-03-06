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
#import "ServiceDeactivationController.h"

@interface LoginCertListViewController ()

@end

@implementation LoginCertListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@""];
    self.loginMethod = LOGIN_BY_CERTIFICATE;
    [self updateUI];
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
    [util showSecureKeypadInParent:self topBar:@"공인인증서" title:@"비밀번호 입력"
                        textLength:20
                        doneAction:@selector(confirmPassword:) cancelAction:nil];
}

- (void)confirmPassword:(NSString *)pw {
    
    LoginUtil * util        = [[LoginUtil alloc] init];
    NSInteger failedTimes   = [util getCertPasswordFailedTimes];
    
    NSString * alertMessage = nil;
    NSInteger tag           = ALERT_DO_NOTHING;
    
    if (failedTimes >= 5) {
        
        alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 서비스가 제한됩니다. 확인 후 다시 거래하시기 바랍니다.";
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
                alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 서비스가 제한됩니다. 확인 후 다시 거래하시기 바랍니다.";
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
        NSString * user_id      = [CommonUtil decrypt3DES:[prefs stringForKey:RESPONSE_CERT_UMS_USER_ID] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
        NSString * crmMobile    = [LoginUtil getDecryptedCrmMobile];
        
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
        [requestBody setObject:crmMobile forKey:REQUEST_CERT_CRM_MOBILE];
        
        NSString *bodyString = [CommonUtil getBodyString:requestBody];
        
        HttpRequest *req = [HttpRequest getInstance];
        [req setDelegate:self selector:@selector(loginResponse:)];
        [req requestUrl:url bodyString:bodyString token:token];
        
        return YES;
    }
    
    return NO;
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
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"현재 저장된 인증서가 없습니다. 인증서 가져오기를 진행해주세요." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        alert.tag = ALERT_DO_NOTHING;
        [alert show];
    }
}

- (void)resizeNoticeContent {
    
    CGFloat screenWidth             = [[UIScreen mainScreen] bounds].size.width;
    CGRect fakeNoticeTextFieldFrame = self.fakeNoticeTextField.frame;
    CGFloat contentWidth            = screenWidth - self.fakeNoticeTextField.superview.frame.origin.x * 2  - (self.noteContent.frame.origin.x - fakeNoticeTextFieldFrame.origin.x) - 5;
    
    CGRect noteContentRect      = self.noteContent.frame;
    noteContentRect.size.width  = contentWidth;
    [self.noteContent setFrame:noteContentRect];
    [self.noteContent sizeToFit];
    noteContentRect             = self.noteContent.frame;
    
    CGRect noteAsteriskRect    = self.noteAsterisk.frame;
    noteAsteriskRect.origin.y  = noteContentRect.origin.y + 3;
    [self.noteAsterisk setFrame:noteAsteriskRect];
    
    fakeNoticeTextFieldFrame.size.height =  noteContentRect.origin.y - fakeNoticeTextFieldFrame.origin.y + noteContentRect.size.height + 5;
    
    [self.fakeNoticeTextField setFrame:fakeNoticeTextFieldFrame];
}

- (void)resizeContainerScrollView {
    
    CGFloat screenHeight                    = [[UIScreen mainScreen] bounds].size.height;
    CGRect containerScrollViewFrame         = self.containerScrollView.frame;
    containerScrollViewFrame.size.height    = screenHeight - self.containerScrollView.frame.origin.y;
    
    [self.containerScrollView setFrame:containerScrollViewFrame];
    
    CGRect containerViewRect = self.containerView.frame;
    if (containerViewRect.size.height <= containerScrollViewFrame.size.height) {
        containerViewRect.size.height = containerScrollViewFrame.size.height - 20;
        [self.containerView setFrame:containerViewRect];
        [self.containerScrollView setScrollEnabled:NO];
    }
    else
    {
        [self.containerScrollView setScrollEnabled:YES];
    }
    
    [self.containerScrollView setContentInset:UIEdgeInsetsZero];
    [self.containerScrollView setContentSize:self.containerView.frame.size];
}

- (void)updateUI {
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeNoticeTextField color:TEXT_FIELD_BORDER_COLOR_FOR_LOGIN_NOTICE];
    [self resizeContainerScrollView];
    [self resizeNoticeContent];
}

@end
