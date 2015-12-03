//
//  TermsOfUseViewController.m
//  np
//
//  Created by Infobank2 on 10/26/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "TermsOfUseViewController.h"

@interface TermsOfUseViewController ()

@end

@implementation TermsOfUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"약관보기"];
    
//    NSString * url = @"https://218.239.251.103:39190/content/html/ef/pu/efpu0911r.html";
    NSString *url = [NSString stringWithFormat:@"%@content/html/ef/pu/efpu0911r.html", SERVER_URL];
    NSURL * nsUrl = [NSURL URLWithString:url];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:nsUrl];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self startIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [self stopIndicator];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"알림" message:error.description delegate:self
                                           cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alert show];
}

@end
