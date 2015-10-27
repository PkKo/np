//
//  AppZoneViewController.m
//  np
//
//  Created by Infobank2 on 10/27/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "AppZoneViewController.h"

@interface AppZoneViewController ()

@end

@implementation AppZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"NH APPZONE"];
    
    NSString * url = @"https://218.239.251.103:39190/content/html/ef/pu/efpu0930r.html";
    NSURL * nsUrl = [NSURL URLWithString:url];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:nsUrl];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
