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
#import "StorageBoxUtil.h"
#import "LoginAccountController.h"
#import "LoginAccountVerificationViewController.h"
#import "CustomerCenterUtil.h"
#import "ServiceDeactivationController.h"

@interface LoginAccountVerificationViewController () {
    UITextField * _edittingTextField;
}

@end

@implementation LoginAccountVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@""];
    
    _edittingTextField = nil;
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)gotoLoginSettings {
    [[[LoginUtil alloc] init] gotoLoginSettings:self.navigationController];
}

#pragma mark - Keyboard
- (IBAction)validateAccountTextEditing:(UITextField *)sender {
    [self checkMaxTextInputLength:15 ofTextField:sender];
}

- (IBAction)validateBirthdayTextEditing:(UITextField *)sender {
    [self checkMaxTextInputLength:6 ofTextField:sender];
}

- (void)checkMaxTextInputLength:(int)maxLength ofTextField:(UITextField *)sender {
    if ([[sender text] length] >= maxLength) {
        [sender setText:[[sender text] substringToIndex:maxLength]];
        [self tapOutsideOfKBToHideKeyboard:nil];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == self.passwordTextField) {
        
        [textField setText:@""];
        
        [textField resignFirstResponder];
        
        SEL confirmAction   = @selector(confirmPassword:);
        
        LoginUtil * util = [[LoginUtil alloc] init];
        [util showSecureNumpadInParent:self topBar:@"계좌 로그인" title:@"계좌비밀번호 입력"
                            textLength:4
                            doneAction:confirmAction methodOnPress:confirmAction];
        return;
    }
    
    _edittingTextField = textField;
    [self.keyboardDimmedBg setHidden:NO];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    return NO;
}

- (void)confirmPassword:(NSString *)pw {
    
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pw];
    self.passwordTextField.text = plainText;
}

- (IBAction)tapOutsideOfKBToHideKeyboard:(UITapGestureRecognizer *)sender {
    if (_edittingTextField) {
        [_edittingTextField resignFirstResponder];
        [self.keyboardDimmedBg setHidden:YES];
        _edittingTextField = nil;
    }
}

- (IBAction)clickToLogin {
    
    NSString * alertMessage = nil;
    NSInteger tag           = ALERT_DO_NOTHING;
    
    if (!self.accountTextField.text || [self.accountTextField.text isEqualToString:@""]) {
        
        alertMessage = @"계좌번호를 다시 확인해주세요.";
        
    } else if (!self.passwordTextField.text || [self.passwordTextField.text length] < 4) {
        
        alertMessage = @"비밀번호를 다시 확인해주세요.";
        
    } else if (!self.birthdayTextField.text || [self.birthdayTextField.text length] < 6) {
        
        alertMessage = @"생년월일을 다시 확인해주세요.";
        
    } else {
        
        [self startIndicator];
        [[[LoginAccountController alloc] init] validateLoginAccount:self.accountTextField.text
                                                           password:self.passwordTextField.text
                                                           birthday:self.birthdayTextField.text
                                                   ofViewController:self action:@selector(loginResponse:)];
        
        //[self clearData];
    }
    
    if (alertMessage) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                        delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alert.tag = tag;
        [alert show];
    }
}

- (void)updateUI {
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeNoticeTextField color:TEXT_FIELD_BORDER_COLOR_FOR_LOGIN_NOTICE];
    [self resizeContainerScrollView];
    [self resizeNoticeContent];
}
- (void)resizeContainerScrollView {
    
    CGFloat screenHeight                    = [[UIScreen mainScreen] bounds].size.height;
    CGRect containerScrollViewFrame         = self.containerScrollView.frame;
    containerScrollViewFrame.size.height    = screenHeight - self.containerScrollView.frame.origin.y;
    
    [self.containerScrollView setFrame:containerScrollViewFrame];
    
    CGRect containerViewRect = self.containerView.frame;
    if (containerViewRect.size.height < containerScrollViewFrame.size.height) {
        containerViewRect.size.height = containerScrollViewFrame.size.height - 20;
        [self.containerView setFrame:containerViewRect];
    }
    
    [self.containerScrollView setContentSize:self.containerView.frame.size];
}

- (void)resizeNoticeContent {
    
    CGFloat screenWidth             = [[UIScreen mainScreen] bounds].size.width;
    CGRect fakeNoticeTextFieldFrame = self.fakeNoticeTextField.frame;
    CGFloat contentWidth            = screenWidth - self.fakeNoticeTextField.superview.frame.origin.x * 2  - (self.noteContent1.frame.origin.x - fakeNoticeTextFieldFrame.origin.x) - 5;
    
    CGRect noteContent1Rect     = self.noteContent1.frame;
    noteContent1Rect.size.width = contentWidth;
    [self.noteContent1 setFrame:noteContent1Rect];
    [self.noteContent1 sizeToFit];
    noteContent1Rect            = self.noteContent1.frame;
    
    CGRect noteAsterisk1Rect    = self.noteAsterisk1.frame;
    noteAsterisk1Rect.origin.y  = noteContent1Rect.origin.y + 3;
    [self.noteAsterisk1 setFrame:noteAsterisk1Rect];
    
    CGRect noteContent2Rect     = self.noteContent2.frame;
    noteContent2Rect.size.width = contentWidth;
    noteContent2Rect.origin.y   = noteContent1Rect.origin.y + noteContent1Rect.size.height + 4;
    [self.noteContent2 setFrame:noteContent2Rect];
    [self.noteContent2 sizeToFit];
    noteContent2Rect            = self.noteContent2.frame;
    
    CGRect noteAsterisk2Rect    = self.noteAsterisk2.frame;
    noteAsterisk2Rect.origin.y  = noteContent2Rect.origin.y + 3;
    [self.noteAsterisk2 setFrame:noteAsterisk2Rect];
    
    fakeNoticeTextFieldFrame.size.height = noteContent2Rect.origin.y - fakeNoticeTextFieldFrame.origin.y + noteContent2Rect.size.height + 5;
    [self.fakeNoticeTextField setFrame:fakeNoticeTextFieldFrame];
}

- (void)clearData {
    self.accountTextField.text = @"";
    self.passwordTextField.text = @"";
    self.birthdayTextField.text = @"";
}
@end
