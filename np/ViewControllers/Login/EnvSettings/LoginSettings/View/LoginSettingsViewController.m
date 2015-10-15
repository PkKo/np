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
#import "SimplePwMgntNewViewController.h"
#import "SimplePwMgntChangeViewController.h"
#import "ConstantMaster.h"

#define HIGHLIGHT_BG_COLOR [UIColor colorWithRed:62.0f/255.0f green:155.0f/255.0f blue:233.0f/255.0f alpha:1]

@interface LoginSettingsViewController () {
    LoginMethod selectedLoginMethod;
}

@end

@implementation LoginSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"로그인 설정"];
    
    selectedLoginMethod = LOGIN_BY_NONE;
    [self updateUI];
    
    LoginMethod savedLoginMethod = [[[LoginUtil alloc] init] getLoginMethod];
    [self selectLoginBy:savedLoginMethod];
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
    
}

- (IBAction)showCertList {
    [[[StorageBoxUtil alloc] init] showCertListInViewController:self];
}

#pragma mark - Simple Login
- (IBAction)selectSimpleLogin:(id)sender {
    [self selectLoginBy:LOGIN_BY_SIMPLEPW];
}

- (IBAction)gotoSimpleLoginMgmt {
    [self.navigationController pushViewController:[[[LoginUtil alloc] init] getSimpleLoginMgmt] animated:YES];
}

#pragma mark - Pattern Login
- (IBAction)selectPatternLogin {
    [self selectLoginBy:LOGIN_BY_PATTERN];
}

- (IBAction)gotoPatternLoginMgmt {
    
}

#pragma mark - cancel/done
- (IBAction)removeLoginSettings {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneLoginSettings {
    if (selectedLoginMethod != LOGIN_BY_NONE) {
        [[[LoginUtil alloc] init] saveLoginMethod:selectedLoginMethod];
    }
    [self removeLoginSettings];
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
            self.accountLoginBtn.selected  = !self.accountLoginBtn.isSelected;
            self.accountCheckBtn.hidden     = !self.accountLoginBtn.isSelected;
            self.accountRadioBtn.hidden     =  self.accountLoginBtn.isSelected;
            break;
            
        case LOGIN_BY_CERTIFICATE:
            self.certLoginBtn.selected      = !self.certLoginBtn.isSelected;
            self.certCheckBtn.hidden        = !self.certLoginBtn.isSelected;
            self.certRadioBtn.hidden        =  self.certLoginBtn.isSelected;
            break;
            
        case LOGIN_BY_SIMPLEPW:
            self.simpleLoginBtn.selected    = !self.simpleLoginBtn.isSelected;
            self.simpleCheckBtn.hidden      = !self.simpleLoginBtn.isSelected;
            self.simpleRadioBtn.hidden      =  self.simpleLoginBtn.isSelected;
            break;
            
        case LOGIN_BY_PATTERN:
            self.patternLoginBtn.selected   = !self.patternLoginBtn.isSelected;
            self.patternCheckBtn.hidden     = !self.patternLoginBtn.isSelected;
            self.patternRadioBtn.hidden     =  self.patternLoginBtn.isSelected;
            break;
            
        default:
            break;
    }
}

@end
