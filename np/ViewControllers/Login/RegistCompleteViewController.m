//
//  RegistCompleteViewController.m
//  가입 - 가입완료
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistCompleteViewController.h"
#import "MainPageViewController.h"
#import "ExchangeSettingViewController.h"
#import "AccountAddViewController.h"
#import "LoginUtil.h"

@interface RegistCompleteViewController ()

@end

@implementation RegistCompleteViewController

@synthesize registCompleteTextLabel;
@synthesize addAccountButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mMenuButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:YES];
    
    [addAccountButton.layer setBorderColor:[UIColor colorWithRed:38.0f/255.0f green:156.0f/255.0f blue:255.0f/255.0f alpha:1.0f].CGColor];
    [addAccountButton.layer setBorderWidth:1.5f];
    
    [registCompleteTextLabel setText:[NSString stringWithFormat:@"%@님의 NH 스마트알림\n서비스 가입이 완료 되었습니다.", [[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_USER_NAME]]];
    
    [self getBannerInfoRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 배너정보 가져오기
- (void)getBannerInfoRequest
{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_BANNER_INFO];
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(getBannerInfoResponse:)];
    [req requestUrl:url bodyString:@""];
}

- (void)getBannerInfoResponse:(NSDictionary *)response
{
    NSLog(@"%s, %@", __FUNCTION__, response);
    BannerInfo *bannerInfo = [[BannerInfo alloc] init];
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
    
    [self performSelectorInBackground:@selector(getBannerImages) withObject:nil];
}

- (void)getBannerImages
{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).nongminBannerImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, NONGMIN_BANNER_IMAGE_URL]]]];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).noticeBannerImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:((AppDelegate *)[UIApplication sharedApplication].delegate).bannerInfo.imagePath]]];
    NSLog(@"%s, nongmin = %@, notice = %@", __FUNCTION__, ((AppDelegate *)[UIApplication sharedApplication].delegate).nongminBannerImg, ((AppDelegate *)[UIApplication sharedApplication].delegate).noticeBannerImg);
}

/**
 @brief 간편보기 기능 설정
 */
- (IBAction)quickViewSettingClick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"비로그인 상태에서 입출금 알림과\n기타알림 간편보기 조회 기능을\n사용하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alertView setTag:111];
    [alertView show];
}

/**
 @brief 환율알림 신청 화면으로 이동
 */
- (IBAction)currentNotiSettingClick:(id)sender
{
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
    // 메인 시작
    MainPageViewController *vc = [[MainPageViewController alloc] init];
    [vc setStartPageIndex:0];
    slidingViewController.topViewController = vc;
    
    [self.navigationController setViewControllers:@[slidingViewController] animated:NO];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;
    
    ExchangeSettingViewController *exchangeVC = [[ExchangeSettingViewController alloc] init];
    ECSlidingViewController *exchangeEcVc = [[ECSlidingViewController alloc] initWithTopViewController:exchangeVC];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController pushViewController:exchangeEcVc animated:YES];
}

/**
 @brief 계좌추가 화면으로 이동
 */
- (IBAction)addAccountClick:(id)sender
{
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
    // 메인 시작
    MainPageViewController *vc = [[MainPageViewController alloc] init];
    [vc setStartPageIndex:0];
    slidingViewController.topViewController = vc;
    
    [self.navigationController setViewControllers:@[slidingViewController] animated:NO];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;
    
    AccountAddViewController *accountAddVc = [[AccountAddViewController alloc] init];
    ECSlidingViewController *accountEcVc = [[ECSlidingViewController alloc] initWithTopViewController:accountAddVc];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController pushViewController:accountEcVc animated:YES];
}

/**
 @brief 메인화면으로 이동
 */
- (IBAction)moveMainPage:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"간편한 로그인 방식을 설정하러\n이동하시겠습니까?" delegate:self cancelButtonTitle:@"메인으로 이동" otherButtonTitles:@"예", nil];
    [alertView setTag:112];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag])
    {
        case 111:
        {
            if(buttonIndex == 1)
            {
                [[[LoginUtil alloc] init] saveUsingSimpleViewFlag:YES];
            }
            [[[LoginUtil alloc] init] showMainPage];
            break;
        }
        case 112:
        {
            if(buttonIndex == 0) // main page
            {
                [[[LoginUtil alloc] init] showMainPage];
            }
            else if (buttonIndex == 1)
            {
                [[[LoginUtil alloc] init] setLogInStatus:YES];
                [[[LoginUtil alloc] init] gotoLoginSettings:self.navigationController];
            }
            break;
        }
        default:
            [[[LoginUtil alloc] init] showMainPage];
            break;
    }
    
    
}
@end
