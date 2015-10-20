//
//  SimplePwMgntNewViewController.m
//  np
//
//  Created by Infobank2 on 10/14/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "SimplePwMgntNewViewController.h"
#import "LoginUtil.h"
#import "EccEncryptor.h"
#import "ConstantMaster.h"
#import "StorageBoxUtil.h"

@interface SimplePwMgntNewViewController ()

@end

@implementation SimplePwMgntNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"간편비밀번호 관리"];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    NSString * title;
    SEL action;
    
    if (textField == self.myNewPw) {
        
        title = @"비밀번호 (숫자 6자리) 입력";
        action = @selector(newPassword:);
        
    } else if (textField == self.myNewPwConfirm) {
        title = @"비밀번호 확인 (숫자 6자리) 입력";
        action = @selector(newPasswordConfirm:);
    }
    
    LoginUtil * util = [[LoginUtil alloc] init];
    [util showSecureNumpadInParent:self topBar:@"간편비밀번호 관리" title:title
                        textLength:6
                        doneAction:action cancelAction:nil];
}

- (void)newPassword:(NSString *)pw {
    [self updateInputPassword:pw forTextField:self.myNewPw];
}

- (void)newPasswordConfirm:(NSString *)pw {
    [self updateInputPassword:pw forTextField:self.myNewPwConfirm];
}

- (void)updateInputPassword:(NSString *)pw forTextField:(UITextField *)textField {
    
    EccEncryptor *ec    = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pw];
    textField.text      = plainText;
}

#pragma mark - Cancel/Done
- (IBAction)clickCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickDone {
    
    const int PW_LENGTH = 6;
    NSString * alertMessage = @"";
    NSInteger tag           = ALERT_DO_NOTHING;
    
    if (self.myNewPw.text.length != PW_LENGTH || self.myNewPwConfirm.text.length != PW_LENGTH) {
        
        alertMessage = @"숫자 6자리를 입력해 주세요.";
        
    } else if (![self.myNewPw.text isEqualToString:self.myNewPwConfirm.text]) {
        
        alertMessage = @"입력하신 비밀번호와 비밀번호 확인이 일치하지 않습니다.";
        
    } else {
        alertMessage = @"간편비밀번호가 설정 되었습니다.";
        tag          = ALERT_SUCCEED_SAVE;
        
        LoginUtil * util = [[LoginUtil alloc] init];
        [util saveSimplePassword:self.myNewPw.text];
    }
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                    delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == ALERT_SUCCEED_SAVE) {
        [self clickCancel];
    }
}

#pragma mark - UI
- (void)updateUI {
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeMyNewPw];
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeMyNewPwConfirm];
}

@end
