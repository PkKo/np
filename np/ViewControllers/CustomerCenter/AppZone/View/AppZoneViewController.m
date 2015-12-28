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
    [self.mNaviView.mTitleLabel setText:@"NH 앱존"];
    
    NSString * url = [NSString stringWithFormat:@"%@content/html/ef/pu/efpu0930r.html", SERVER_URL];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%s, %@", __FUNCTION__, request.URL.path);
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [self stopIndicator];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"알림" message:error.description delegate:self
                                           cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alert show];
}


@end
