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
    self.loginMethod = LOGIN_BY_SIMPLEPW;
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
    
    const int PW_LENGTH                   = 6;
    
    NSString * alertMessage     = nil;
    NSInteger tag               = ALERT_DO_NOTHING;
    
    if (!self.existingPw.isHidden) {
        
        if (self.existingPw.text.length != PW_LENGTH) {
            
            alertMessage = @"숫자 6자리를 입력해 주세요.";
            
        } else {
            
            [self startIndicator];
            [self validateLoginPassword:self.existingPw.text checkPasswordSEL:@selector(checkLoginPassword:)];
            
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
            [self startIndicator];
            [self resetPasswordOnServer:self.myNewPw.text];
        }
        
    }
    
    if (alertMessage) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                        delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alert.tag = tag;
        [alert show];
    }
}

- (void)checkLoginPassword:(NSDictionary *)response {
    
    NSLog(@"%s", __func__);
    
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        const int PW_LENGTH         = 6;
        NSString * alertMessage     = nil;
        NSInteger tag               = ALERT_DO_NOTHING;
        
        if (self.myNewPw.text.length != PW_LENGTH || self.myNewPwConfirm.text.length != PW_LENGTH) {
            
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
            
            [self startIndicator];
            [self resetPasswordOnServer:self.myNewPw.text];
        }
        
        if (alertMessage != nil) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                            delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            alert.tag = tag;
            [alert show];
        }
        
    } else {
        
        NSInteger tag = ALERT_DO_NOTHING;
        
        if([[response objectForKey:RESULT] isEqualToString:RESULT_PIN_EXCEED_5_TIMES]) {
            tag = ALERT_GOTO_SELF_IDENTIFY;
        }
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alertView.tag = tag;
        [alertView show];
    }
}

- (BOOL)resetPassword:(NSDictionary *)response {
    
    NSLog(@"----- NHI ----> %s", __func__);
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        [[[LoginUtil alloc] init] setSimplePasswordExist:YES];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"간편비밀번호가 변경 되었습니다."
                                                        delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alert.tag = ALERT_SUCCEED_SAVE;
        [alert show];
        
        return YES;
        
    } else {
        
        [self stopIndicator];
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
    
    return NO;
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
    LoginUtil   * util      = [[LoginUtil alloc] init];
    BOOL simplePassword     = [util existSimplePassword];
    
    [self.existingPw setHidden:!simplePassword];
    CGRect newPwSettingsViewFrame = self.myNewPwSettingsView.frame;
    newPwSettingsViewFrame.origin.y = simplePassword ? 48 : 0;
    [self.myNewPwSettingsView setFrame:newPwSettingsViewFrame];
}

#pragma mark - strong password policy
- (BOOL)isPasswordContainsMobileNo:(NSString *)pw {
    
    NSUserDefaults  * prefs     = [NSUserDefaults standardUserDefaults];
    NSString        * crmMobile = [CommonUtil decrypt3DES:[prefs stringForKey:RESPONSE_CERT_CRM_MOBILE] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
    
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
