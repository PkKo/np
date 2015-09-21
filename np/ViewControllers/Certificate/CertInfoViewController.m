//
//  CertInfoViewController.m
//  공인인증서 상세보기
//
//  Created by Infobank1 on 2015. 9. 17..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CertInfoViewController.h"
#import "CertPasswordChangeViewController.h"
#import "FileManager.h"
#import "CertManager.h"

@interface CertInfoViewController ()

@end

@implementation CertInfoViewController

@synthesize certInfo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // certInfo에 맞춰 데이터뷰 구성
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 @brief 비밀번호 변경 뷰컨트롤러로 이동
 */
- (IBAction)passwordChangeClick:(id)sender
{
    CertPasswordChangeViewController *vc = [[CertPasswordChangeViewController alloc] init];
    [vc setCertInfo:certInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /* 인증서 삭제
    [FileManager deleteCertFile:certInfo.subjectDN];
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([[CertManager getLoginedCertInfo].subjectDN isEqualToString:certInfo.subjectDN])
    {     //추가된부분
        [CertManager clear];
    }
     
     [[NSNotificationCenter defaultCenter] postNotificationName:@"CertDeletedNotification" object:self];
     */
}
@end
