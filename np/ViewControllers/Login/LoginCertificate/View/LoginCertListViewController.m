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

@interface LoginCertListViewController ()

@end

@implementation LoginCertListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@""];
    [self updateUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

- (IBAction)gotoNB {
}
- (IBAction)gotoFAQ {}

- (IBAction)gotoTelInquiry {}

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
        
        EccEncryptor * ec   = [EccEncryptor sharedInstance];
        NSString * password = [ec makeDecNoPadWithSeedkey:pw];
        
        LoginCertController * controller = [[LoginCertController alloc] init];
        [controller addTargetForLoginResponse:self action:@selector(succeedToLogin:)];
        BOOL succeed = [controller checkPasswordOfCert:password];
        
        
        if (succeed) {
            
            [util saveCertPasswordFailedTimes:0];
            
        } else {
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

- (void)succeedToLogin:(BOOL)isSucceeded {
    if (isSucceeded) {
        [[[LoginUtil alloc] init] showMainPage];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_GOTO_SELF_IDENTIFY:
        {
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

#pragma mark - Refrest View
- (void)refreshView {
    
    CertInfo * certInfo = [[[LoginUtil alloc] init] getCertToLogin];
    
    if (certInfo) {
        
        self.certView.hidden = NO;
        
        NSDateFormatter * formatter = [StatisticMainUtil getDateFormatterWithStyle:@"yyyy/MM/dd"];
        self.certName.text      = certInfo.subjectDN2;
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
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeNoticeTextField];
}

@end
