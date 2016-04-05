//
//  AppDelegate.m
//  np
//
//  Created by Infobank1 on 2015. 9. 9..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashViewController.h"
#import "HomeQuickViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize slidingViewController;
@synthesize serverKey;
@synthesize bannerInfo;
@synthesize nongminBannerImg;
@synthesize noticeBannerImg;
@synthesize currentDeviceToken;

#ifdef DEV_MODE
void MyUncaughtExceptionHandler(NSException *exception) {
	NSLog(@"APPDELEGATE CRASH REPORT ---------------- %@", [exception callStackSymbols]);
}
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEV_MODE    
	NSSetUncaughtExceptionHandler(&MyUncaughtExceptionHandler);
#endif
	
	NSLog(@"########## %s ##########\nuserInfo\n%@", __FUNCTION__, launchOptions);
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    /*
    if(launchOptions != nil)
    {
        NSInteger badgeCount = application.applicationIconBadgeNumber;
        badgeCount++;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
    }*/
    
    // IPNS 설정
    NSMutableDictionary *appInfo = [[NSMutableDictionary alloc] init];
    [appInfo setObject:PUSH_APP_ID forKey:IBNgmServiceInfoAppIdKey];
    [appInfo setObject:PUSH_APP_SECRET forKey:IBNgmServiceInfoAppSecretKey];
    
    [IBNgmService startServiceWithApplicationInfo:appInfo];
    
    // account address 설정
    [[IBNgmService sharedInstance] setUseCustomAddress:YES];
    [[IBNgmService sharedInstance] setAccountServAddr:IPNS_ACCOUNT_HOST];
    [[IBNgmService sharedInstance] setPortNum:6100];
    
    //[IBNgmService setNgmServiceReceiver:self];
    
    // APN 데이터를 처리한 후 라이브러리로부터 메시지를 받을 Delegate 설정
    [IBPush setApnsHelperReceiver:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
    // APNS Device 등록 및 Device Token 요청
    [IBPush registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
    NSInteger count = [UIApplication sharedApplication].applicationIconBadgeNumber;
    NSLog(@"%s, %d, %d", __FUNCTION__, (int)count, (int)application.applicationIconBadgeNumber);
    
    
    
    
    
    
    
    //Remote notification info
    NSDictionary *remoteNotifiInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    //Accept push notification when app is not open
    if (remoteNotifiInfo) {
        [self application:application didReceiveRemoteNotification:remoteNotifiInfo];
    }
    
    
    
    
    
    
    
    /*
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType types = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }*/
/*
#if 1
//    [IBNgmService registerUserWithAccountId:@"8C5B196D-FD00-4814-BCA6-0C19300B58F0" verifyCode:[@"8C5B196D-FD00-4814-BCA6-0C19300B58F0" dataUsingEncoding:NSUTF8StringEncoding]];
    [IBNgmService registerUserWithAccountId:@"151015104128899" verifyCode:[@"151015104128899" dataUsingEncoding:NSUTF8StringEncoding]];
#else
    [IBNgmService registerUserWithAccountId:[CommonUtil getDeviceUUID] verifyCode:[[CommonUtil getDeviceUUID] dataUsingEncoding:NSUTF8StringEncoding]];
#endif*/

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
    NSLog(@"########## %s ##########\nuserInfo\n%@", __FUNCTION__, deviceToken);
    [IBPush registerApnsDeviceToken:deviceToken];
    currentDeviceToken = deviceToken;
	
	NSString *isUser = [[NSUserDefaults standardUserDefaults] objectForKey:IS_USER];
	NSData *oldTok = [[NSUserDefaults standardUserDefaults] objectForKey: kOldDeviceToken];
	if ([isUser isEqualToString:@"Y"] &&
		(NO == [currentDeviceToken isEqualToData: oldTok]))
	{
		//디바이스 정보 등록 요청
		[IBNgmService setNgmServiceReceiver:self];
        [IBNgmService registerDeviceInfo];
	}
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
    
    if (userInfo[@"scd"] != nil) {
        
        NSInteger scd = [userInfo[@"scd"] intValue];
        
        if (scd >= 100 && scd <= 106) {
            
            self.simpleViewType = SIMPLE_VIEW_TYPE_PUSH;
            
        } else {
            self.simpleViewType = SIMPLE_VIEW_TYPE_NOTI;
        }
        
    } else {
        self.simpleViewType = SIMPLE_VIEW_TYPE_NOTI;
    }
    
    if (self.slidingViewController && slidingViewController.topViewController && [self.slidingViewController.topViewController isKindOfClass:[HomeQuickViewController class]]) {
        
        [(HomeQuickViewController *)slidingViewController.topViewController setNotifType:self.simpleViewType];
    }
    
    /*
    NSInteger badgeCount = 0;
    badgeCount = application.applicationIconBadgeNumber + 1;
    [application setApplicationIconBadgeNumber:5];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:5];
    [IBPush setApplicationBadgeNumber:5];*/
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                    message:[userInfo description]
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    // APN(Apple Push Notification) 데이터 처리를 위해 Library에 데이터 전달
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    [IBPush apnsHandleRemoteNotification:userInfo];
    
    
    
    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
}

/*
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"########## %s ##########\nuserInfo\n%@", __FUNCTION__, userInfo);
    
    NSInteger badgeCount = 0;
    badgeCount = application.applicationIconBadgeNumber + 1;
    [application setApplicationIconBadgeNumber:10];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:10];
    [IBPush setApplicationBadgeNumber:10];
    [IBPush apnsHandleRemoteNotification:userInfo];
}*/

- (void)timeoutError:(NSDictionary *)response
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alertView setTag:123456];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s", __FUNCTION__);
    
    if([alertView tag] == 123456)
    {
        [self restartApplication];
    }
	else if([alertView tag] == 1100)
    {
        if(buttonIndex == BUTTON_INDEX_OK)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_APP_URL]];
            // 스마트 알림앱이 등록된 이후 앱스토어 주소로 변경한다.
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://smartdev.nonghyup.com:39310/apps/push/p.html"]];
        }
    }
    else if([alertView tag] == 1101)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_APP_URL]];
		exit(0);
        // 스마트 알림앱이 등록된 이후 앱스토어 주소로 변경한다.
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://smartdev.nonghyup.com:39310/apps/push/p.html"]];
    }
}

- (void)restartApplication
{
    UIStoryboard        * mainStoryBoard       = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *naviCon = [mainStoryBoard instantiateViewControllerWithIdentifier:@"RootNavigationController"];
    self.window.rootViewController = naviCon;
}

#pragma mark
#pragma mark - IBNgmServiceProtocol

- (void)registerDeviceInfoResponse:(int)responseCode
{
    //디바이스 정보 등록 성공
    if(100 == responseCode)
    {
        //변경된 토큰 저장
		[[NSUserDefaults standardUserDefaults] setObject: currentDeviceToken forKey: kOldDeviceToken];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    //디바이스 정보 등록 실패
    else
    {
        NSLog(@"디바이스 정보 등록에 실패 하였습니다.");
    }
}



#pragma mark etc
				
- (void) checkAppUpdate {
    NSString *updateYN = [[NSUserDefaults standardUserDefaults] valueForKey: @"updateNotiYn"];

	if([updateYN isEqualToString:@"Y"])
	{
	    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"최신버전 업데이트가 있습니다.\n업데이트 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
	    [alertView setTag:1100];
	    [alertView show];
	}
	else if([updateYN isEqualToString:@"F"])
	{
	    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"최신버전 업데이트가\n필요합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
	    [alertView setTag:1101];
	    [alertView show];
	}

	[[NSUserDefaults standardUserDefaults] setValue: @"" forKey: @"updateNotiYn"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
