//
//  LoginSimpleVerificationViewController.h
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface LoginSimpleVerificationViewController : CommonViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *pwTextField;
@property (weak, nonatomic) IBOutlet UITextField *fakeNoticeTextField;
- (IBAction)gotoLoginSettings;
@end
