//
//  CustomerCenterViewController.m
//  np
//
//  Created by Infobank2 on 10/19/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "CustomerCenterViewController.h"
#import "TelInquiryViewController.h"
#import "VersionInfoViewController.h"
#import "ServiceDeactivationViewController.h"
#import "ServiceGuideViewController.h"

@interface CustomerCenterViewController ()

@end

@implementation CustomerCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"고객센터"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoTelEnquiry {
    TelInquiryViewController * telInquiry = [[TelInquiryViewController alloc] initWithNibName:@"TelInquiryViewController"
                                                                                       bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:telInquiry];
    [self.navigationController pushViewController:eVC animated:YES];
}

- (IBAction)gotoVersionInfo {
    VersionInfoViewController * versionInfo = [[VersionInfoViewController alloc] initWithNibName:@"VersionInfoViewController"
                                                                                       bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:versionInfo];
    [self.navigationController pushViewController:eVC animated:YES];
}


- (IBAction)gotoServiceDeactivation {
    ServiceDeactivationViewController * serviceDeactivation = [[ServiceDeactivationViewController alloc] initWithNibName:@"ServiceDeactivationViewController"
                                                                                          bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:serviceDeactivation];
    [self.navigationController pushViewController:eVC animated:YES];
}

- (IBAction)gotoServiceGuide {
    ServiceGuideViewController * serviceGuide = [[ServiceGuideViewController alloc] initWithNibName:@"ServiceGuideViewController"
                                                                                                                  bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:serviceGuide];
    [self.navigationController pushViewController:eVC animated:YES];
}
@end
