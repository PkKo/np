//
//  CertPasswordChangeViewController.m
//  공인인증서 비밀번호 변경
//
//  Created by Infobank1 on 2015. 9. 17..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CertPasswordChangeViewController.h"
#import "NFilterChar.h"
#import "nFilterCharForPad.h"
#import "EccEncryptor.h"

@interface CertPasswordChangeViewController ()

@end

@implementation CertPasswordChangeViewController

@synthesize certInfo;
@synthesize currentPasswordInput;
@synthesize passwordNewInput;
@synthesize passwordNewCheck;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(certInfo != nil)
    {
        [[CertManager sharedInstance] setCertInfo:certInfo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)passwordChangeClick:(id)sender
{
    // 기존 비밀번호 입력 확인
    if([currentPassword length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"기존 비밀번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 기존 비밀번호와 변경할 비밀번호가 동일한 경우
    if([currentPassword isEqualToString:newPassword])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"기존 비밀번호와 변경할 비밀번호가 동일합니다.\n변경할 비밀번호를 다르게 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    int rc = 0;
    
    rc = [[CertManager sharedInstance] changePassword:newPassword currentPassword:currentPassword];
    
    if (rc != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"입력하신 비밀번호가 일치하지 않습니다.\n비밀번호를 확인하시고 이용해주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"비밀번호가 변경되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert setTag:999];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        switch ([alertView tag])
        {
            case 999: // 비밀번호 변경 완료
            {
                [self.navigationController popViewControllerAnimated:YES];
                break;
            }
                
            default:
                break;
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self showNFilterKeypad:[NSString stringWithFormat:@"%ld", (long)[textField tag]]];
}

- (void)showNFilterKeypad:(NSString *)textFieldTag
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        NFilterChar *vc = [[NFilterChar alloc] initWithNibName:@"NFilterChar" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:@""];
        
        //콜백함수 설정
        [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
        [vc setLengthWithTagName:textFieldTag length:20 webView:nil];
        [vc setFullMode:YES];
        [vc setTopBarText:@"비밀번호 입력"];
        [vc setTitleText:@"기존 비밀번호"];
        [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
    }
    else
    {
        nFilterCharForPad *vc = [[nFilterCharForPad alloc] initWithNibName:@"nFilterCharForPad" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:@""];
        
        //콜백함수 설정
        [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
        [vc setLengthWithTagName:textFieldTag length:20 webView:nil];
        [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
    }
}

- (void)onPasswordConfirmNFilter:(NSString *)pPlainText encText:(NSString *)pEncText dummyText:(NSString *)pDummyText tagName:(NSString *)pTagName
{
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pPlainText];
    
    // tag name에 따라 입력필드 결정
    NSInteger tag = [pTagName integerValue];
    switch (tag)
    {
        case CURRENT_PASSWORD:
        {
            currentPassword = plainText;
            [currentPasswordInput setText:currentPassword];
            break;
        }
        case NEW_PASSWORD:
        {
            newPassword = plainText;
            [passwordNewInput setText:newPassword];
            break;
        }
        case NEW_PASSWORD_CHECK:
        {
            newCheckPassword = plainText;
            [passwordNewCheck setText:newCheckPassword];
            break;
        }
        default:
            break;
    }
}
@end
