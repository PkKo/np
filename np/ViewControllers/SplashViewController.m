//
//  SplashViewController.m
//  로딩화면
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "SplashViewController.h"
#import "HomeViewController.h"
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
    
    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
    
}

- (void)setMainViewController
{
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
//    HomeViewController *vc = [[HomeViewController alloc] init];
//    [vc setMViewType:TIMELINE];
//    RegistAccountViewController *vc = [[RegistAccountViewController alloc] init];
    MainPageViewController *vc = [[MainPageViewController alloc] init];
    [vc setStartPageIndex:0];
    slidingViewController.topViewController = vc;
//    UINavigationController *nVC = [[UINavigationController alloc] initWithRootViewController:vc];
//    [nVC setNavigationBarHidden:YES];
//    slidingViewController.topViewController = nVC;
    
    [self.navigationController setViewControllers:@[slidingViewController] animated:YES];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;
}

@end