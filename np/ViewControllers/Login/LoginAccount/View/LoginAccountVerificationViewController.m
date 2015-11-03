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
    
    BOOL isAccountNo = NO;
    
    if (textField == self.accountTextField) {
        isAccountNo = YES;
    }
    LoginUtil * util = [[LoginUtil alloc] init];
    
    SEL textEditingAction = isAccountNo ? @selector(confirmAccountNo:) : @selector(confirmPassword:);
    
    [util showSecureNumpadInParent:self topBar:@"계좌 로그인" title:isAccountNo ? @"계좌번호 입력" : @"계좌비밀번호 입력"
                        textLength:isAccountNo ? 15 : 4
                        doneAction:textEditingAction methodOnPress:textEditingAction];
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

- (IBAction)clickToLogin {
    
    LoginUtil * util        = [[LoginUtil alloc] init];
    
    NSString * alertMessage = nil;
    NSInteger tag           = ALERT_DO_NOTHING;
    
    if (!self.accountTextField.text || [self.accountTextField.text isEqualToString:@""]) {
        
        alertMessage = @"계좌번호를 다시 확인해주세요.";
        
    } else if (!self.passwordTextField.text || [self.passwordTextField.text length] < 4) {
        
        alertMessage = @"비밀번호를 다시 확인해주세요.";
        
    } else {
        
        [self startIndicator];
        [[[LoginAccountController alloc] init] validateLoginAccount:self.accountTextField.text password:self.passwordTextField.text ofViewController:self action:@selector(loginResult:)];
    }
    
    if (alertMessage) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                        delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alert.tag = tag;
        [alert show];
    }
}

- (void)updateUI {
    
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeNoticeTextField];
}

- (void)loginResult:(NSDictionary *)response {
    
    NSLog(@"response: %@", response);
    [self stopIndicator];
    
    LoginUtil * util        = [[LoginUtil alloc] init];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        NSDictionary * list     = (NSDictionary *)(response[@"list"]);
        NSArray * accounts      = (NSArray *)(list[@"sub"]);
        
        int numberOfAccounts    = (int)[accounts count];
        
        if (numberOfAccounts > 0) {
            
            NSMutableArray * accountNumbers = [NSMutableArray arrayWithCapacity:numberOfAccounts];
            for (NSDictionary * account in accounts) {
                [accountNumbers addObject:(NSString *)account[@"UMSD060101_OUT_SUB.account_number"]];
            }
            
            if ([accountNumbers count] > 0) {
                
                [util saveAllAccounts:[accountNumbers copy]];
                [util showMainPage];
                
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"계좌목록 없습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
            }
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
