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
    NSInteger failedTimes   = [util getAccountPasswordFailedTimes];
    
    NSString * alertMessage = nil;
    NSInteger tag           = ALERT_DO_NOTHING;
    
    if (!self.accountTextField.text || [self.accountTextField.text isEqualToString:@""]) {
        
        alertMessage = @"계좌번호를 다시 확인해주세요.";
        
    } else if (!self.passwordTextField.text || [self.passwordTextField.text length] < 4) {
        
        alertMessage = @"비밀번호를 다시 확인해주세요.";
        
    } else {
        
        if (failedTimes >= 3) {
            
            alertMessage    = @"비밀번호 오류가 3회 이상 발생하여 해당 계좌 인증이 불가능합니다. 가까운 NH농협 영업점을 방문하셔서 비밀번호를 재설정해주세요.";
            tag             = ALERT_GOTO_SELF_IDENTIFY;
            
        } else {
            [self startIndicator];
            [[[LoginAccountController alloc] init] validateLoginAccount:self.accountTextField.text password:self.passwordTextField.text ofViewController:self action:@selector(loginResult:)];
        }
    }
    
    if (alertMessage) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                        delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alert.tag = tag;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_GOTO_SELF_IDENTIFY:
        {
            exit(0);
            break;
        }
        default:
            break;
    }
}

- (void)updateUI {
    
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeNoticeTextField];
}

- (void)loginResult:(NSDictionary *)response {
    
    LoginUtil * util        = [[LoginUtil alloc] init];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        NSDictionary * list     = (NSDictionary *)(response[@"list"]);
        NSArray * accounts      = (NSArray *)(list[@"sub"]);
        
        NSLog(@"accounts: %@", accounts);
        
        int numberOfAccounts    = (int)[accounts count];
        
        if (numberOfAccounts > 0) {
            
            NSMutableArray * accountNumbers = [NSMutableArray arrayWithCapacity:numberOfAccounts];
            for (NSDictionary * account in accounts) {
                [accountNumbers addObject:(NSString *)account[@"UMSD060101_OUT_SUB.account_number"]];
            }
            
            if ([accountNumbers count] > 0) {
                [util saveAllAccounts:[accountNumbers copy]];
            }
        }
        
        [util saveAccountPasswordFailedTimes:0];
        [self stopIndicator];
        [util showMainPage];
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        
        /*
        NSString * alertMessage = nil;
        NSInteger tag           = ALERT_DO_NOTHING;
        NSInteger failedTimes   = [util getAccountPasswordFailedTimes];
         
        failedTimes++;
        [util saveAccountPasswordFailedTimes:failedTimes];
        if (failedTimes >= 3) {
            
            alertMessage    = @"비밀번호 오류가 3회 이상 발생하여 해당 계좌 인증이 불가능합니다. 가까운 NH농협 영업점을 방문하셔서 비밀번호를 재설정해주세요.";
            tag             = ALERT_GOTO_SELF_IDENTIFY;
            
        } else {
            
            alertMessage = [NSString stringWithFormat:@"입력하신 비밀번호가 일치하지 않습니다.\n비밀번호를 확인하시고 이용해주세요.\n비밀번호 %d 회 오류입니다.", (int)failedTimes];
        }
        
        
        if (alertMessage) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                            delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            alert.tag = tag;
            [alert show];
        }
         */
    }
}

@end
