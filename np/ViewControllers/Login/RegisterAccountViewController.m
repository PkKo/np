//
//  RegisterAccountViewController.m
//  가입 - 계좌등록
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegisterAccountViewController.h"
#import "RegistCompleteViewController.h"

@interface RegisterAccountViewController ()

@end

@implementation RegisterAccountViewController

@synthesize scrollView;
@synthesize contentView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mMenuButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
    [self allAccountListRequest];
    
    // 공인인증서 인증 or 계좌인증 체크하여 뷰 구성을 따로한다.
    if([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_CERT])
    {
        // 공인인증서 인증 - 전 계좌 조회하여 계좌리스트 구성
        isCertMode = YES;
        // 전 계좌 조회 루틴 실행
        [self allAccountListRequest];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_ACCOUNT])
    {
        // 계좌인증 - 입력한 계좌 혹은 다른 계좌번호를 입력받을 수 있도록 뷰 구성
        isCertMode = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 공인인증 : 전계좌 리스트 뷰 구성
- (void)allAccountListRequest
{
    [self startIndicator];
    HttpRequest *req = [HttpRequest getInstance];
    
    // 전계좌 조회 실행
    [self performSelector:@selector(allAccountListResponse:) withObject:nil afterDelay:1.0];
}

- (void)allAccountListResponse:(NSDictionary *)response
{
    [self stopIndicator];
    allAccountList = [[NSMutableArray alloc] initWithArray:@[@"1111-22-333333(외환)", @"111111-22-333333(신탁)", @"111-2222-3333-44(입출식)", @"1111-222-333333(수익증권)"]];
    
    [self makeAllAccountListView];
}

- (void)makeAllAccountListView
{
    allListView = [RegistAccountAllListView view];
    [allListView initAccountList:allAccountList customerName:@"김농협"];
    [allListView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [contentView addSubview:allListView];
}

#pragma mark - UIButton Action
- (IBAction)nextButtonClick:(id)sender
{
    UIButton *nextButton = (UIButton *)sender;
    switch ([nextButton tag])
    {
        case 0:
        {
            // 계좌옵션 설정 뷰를 보여줌
            [nextButton setTag:1];
            break;
        }
        case 1:
        {
            // 등록완료 뷰 컨트롤러로 이동
            RegistCompleteViewController *vc = [[RegistCompleteViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}
@end
