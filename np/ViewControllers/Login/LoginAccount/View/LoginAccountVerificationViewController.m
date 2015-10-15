//
//  LoginAccountVerificationViewController.m
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginAccountVerificationViewController.h"
#import "LoginUtil.h"
#import "EccEncryptor.h"
#import "LoginSettingsViewController.h"

@interface LoginAccountVerificationViewController ()

@end

@implementation LoginAccountVerificationViewController

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


- (IBAction)gotoLoginSettings {
    LoginSettingsViewController * loginSettings = [[LoginSettingsViewController alloc] initWithNibName:@"LoginSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:loginSettings animated:YES];
}

#pragma mark - Keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    BOOL isAccountNo = NO;
    
    if (textField == self.accountTextField) {
        isAccountNo = YES;
    }
    LoginUtil * util = [[LoginUtil alloc] init];
    [util showSecureNumpadInParent:self topBar:@"계좌 로그인" title:isAccountNo ? @"계좌번호 입력" : @"계좌비밀번호 입력"
                        textLength:isAccountNo ? 15 : 4
                        doneAction:isAccountNo ? @selector(confirmAccountNo:) : @selector(confirmPassword:) cancelAction:nil];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    return NO;
}

- (void)confirmAccountNo:(NSString *)accountNo {
    
    EccEncryptor * ec = [EccEncryptor sharedInstance];
    NSString * plainText = [ec makeDecNoPadWithSeedkey:accountNo];
    self.accountTextField.text = plainText;
}


- (void)confirmPassword:(NSString *)pw {
    
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pw];
    self.passwordTextField.text = plainText;
}

- (void)updateUI {
    
    [self.fakeNoticeTextField.layer setBorderWidth:1.0f];
    [self.fakeNoticeTextField.layer setBorderColor:[[UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1] CGColor]];
}

@end
