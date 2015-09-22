//
//  CommonViewController.m
//  mp
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

@synthesize mNaviView;
@synthesize mMenuCloseButton;
@synthesize keyboardCloseButton;
@synthesize currentTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeNaviAndMenuView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(![self.slidingViewController.underRightViewController isKindOfClass:[MenuViewController class]])
    {
        self.slidingViewController.underRightViewController = [[MenuViewController alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)makeNaviAndMenuView
{
    self.mNaviView = [NavigationView view];
    [self.mNaviView setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.mNaviView.frame.size.height)];
    [self.view addSubview:self.mNaviView];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        [self.mNaviView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).offset(20);
            make.height.equalTo(@(self.mNaviView.frame.size.height));
        }];
    }
    
    [self.mNaviView.mMenuButton addTarget:self action:@selector(showMenuView) forControlEvents:UIControlEventTouchUpInside];
    [self.mNaviView.mBackButton addTarget:self action:@selector(moveBack) forControlEvents:UIControlEventTouchUpInside];
    
    mMenuCloseButton = [[UIButton alloc] init];
    [mMenuCloseButton setBackgroundColor:[UIColor clearColor]];
    [mMenuCloseButton addTarget:self action:@selector(closeMenuView) forControlEvents:UIControlEventTouchUpInside];
    [mMenuCloseButton setEnabled:NO];
    [mMenuCloseButton setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [mMenuCloseButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:mMenuCloseButton];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        [mMenuCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.top.equalTo(self.view.mas_top);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    
    [self.view bringSubviewToFront:mMenuCloseButton];
    
    keyboardCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [keyboardCloseButton setBackgroundColor:[UIColor clearColor]];
    [keyboardCloseButton addTarget:self action:@selector(keyboardClose) forControlEvents:UIControlEventTouchUpInside];
    [keyboardCloseButton setEnabled:NO];
    [keyboardCloseButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:keyboardCloseButton];
    
    [self.view bringSubviewToFront:keyboardCloseButton];
}

- (void)showMenuView
{
    [self.slidingViewController anchorTopViewToLeftAnimated:YES onComplete:^{
        [mMenuCloseButton setEnabled:YES];
    }];
}

- (void)closeMenuView
{
    [self.slidingViewController resetTopViewAnimated:YES onComplete:^{
        [mMenuCloseButton setEnabled:NO];
    }];
}

- (void)moveBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardClose
{
    if(currentTextField != nil)
    {
        [currentTextField resignFirstResponder];
    }
}

@end
