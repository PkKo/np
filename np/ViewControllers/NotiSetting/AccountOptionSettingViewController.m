//
//  AccountOptionSettingViewController.m
//  np
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "AccountOptionSettingViewController.h"

@interface AccountOptionSettingViewController ()

@end

@implementation AccountOptionSettingViewController

@synthesize accountNumber;
@synthesize contentView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:NO];
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"입출금 알림 계좌관리"];
    
    optionView = [RegistAccountOptionSettingView view];
    [optionView setDelegate:self];
    [optionView initDataWithAccountNumber:accountNumber];
    [optionView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [contentView addSubview:optionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
