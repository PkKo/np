//
//  AppDelegate.m
//  np
//
//  Created by Infobank1 on 2015. 9. 9..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize slidingViewController;
@synthesize serverKey;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // IPNS 설정
    NSMutableDictionary *appInfo = [[NSMutableDictionary alloc] init];
    [appInfo setObject:PUSH_APP_ID forKey:IBNgmServiceInfoAppIdKey];
    [appInfo setObject:PUSH_APP_SECRET forKey:IBNgmServiceInfoAppSecretKey];
    
    [IBNgmService startServiceWithApplicationInfo:appInfo];
    
    // account address 설정
    [[IBNgmService sharedInstance] setUseCustomAddress:YES];
    [[IBNgmService sharedInstance] setAccountServAddr:IPNS_ACCOUNT_HOST];
    [[IBNgmService sharedInstance] setPortNum:6100];
    
    // APN 데이터를 처리한 후 라이브러리로부터 메시지를 받을 Delegate 설정
    [IBPush setApnsHelperReceiver:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    // APNS Device 등록 및 Device Token 요청
    [IBPush registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
/*
#if 0
    [IBNgmService registerUserWithAccountId:@"8C5B196D-FD00-4814-BCA6-0C19300B58F0" verifyCode:[@"8C5B196D-FD00-4814-BCA6-0C19300B58F0" dataUsingEncoding:NSUTF8StringEncoding]];
//    [IBNgmService registerUserWithAccountId:@"150324104128890" verifyCode:[@"150324104128890" dataUsingEncoding:NSUTF8StringEncoding]];
#else
    [IBNgmService registerUserWithAccountId:[CommonUtil getDeviceUUID] verifyCode:[[CommonUtil getDeviceUUID] dataUsingEncoding:NSUTF8StringEncoding]];
#endif
*/    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"MCPU_SSID"])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MCPU_SSID"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"PHAROSVISITOR"])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PHAROSVISITOR"];
    }
    
    [IBNgmService stopService];
}

// 푸시 설정 성공
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [IBPush registerApnsDeviceToken:deviceToken];
}

// 푸시 설정 에러
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%s, %@", __FUNCTION__, error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"##########################################################");
    NSLog(@"didReceiveRemoteNotification");
    NSLog(@"##########################################################");
    
    NSLog(@"########## %s ##########\nuserInfo\n%@", __FUNCTION__, userInfo);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[userInfo description]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
//    [alert show];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // APN(Apple Push Notification) 데이터 처리를 위해 Library에 데이터 전달
    ////////////////////////////////////////////////////////////////////////////////////////////////
    [IBPush apnsHandleRemoteNotification:userInfo];
}
@end
