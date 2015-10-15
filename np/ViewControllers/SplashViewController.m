//
//  SplashViewController.m
//  로딩화면
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "SplashViewController.h"
#import "HomeViewController.h"
#import "HomeQuickViewController.h"
#import "RegistAccountViewController.h"
#import "MainPageViewController.h"
#import "AppDelegate.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 앱 위변조 체크 삽입 예정
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self appVersionCheckRequest];
//    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
//    [self sessionTestRequest];
}

- (void)appVersionCheckRequest
{
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[CommonUtil getDeviceUUID] forKey:REQUEST_APP_VERSION_UUID];
    [reqBody setObject:[CommonUtil getAppVersion] forKey:REQUEST_APP_VERSION_APPVER];
    [reqBody setObject:@"N" forKey:@"forceUpdate"];
    [reqBody setObject:@"N" forKey:@"lpType"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_APP_VERSION];
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(appVersionCheckResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)appVersionCheckResponse:(NSDictionary *)response
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSLog(@"%s, %@", __FUNCTION__, cookies);
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS])
    {
//        for (NSHTTPCookie *cookie in cookies)
//        {
//            [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:cookie.name];
//        }
//        [self sessionTestRequest];
//        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for (NSHTTPCookie *cookie in [storage cookies])
//        {
//            [storage deleteCookie:cookie];
//        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
    
    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
}

- (void)sessionTestRequest
{
    HttpRequest *req = [HttpRequest getInstance];
    
    [req setDelegate:self selector:@selector(sessionTestResponse:)];
    [req requestUrl:[NSString stringWithFormat:@"%@/%@", SERVER_URL, @"sessionTest.cmd"] bodyString:@""];
}

- (void)sessionTestResponse:(NSDictionary *)response
{
    NSLog(@"%@", response);
    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
}

- (void)setMainViewController
{
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
    // 가입시작
//    RegistAccountViewController *vc = [[RegistAccountViewController alloc] init];
    // 메인 시작
    MainPageViewController *vc = [[MainPageViewController alloc] init];
    [vc setStartPageIndex:0];
    // 퀵뷰
//    HomeQuickViewController *vc = [[HomeQuickViewController alloc] init];
    slidingViewController.topViewController = vc;
    
//    [self.navigationController setViewControllers:@[slidingViewController] animated:YES];
//    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;
    [self.navigationController pushViewController:vc animated:YES];
}

@end