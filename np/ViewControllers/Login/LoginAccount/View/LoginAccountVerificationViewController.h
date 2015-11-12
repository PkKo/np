//
//  LoginAccountVerificationViewController.h
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface LoginAccountVerificationViewController : CommonViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField    * accountTextField;
@property (weak, nonatomic) IBOutlet UITextField    * passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField    * birthdayTextField;
@property (weak, nonatomic) IBOutlet UITextField    * fakeNoticeTextField;
@property (weak, nonatomic) IBOutlet UILabel        * noteAsterisk1;
@property (weak, nonatomic) IBOutlet UILabel        * noteAsterisk2;
@property (weak, nonatomic) IBOutlet UILabel        * noteContent1;
@property (weak, nonatomic) IBOutlet UILabel        * noteContent2;

@property (weak, nonatomic) IBOutlet UIView         * containerView;
@property (weak, nonatomic) IBOutlet UIScrollView   * containerScrollView;

- (IBAction)clickToLogin;
- (IBAction)gotoLoginSettings;

#pragma mark - Footer
- (IBAction)gotoNotice;
- (IBAction)gotoFAQ;
- (IBAction)gotoTelEnquiry;

@end
