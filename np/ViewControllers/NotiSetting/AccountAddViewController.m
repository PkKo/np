//
//  AccountAddViewController.m
//  np
//
//  Created by Infobank1 on 2015. 10. 21..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "AccountAddViewController.h"
#import "NFilterNum.h"
#import "nFilterNumForPad.h"
#import "NFilterChar.h"
#import "nFilterCharForPad.h"
#import "EccEncryptor.h"
#import "CertInfo.h"
#import "CertManager.h"
#import "CertLoader.h"

@interface AccountAddViewController ()

@end

@implementation AccountAddViewController

@synthesize accountCertTab;
@synthesize CertTab;
@synthesize accountInputView;
@synthesize accountInputField;
@synthesize accountPasswordField;
@synthesize birthdayInputField;

@synthesize certMenuView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:NO];
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"계좌추가"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeCertView:(id)sender
{
    UIButton *currentButton = (UIButton *)sender;
    if(currentButton == accountCertTab)
    {
        [accountCertTab setEnabled:NO];
        [CertTab setEnabled:YES];
        [accountInputView setHidden:NO];
        [certMenuView setHidden:YES];
    }
    else if(currentButton == CertTab)
    {
        [accountCertTab setEnabled:YES];
        [CertTab setEnabled:NO];
        [accountInputView setHidden:YES];
        [certMenuView setHidden:NO];
    }
}

- (IBAction)nextButtonClick:(id)sender
{
    if(![CertTab isEnabled])
    {
        // 공인인증서로 추가
    }
    else if(![accountCertTab isEnabled])
    {
        // 계좌인증
    }
}

- (void)certInfoSelected:(CertInfo *)certInfo
{
    [[CertManager sharedInstance] setCertInfo:certInfo];
    isCertRegist = NO;
    
    [self showNFilterKeypad];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    
    if([self.currentTextField isSecureTextEntry])
    {
        [textField resignFirstResponder];
        [self showNFilterKeypad];
    }
    else
    {
        [self.keyboardCloseButton setEnabled:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.keyboardCloseButton setEnabled:NO];
    
    if(![self.currentTextField isSecureTextEntry])
    {
        self.currentTextField = nil;
    }
}

- (void)showNFilterKeypad
{
    if(![CertTab isEnabled])
    {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            NFilterChar *vc = [[NFilterChar alloc] initWithNibName:@"NFilterChar" bundle:nil];
            //        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterSerialNum" bundle:nil];
            //서버 공개키 설정
            [vc setServerPublickey:@""];
            
            //콜백함수 설정
            [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
            [vc setLengthWithTagName:@"PasswordInput" length:20 webView:nil];
            [vc setFullMode:YES];
            [vc setTopBarText:@"공인인증센터"];
            [vc setTitleText:@"공인인증서 비밀번호 입력"];
            [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
        }
        else
        {
            nFilterCharForPad *vc = [[nFilterCharForPad alloc] initWithNibName:@"nFilterCharForPad" bundle:nil];
            //서버 공개키 설정
            [vc setServerPublickey:@""];
            
            //콜백함수 설정
            [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
            [vc setLengthWithTagName:@"PasswordInput" length:20 webView:nil];
            [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
        }
    }
    else if(![accountCertTab isEnabled])
    {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterNum" bundle:nil];
            //        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterSerialNum" bundle:nil];
            //서버 공개키 설정
            [vc setServerPublickey:@""];
            
            //콜백함수 설정
            [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
            [vc setLengthWithTagName:@"PasswordInput" length:4 webView:nil];
            [vc setFullMode:YES];
            [vc setTopBarText:@"계좌비밀번호"];
            [vc setTitleText:@"계좌 비밀번호 입력"];
            [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
        }
        else
        {
            nFilterNumForPad *vc = [[nFilterNumForPad alloc] initWithNibName:@"nFilterNumForPad" bundle:nil];
            //서버 공개키 설정
            [vc setServerPublickey:@""];
            
            //콜백함수 설정
            [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
            [vc setLengthWithTagName:@"PasswordInput" length:4 webView:nil];
            [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
        }
    }
}

- (void)onPasswordConfirmNFilter:(NSString *)pPlainText encText:(NSString *)pEncText dummyText:(NSString *)pDummyText tagName:(NSString *)pTagName
{
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pPlainText];
    
    if(self.currentTextField != nil)
    {
        [self.currentTextField setText:plainText];
    }
    
    self.currentTextField = nil;
}
@end
