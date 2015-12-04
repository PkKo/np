//
//  CertificateRoamingPassViewController.m
//  공인인증서 가져오기 - 비밀번호 확인
//
//  Created by Infobank1 on 2015. 9. 15..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CertificateRoamingPassViewController.h"
#import "NFilterChar.h"
#import "NFilterNum.h"
#import "nFilterCharForPad.h"
#import "EccEncryptor.h"
#import "CertManager.h"

@interface CertificateRoamingPassViewController ()

@end

@implementation CertificateRoamingPassViewController

@synthesize p12Data;
@synthesize p12Url;
@synthesize mPassInputText;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mTitleLabel setText:@"비밀번호 입력"];
//    [self.mNaviView.mMenuButton setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)passwordCheck
{
    int rc = 0;
    rc = [[CertManager sharedInstance] p12ImportWithUrl:p12Url password:mPassInputText.text];
    
    if (rc == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"완료" message:@"인증서 저장이 완료되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:([[self.navigationController viewControllers] count] - 3)] animated:YES];
    }
    else if (rc == 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서버와의 통신에 문제가 발생했습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
    }
    else if (rc == 200)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"PC에서 인증서가 업로드되지 않았습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"비밀번호가 일치하지 않습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self showNFilterKeypad];
}

#pragma mark - NFilter
- (void)showNFilterKeypad
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        NFilterChar *vc = [[NFilterChar alloc] initWithNibName:@"NFilterChar" bundle:nil];
//        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterSerialNum" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
        
        //콜백함수 설정
        [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
        [vc setLengthWithTagName:@"PasswordInput" length:20 webView:nil];
        [vc setFullMode:YES];
        [vc setSupportRetinaHD:YES];
        [vc setTopBarText:@"공인인증센터"];
        [vc setTitleText:@"비밀번호 입력"];
        [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
    }
    else
    {
        nFilterCharForPad *vc = [[nFilterCharForPad alloc] initWithNibName:@"nFilterCharForPad" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
        
        //콜백함수 설정
        [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
        [vc setLengthWithTagName:@"PasswordInput" length:20 webView:nil];
        [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
    }
}

- (void)onPasswordConfirmNFilter:(NSString *)pPlainText encText:(NSString *)pEncText dummyText:(NSString *)pDummyText tagName:(NSString *)pTagName
{
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pPlainText];
    
    [mPassInputText setText:plainText];
    
    [self passwordCheck];
}

#pragma mark - UIButtonAction
- (IBAction)passInputButtonClick:(id)sender
{
#if DEV_MODE
    NSLog(@"%s, viewController count = %lu", __FUNCTION__, [[self.navigationController viewControllers] count]);
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:([[self.navigationController viewControllers] count] - 3)] animated:YES];
#else
    [self passwordCheck];
#endif
}

- (IBAction)cancelButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
