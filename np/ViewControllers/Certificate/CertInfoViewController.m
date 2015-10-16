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

#define CERT_DELETE_TAG     111

@interface CertInfoViewController ()

@end

@implementation CertInfoViewController

@synthesize certInfo;

@synthesize nameLabel;
@synthesize issuerLabel;
@synthesize policyLabel;
@synthesize expiredDateLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mTitleLabel setText:@"공인인증센터"];
    [self.mNaviView.mMenuButton setHidden:YES];
    
    // certInfo에 맞춰 데이터뷰 구성
    if(certInfo != nil)
    {
        [[CertManager sharedInstance] setCertInfo:certInfo];
        
        // 사용자명
        NSString *name = nil;
        
        NSArray *subjectDN2 = [certInfo.subjectDN2 componentsSeparatedByString:@","];
        if([subjectDN2 count] > 0)
        {
            NSArray *dnName = [[subjectDN2 objectAtIndex:0] componentsSeparatedByString:@"="];
            if([dnName count] > 1)
            {
                name = [dnName objectAtIndex:1];
            }
        }
        
        if(name == nil)
        {
            name = certInfo.subjectCN;
        }
        [nameLabel setText:name];
        
        // 발급자
        [issuerLabel setText:certInfo.issuer];
        
        // 구분
        [policyLabel setText:certInfo.policy];
        
        // 만료일자
        [expiredDateLabel setText:certInfo.notAfter];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 @brief 비밀번호 변경 뷰컨트롤러로 이동
 */
- (IBAction)deleteCertClick:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증서를 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alertView setTag:CERT_DELETE_TAG];
    [alertView show];
}

- (IBAction)passwordChangeClick:(id)sender
{
    CertPasswordChangeViewController *vc = [[CertPasswordChangeViewController alloc] init];
    [vc setCertInfo:certInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == CERT_DELETE_TAG && buttonIndex == BUTTON_INDEX_OK)
    {
        /* 인증서 삭제*/
         [FileManager deleteCertFile:certInfo.subjectDN];
         [self.navigationController popViewControllerAnimated:YES];
         
         if ([[CertManager getLoginedCertInfo].subjectDN isEqualToString:certInfo.subjectDN])
         {     //추가된부분
             [CertManager clear];
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"CertDeletedNotification" object:self];
    }
}
@end
