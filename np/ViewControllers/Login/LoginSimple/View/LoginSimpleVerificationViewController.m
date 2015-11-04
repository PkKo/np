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
#import "CustomerCenterUtil.h"

@interface LoginSimpleVerificationViewController () {
    NSString * _pw;
    BOOL _backFromSelfIdentifer;
}

@end

@implementation LoginSimpleVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@""];
    
    _backFromSelfIdentifer = NO;
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_backFromSelfIdentifer) {
        LoginUtil * util = [[LoginUtil alloc] init];
        NSString * patternPw = [util getSimplePassword];
        if (!patternPw) {
            [util gotoSimpleLoginMgmt:self.navigationController];
        }
    }
}

#pragma mark - Action
-(IBAction)clickEnterPassword {
    
    [self toggleBtnBgColor:NO textLength:0];
    
    LoginUtil * util = [[LoginUtil alloc] init];
    [util showSecureNumpadInParent:self topBar:@"간편 로그인" title:@"비밀번호 입력"
                        textLength:6
                        doneAction:@selector(confirmPassword:) methodOnPress:@selector(confirmPassword:)];
}

- (IBAction)gotoLoginSettings {
    [[[LoginUtil alloc] init] gotoLoginSettings:self.navigationController];
}

- (IBAction)gotoSimpleLoginSettings {
    [[[LoginUtil alloc] init] gotoSimpleLoginMgmt:self.navigationController];
}

- (IBAction)doLogin {
    if ([self validatePW:_pw]) {
        [self startIndicator];
        [self validateLoginSimple];
        [[[LoginUtil alloc] init] saveSimplePasswordFailedTimes:0];
    }
}

#pragma mark - Logic
- (void)confirmPassword:(NSString *)pw {
    
    EccEncryptor *ec    = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pw];
    _pw                 = plainText;
    
    [self toggleBtnBgColor:NO textLength:0];
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
        [util saveSimplePasswordFailedTimes:failedTimes];
        if (failedTimes >= 5) {
            
            alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 본인인증이 필요합니다. 본인인증 후 다시 이용해주세요.";
            tag             = ALERT_GOTO_SELF_IDENTIFY;
            
        } else {
            
            alertMessage = [NSString stringWithFormat:@"비밀번호가 일치하지 않습니다.\n비밀번호 %d 회 오류입니다.", (int)failedTimes];
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
            [self toggleBtnBgColor:NO textLength:0];
            _backFromSelfIdentifer = YES;
            [[[LoginUtil alloc] init] showSelfIdentifer:LOGIN_BY_SIMPLEPW];
            break;
        default:
            break;
    }
}

- (void)updateUI {
    
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeNoticeTextField color:TEXT_FIELD_BORDER_COLOR_FOR_LOGIN_NOTICE];
    
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
            
            [loginBtn setBackgroundColor:[UIColor colorWithRed:62.0f/255.0f green:155.0f/255.0f blue:233.0f/255.0f alpha:1]];
        }
        
    } else {
        for (UIButton * loginBtn in self.loginBtns.subviews) {
            [loginBtn setBackgroundColor:[UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1]];
        }
    }
}

#pragma mark - Server Connection
- (void)validateLoginSimple {
    
    NSLog(@"%s", __func__);
    
    NSString * loginType        = @"PIN";
    NSUserDefaults * prefs  = [NSUserDefaults standardUserDefaults];
    NSString * user_id      = [prefs stringForKey:RESPONSE_CERT_UMS_USER_ID]; //@"150324104128890";
    NSString * crmMobile    = [prefs stringForKey:RESPONSE_CERT_CRM_MOBILE];;//@"01540051434";
    
    NSLog(@"user_id: %@", user_id);
    NSLog(@"crmMobile: %@", crmMobile);
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_LOGIN_PINPAT];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setObject:user_id forKey:@"user_id"];
    [requestBody setObject:crmMobile forKey:@"crmMobile"];
    [requestBody setObject:loginType forKey:@"loginType"];
    
    NSString *bodyString = [CommonUtil getBodyString:requestBody];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(loginResponse:)];
    [req requestUrl:url bodyString:bodyString];
    
}

- (void)loginResponse:(NSDictionary *)response {
    
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        NSDictionary * list     = (NSDictionary *)(response[@"list"]);
        NSArray * accounts      = (NSArray *)(list[@"sub"]);
        int numberOfAccounts    = (int)[accounts count];
        BOOL hasAccounts        = NO;
        
        if (numberOfAccounts > 0) {
            
            NSMutableArray * accountNumbers = [NSMutableArray array];
            for (NSDictionary * account in accounts) {
                [accountNumbers addObject:(NSString *)account[@"UMSD060101_OUT_SUB.account_number"]];
            }
            
            if ([accountNumbers count] > 0) {
                hasAccounts = YES;
                [[[LoginUtil alloc] init] saveAllAccounts:[accountNumbers copy]];
                [[[LoginUtil alloc] init] showMainPage];
            }
        }
        
        if (!hasAccounts) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"계좌목록 없습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
        }
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
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
