//
//  LoginSimpleVerificationViewController.m
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginSimpleVerificationViewController.h"
#import "LoginUtil.h"
#import "EccEncryptor.h"
#import "LoginSettingsViewController.h"
#import "LoginSettingsViewController.h"
#import "StorageBoxUtil.h"
#import "LoginSimpleController.h"

@interface LoginSimpleVerificationViewController () {
    NSString * _pw;
}

@end

@implementation LoginSimpleVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@""];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(IBAction)clickEnterPassword {
    
    [self toggleBtnBgColor:NO textLength:0];
    
    LoginUtil * util = [[LoginUtil alloc] init];
    [util showSecureNumpadInParent:self topBar:@"간편 로그인" title:@"비밀번호 입력"
                        textLength:6
                        doneAction:@selector(confirmPassword:) cancelAction:nil];
}

- (IBAction)gotoLoginSettings {
    [[[LoginUtil alloc] init] gotoLoginSettings:self.navigationController];
}

- (IBAction)gotoSimpleLoginSettings {
    [[[LoginUtil alloc] init] gotoSimpleLoginMgmt:self.navigationController];
}

- (IBAction)doLogin {
    if ([self validatePW:_pw]) {
        [[[LoginSimpleController alloc] init] validateLoginSimple];
        [[[LoginUtil alloc] init] saveSimplePasswordFailedTimes:0];
        [self closeView];
    }
}

#pragma mark - Logic
- (void)confirmPassword:(NSString *)pw {
    
    EccEncryptor *ec    = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pw];
    _pw                 = plainText;
    
    [self toggleBtnBgColor:YES textLength:((int)_pw.length)];
}

- (BOOL)validatePW:(NSString *)pw {
    
    LoginUtil * util = [[LoginUtil alloc] init];
    
    const int PW_LENGTH                   = 6;
    
    NSString * alertMessage     = nil;
    NSString * savedPassword    = [util getSimplePassword];
    NSInteger failedTimes       = [util getSimplePasswordFailedTimes];
    NSInteger tag               = ALERT_DO_NOTHING;
    
    if ([pw length] != PW_LENGTH) {
        
        alertMessage = @"숫자 6자리를 입력해 주세요.";
        
    } else if (![pw isEqualToString:savedPassword]) {
        
        failedTimes++;
        if (failedTimes >= 5) {
            
            alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 본인인증이 필요합니다. 본인인증 후 다시 이용해주세요.";
            tag             = ALERT_GOTO_SELF_IDENTIFY;
            
            [util removeSimplePassword];
            
        } else {
            
            alertMessage = [NSString stringWithFormat:@"비밀번호가 일치하지 않습니다.\n비밀번호 %d 회 오류입니다.", (int)failedTimes];
            [util saveSimplePasswordFailedTimes:failedTimes];
        }
    }
    
    if (alertMessage) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                        delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alert.tag = tag;
        [alert show];
        
        return NO;
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_GOTO_SELF_IDENTIFY:
            NSLog(@"본인인증으로 이동");
            [self closeView];
            break;
        default:
            break;
    }
}

- (void)closeView {
    [[[LoginUtil alloc] init] showMainPage];
}

- (void)updateUI {
    
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeNoticeTextField];
    
    for (UIButton * loginBtn in self.loginBtns.subviews) {
        loginBtn.layer.cornerRadius = loginBtn.layer.frame.size.width / 2;
    }
}

- (void)toggleBtnBgColor:(BOOL)isSelected textLength:(int)textLength {
    
    if (isSelected) {
        
        int numberOfBtns            = (int)[[self.loginBtns subviews] count];
        int maxSelectedNumberOfBtns = numberOfBtns < textLength ? numberOfBtns : textLength;
        int btnIdx                  = 0;
        
        for (UIButton * loginBtn in self.loginBtns.subviews) {
            
            if (btnIdx >= maxSelectedNumberOfBtns) {
                break;
            }
            btnIdx++;
            
            [loginBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
        }
        
    } else {
        for (UIButton * loginBtn in self.loginBtns.subviews) {
            [loginBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.4]];
        }
    }
}


@end
