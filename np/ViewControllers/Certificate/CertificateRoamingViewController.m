//
//  CertificateRoamingViewController.m
//  공인인증서 가져오기
//
//  Created by Infobank1 on 2015. 9. 14..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CertificateRoamingViewController.h"
#import "CertManager.h"
#import "CertificateRoamingPassViewController.h"

@interface CertificateRoamingViewController ()

@end

@implementation CertificateRoamingViewController

@synthesize mainView;

@synthesize certNum1;
@synthesize certNum2;
@synthesize certNum3;
@synthesize certNum4;

@synthesize nextButton;

@synthesize scrollView;
@synthesize bottomView;

@synthesize descriptionOneLabel;
@synthesize descriptionTwoLabel;
@synthesize descriptionThreeLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mTitleLabel setText:@"공인인증센터"];
    [self.mNaviView.mMenuButton setHidden:YES];
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, bottomView.frame.origin.y + bottomView.frame.size.height)];
    
    certNum1.layer.borderColor = [UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.f alpha:1.0f].CGColor;
    certNum1.layer.borderWidth = 1.0f;
    certNum2.layer.borderColor = [UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.f alpha:1.0f].CGColor;
    certNum2.layer.borderWidth = 1.0f;
    certNum3.layer.borderColor = [UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.f alpha:1.0f].CGColor;
    certNum3.layer.borderWidth = 1.0f;
    certNum4.layer.borderColor = [UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.f alpha:1.0f].CGColor;
    certNum4.layer.borderWidth = 1.0f;
    
    // 인증번호 요청
    [self performSelector:@selector(requestAuthNumber) withObject:nil afterDelay:0.01f];
    
    NSMutableAttributedString *textOne = [[NSMutableAttributedString alloc] initWithString:descriptionOneLabel.text];
    [textOne addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(0, 13)];
    [textOne addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:48.0/255.0f green:158.0/255.0f blue:251.0/255.0f alpha:1.0f] range:NSMakeRange(13, 28)];
    [textOne addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(13, 28)];
    [textOne addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(41, 8)];
    [descriptionOneLabel setAttributedText:textOne];
    
    NSMutableAttributedString *textTwo = [[NSMutableAttributedString alloc] initWithString:descriptionTwoLabel.text];
    [textTwo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(0, 23)];
    [textTwo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:48.0/255.0f green:158.0/255.0f blue:251.0/255.0f alpha:1.0f] range:NSMakeRange(23, 15)];
    [textTwo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(38, 8)];
    [descriptionTwoLabel setAttributedText:textTwo];
    
    NSMutableAttributedString *texthree = [[NSMutableAttributedString alloc] initWithString:descriptionThreeLabel.text];
    [texthree addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(0, 19)];
    [texthree addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:48.0/255.0f green:158.0/255.0f blue:251.0/255.0f alpha:1.0f] range:NSMakeRange(19, 9)];
    [texthree addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(28, 8)];
    [descriptionThreeLabel setAttributedText:texthree];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method

- (void)requestAuthNumber
{
    // 농협 스마트뱅킹 리얼 주소
    NSString *auth = [[CertManager sharedInstance] getAuthNumber:@"https://newsmart.nonghyup.com/so/jsp/btworks/roaming/getauth.jsp"];
    
    if (auth == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서버와의 통신에 문제가 발생했습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /* Auth number 4자리씩 표시 */
    certNum1.text = [auth substringWithRange:NSMakeRange(0, 4)];
    certNum2.text = [auth substringWithRange:NSMakeRange(4, 4)];
    certNum3.text = [auth substringWithRange:NSMakeRange(8, 4)];
    certNum4.text = [auth substringWithRange:NSMakeRange(12, 4)];
}

- (IBAction)nextButtonClick:(id)sender
{
    // 농협 스마트뱅킹 리얼 주소
    int rc = [[CertManager sharedInstance] verifyP12Uploaded:@"https://newsmart.nonghyup.com/so/jsp/btworks/roaming/getcert.jsp"];
    
    if (rc == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"PC에서 인증서가 업로드 되었습니다. 계속 진행하세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alert.tag = 9999;
        [alert show];
        return;
    }
    else if (rc == 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서버와의 통신에 문제가 발생했습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (rc == 200)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"PC에서 인증서가 업로드되지 않았습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 9999)
    {
        ECSlidingViewController *eVc = [[ECSlidingViewController alloc] init];
        CertificateRoamingPassViewController *viewController = [[CertificateRoamingPassViewController alloc] init];
        // 농협 스마트뱅킹 리얼 주소
        viewController.p12Url = [NSString stringWithFormat:@"https://newsmart.nonghyup.com/so/jsp/btworks/roaming/getcert.jsp"];
        eVc.topViewController = viewController;
        [self.navigationController pushViewController:eVc animated:YES];
    }
}
@end
