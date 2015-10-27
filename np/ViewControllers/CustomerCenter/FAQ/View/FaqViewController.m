//
//  FaqViewController.m
//  np
//
//  Created by Infobank2 on 10/26/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "FaqViewController.h"

@interface FaqViewController ()

@end

@implementation FaqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"FAQ"];
    
    NSString * url = @"https://218.239.251.103:39190/content/html/ef/pu/efpu0920r.html";
    NSURL * nsUrl = [NSURL URLWithString:url];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:nsUrl];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
