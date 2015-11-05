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
    [[[LoginUtil alloc] init] gotoLoginSettings:self.navigationController];
}

#pragma mark - Keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    int textLength;
    SEL confirmAction;
    NSString * title;
    
    if (textField == self.accountTextField) {
        
        textLength      = 15;
        confirmAction   = @selector(confirmAccountNo:);
        title           = @"계좌번호 입력";
        
    } else if (textField == self.passwordTextField) {
        
        textLength      = 4;
        confirmAction   = @selector(confirmPassword:);
        title           = @"계좌비밀번호 입력";
        
    } else if (textField == self.birthdayTextField) {
        
        textLength      = 6;
        confirmAction   = @selector(confirmBirthday:);
        title           = @"생년월일 입력";
    }
    
    LoginUtil * util = [[LoginUtil alloc] init];
    
    [util showSecureNumpadInParent:self topBar:@"계좌 로그인" title:title
                        textLength:textLength
                        doneAction:confirmAction methodOnPress:confirmAction];
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

- (void)confirmBirthday:(NSString *)birthday {
    
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:birthday];
    self.birthdayTextField.text = plainText;
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
                                                   ofViewController:self action:@selector(loginResult:)];
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
}

- (void)loginResult:(NSDictionary *)response {
    
    NSLog(@"response: %@", response);
    [self stopIndicator];
    
    LoginUtil * util        = [[LoginUtil alloc] init];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        NSDictionary * list     = (NSDictionary *)(response[@"list"]);
        NSArray * accounts      = (NSArray *)(list[@"sub"]);
        
        int numberOfAccounts    = (int)[accounts count];
        BOOL hasAccounts         = NO;
        
        if (numberOfAccounts > 0) {
            
            NSMutableArray * accountNumbers = [NSMutableArray array];
            for (NSDictionary * account in accounts) {
                [accountNumbers addObject:(NSString *)account[@"UMSA360101_OUT_SUB.account_number"]];
            }
            
            if ([accountNumbers count] > 0) {
                hasAccounts = YES;
                [util saveAllAccounts:[accountNumbers copy]];
                [util showMainPage];
            }
        }
        
        if (!hasAccounts) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"계좌목록 없습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
        }
        
    } else {
        
        NSString    * message   = [response objectForKey:RESULT_MESSAGE];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Footer
- (IBAction)gotoNotice {
    [[CustomerCenterUtil sharedInstance] gotoNotice];
}
- (IBAction)gotoFAQ {
    [[CustomerCenterUtil sharedInstance] gotoFAQ];
}

- (IBAction)gotoTelEnquiry {
    [[CustomerCenterUtil sharedInstance] gotoTelEnquiry];
}

@end
