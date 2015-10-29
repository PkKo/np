//
//  SimplePwMgntChangeViewController.h
//  np
//
//  Created by Infobank2 on 10/14/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface SimplePwMgntChangeViewController : CommonViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField    *existingPw;
@property (weak, nonatomic) IBOutlet UIView         *myNewPwSettingsView;
@property (weak, nonatomic) IBOutlet UITextField    *myNewPw;
@property (weak, nonatomic) IBOutlet UITextField    *myNewPwConfirm;

@property (weak, nonatomic) IBOutlet UITextField    *fakeExistingPw;
@property (weak, nonatomic) IBOutlet UITextField    *fakeMyNewPw;
@property (weak, nonatomic) IBOutlet UITextField    *fakeMyNewPwConfirm;

- (IBAction)clickCancel;
- (IBAction)clickDone;

@end
