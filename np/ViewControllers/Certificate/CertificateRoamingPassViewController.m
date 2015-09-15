//
//  CertificateRoamingPassViewController.m
//  공인인증서 가져오기 - 비밀번호 확인
//
//  Created by Infobank1 on 2015. 9. 15..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CertificateRoamingPassViewController.h"

@interface CertificateRoamingPassViewController ()

@end

@implementation CertificateRoamingPassViewController

@synthesize p12Data;
@synthesize p12Url;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mTitleLabel setText:@"인증서 비밀번호 입력"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
