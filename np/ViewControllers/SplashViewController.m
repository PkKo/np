//
//  SplashViewController.m
//  로딩화면
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "SplashViewController.h"
#import "HomeViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%s", __FUNCTION__);
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
    NSLog(@"%s", __FUNCTION__);
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:2];
    
}

- (void)setMainViewController
{
    NSLog(@"%s", __FUNCTION__);
    
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
    HomeViewController *vc = [[HomeViewController alloc] init];
    [vc setMViewType:TIMELINE];
    slidingViewController.topViewController = vc;
    
    [self.navigationController setViewControllers:@[slidingViewController] animated:YES];
}

@end