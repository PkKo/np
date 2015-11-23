//
//  ServiceDeactivationViewController.m
//  np
//
//  Created by Infobank2 on 10/21/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ServiceDeactivationViewController.h"

@interface ServiceDeactivationViewController ()

@end

@implementation ServiceDeactivationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"서비스 해지"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deactivateService {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"서비스를 해지 하시겠습니까?\n서비스해지는 로그인 후 완료됩니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        LoginUtil * util = [[LoginUtil alloc] init];
        
        [util deactivateService:YES];
        [util setLogInStatus:NO];
        [util showLoginPage:self.navigationController];
    }
}

@end
