//
//  LoginSimpleVerificationViewController.h
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginBase.h"

@interface LoginSimpleVerificationViewController : LoginBase

@property (weak, nonatomic) IBOutlet UIView *loginBtns;
@property (weak, nonatomic) IBOutlet UITextField *fakeNoticeTextField;

@property (weak, nonatomic) IBOutlet UIView  *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;

@property (weak, nonatomic) IBOutlet UILabel        * noteAsterisk1;
@property (weak, nonatomic) IBOutlet UILabel        * noteAsterisk2;
@property (weak, nonatomic) IBOutlet UILabel        * noteContent1;
@property (weak, nonatomic) IBOutlet UILabel        * noteContent2;
-(IBAction)clickEnterPassword;
- (IBAction)gotoLoginSettings;
- (IBAction)gotoSimpleLoginSettings;
- (IBAction)doLogin;

@end
