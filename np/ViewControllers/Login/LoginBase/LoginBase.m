//
//  LoginBase.m
//  np
//
//  Created by Infobank2 on 11/24/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginBase.h"
#import "ServiceDeactivationController.h"
#import "NewTermsOfUseViewController.h"
#import "StatisticMainUtil.h"
#import "CustomerCenterUtil.h"
#import "BTWCodeguard.h"

@interface LoginBase ()

@end

@implementation LoginBase

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CERT, ACCOUNT, PIN, PAT Login
- (void)loginResponse:(NSDictionary *)response {
    
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        NSString * isRegistered = (NSString *)response[@"reg_yn"];
        
        if ([isRegistered isEqualToString:IS_REGISTERED_NO]) {
            [[ServiceDeactivationController sharedInstance] showForceToDeactivateAlert];
            return;
        }
        
        if ([isRegistered isEqualToString:IS_REGISTERED_F]) {
            
            NSString *message = (NSString *)response[RESULT_MESSAGE2];
            
            [[ServiceDeactivationController sharedInstance] showForceToDeactivateALertWithMessage:message];
            return;
        }
        
        LoginUtil * util        = [[LoginUtil alloc] init];
        [util saveAllAccountsAndAllTransAccounts:response];
        
        NSString * isLatestTermsOfUse = (NSString *)response[@"provision_check"];
        
        if ([isLatestTermsOfUse isEqualToString:IS_LATEST_TERMS_OF_USE_YES]) {
            
            [util showMainPage];
            
        } else {
            NewTermsOfUseViewController *termsOfUseView = [[NewTermsOfUseViewController alloc] initWithNibName:@"NewTermsOfUseViewController" bundle:nil];
            ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:termsOfUseView];
            [self.navigationController pushViewController:eVC animated:YES];
        }
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        BOOL isPINPAT = (self.loginMethod == LOGIN_BY_PATTERN || self.loginMethod == LOGIN_BY_SIMPLEPW);
        
        
        if (!isPINPAT) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil
                                                      cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
        } else {
            
            NSInteger tag = ALERT_DO_NOTHING;
            
            if([[response objectForKey:RESULT] isEqualToString:RESULT_PIN_EXCEED_5_TIMES]
               || [[response objectForKey:RESULT] isEqualToString:RESULT_PAT_EXCEED_5_TIMES]) {
                
                tag = ALERT_GOTO_SELF_IDENTIFY;
            }
            
            [self showAlert:message tag:tag];
        }
    }
}

- (void)showAlert:(NSString *)alertMessage tag:(int)tag {
    NSLog(@"handle by subclass");
}

#pragma mark - PIN/PAT Server Connection
#pragma mark - Password Reset
- (void)resetPasswordOnServer:(NSString *)pw {
    
    NSString * inputPassword    = [[[LoginUtil alloc] init] getEncryptedPassword:pw];
    NSString * loginType        = self.loginMethod == LOGIN_BY_PATTERN ? @"PAT" : @"PIN";
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_LOGIN_PINPAT_RESET];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setObject:loginType forKey:@"loginType"];
    [requestBody setObject:inputPassword forKey:@"enc_pw_code"];
    
    NSString *bodyString = [CommonUtil getBodyString:requestBody];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(resetPassword:)];
    [req requestUrl:url bodyString:bodyString];
}

- (BOOL)resetPassword:(NSDictionary *)response {
    NSLog(@"handle by subclass");
    return YES;
}

#pragma mark - Password Validation & Account List
- (void)validateLoginPassword:(NSString *)pw checkPasswordSEL:(SEL)checkPasswordSEL {
    [self checkPasswordOnServerSide:pw responseAction:checkPasswordSEL];
}

- (void)checkLoginPassword:(NSDictionary *)response {
    NSLog(@"handle by subclass");
}

- (void)validateLoginPasswordAndGetAccountList:(NSString *)pw {
    [self checkPasswordOnServerSide:pw responseAction:@selector(loginResponse:)];
}

- (void)checkPasswordOnServerSide:(NSString *)pw responseAction:(SEL)responseAction {
    
    NSString * inputPassword = [[[LoginUtil alloc] init] getEncryptedPassword:pw];
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    
    NSString * loginType    = self.loginMethod == LOGIN_BY_PATTERN ? @"PAT" : @"PIN";
    NSString * user_id      = [CommonUtil decrypt3DES:[prefs stringForKey:RESPONSE_CERT_UMS_USER_ID] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
    NSString * crmMobile    = [LoginUtil getDecryptedCrmMobile];
    
    [[Codeguard sharedInstance] setAppName:@"NHSmartPush"];
    [[Codeguard sharedInstance] setAppVer:[CommonUtil getAppVersion]];
    [[Codeguard sharedInstance] setChallengeRequestUrl:[NSString stringWithFormat:@"%@CodeGuard/check.jsp", SERVER_URL]];
    NSString *token = [[Codeguard sharedInstance] requestAndGetToken];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_LOGIN_PINPAT];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setObject:user_id          forKey:@"user_id"];
    [requestBody setObject:crmMobile        forKey:REQUEST_CERT_CRM_MOBILE];
    [requestBody setObject:loginType        forKey:@"loginType"];
    [requestBody setObject:inputPassword    forKey:@"enc_pw_code"];
    
    NSString *bodyString = [CommonUtil getBodyString:requestBody];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:responseAction];
    [req requestUrl:url bodyString:bodyString token:token];
}

#pragma mark - Footer
- (IBAction)gotoNotice {
    [[CustomerCenterUtil sharedInstance] gotoNotice];
}
- (IBAction)gotoFAQ {
    [[CustomerCenterUtil sharedInstance] gotoFAQ];
}

- (IBAction)gotoTelEnquiry {
    [[CustomerCenterUtil sharedInstance] gotoTelEnquiry];
}

@end
