//
//  IBPush.h
//  IBNgmService
//
//  Created by soulkey on 12. 9. 25..
//  Copyright (c) 2012년 Infobank Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark IBPush

@interface IBPush : NSObject

//////////////////////////////////////////////////////////////////////////////
//								Open API									//
//////////////////////////////////////////////////////////////////////////////

+ (void)resetApplicationBadge;
+ (void)setApplicationBadgeNumber:(int)badgeNumber;

+ (void)setApnsHelperReceiver:(id)listener;

+ (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types;
+ (void)registerApnsDeviceToken:(NSData *)token;

+ (void)apnsHandleLaunchOptions:(NSDictionary *)launchOptions;
+ (void)apnsHandleRemoteNotification:(NSDictionary *)userInfo;

@end
