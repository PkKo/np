//
//  LoginSettingsViewController.h
//  np
//
//  Created by Infobank2 on 10/14/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface LoginSettingsViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UIButton *accountRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *accountCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *accountLoginBtn;
- (IBAction)selectAccountLogin;

@property (weak, nonatomic) IBOutlet UIButton *certRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *certCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *certLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *certMgmtCenterBtn;
- (IBAction)selectCertLogin;
- (IBAction)gotoCertMgmtCenter;
- (IBAction)showCertList;
@property (weak, nonatomic) IBOutlet UIButton *certListBtn;

@property (weak, nonatomic) IBOutlet UIButton *simpleRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *simpleCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *simpleLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *simpleLoginMgmtBtn;
- (IBAction)selectSimpleLogin:(id)sender;
- (IBAction)gotoSimpleLoginMgmt;

@property (weak, nonatomic) IBOutlet UIButton *patternRadioBtn;
@property (weak, nonatomic) IBOutlet UIButton *patternCheckBtn;
@property (weak, nonatomic) IBOutlet UIButton *patternLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *patternLoginMgmtBtn;
- (IBAction)selectPatternLogin;
- (IBAction)gotoPatternLoginMgmt;

- (IBAction)removeLoginSettings;
- (IBAction)doneLoginSettings;


@end
