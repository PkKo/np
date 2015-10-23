//
//  EnvMgmtViewController.m
//  np
//
//  Created by Infobank2 on 10/19/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "EnvMgmtViewController.h"
#import "LoginUtil.h"
#import "NoticeBackgroundSettingsViewController.h"
#import "DrawPatternLockViewController.h"
#import "LoginCertListViewController.h"
#import "LoginAccountVerificationViewController.h"
#import "LoginSimpleVerificationViewController.h"

@interface EnvMgmtViewController ()

@end

@implementation EnvMgmtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"환경설정"];
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toggleUsingSimpleView:(UIButton *)simpleViewSwitch {
    [simpleViewSwitch setSelected:!simpleViewSwitch.isSelected];
    LoginUtil * util = [[LoginUtil alloc] init];
    [util saveUsingSimpleViewFlag:simpleViewSwitch.isSelected];
}

-(IBAction)gotoLoginSettings {
    [[[LoginUtil alloc] init] gotoLoginSettings:self.navigationController];
}

-(IBAction)gotoSimpleLoginMgmt {
    [[[LoginUtil alloc] init] gotoSimpleLoginMgmt:self.navigationController];
}

-(IBAction)gotoPatternLoginMgmt {
    [[[LoginUtil alloc] init] gotoPatternLoginMgmt:self.navigationController];
}

-(IBAction)gotoNoticeBgColorSettings {
    NoticeBackgroundSettingsViewController *noticeBgColorSettings = [[NoticeBackgroundSettingsViewController alloc] initWithNibName:@"NoticeBackgroundSettingsViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:noticeBgColorSettings];
    [self.navigationController pushViewController:eVC animated:YES];
}

-(void)refreshUI {
    LoginUtil * util = [[LoginUtil alloc] init];
    [self.usingSimpleViewBtn setSelected:[util isUsingSimpleView]];
}










- (IBAction)gotoPatternLogin:(id)sender {
    
    DrawPatternLockViewController *certLogin = [[DrawPatternLockViewController alloc] initWithNibName:@"DrawPatternLockViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:certLogin];
    [self.navigationController pushViewController:eVC animated:YES];
    
}

- (IBAction)gotoCertLogin:(id)sender {
    
    LoginCertListViewController *certLogin = [[LoginCertListViewController alloc] initWithNibName:@"LoginCertListViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:certLogin];
    [self.navigationController pushViewController:eVC animated:YES];
}

- (IBAction)gotoAccountLogin:(id)sender {
    
    LoginAccountVerificationViewController *accountLogin = [[LoginAccountVerificationViewController alloc] initWithNibName:@"LoginAccountVerificationViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:accountLogin];
    [self.navigationController pushViewController:eVC animated:YES];
}
- (IBAction)gotoSimpleLogin:(id)sender {
    
    LoginSimpleVerificationViewController *simpleLogin = [[LoginSimpleVerificationViewController alloc] initWithNibName:@"LoginSimpleVerificationViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:simpleLogin];
    [self.navigationController pushViewController:eVC animated:YES];
}

@end
