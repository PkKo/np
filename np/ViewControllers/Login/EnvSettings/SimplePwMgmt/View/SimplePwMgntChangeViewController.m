//
//  SimplePwMgntChangeViewController.m
//  np
//
//  Created by Infobank2 on 10/14/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "SimplePwMgntChangeViewController.h"
#import "EccEncryptor.h"
#import "LoginUtil.h"
#import "StorageBoxUtil.h"
#import "RegistAccountViewController.h"

@interface SimplePwMgntChangeViewController ()

@end

@implementation SimplePwMgntChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"간편비밀번호 관리"];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUI];
}

#pragma mark - Keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    BOOL isFullMode = YES;
    
    if (!isFullMode) {
        [textField setText:@""];
    }
    
    NSString * title = textField.placeholder;;
    SEL action;
    
    if (textField == self.existingPw) {
        
        action = @selector(currentPassword:);
        
    } else if (textField == self.myNewPw) {
        
        action = @selector(newPassword:);
        
    } else if (textField == self.myNewPwConfirm) {
        
        action = @selector(newPasswordConfirm:);
    }
    
    LoginUtil * util = [[LoginUtil alloc] init];
    [util showSecureNumpadInParent:self topBar:@"간편비밀번호" title:title
                        textLength:6
                        doneAction:action methodOnPress:action
                        isFullMode:isFullMode isAutoCloseKeyboard:!isFullMode];
}

- (void)currentPassword:(NSString *)pw {
    [self updateInputPassword:pw forTextField:self.existingPw];
}

- (void)newPassword:(NSString *)pw {
    [self updateInputPassword:pw forTextField:self.myNewPw];
}

- (void)newPasswordConfirm:(NSString *)pw {
    [self updateInputPassword:pw forTextField:self.myNewPwConfirm];
}

- (void)updateInputPassword:(NSString *)pw forTextField:(UITextField *)textField {
    
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pw];
    textField.text = plainText;
}

#pragma mark - Cancel/Done
- (IBAction)clickCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickDone {
    
    LoginUtil * util = [[LoginUtil alloc] init];
    
    const int PW_LENGTH                   = 6;
    
    NSString * alertMessage     = @"";
    NSString * savedPassword    = [util getSimplePassword];
    NSInteger failedTimes       = [util getSimplePasswordFailedTimes];
    NSInteger tag               = ALERT_DO_NOTHING;
    
    if (!self.existingPw.isHidden) {
        
        if (self.existingPw.text.length != PW_LENGTH) {
            
            alertMessage = @"숫자 6자리를 입력해 주세요.";
            
        } else if (![[util getEncryptedPassword:self.existingPw.text] isEqualToString:savedPassword]) {
            
            failedTimes++;
            [util saveSimplePasswordFailedTimes:failedTimes];
            if (failedTimes >= 5) {
                
                alertMessage    = @"간편 비밀번호 오류가 5회 이상 발생하여\n로그인이 불가능합니다. 본인인증 후\n간편 비밀번호를 재설정해주세요.";
                tag             = ALERT_GOTO_SELF_IDENTIFY;
            } else {
                
                alertMessage = [NSString stringWithFormat:@"입력하신 비밀번호가 일치하지 않습니다.\n비밀번호를 확인하시고 이용해주세요.\n비밀번호 %d회 오류입니다.", (int)failedTimes];
            }
        } else if (self.myNewPw.text.length != PW_LENGTH || self.myNewPwConfirm.text.length != PW_LENGTH) {
            
            alertMessage = @"숫자 6자리를 입력해 주세요.";
            
        } else if (![self.myNewPw.text isEqualToString:self.myNewPwConfirm.text]) {
            
            alertMessage = @"입력하신 비밀번호와 비밀번호 확인이 일치하지 않습니다.";
            
        } else if ([self.existingPw.text isEqualToString:self.myNewPw.text]) {
            
            alertMessage = @"현재 비밀번호와 동일한 비밀번호 입니다.";
            
        } else if ([self isPasswordContainsMobileNo:self.myNewPw.text]) {
            
            alertMessage = @"휴대폰번호와 중복되는 간편 비밀번호는\n사용하실 수 없습니다.";
            
        } else if ([CommonUtil isRepeatSameString:self.myNewPw.text] || [CommonUtil isRepeatSequenceString:self.myNewPw.text]) {
            
            alertMessage = @"연속된 번호는 간편 비밀번호로\n사용하실 수 없습니다.";
            
        } else {
            
            alertMessage = @"간편비밀번호가 번경 되었습니다.";
            [util saveSimplePassword:self.myNewPw.text];
            tag = ALERT_SUCCEED_SAVE;
        }
    } else {
        
        if (self.myNewPw.text.length != PW_LENGTH || self.myNewPwConfirm.text.length != PW_LENGTH) {
            
            alertMessage = @"숫자 6자리를 입력해 주세요.";
            
        } else if (![self.myNewPw.text isEqualToString:self.myNewPwConfirm.text]) {
            
            alertMessage = @"입력하신 비밀번호와 비밀번호 확인이 일치하지 않습니다.";
            
        } else if ([self isPasswordContainsMobileNo:self.myNewPw.text]) {
            
            alertMessage = @"휴대폰번호와 중복되는 간편 비밀번호는\n사용하실 수 없습니다.";
            
        } else if ([CommonUtil isRepeatSameString:self.myNewPw.text] || [CommonUtil isRepeatSequenceString:self.myNewPw.text]) {
            
            alertMessage = @"연속된 번호는 간편 비밀번호로\n사용하실 수 없습니다.";
            
        } else {
            alertMessage = @"간편비밀번호가 설정 되었습니다.";
            tag          = ALERT_SUCCEED_SAVE;
            
            LoginUtil * util = [[LoginUtil alloc] init];
            [util saveSimplePassword:self.myNewPw.text];
        }

    }
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                    delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_GOTO_SELF_IDENTIFY:
        {
            self.existingPw.text        = @"";
            self.myNewPw.text           = @"";
            self.myNewPwConfirm.text    = @"";
            [[[LoginUtil alloc] init] showSelfIdentifer:LOGIN_BY_SIMPLEPW];
            break;
        }
        case ALERT_SUCCEED_SAVE:
            [self clickCancel];
            break;
        default:
            break;
    }
    
}

#pragma mark - UI
- (void)updateUI {
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeExistingPw];
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeMyNewPw];
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeMyNewPwConfirm];
}

- (void)refreshUI {
    LoginUtil   * util              = [[LoginUtil alloc] init];
    NSString    * simplePassword    = [util getSimplePassword];
    
    [self.existingPw setHidden:!simplePassword];
    CGRect newPwSettingsViewFrame = self.myNewPwSettingsView.frame;
    newPwSettingsViewFrame.origin.y = simplePassword ? 48 : 0;
    [self.myNewPwSettingsView setFrame:newPwSettingsViewFrame];
}

#pragma mark - strong password policy
- (BOOL)isPasswordContainsMobileNo:(NSString *)pw {
    
    NSUserDefaults  * prefs     = [NSUserDefaults standardUserDefaults];
    NSString        * crmMobile = [prefs stringForKey:RESPONSE_CERT_CRM_MOBILE];
    
    NSString        * firstPart;
    NSString        * secondPart;
    
    if (!crmMobile || crmMobile.length < 7) {
        return NO;
    }
    
    // 01074560407
    secondPart  = [crmMobile substringFromIndex:crmMobile.length - 4];  // 0407
    crmMobile   = [crmMobile substringToIndex:crmMobile.length - 4];    // 0107456
    firstPart   = [crmMobile substringFromIndex:3];                     // 7456
    
    if ([pw containsString:firstPart]) {
        return YES;
    }
    
    if ([pw containsString:secondPart]) {
        return YES;
    }
    return NO;
}

@end
