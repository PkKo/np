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

-(IBAction)resetData {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"NH스마트알림 모든 데이터 (전체, 입출금, 보관함 등)가 초기화 됩니다. 초기화 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alert show];
}

-(void)refreshUI {
    LoginUtil * util = [[LoginUtil alloc] init];
    [self.usingSimpleViewBtn setSelected:[util isUsingSimpleView]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            // remove data here
            
            // show main view
            [[[LoginUtil alloc] init] showMainPage];
            break;
        default:
            break;
    }
}

@end
