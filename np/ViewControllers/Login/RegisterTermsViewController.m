//
//  RegisterTermsViewController.m
//  가입 - 약관동의
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegisterTermsViewController.h"
#import "RegisterAccountViewController.h"

#define SERVICE_TERMS_URL_SHORT     [NSString stringWithFormat:@"%@%@", SERVER_URL, @"content/html/ef/pu/efpu0911m.html"]
#define SERVICE_TERMS_URL_TOTAL     [NSString stringWithFormat:@"%@%@", SERVER_URL, @"content/html/ef/pu/efpu0911a.html"]
#define PERSONAL_TERMS_URL_SHORT    [NSString stringWithFormat:@"%@%@", SERVER_URL, @"content/html/ef/pu/efpu0912m.html"]
#define PERSONAL_TERMS_URL_TOTAL    [NSString stringWithFormat:@"%@%@", SERVER_URL, @"content/html/ef/pu/efpu0912a.html"]

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
    
    contentViewHeight = contentView.frame.size.height;
    [scrollView setContentSize:contentView.frame.size];
    
    [serviceTermWebView.layer setBorderColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f].CGColor];
    [serviceTermWebView.layer setBorderWidth:1.0f];
    [personalDataTermWebView.layer setBorderColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f].CGColor];
    [personalDataTermWebView.layer setBorderWidth:1.0f];
    
    [serviceTermWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SERVICE_TERMS_URL_SHORT]]];
    [personalDataTermWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PERSONAL_TERMS_URL_SHORT]]];
    
    serviceTermClick = NO;
    personalTermClick = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startIndicator];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(contentView.frame.size.height < contentViewHeight)
    {
        [contentView setFrame:CGRectMake(contentView.frame.origin.x,
                                         contentView.frame.origin.y,
                                         contentView.frame.size.width,
                                         contentViewHeight)];
        [scrollView setContentSize:contentView.frame.size];
    }
    
    [self stopIndicator];
}

// 서비스 이용약관을 전체화면으로 보여준다.
- (IBAction)showServiceTerm:(id)sender
{
    [serviceTermsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:serviceTermsView];
    [totalTermsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SERVICE_TERMS_URL_TOTAL]]];
    serviceTermClick = YES;
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
    [self.view addSubview:serviceTermsView];
    [totalTermsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PERSONAL_TERMS_URL_TOTAL]]];
    personalTermClick = YES;
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
    if(!serviceTermClick)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서비스 이용약관 전문보기를 선택하시고\n약관 내용을 확인하셔야 서비스 이용이 가능합니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }

    // 약관동의 여부 체크
    if(![serviceTermAgreeImg isHighlighted])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서비스 이용약관에 동의하셔야 서비스 이용이 가능합니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if(!personalTermClick)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"개인정보 수집/이용 약관 전문보기를 선택하시고\n약관 내용을 확인하셔야 서비스 이용이 가능합니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if(![personalDataTermAgreeImg isHighlighted])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"개인정보 수집/이용 약관에 동의하셔야 서비스 이용이 가능합니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
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
    
    serviceTermClick = NO;
    personalTermClick = NO;
    [self checkPersonalTermAgree:nil];
    [self checkServiceTermAgree:nil];
    [pushAgreeText setTextColor:[UIColor colorWithRed:144.0f/255.0f green:145.0f/255.0f blue:150.0f/255.0f alpha:1.0f]];
    [pushAgreeImg setHighlighted:NO];
}

- (IBAction)closeServiceTermsView:(id)sender
{
    [totalTermsWebView loadHTMLString:@"" baseURL:nil];
    [serviceTermsView removeFromSuperview];
}

#pragma mark - UIWebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"%s", __FUNCTION__);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%s, %@", __FUNCTION__, request.URL.path);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"%s", __FUNCTION__);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"%s", __FUNCTION__);
    [self zoomToFit:webView];
}

- (void)zoomToFit:(UIWebView *)webview
{
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content','width=%d;',false);", (int)webview.frame.size.width]];
}
@end
