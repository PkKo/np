//
//  RegisterTermsViewController.m
//  가입 - 약관동의
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegisterTermsViewController.h"
#import "RegisterAccountViewController.h"

@interface RegisterTermsViewController ()

@end

@implementation RegisterTermsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mMenuButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonClick:(id)sender
{
    // 약관동의 여부 체크
    
    // 계좌번호 등록 뷰 컨트롤러로 이동
    RegisterAccountViewController *vc = [[RegisterAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
