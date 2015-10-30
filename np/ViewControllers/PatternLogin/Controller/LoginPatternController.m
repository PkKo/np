//
//  LoginPatternController.m
//  np
//
//  Created by Infobank2 on 10/28/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginPatternController.h"
#import "LoginUtil.h"

@implementation LoginPatternController

- (void)validateLoginPattern {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    
    NSString * loginType        = @"PAT";
    NSString * user_id      = [prefs stringForKey:RESPONSE_CERT_UMS_USER_ID]; //@"150324104128890";
    NSString * crmMobile    = [prefs stringForKey:RESPONSE_CERT_CRM_MOBILE]; //@"01540051434";
    
    NSLog(@"user_id: %@", user_id);
    NSLog(@"crmMobile: %@", crmMobile);
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_LOGIN_PINPAT];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setObject:user_id forKey:@"user_id"];
    [requestBody setObject:crmMobile forKey:@"crmMobile"];
    [requestBody setObject:loginType forKey:@"loginType"];
    
    NSString *bodyString = [CommonUtil getBodyString:requestBody];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(loginPatternResponse:)];
    [req requestUrl:url bodyString:bodyString];
    
}

- (void)loginPatternResponse:(NSDictionary *)response {
    
    NSLog(@"response: %@", response);
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        NSDictionary * list     = (NSDictionary *)(response[@"list"]);
        NSArray * accounts      = (NSArray *)(list[@"sub"]);
        int numberOfAccounts    = [accounts count];
        
        NSLog(@"accounts: %@", accounts);
        
        if (numberOfAccounts > 0) {
            
            NSMutableArray * accountNumbers = [NSMutableArray arrayWithCapacity:numberOfAccounts];
            for (NSDictionary * account in accounts) {
                [accountNumbers addObject:(NSString *)account[@"UMSD060101_OUT_SUB.account_number"]];
            }
            
            if ([accountNumbers count] > 0) {
                [[[LoginUtil alloc] init] saveAllAccounts:[accountNumbers copy]];
            }
        }
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
