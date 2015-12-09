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
#import "CertificateMenuViewController.h"
#import "JBroken.h"

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
    
    [self.bgImage setImage:[UIImage imageNamed:IS_IPHONE_4_OR_LESS ? @"bg_01_4s" : @"bg_01"]];
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
//    [self appVersionCheckRequest];
//    return;
    //*
    [[[LoginUtil alloc] init] setLogInStatus:NO];
    
    if([CommonUtil getNetworkStatus] == NotReachable)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크에 연결되지 않았습니다.\n네트워크 상태를 확인해주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView setTag:90004];
        [alertView show];
    }
    else
    {
        if(!isDeviceJailbroken())
        {
            [self appVersionCheckRequest];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"고객님의 소중한 재산을 보호하기 위해 탈옥된\n스마트기기 및 앱스토어외에 블로그, 카페에서\n설치한 위변조된 앱(App)에 대해 거래를 차단\n하오니 양해해 주시기 바랍니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView setTag:90001];
            [alertView show];
        }
    }//*/
//    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
//    [self sessionTestRequest];
//    [self htmlRequestTest];
//    [self ipsTest];
    /*
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
//    MainPageViewController *vc = [[MainPageViewController alloc] init];
//    [vc setStartPageIndex:0];
//    CertificateMenuViewController *vc = [[CertificateMenuViewController alloc] init];
//    RegistAccountViewController *vc = [[RegistAccountViewController alloc] init];
    RegistCompleteViewController *vc = [[RegistCompleteViewController alloc] init];

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
    
    // 퀵뷰
    HomeQuickViewController *vc = [[HomeQuickViewController alloc] init];
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] initWithTopViewController:vc];
    
    [self.navigationController setViewControllers:@[slidingViewController] animated:YES];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;
}

#pragma mark - 세션 생성 init 및 앱 버전 확인
- (void)appVersionCheckRequest
{
    [loadingProgressBar setProgress:0.2f animated:YES];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[CommonUtil getDeviceUUID] forKey:REQUEST_APP_VERSION_UUID];
    [reqBody setObject:[CommonUtil getAppVersion] forKey:REQUEST_APP_VERSION_APPVER];
    [reqBody setObject:@"I" forKey:@"appType"];
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
            if([layerPopupInfo.linkOutUrl length] > 0)
            {
                if(![layerPopupInfo.linkOutUrl hasPrefix:@"http://"])
                {
                    layerPopupInfo.linkOutUrl = [NSString stringWithFormat:@"http://%@", layerPopupInfo.linkOutUrl];
                }
            }
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
            
            NSMutableDictionary *layerData = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:LAYER_POPUP_SEQ_ENDDATE]];
            if(layerData != nil)
            {
                NSString *viewHideDate = [layerData objectForKey:layerPopupInfo.layerSeq];
                if(viewHideDate != nil && [CommonUtil compareDateString:viewHideDate toDate:[CommonUtil getTodayDateString]] > NSOrderedSame)
                {
                    layerPopupInfo = nil;
                }
            }
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
//    NSLog(@"%s, %@", __FUNCTION__, response);
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
        [self performSelectorInBackground:@selector(getBannerImages) withObject:nil];
    }
    
//    [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
    [self showLayerPopupView];
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
    if(layerPopupInfo != nil)
    {
        SplashLayerPopupView *view = [SplashLayerPopupView view];
        if([layerPopupInfo.popupType isEqualToString:@"S"])
        {
            [view.contentLabel setText:layerPopupInfo.textBody];
            [view.contentLabel sizeToFit];
        }
        else if([layerPopupInfo.popupType isEqualToString:@"I"])
        {
            [view.contentImage setHidden:NO];
            [view.contentImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:layerPopupInfo.imageUrl]]]];
        }
        [view.closeDayOptionButton setTitle:[NSString stringWithFormat:@"%@일간 보지 않기", layerPopupInfo.closedayType] forState:UIControlStateNormal];
        if([layerPopupInfo.linkType isEqualToString:@"O"] && layerPopupInfo.linkOutUrl != nil && [layerPopupInfo.linkOutUrl length] > 0)
        {
            view.linkOutUrl = layerPopupInfo.linkOutUrl;
            [view.linkUrlButton setEnabled:YES];
        }
        else if ([layerPopupInfo.linkType isEqualToString:@"I"] && layerPopupInfo.linkInUrl != nil && [layerPopupInfo.linkInUrl length] > 0)
        {
            view.linkInUrl = layerPopupInfo.linkInUrl;
            [view.linkUrlButton setEnabled:YES];
        }
        [view setDelegate:self];
        [view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:view];
    }
    else
    {
        [self performSelector:@selector(setMainViewController) withObject:nil afterDelay:1];
    }
}

- (void)closeLayerPopup:(id)sender
{
    if([sender tag] == 1)
    {
        // 해당 레이어 아이디를 가진 것은 일주일간 보이지 않음으로 한다.
        NSMutableDictionary *layerData = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:LAYER_POPUP_SEQ_ENDDATE]];
        if(layerData != nil)
        {
            [layerData removeAllObjects];
        }
        else
        {
            layerData = [[NSMutableDictionary alloc] init];
        }
        [layerData setObject:[CommonUtil getFormattedDateStringWithIndex:@"yyyy.MM.dd" indexDay:[layerPopupInfo.closedayType integerValue]] forKey:layerPopupInfo.layerSeq];
        [[NSUserDefaults standardUserDefaults] setObject:layerData forKey:LAYER_POPUP_SEQ_ENDDATE];
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
        // 간편보기 확인
        if([[[LoginUtil alloc] init] isUsingSimpleView])
        {
            [self getUnreadMessageCountFromIPS];
        }
        else
        {
            [loadingProgressBar setProgress:0.9f animated:NO];
            // Login
            [[[LoginUtil alloc] init] showLoginPage:self.navigationController];
        }
        
        // 메인 시작
        //    MainPageViewController *vc = [[MainPageViewController alloc] init];
        //    [vc setStartPageIndex:0];
    }
    else
    {
        [loadingProgressBar setProgress:0.9f animated:NO];
        // 가입시작
        vc = [[ServiceInfoViewController alloc] init];
//        vc = [[RegistAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
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

- (void)getBannerImages
{
    UIImage *nongminBannerImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, NONGMIN_BANNER_IMAGE_URL]]]];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).nongminBannerImg = nongminBannerImage;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).noticeBannerImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:((AppDelegate *)[UIApplication sharedApplication].delegate).bannerInfo.imagePath]]];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == 1100)
    {
        if(buttonIndex == BUTTON_INDEX_OK)
        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://geo.itunes.apple.com/kr/app/newnhseumateubaengking/id398002630?mt=8"]];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"com.nonghyup.nhsmartbanking://"]];
            // 스마트 알림앱이 등록된 이후 앱스토어 주소로 변경한다.
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://smartdev.nonghyup.com:39310/apps/push/p.html"]];
        }
        [self getBannerInfoRequest];
    }
    else if([alertView tag] == 1101)
    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://geo.itunes.apple.com/kr/app/newnhseumateubaengking/id398002630?mt=8"]];
        // 스마트 알림앱이 등록된 이후 앱스토어 주소로 변경한다.
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://smartdev.nonghyup.com:39310/apps/push/p.html"]];
    }
    else if([alertView tag] == 90001)
    {
        exit(0);
    }
    else if ([alertView tag] == 90004)
    {
        [((AppDelegate *)[UIApplication sharedApplication].delegate) restartApplication];
    }
}

@end