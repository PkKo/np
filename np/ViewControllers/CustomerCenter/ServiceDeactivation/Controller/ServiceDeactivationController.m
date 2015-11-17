//
//  ServiceDeactivationController.m
//  np
//
//  Created by Infobank2 on 11/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ServiceDeactivationController.h"

@implementation ServiceDeactivationController

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (void)deactivateService {
    
    NSUserDefaults * prefs  = [NSUserDefaults standardUserDefaults];
    NSString * user_id      = [prefs stringForKey:RESPONSE_CERT_UMS_USER_ID];
    
    NSLog(@"user_id: %@", user_id);
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_SERVICE_DEACTIVATION];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setObject:user_id forKey:@"user_id"];
    [requestBody setObject:PUSH_APP_ID forKey:@"app_id"];
    
    NSString *bodyString = [CommonUtil getBodyString:requestBody];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(receiveResponse:)];
    [req requestUrl:url bodyString:bodyString];
}

- (void)receiveResponse:(NSDictionary *)response {
    
    NSLog(@"RESPONSE: %@", response);
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO]) {
        LoginUtil * util = [[LoginUtil alloc] init];
        [util removeAllData];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내"
                                                         message:@"모든 데이터 초기화 처리 후\n서비스 해지 처리가 완료되었습니다."
                                                        delegate:self cancelButtonTitle:@"확인"
                                               otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    exit(0);
}

@end
