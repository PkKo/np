//
//  SplashViewController.m
//  로딩화면
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "SplashViewController.h"
#import "HomeViewController.h"
#import "HomeQuickViewController.h"
#import "RegistAccountViewController.h"
#import "MainPageViewController.h"
#import "AppDelegate.h"
#import "LoginUtil.h"
#import "LoginCertListViewController.h"
#import "LoginAccountVerificationViewController.h"
#import "DrawPatternLockViewController.h"
#import "LoginSimpleVerificationViewController.h"
#import "ServiceInfoViewController.h"
#import "RegistCompleteViewController.h"
#import "BannerInfo.h"
#import "SplashLayerPopupView.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

@synthesize loadingTextLabel;
@synthesize loadingProgressBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 앱 위변조 체크 삽입 예정
    layerPopupInfo = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self appVersionCheckRequest];
//    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
//    [self sessionTestRequest];
//    [self htmlRequestTest];
//    [self ipsTest];
    /*
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
    MainPageViewController *vc = [[MainPageViewController alloc] init];
    [vc setStartPageIndex:0];
    slidingViewController.topViewController = vc;
    
    [self.navigationController setViewControllers:@[slidingViewController] animated:YES];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;//*/
}

- (void)getUnreadMessageCountFromIPS
{
//    [IBNgmService registerUserWithAccountId:@"151015104128899" verifyCode:[@"151015104128899" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [loadingProgressBar setProgress:0.6f animated:YES];
    
    [IBInbox loadWithListener:self];
    [IBInbox requestInboxCategoryInfo];
}

- (void)loadedInboxCategoryList:(NSArray *)categoryList
{
    NSLog(@"%s, %@", __FUNCTION__, categoryList);
    [loadingProgressBar setProgress:0.9f animated:YES];
    
    for(InboxCategotyData *data in categoryList)
    {
        if(data.categoryId == 1)
        {
            [CommonUtil setUnreadCountForBanking:data.unreadCount];
        }
        else if (data.categoryId == 2)
        {
            [CommonUtil setUnreadCountForEtc:data.unreadCount];
        }
    }
    
    if(layerPopupInfo != nil)
    {
        [self showLayerPopupView];
    }
    else
    {
        [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
    }
}

#pragma mark - 세션 생성 init 및 앱 버전 확인
- (void)appVersionCheckRequest
{
    [loadingProgressBar setProgress:0.2f animated:YES];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[CommonUtil getDeviceUUID] forKey:REQUEST_APP_VERSION_UUID];
    [reqBody setObject:[CommonUtil getAppVersion] forKey:REQUEST_APP_VERSION_APPVER];
//    [reqBody setObject:@"N" forKey:@"forceUpdate"];
//    [reqBody setObject:@"N" forKey:@"lpType"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_APP_VERSION];
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(appVersionCheckResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)appVersionCheckResponse:(NSDictionary *)response
{
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS])
    {
        [loadingProgressBar setProgress:0.3f animated:YES];
        
        ((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey = [response objectForKey:@"encodeKey"];
        NSString *terms1Ver = [response objectForKey:@"terms1Ver"];
        NSString *terms2Ver = [response objectForKey:@"terms2Ver"];
        
        if(terms1Ver != nil)
        {
            [[NSUserDefaults standardUserDefaults] setObject:terms1Ver forKey:@"terms1Ver"];
        }
        if(terms2Ver != nil)
        {
            [[NSUserDefaults standardUserDefaults] setObject:terms2Ver forKey:@"terms2Ver"];
        }
        
        if([response objectForKey:@"layer_seq"] != nil)
        {
            layerPopupInfo = [[LayerPopupInfo alloc] init];
            layerPopupInfo.viewStartdate    = [response objectForKey:@"view_startdate"];
            layerPopupInfo.linkOutUrl       = [response objectForKey:@"link_out_url"];
            layerPopupInfo.viewEnddate      = [response objectForKey:@"view_enddate"];
            layerPopupInfo.popupType        = [response objectForKey:@"popup_type"];
            layerPopupInfo.viewTitle        = [response objectForKey:@"view_title"];
            layerPopupInfo.linkInUrl        = [response objectForKey:@"link_in_url"];
            layerPopupInfo.closedayType     = [response objectForKey:@"closeday_type"];
            layerPopupInfo.createDate       = [response objectForKey:@"create_date"];
            layerPopupInfo.viewType         = [response objectForKey:@"view_type"];
            layerPopupInfo.imageUrl         = [response objectForKey:@"image_url"];
            layerPopupInfo.textBody         = [response objectForKey:@"text_body"];
            layerPopupInfo.layerSeq         = [response objectForKey:@"layer_seq"];
            layerPopupInfo.editDate         = [response objectForKey:@"edit_date"];
            layerPopupInfo.linkType         = [response objectForKey:@"link_type"];
        }
        
        NSString *updateYN = [response objectForKey:@"updateNotiYn"];
        if([updateYN isEqualToString:@"Y"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"최신버전 업데이트가 있습니다.\n업데이트 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
            [alertView setTag:1100];
            [alertView show];
        }
        else if([updateYN isEqualToString:@"F"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"최신버전 업데이트가\n필요합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView setTag:1101];
            [alertView show];
        }
        else
        {
            [self getBannerInfoRequest];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)htmlRequestTest
{
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.nongmin.com/xml/ar_xml_nh.htm"] encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSKorean) error:nil];
    NSLog(@"%s, string = %@", __FUNCTION__, string);
}

#pragma mark - 위변조 체크

#pragma mark - 배너정보 가져오기
- (void)getBannerInfoRequest
{
    [loadingProgressBar setProgress:0.5f animated:YES];
    /*
    // temp
    NSString *isUser = [[NSUserDefaults standardUserDefaults] objectForKey:IS_USER];
    
    if(isUser != nil && [isUser isEqualToString:@"Y"])
    {
        [self getUnreadMessageCountFromIPS];
    }
    else
    {
        [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
    }*/
    
    NSString *isUser = [[NSUserDefaults standardUserDefaults] objectForKey:IS_USER];
    
    if(isUser != nil && [isUser isEqualToString:@"Y"])
    {
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_BANNER_INFO];
        HttpRequest *req = [HttpRequest getInstance];
        [req setDelegate:self selector:@selector(getBannerInfoResponse:)];
        [req requestUrl:url bodyString:@""];
    }
    else
    {
        if(layerPopupInfo != nil)
        {
            [self showLayerPopupView];
        }
        else
        {
            [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
        }
    }
}

- (void)getBannerInfoResponse:(NSDictionary *)response
{
    NSLog(@"%s, %@", __FUNCTION__, response);
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        BannerInfo *bannerInfo = [[BannerInfo alloc] init];
        bannerInfo.bannerSeq        = [response objectForKey:@"banner_seq"];
        bannerInfo.createDate       = [response objectForKey:@"create_date"];
        bannerInfo.editDate         = [response objectForKey:@"edit_date"];
        bannerInfo.imagePath        = [response objectForKey:@"image_url"];
        bannerInfo.linkInUrl        = [response objectForKey:@"link_in_url"];
        bannerInfo.linkOutUrl       = [response objectForKey:@"link_out_url"];
        bannerInfo.linkType         = [response objectForKey:@"link_type"];
        bannerInfo.viewEndDate      = [response objectForKey:@"view_enddate"];
        bannerInfo.viewStartDate    = [response objectForKey:@"view_startdate"];
        bannerInfo.viewType         = [response objectForKey:@"view_type"];
        
        ((AppDelegate *)[UIApplication sharedApplication].delegate).bannerInfo = bannerInfo;
    }
    
//    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
    [self getUnreadMessageCountFromIPS];
}

- (void)didFailWithError:(NSError *)error
{
    NSLog(@"%s, error = %@", __FUNCTION__, error);
    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
}

- (void)sessionTestRequest
{
    HttpRequest *req = [HttpRequest getInstance];
    
    [req setDelegate:self selector:@selector(sessionTestResponse:)];
    [req requestUrl:[NSString stringWithFormat:@"%@/%@", SERVER_URL, @"sessionTest.cmd"] bodyString:@""];
}

- (void)sessionTestResponse:(NSDictionary *)response
{
    NSLog(@"%@", response);
    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
}

- (void)showLayerPopupView
{
    SplashLayerPopupView *view = [SplashLayerPopupView view];
    [view.titleLabel setText:layerPopupInfo.viewTitle];
    [view.contentLabel setText:layerPopupInfo.textBody];
    [view.contentLabel sizeToFit];
    [view setDelegate:self];
    [view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:view];
}

- (void)closeLayerPopup:(id)sender
{
    if([sender tag] == 1)
    {
        // 해당 레이어 아이디를 가진 것은 일주일간 보이지 않음으로 한다.
    }
    
    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
}

- (void)setMainViewController
{
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
    UIViewController *vc = nil;
    NSString *isUser = [[NSUserDefaults standardUserDefaults] objectForKey:IS_USER];
    
    if(isUser != nil && [isUser isEqualToString:@"Y"])
    {
        [[[LoginUtil alloc] init] setLogInStatus:NO];
        // 간편보기 확인
        if([[[LoginUtil alloc] init] isUsingSimpleView])
        {
            // 퀵뷰
            vc = [[HomeQuickViewController alloc] init];
            slidingViewController.topViewController = vc;
            
            [self.navigationController setViewControllers:@[slidingViewController] animated:YES];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;
        }
        else
        {
            // Login
            [[[LoginUtil alloc] init] showLoginPage:self.navigationController];
        }
        
        // 메인 시작
        //    MainPageViewController *vc = [[MainPageViewController alloc] init];
        //    [vc setStartPageIndex:0];
    }
    else
    {
        // 가입시작
        vc = [[ServiceInfoViewController alloc] init];
//        vc = [[RegistAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
     
//    RegistCompleteViewController *vc = [[RegistCompleteViewController alloc] init];
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // main test 진입 code
    /* 메인 시작
    MainPageViewController *vc = [[MainPageViewController alloc] init];
    [vc setStartPageIndex:0];
    slidingViewController.topViewController = vc;
    
    [self.navigationController setViewControllers:@[slidingViewController] animated:YES];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////*/
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == 1100)
    {
        if(buttonIndex == BUTTON_INDEX_OK)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://geo.itunes.apple.com/kr/app/newnhseumateubaengking/id398002630?mt=8"]];
        }
        [self getBannerInfoRequest];
    }
    else if([alertView tag] == 1101)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://geo.itunes.apple.com/kr/app/newnhseumateubaengking/id398002630?mt=8"]];
    }
}

@end