//
//  CustomerCenterViewController.m
//  np
//
//  Created by Infobank2 on 10/19/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "CustomerCenterViewController.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
