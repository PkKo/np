//
//  ServiceDeactivationController.h
//  np
//
//  Created by Infobank2 on 11/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_REGISTERED_YES   @"Y"
#define IS_REGISTERED_NO    @"N"
#define IS_REGISTERED_F     @"F"

typedef enum AlertTag {
    SERVICE_DEACTIVATION_DONE_EXIT,
    SERVICE_DEACTIVATION_WILL_DO,
    SERVICE_DEACTIVATION_WILL_DO_REG_F
} AlertTag;


@interface ServiceDeactivationController : NSObject <UIAlertViewDelegate>

+ (instancetype)sharedInstance;
- (void)deactivateService:(NSString *)isRegistered;

#pragma mark - Alert
- (void)showForceToDeactivateAlert;
- (void)showForceToDeactivateALertWithMessage:(NSString *)msg;
@end
