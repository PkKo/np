//
//  SimplePwMgntNewViewController.h
//  np
//
//  Created by Infobank2 on 10/14/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface SimplePwMgntNewViewController : CommonViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *myNewPw;
@property (weak, nonatomic) IBOutlet UITextField *myNewPwConfirm;

- (IBAction)clickCancel;
- (IBAction)clickDone;

@end
