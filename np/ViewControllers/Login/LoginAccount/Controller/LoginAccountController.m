//
//  LoginAccountController.m
//  np
//
//  Created by Infobank2 on 10/27/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginAccountController.h"
#import "CertManager.h"

@implementation LoginAccountController

- (void)validateLoginAccount:(NSString *)accountNo password:(NSString *)pw ofViewController:(UIViewController *)viewController action:(SEL)action {
    
    NSString * user_id          = @"150324104128890";
    NSString * crmMobile        = @"01540051434";
    NSString * account_number   = @"15702311194";
    NSString * account_password = @"111";
    NSString * user_birthday    = @"830226";
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_LOGIN_ACCOUNT];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setObject:user_id forKey:@"user_id"];
    [requestBody setObject:crmMobile forKey:@"crmMobile"];
    [requestBody setObject:account_number forKey:@"account_number"];
    [requestBody setObject:account_password forKey:@"account_password"];
    [requestBody setObject:user_birthday forKey:@"user_birthday"];
    
    NSString *bodyString = [CommonUtil getBodyString:requestBody];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:viewController selector:action];
    [req requestUrl:url bodyString:bodyString];
    
}

@end
