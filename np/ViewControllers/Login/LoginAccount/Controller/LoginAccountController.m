//
//  LoginAccountController.m
//  np
//
//  Created by Infobank2 on 10/27/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginAccountController.h"
#import "CertManager.h"
#import "BTWCodeguard.h"

@implementation LoginAccountController

- (void)validateLoginAccount:(NSString *)accountNo password:(NSString *)pw birthday:(NSString *)birthday ofViewController:(UIViewController *)viewController action:(SEL)action {
    
    NSUserDefaults * prefs  = [NSUserDefaults standardUserDefaults];
    NSString * user_id      = [prefs stringForKey:RESPONSE_CERT_UMS_USER_ID];
    NSString * crmMobile    = [LoginUtil getDecryptedCrmMobile];
    
    NSString * account_number   = accountNo;
    NSString * account_password = pw;
    NSString * user_birthday    = birthday;
    
    [[Codeguard sharedInstance] setAppName:@"NHSmartPush"];
    [[Codeguard sharedInstance] setAppVer:[CommonUtil getAppVersion]];
    [[Codeguard sharedInstance] setChallengeRequestUrl:[NSString stringWithFormat:@"%@CodeGuard/check.jsp", SERVER_URL]];
    NSString *token = [[Codeguard sharedInstance] requestAndGetToken];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_LOGIN_ACCOUNT];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setObject:user_id forKey:@"user_id"];
    [requestBody setObject:crmMobile forKey:REQUEST_CERT_CRM_MOBILE];
    [requestBody setObject:account_number forKey:@"account_number"];
    [requestBody setObject:account_password forKey:@"account_password"];
    [requestBody setObject:user_birthday forKey:@"user_birthday"];
    
    NSString *bodyString = [CommonUtil getBodyString:requestBody];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:viewController selector:action];
    [req requestUrl:url bodyString:bodyString token:token];
    
}

@end
