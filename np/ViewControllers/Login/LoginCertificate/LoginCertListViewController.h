//
//  LoginCertListViewController.h
//  np
//
//  Created by Infobank2 on 10/12/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface LoginCertListViewController : CommonViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *certView;
@property (weak, nonatomic) IBOutlet UILabel *certName;
@property (weak, nonatomic) IBOutlet UILabel *certIssuer;
@property (weak, nonatomic) IBOutlet UILabel *certType;
@property (weak, nonatomic) IBOutlet UILabel *issueDate;
@property (weak, nonatomic) IBOutlet UILabel *expiryDate;

- (IBAction)gotoCertCenter;
- (IBAction)gotoLoginSettings;
- (IBAction)gotoNB;
- (IBAction)gotoFAQ;
- (IBAction)gotoTelInquiry;
- (IBAction)clickOnCert:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UITextField *fakeNoticeTextField;
@end
