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
    [addAccountButton.layer setBorderWidth:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
    // 메인 시작
    MainPageViewController *vc = [[MainPageViewController alloc] init];
    [vc setStartPageIndex:0];
    slidingViewController.topViewController = vc;
    
    [self.navigationController setViewControllers:@[slidingViewController] animated:YES];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;
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
            break;
        }
            
        default:
            break;
    }
    
    [self moveMainPage:nil];
}
@end
