//
//  SplashViewController.m
//  로딩화면
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "SplashViewController.h"
#import "HomeViewController.h"
#import "RegistPhoneViewController.h"

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
    
    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:2];
    
}

- (void)setMainViewController
{
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
//    HomeViewController *vc = [[HomeViewController alloc] init];
//    [vc setMViewType:TIMELINE];
    RegistPhoneViewController *vc = [[RegistPhoneViewController alloc] init];
    slidingViewController.topViewController = vc;
    
    [self.navigationController setViewControllers:@[slidingViewController] animated:YES];
}

@end