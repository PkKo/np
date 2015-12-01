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
#import "BTWCodeguard.h"
#import "ServiceDeactivationController.h"

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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_backFromSelfIdentifer) {
        LoginUtil * util = [[LoginUtil alloc] init];
        NSString * patternPw = [util getSimplePassword];
        if (!patternPw) {
            [util gotoSimpleLoginMgmt:self.navigationController animated:YES];
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
    [self toggleBtnBgColor:NO textLength:0];
    _backFromSelfIdentifer = YES;
    [[[LoginUtil alloc] init] showSelfIdentifer:LOGIN_BY_SIMPLEPW];
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
        
    } else if (![[util getEncryptedPassword:pw] isEqualToString:savedPassword]) {
        
        failedTimes++;
        [util saveSimplePasswordFailedTimes:failedTimes];
        if (failedTimes >= 5) {
            
            alertMessage    = @"간편 비밀번호 오류가 5회 이상 발생하여 로그인이 불가능합니다. 본인인증 후 간편 비밀번호를 재설정해주세요.";
            tag             = ALERT_GOTO_SELF_IDENTIFY;
            
        } else {
            
            alertMessage = [NSString stringWithFormat:@"입력하신 비밀번호가 일치하지 않습니다.\n비밀번호를 확인하시고 이용해주세요.\n비밀번호 %d회 오류입니다.", (int)failedTimes];
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
    
    [self toggleBtnBgColor:NO textLength:0];
    
    switch (alertView.tag) {
        case ALERT_GOTO_SELF_IDENTIFY:
            [self gotoSimpleLoginSettings];
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
    
    NSString * loginType        = @"PIN";
    NSUserDefaults * prefs  = [NSUserDefaults standardUserDefaults];
    NSString * user_id      = [prefs stringForKey:RESPONSE_CERT_UMS_USER_ID];
    NSString * crmMobile    = [prefs stringForKey:RESPONSE_CERT_CRM_MOBILE];;
    
    [[Codeguard sharedInstance] setAppName:@"NHSmartPush"];
    [[Codeguard sharedInstance] setAppVer:[CommonUtil getAppVersion]];
    [[Codeguard sharedInstance] setChallengeRequestUrl:[NSString stringWithFormat:@"%@CodeGuard/check.jsp", SERVER_URL]];
    NSString *token = [[Codeguard sharedInstance] requestAndGetToken];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_LOGIN_PINPAT];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setObject:user_id forKey:@"user_id"];
    [requestBody setObject:crmMobile forKey:@"crmMobile"];
    [requestBody setObject:loginType forKey:@"loginType"];
    
    NSString *bodyString = [CommonUtil getBodyString:requestBody];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(loginResponse:)];
    [req requestUrl:url bodyString:bodyString token:token];
    
}

@end
