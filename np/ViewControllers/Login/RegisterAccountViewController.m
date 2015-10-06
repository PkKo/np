//
//  RegisterAccountViewController.m
//  가입 - 계좌등록
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegisterAccountViewController.h"

@interface RegisterAccountViewController ()

@end

@implementation RegisterAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mMenuButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
    // 공인인증서 인증 or 계좌인증 체크하여 뷰 구성을 따로한다.
    if([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_CERT])
    {
        // 공인인증서 인증 - 전 계좌 조회하여 계좌리스트 구성
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_ACCOUNT])
    {
        // 계좌인증 - 입력한 계좌 혹은 다른 계좌번호를 입력받을 수 있도록 뷰 구성
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
