//
//  RegisterTermsViewController.m
//  가입 - 약관동의
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegisterTermsViewController.h"
#import "RegisterAccountViewController.h"

#define SERVICE_TERMS_URL_SHORT     @"https://218.239.251.103:39190/content/html/ef/pu/efpu0911m.html"
#define SERVICE_TERMS_URL_TOTAL     @"https://218.239.251.103:39190/content/html/ef/pu/efpu0911r.html"
#define PERSONAL_TERMS_URL_SHORT    @"https://218.239.251.103:39190/content/html/ef/pu/efpu0912m.html"
#define PERSONAL_TERMS_URL_TOTAL    @"https://218.239.251.103:39190/content/html/ef/pu/efpu0912r.html"

@interface RegisterTermsViewController ()

@end

@implementation RegisterTermsViewController

@synthesize scrollView;
@synthesize contentView;

@synthesize serviceTermWebView;
@synthesize serviceTermAgreeImg;
@synthesize serviceTermAgreeText;

@synthesize personalDataTermWebView;
@synthesize personalDataTermAgreeImg;
@synthesize personalDataTermAgreeText;

@synthesize pushAgreeImg;
@synthesize pushAgreeText;

@synthesize serviceTermsView;
@synthesize totalTermsWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mMenuButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
    [scrollView setContentSize:contentView.frame.size];
    
    [serviceTermWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SERVICE_TERMS_URL_SHORT]]];
    [personalDataTermWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PERSONAL_TERMS_URL_SHORT]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 서비스 이용약관을 전체화면으로 보여준다.
- (IBAction)showServiceTerm:(id)sender
{
    [serviceTermsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [totalTermsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SERVICE_TERMS_URL_TOTAL]]];
    [self.view addSubview:serviceTermsView];
}

// 서비스 이용약관 체크
- (IBAction)checkServiceTermAgree:(id)sender
{
    if([serviceTermAgreeImg isHighlighted])
    {
        // 체크 해제
        [serviceTermAgreeText setTextColor:[UIColor colorWithRed:144.0f/255.0f green:145.0f/255.0f blue:150.0f/255.0f alpha:1.0f]];
    }
    else
    {
        // 체크 실행
        [serviceTermAgreeText setTextColor:[UIColor colorWithRed:48.0f/255.0f green:158.0f/255.0f blue:251.0f/255.0f alpha:1.0f]];
    }
    
    [serviceTermAgreeImg setHighlighted:![serviceTermAgreeImg isHighlighted]];
}

// 개인정보 이용동의 약관을 전체화면으로 보여준다
- (IBAction)showPersonalTerm:(id)sender
{
    [serviceTermsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [totalTermsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PERSONAL_TERMS_URL_TOTAL]]];
    [self.view addSubview:serviceTermsView];
}

// 개인정보 이용동의 체크
- (IBAction)checkPersonalTermAgree:(id)sender
{
    if([personalDataTermAgreeImg isHighlighted])
    {
        // 체크 해제
        [personalDataTermAgreeText setTextColor:[UIColor colorWithRed:144.0f/255.0f green:145.0f/255.0f blue:150.0f/255.0f alpha:1.0f]];
    }
    else
    {
        // 체크 실행
        [personalDataTermAgreeText setTextColor:[UIColor colorWithRed:48.0f/255.0f green:158.0f/255.0f blue:251.0f/255.0f alpha:1.0f]];
    }
    
    [personalDataTermAgreeImg setHighlighted:![personalDataTermAgreeImg isHighlighted]];
}

- (IBAction)checkPushAgree:(id)sender
{
    if([pushAgreeImg isHighlighted])
    {
        // 체크 해제
        [pushAgreeText setTextColor:[UIColor colorWithRed:144.0f/255.0f green:145.0f/255.0f blue:150.0f/255.0f alpha:1.0f]];
    }
    else
    {
        // 체크 실행
        [pushAgreeText setTextColor:[UIColor colorWithRed:48.0f/255.0f green:158.0f/255.0f blue:251.0f/255.0f alpha:1.0f]];
    }
    
    [pushAgreeImg setHighlighted:![pushAgreeImg isHighlighted]];
}

- (IBAction)nextButtonClick:(id)sender
{
    // 약관동의 여부 체크
    if(![serviceTermAgreeImg isHighlighted])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"약관에 동의하셔야 서비스 이용이 가능합니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if(![personalDataTermAgreeImg isHighlighted])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"약관에 동의하셔야 서비스 이용이 가능합니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if(![pushAgreeImg isHighlighted])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"금융정보/기타 알림메시지 수신에 동의하셔야 서비스 이용이 가능합니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 계좌번호 등록 뷰 컨트롤러로 이동
    RegisterAccountViewController *vc = [[RegisterAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)closeServiceTermsView:(id)sender
{
    [serviceTermsView removeFromSuperview];
}

#pragma mark - UIWebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
}
@end
