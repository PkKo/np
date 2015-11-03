//
//  LoginSimpleVerificationViewController.h
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface LoginSimpleVerificationViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UIView *loginBtns;
@property (weak, nonatomic) IBOutlet UITextField *fakeNoticeTextField;
-(IBAction)clickEnterPassword;
- (IBAction)gotoLoginSettings;
- (IBAction)gotoSimpleLoginSettings;
- (IBAction)doLogin;

#pragma mark - Footer
- (IBAction)gotoNotice;
- (IBAction)gotoFAQ;
- (IBAction)gotoTelEnquiry;
@end
