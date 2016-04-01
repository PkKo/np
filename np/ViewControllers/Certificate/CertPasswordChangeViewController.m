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
#import "BTWSSLCrypto.h"

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

    [self.mNaviView.mTitleLabel setText:@"공인인증센터"];
//    [self.mNaviView.mMenuButton setHidden:YES];
    
    wrongPasswordCount = 0;
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
    
    if([newPassword length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"변경할 비밀번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if([newCheckPassword length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"변경할 비밀번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if(![newPassword isEqualToString:newCheckPassword])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"변경할 비밀번호와 확인 비밀번호가 일치하지 않습니다.\n다시 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
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
    
    if(![CommonUtil CheckCertPassword:newPassword])
    {
        // password 유효성 검사
        // 10자리 이상, 특수문자,숫자,영자 모두 포함되어야 함
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증서 암호는 숫자,영문,특수문자를\n반드시 포함하여 10자리 이상으로\n입력해야 합니다.\n(단, ',\",\\,₩(|) 사용불가)" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    BOOL a = [CommonUtil isRepeatSameString:newPassword];
    BOOL b = [CommonUtil isRepeatSequenceString:newPassword];
    if(a || b)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증서 암호에 연속된 문자/숫자 3자리 이상\n사용할 수 없습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if(certInfo != nil)
    {
        [[CertManager sharedInstance] setCertInfo:certInfo];
        
        int passCheck = [[CertManager sharedInstance] checkPassword:currentPassword];
        
        if(passCheck == 0)
        {
            int rc = 0;
            
            rc = [[CertManager sharedInstance] changePassword:newPassword currentPassword:currentPassword];
            
            if (rc != 0)
            {
                wrongPasswordCount++;
                
                NSString *alertMessage = @"";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:alertMessage delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
                if (wrongPasswordCount >= 5) {
                    alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 인증서 사용이 불가능합니다.\n가까운 NH농협 영업점을 방문하셔서 공인 인증서 비밀번호를 재설정해주세요.";
                    [alert setTag:999];
                    
                } else {
                    
                    alertMessage = [NSString stringWithFormat:@"입력하신 비밀번호가 일치하지 않습니다.\n비밀번호를 확인하시고 이용해주세요.\n비밀번호 %d 회 오류입니다.", (int)wrongPasswordCount];
                }
                [alert setMessage:alertMessage];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"공인인증서 비밀번호가 변경되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alert setTag:999];
                [alert show];
            }
        }
        else
        {
            wrongPasswordCount++;
            
            NSString *alertMessage = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:alertMessage delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            if (wrongPasswordCount >= 5) {
                alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 인증서 사용이 불가능합니다.\n가까운 NH농협 영업점을 방문하셔서 공인 인증서 비밀번호를 재설정해주세요.";
                [alert setTag:999];
                
            } else {
                
                alertMessage = [NSString stringWithFormat:@"입력하신 비밀번호가 일치하지 않습니다.\n비밀번호를 확인하시고 이용해주세요.\n비밀번호 %d 회 오류입니다.", (int)wrongPasswordCount];
            }
            [alert setMessage:alertMessage];
            [alert show];
        }
        
    }
}

- (IBAction)cancelClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSInteger tag = [textFieldTag integerValue];
    NSString *titleText = @"";
    switch (tag)
    {
        case CURRENT_PASSWORD:
        {
            titleText = @"기존 비밀번호 입력";
            break;
        }
        case NEW_PASSWORD:
        {
            titleText = @"변경할 비밀번호 입력";
            break;
        }
        case NEW_PASSWORD_CHECK:
        {
            titleText = @"변경할 비밀번호 확인";
            break;
        }
        default:
            break;
    }
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        NFilterChar *vc = [[NFilterChar alloc] initWithNibName:@"NFilterChar" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
        
        //콜백함수 설정
        [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
        [vc setLengthWithTagName:textFieldTag length:20 webView:nil];
        [vc setFullMode:YES];
        [vc setSupportRetinaHD:YES];
        [vc setTopBarText:@"비밀번호 입력"];
        [vc setTitleText:titleText];
        [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
    }
    else
    {
        nFilterCharForPad *vc = [[nFilterCharForPad alloc] initWithNibName:@"nFilterCharForPad" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
        
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
