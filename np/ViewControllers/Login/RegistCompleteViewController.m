//
//  RegistCompleteViewController.m
//  가입 - 가입완료
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistCompleteViewController.h"
#import "MainPageViewController.h"

@interface RegistCompleteViewController ()

@end

@implementation RegistCompleteViewController

@synthesize registCompleteTextLabel;
@synthesize addAccountButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mMenuButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"비로그인 상태에서 입출금 알림과\n기타알림 간편보기 조회 기능을\n사용하시겠습니까?" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:@"취소", nil];
    [alertView setTag:111];
    [alertView show];
}

/**
 @brief 환율알림 신청 화면으로 이동
 */
- (IBAction)currentNotiSettingClick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"환율 알림 설정 페이지로 이동한다.\n상세 동작은 추후 페이지 구성이 완료되면 구현\n현재는 메인페이지로만 이동" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alertView show];
    
    [self moveMainPage:nil];
}

/**
 @brief 계좌추가 화면으로 이동
 */
- (IBAction)addAccountClick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"계좌 추가 페이지로 이동한다.\n상세 동작은 추후 페이지 구성이 완료되면 구현\n현재는 메인페이지로만 이동" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alertView show];
    
    [self moveMainPage:nil];
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
            if(buttonIndex == 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"간편보기 설정 값 입력 후 메인페이지로 이동" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"간편보기 설정없이 메인페이지로 이동" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
            
        default:
            break;
    }
    
    [self moveMainPage:nil];
}
@end
