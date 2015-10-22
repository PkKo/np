//
//  ExchangeCountryAddViewController.m
//  np
//
//  Created by Infobank1 on 2015. 10. 21..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "ExchangeCountryAddViewController.h"

@interface ExchangeCountryAddViewController ()

@end

@implementation ExchangeCountryAddViewController

@synthesize scrollView;
@synthesize contentView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:NO];
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"통화국가 추가/편집"];

    [scrollView setContentSize:contentView.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
