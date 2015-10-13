//
//  LoginCertVerificationViewController.h
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface LoginCertVerificationViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UITextField *fakeTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
- (IBAction)clickCancel;
- (IBAction)clickDone;
@end
