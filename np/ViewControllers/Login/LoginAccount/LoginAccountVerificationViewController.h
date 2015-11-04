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
@property (weak, nonatomic) IBOutlet UITextField * accountTextField;
@property (weak, nonatomic) IBOutlet UITextField * passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField * fakeNoticeTextField;
@end