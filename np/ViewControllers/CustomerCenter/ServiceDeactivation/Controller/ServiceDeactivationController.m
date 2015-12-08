//
//  ServiceDeactivationController.m
//  np
//
//  Created by Infobank2 on 11/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ServiceDeactivationController.h"
#import "MainPageViewController.h"

@interface ServiceDeactivationController() {
    NSString * _isRegistered;
}

@end

@implementation ServiceDeactivationController

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (void)deactivateService:(NSString *)isRegistered {
    
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) startIndicator];
    
    _isRegistered = isRegistered;
    
    NSUserDefaults * prefs  = [NSUserDefaults standardUserDefaults];
    NSString * user_id      = [prefs stringForKey:RESPONSE_CERT_UMS_USER_ID];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_SERVICE_DEACTIVATION];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setObject:user_id forKey:@"user_id"];
    [requestBody setObject:PUSH_APP_ID forKey:@"app_id"];
    [requestBody setObject:isRegistered forKey:@"reg_yn"];
    
    NSString *bodyString = [CommonUtil getBodyString:requestBody];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(receiveResponse:)];
    [req requestUrl:url bodyString:bodyString];
}

- (void)receiveResponse:(NSDictionary *)response {
    
    NSLog(@"RESPONSE: %@", response);
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO]) {
        LoginUtil * util = [[LoginUtil alloc] init];
        [util removeAllData];
        
        
        if ([_isRegistered isEqualToString:IS_REGISTERED_NO]) { // 비정상 해지
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate restartApplication];
            
        } else if ([_isRegistered isEqualToString:IS_REGISTERED_YES]) { // 정상 해지
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내"
                                                             message:@"모든 데이터 초기화 처리 후\n서비스 해지 처리가 완료되었습니다."
                                                            delegate:self cancelButtonTitle:@"확인"
                                                   otherButtonTitles:nil];
            alert.tag = SERVICE_DEACTIVATION_DONE_EXIT;
            [alert show];
        }
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Alert
- (void)showForceToDeactivateAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내"
                                                     message:@"NH스마트알림 앱 서비스를\n해지 하셨습니다.\n\n서비스를 재가입하시겠습니까?"
                                                    delegate:self
                                           cancelButtonTitle:@"취소"
                                           otherButtonTitles:@"확인", nil];
    alert.tag = SERVICE_DEACTIVATION_WILL_DO;
    [alert show];
}

- (void)showForceToDeactivateALertWithMessage:(NSString *)msg {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내"
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:@"확인"
                                           otherButtonTitles:nil];
    alert.tag = SERVICE_DEACTIVATION_WILL_DO_REG_F;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
            
        case SERVICE_DEACTIVATION_DONE_EXIT:
            exit(0);
            break;
            
        case SERVICE_DEACTIVATION_WILL_DO:
        {
            if (buttonIndex == 0) {
                exit(0);
            } else if (buttonIndex == 1) {
                [self deactivateService:IS_REGISTERED_NO];
            }
            
            break;
        }
        case SERVICE_DEACTIVATION_WILL_DO_REG_F:
        {
            [[[LoginUtil alloc] init] removeAllData];
            [(AppDelegate *)[UIApplication sharedApplication].delegate restartApplication];
            break;
        }
            
        default:
            break;
    }
}

@end
