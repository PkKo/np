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

@interface EnvMgmtViewController ()

@end

@implementation EnvMgmtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"환경설정"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)gotoLoginSettings {
    [[[LoginUtil alloc] init] gotoLoginSettings:self.navigationController];
}

-(IBAction)gotoSimpleLoginMgmt {
    [[[LoginUtil alloc] init] gotoSimpleLoginMgmt:self.navigationController];
}

-(IBAction)gotoNoticeBgColorSettings {
    NoticeBackgroundSettingsViewController *noticeBgColorSettings = [[NoticeBackgroundSettingsViewController alloc] initWithNibName:@"NoticeBackgroundSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:noticeBgColorSettings animated:YES];
}

@end
