//
//  LoginSettingsViewController.m
//  np
//
//  Created by Infobank2 on 10/14/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginSettingsViewController.h"
#import "StorageBoxUtil.h"
#import "UIButton+BackgroundColor.h"
#import "LoginUtil.h"
#import "SimplePwMgntChangeViewController.h"
#import "LoginCertController.h"
#import "CertificateMenuViewController.h"
#import "EnvMgmtViewController.h"
#import "RegistCompleteViewController.h"
#import "MainPageViewController.h"

#define HIGHLIGHT_BG_COLOR              [UIColor colorWithRed:62.0f/255.0f green:155.0f/255.0f blue:233.0f/255.0f alpha:1]

#define OVAL_BUTTON_SELECTED_BG_COLOR   [UIColor whiteColor]
#define OVAL_BUTTON_SELECTED_TEXT_COLOR [UIColor colorWithRed:48.0f/255.0f green:158.0f/255.0f blue:251.0f/255.0f alpha:1]

#define OVAL_BUTTON_NORMAL_BG_COLOR     [UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1]
#define OVAL_BUTTON_NORMAL_TEXT_COLOR   [UIColor whiteColor]

#define BOX_BORDER_NORMAL_COLOR         [UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1]
#define BOX_BORDER_SELECTED_COLOR       [UIColor whiteColor]

#define ALERT_CERT_CENTER               100
#define ALERT_SETTINGS_DONE_CONFIRM     101
#define ALERT_SETTINGS_DONE_NO_CHANGE   102

@interface LoginSettingsViewController () {
    LoginMethod selectedLoginMethod;
    LoginMethod selectedPINPATOnly;
    /*
     NSString * originalPAT;
     NSString * originalPIN;
     */
}

@end

@implementation LoginSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:[self isRegistCompleteViewControllerItsParent]];
    [self.mNaviView.mTitleLabel setText:@"로그인 설정"];
    
    selectedPINPATOnly  = LOGIN_BY_NONE;
    selectedLoginMethod = LOGIN_BY_NONE;
    [self updateUI];
    
    LoginMethod savedLoginMethod = [[[LoginUtil alloc] init] getLoginMethod];
    [self selectLoginBy:savedLoginMethod];
    /*
     originalPAT = [[[LoginUtil alloc] init] getPatternPassword];
     originalPIN = [[[LoginUtil alloc] init] getSimplePassword];
     */
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateAfterChangingSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Account Login
- (IBAction)selectAccountLogin {
    
    [self selectLoginBy:LOGIN_BY_ACCOUNT];
}

#pragma mark - Certifcate Login
- (IBAction)selectCertLogin {
    [self selectLoginBy:LOGIN_BY_CERTIFICATE];
}

- (IBAction)gotoCertMgmtCenter {
    [[[LoginUtil alloc] init] gotoCertCentre:self.navigationController];
}

- (IBAction)showCertList {
    NSArray * certificates = [[[LoginCertController alloc] init] getCertList];
    if (certificates && [certificates count] > 0) {
        [[[StorageBoxUtil alloc] init] showCertListInViewController:self dataSource:certificates updateSltedCert:@selector(updateSelectedCert:)];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"현재 저장된 인증서가 없습니다. 인증서 가져오기를 진행해주세요." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        alert.tag = ALERT_CERT_CENTER;
        [alert show];
    }
}

- (void)updateSelectedCert:(CertInfo *)sltedCert {
    if (sltedCert) {
        [self.certListBtn setTitle:[sltedCert.subjectDN2 substringFromIndex:3] forState:UIControlStateNormal];
    }
}

#pragma mark - Simple Login
- (IBAction)selectSimpleLogin:(id)sender {
    
    LoginUtil * util    = [[LoginUtil alloc] init];
    selectedPINPATOnly  = LOGIN_BY_SIMPLEPW;
    
    if ([util existSimplePassword]) {
        
        [self selectLoginBy:LOGIN_BY_SIMPLEPW];
        
    } else if ([util isLoggedIn]) {
        
        [self gotoSimpleLoginMgmt];
    }
}

- (IBAction)gotoSimpleLoginMgmt {
    selectedPINPATOnly  = LOGIN_BY_SIMPLEPW;
    [[[LoginUtil alloc] init] gotoSimpleLoginMgmt:self.navigationController animated:YES];
}

#pragma mark - Pattern Login
- (IBAction)selectPatternLogin {
    
    LoginUtil * util    = [[LoginUtil alloc] init];
    selectedPINPATOnly  = LOGIN_BY_PATTERN;
    
    if ([util existPatternPassword]) {
        
        [self selectLoginBy:LOGIN_BY_PATTERN];
        
    } else if ([util isLoggedIn]) {
        
        [self gotoPatternLoginMgmt];
    }
}

- (IBAction)gotoPatternLoginMgmt {
    selectedPINPATOnly  = LOGIN_BY_PATTERN;
    [[[LoginUtil alloc] init] gotoPatternLoginMgmt:self.navigationController animated:YES];
}

#pragma mark - cancel/done
// overwrite back button's action
- (void)moveBack {
    [self removeLoginSettings];
}

- (IBAction)removeLoginSettings {
    
    LoginMethod loggedInMethod = [[[LoginUtil alloc] init] getLoginMethod];
    if (selectedLoginMethod == LOGIN_BY_NONE && loggedInMethod == LOGIN_BY_NONE) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"로그인 방식을 설정해주세요." delegate:self
                                               cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self isRegistCompleteViewControllerItsParent]) {
        [[[LoginUtil alloc] init] showMainPage];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isRegistCompleteViewControllerItsParent {
    
    NSArray             * viewControllers       = [self.navigationController viewControllers];
    UIViewController    * loginSettingsParent   = nil;
    int                 numberOfViewControllers = (int)[viewControllers count];
    
    if (numberOfViewControllers >= 2) {
        
        loginSettingsParent = [viewControllers objectAtIndex:(numberOfViewControllers - 2)];
        
        if (loginSettingsParent && [[(ECSlidingViewController *)loginSettingsParent topViewController] isKindOfClass:[RegistCompleteViewController class]]) {
            
            return YES;
        }
    }
    return NO;
}

- (IBAction)doneLoginSettings {
    
    LoginUtil * util = [[LoginUtil alloc] init];
    CertInfo * savedCertToLogin = [util getCertToLogin];
    
    if (selectedLoginMethod == LOGIN_BY_CERTIFICATE && !savedCertToLogin) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"공인인증서를 선택해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        if (selectedLoginMethod == LOGIN_BY_NONE) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"로그인 방식을 설정해주세요." delegate:self
                                                   cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"로그인 설정이 완료 되었습니다." delegate:self
                                               cancelButtonTitle:@"확인" otherButtonTitles:nil];
        LoginMethod loggedInMethod = [util getLoginMethod];
        if (loggedInMethod == selectedLoginMethod) {
            
            alert.tag = ALERT_SETTINGS_DONE_NO_CHANGE;
            
        } else {
            [util saveLoginMethod:selectedLoginMethod];
            alert.tag = ALERT_SETTINGS_DONE_CONFIRM;
        }
        [alert show];
    }
}

#pragma mark - UI
- (void)updateUI {
    
    // set background color for highlight state
    [self.accountLoginBtn setBackgroundColor:HIGHLIGHT_BG_COLOR forState:UIControlStateSelected];
    [self.certLoginBtn setBackgroundColor:HIGHLIGHT_BG_COLOR forState:UIControlStateSelected];
    [self.certListBtn setBackgroundColor:HIGHLIGHT_BG_COLOR forState:UIControlStateSelected];
    [self.simpleLoginBtn setBackgroundColor:HIGHLIGHT_BG_COLOR forState:UIControlStateSelected];
    [self.patternLoginBtn setBackgroundColor:HIGHLIGHT_BG_COLOR forState:UIControlStateSelected];
    
    // radio buttons
    self.accountRadioBtn.layer.cornerRadius = self.accountRadioBtn.layer.frame.size.width / 2;
    self.certRadioBtn.layer.cornerRadius    = self.accountRadioBtn.layer.frame.size.width / 2;
    self.simpleRadioBtn.layer.cornerRadius  = self.accountRadioBtn.layer.frame.size.width / 2;
    self.patternRadioBtn.layer.cornerRadius = self.accountRadioBtn.layer.frame.size.width / 2;
    
    // oval buttons
    self.certMgmtCenterBtn.layer.cornerRadius   = 10;
    self.simpleLoginMgmtBtn.layer.cornerRadius  = 10;
    self.patternLoginMgmtBtn.layer.cornerRadius = 10;
}

- (void)updateAfterChangingSetting {
    
    LoginUtil * util            = [[LoginUtil alloc] init];
    CertInfo * savedCertToLogin = [util getCertToLogin];
    [self updateSelectedCert:savedCertToLogin];
    /*
     NSString * simplePw     = [util getSimplePassword];
     NSString * patternPw    = [util getPatternPassword];
     */
    if (![util isLoggedIn]) {
        
        if (![util existSimplePassword]) {
            [self.simpleLoginBtn setEnabled:NO];
        }
        
        if (![util existPatternPassword]) {
            [self.patternLoginBtn setEnabled:NO];
        }
        
        [self.simpleLoginMgmtBtn setEnabled:self.simpleLoginBtn.isEnabled];
        [self.patternLoginMgmtBtn setEnabled:self.patternLoginBtn.isEnabled];
        
    } else {
        [self.simpleLoginMgmtBtn setEnabled:YES];
        [self.patternLoginMgmtBtn setEnabled:YES];
    }
    
    // toggle PIN/PAT login selection
    if ( (selectedLoginMethod == LOGIN_BY_SIMPLEPW && ![util existSimplePassword]) || (selectedLoginMethod == LOGIN_BY_PATTERN && ![util existPatternPassword]) ) {
        [self selectLoginBy:LOGIN_BY_NONE];
    }
    
    LoginMethod loginMethod = [util getLoginMethod];
    if ( (loginMethod == LOGIN_BY_SIMPLEPW && ![util existSimplePassword]) || (loginMethod == LOGIN_BY_PATTERN && ![util existPatternPassword]) ) {
        [util saveLoginMethod:LOGIN_BY_NONE];
    }
    
    // automatically select PIN/PAT login if PIN/PAT is reset.
    if ([util existSimplePassword] && (selectedPINPATOnly == LOGIN_BY_SIMPLEPW)) {
        
        [self selectLoginBy:LOGIN_BY_SIMPLEPW];
        
    } else if ([util existPatternPassword] && (selectedPINPATOnly == LOGIN_BY_PATTERN)) {
        
        [self selectLoginBy:LOGIN_BY_PATTERN];
    }
    
    selectedPINPATOnly = LOGIN_BY_NONE;
}

- (void)selectLoginBy:(LoginMethod)loginMethod {
    
    if (loginMethod == selectedLoginMethod) {
        return;
    }
    [self updateUIByLoginMethod:loginMethod];
    [self updateUIByLoginMethod:selectedLoginMethod];
    selectedLoginMethod = loginMethod;
}

- (void)updateUIByLoginMethod:(LoginMethod)loginMethod {
    
    switch (loginMethod) {
            
        case LOGIN_BY_ACCOUNT:
            self.accountLoginBtn.selected   = !self.accountLoginBtn.isSelected;
            self.accountCheckBtn.hidden     = !self.accountLoginBtn.isSelected;
            self.accountRadioBtn.hidden     =  self.accountLoginBtn.isSelected;
            
            for (UIView * border in self.accountLoginView.subviews) {
                if ([border isKindOfClass:[UILabel class]]) {
                    [border setBackgroundColor:self.accountLoginBtn.isSelected ? HIGHLIGHT_BG_COLOR : BOX_BORDER_NORMAL_COLOR];
                }
            }
            break;
            
        case LOGIN_BY_CERTIFICATE:
            self.certLoginBtn.selected              = !self.certLoginBtn.isSelected;
            self.certCheckBtn.hidden                = !self.certLoginBtn.isSelected;
            self.certRadioBtn.hidden                =  self.certLoginBtn.isSelected;
            self.certMgmtCenterBtn.backgroundColor  =  self.certLoginBtn.isSelected ? OVAL_BUTTON_SELECTED_BG_COLOR : OVAL_BUTTON_NORMAL_BG_COLOR;
            [self.certMgmtCenterBtn setTitleColor:self.certLoginBtn.isSelected ? OVAL_BUTTON_SELECTED_TEXT_COLOR : OVAL_BUTTON_NORMAL_TEXT_COLOR forState:UIControlStateNormal];
            
            for (UIView * border in self.certLoginView.subviews) {
                if ([border isKindOfClass:[UILabel class]]) {
                    [border setBackgroundColor:self.certLoginBtn.isSelected ? HIGHLIGHT_BG_COLOR : BOX_BORDER_NORMAL_COLOR];
                }
            }
            break;
            
        case LOGIN_BY_SIMPLEPW:
            self.simpleLoginBtn.selected            = !self.simpleLoginBtn.isSelected;
            self.simpleCheckBtn.hidden              = !self.simpleLoginBtn.isSelected;
            self.simpleRadioBtn.hidden              =  self.simpleLoginBtn.isSelected;
            self.simpleLoginMgmtBtn.backgroundColor =  self.simpleLoginBtn.isSelected ? OVAL_BUTTON_SELECTED_BG_COLOR : OVAL_BUTTON_NORMAL_BG_COLOR;
            [self.simpleLoginMgmtBtn setTitleColor:self.simpleLoginBtn.isSelected ? OVAL_BUTTON_SELECTED_TEXT_COLOR : OVAL_BUTTON_NORMAL_TEXT_COLOR forState:UIControlStateNormal];
            
            for (UIView * border in self.simpleLoginView.subviews) {
                if ([border isKindOfClass:[UILabel class]]) {
                    [border setBackgroundColor:self.simpleLoginBtn.isSelected ? HIGHLIGHT_BG_COLOR : BOX_BORDER_NORMAL_COLOR];
                }
            }
            break;
            
        case LOGIN_BY_PATTERN:
            self.patternLoginBtn.selected               = !self.patternLoginBtn.isSelected;
            self.patternCheckBtn.hidden                 = !self.patternLoginBtn.isSelected;
            self.patternRadioBtn.hidden                 =  self.patternLoginBtn.isSelected;
            self.patternLoginMgmtBtn.backgroundColor    =  self.patternLoginBtn.isSelected ? OVAL_BUTTON_SELECTED_BG_COLOR : OVAL_BUTTON_NORMAL_BG_COLOR;
            [self.patternLoginMgmtBtn setTitleColor:self.patternLoginBtn.isSelected ? OVAL_BUTTON_SELECTED_TEXT_COLOR : OVAL_BUTTON_NORMAL_TEXT_COLOR forState:UIControlStateNormal];
            
            for (UIView * border in self.patternLoginView.subviews) {
                if ([border isKindOfClass:[UILabel class]]) {
                    [border setBackgroundColor:self.patternLoginBtn.isSelected ? HIGHLIGHT_BG_COLOR : BOX_BORDER_NORMAL_COLOR];
                }
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case ALERT_CERT_CENTER:
        {
            if (buttonIndex == 1) {
                [[[LoginUtil alloc] init] gotoCertCentre:self.navigationController];
            }
            break;
        }
            
        case ALERT_SETTINGS_DONE_CONFIRM:
        {
            NSArray             * viewControllers       = [self.navigationController viewControllers];
            UIViewController    * loginSettingsParent   = nil;
            int                 numberOfViewControllers = (int)[viewControllers count];
            
            if (numberOfViewControllers >= 2) {
                
                loginSettingsParent = [viewControllers objectAtIndex:(numberOfViewControllers - 2)];
                
                UIViewController * previousVC = [(ECSlidingViewController *)loginSettingsParent topViewController];
                
                if (loginSettingsParent && ([previousVC isKindOfClass:[EnvMgmtViewController class]] || [previousVC isKindOfClass:[MainPageViewController class]])) { // click on 로그인 설정 button
                    
                    [self removeLoginSettings];
                    
                } else if (loginSettingsParent && [previousVC isKindOfClass:[RegistCompleteViewController class]]) {
                    
                    [[[LoginUtil alloc] init] showMainPage];
                    
                } else { // login page
                    [[[LoginUtil alloc] init] showLoginPage:self.navigationController];
                }
            }
            break;
        }
            
        case ALERT_SETTINGS_DONE_NO_CHANGE:
        {
            [self removeLoginSettings];
            break;
        }
        default:
            break;
    }
}


@end
