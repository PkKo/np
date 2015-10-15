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

@interface LoginSimpleVerificationViewController ()

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

- (IBAction)gotoLoginSettings {
    LoginSettingsViewController * loginSettings = [[LoginSettingsViewController alloc] initWithNibName:@"LoginSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:loginSettings animated:YES];
}

#pragma mark - Keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    LoginUtil * util = [[LoginUtil alloc] init];
    [util showSecureNumpadInParent:self topBar:@"간편 로그인" title:@"비밀번호 입력"
                        textLength:6
                        doneAction:@selector(confirmPassword:) cancelAction:nil];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    return NO;
}

- (void)confirmPassword:(NSString *)pw {
    
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pw];
    self.pwTextField.text = plainText;
}

- (void)updateUI {
    
    [self.fakeNoticeTextField.layer setBorderWidth:1.0f];
    [self.fakeNoticeTextField.layer setBorderColor:[[UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1] CGColor]];
}

@end
