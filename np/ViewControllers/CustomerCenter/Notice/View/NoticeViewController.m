//
//  NoticeViewController.m
//  np
//
//  Created by Infobank2 on 10/26/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "NoticeViewController.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"공지사항"];
    
    NSString * url = @"https://218.239.251.103:39190/servlet/SBAB1010R.view";
    NSURL * nsUrl = [NSURL URLWithString:url];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:nsUrl];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
