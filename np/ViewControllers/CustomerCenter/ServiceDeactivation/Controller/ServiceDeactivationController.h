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

typedef enum AlertTag {
    SERVICE_DEACTIVATION_DONE,
    SERVICE_DEACTIVATION_WILL_DO
} AlertTag;


@interface ServiceDeactivationController : NSObject <UIAlertViewDelegate>

+ (instancetype)sharedInstance;
- (void)deactivateService:(NSString *)isRegistered;

#pragma mark - Alert
- (void)showForceToDeactivateAlert;
@end
