//
//  LoginCertListViewController.h
//  np
//
//  Created by Infobank2 on 10/12/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginBase.h"

@interface LoginCertListViewController : LoginBase <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView         * certView;
@property (weak, nonatomic) IBOutlet UILabel        * certName;
@property (weak, nonatomic) IBOutlet UILabel        * certIssuer;
@property (weak, nonatomic) IBOutlet UILabel        * certType;
@property (weak, nonatomic) IBOutlet UILabel        * issueDate;
@property (weak, nonatomic) IBOutlet UILabel        * expiryDate;

@property (weak, nonatomic) IBOutlet UIView         * containerView;
@property (weak, nonatomic) IBOutlet UIScrollView   * containerScrollView;

@property (weak, nonatomic) IBOutlet UITextField    * fakeNoticeTextField;
@property (weak, nonatomic) IBOutlet UILabel        * noteAsterisk;
@property (weak, nonatomic) IBOutlet UILabel        * noteContent;

- (IBAction)gotoCertCenter;
- (IBAction)gotoLoginSettings;
- (IBAction)clickOnCert:(UITapGestureRecognizer *)sender;
@end
