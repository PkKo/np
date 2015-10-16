//
//  CertPasswordChangeViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 17..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "CertInfo.h"
#import "Keychain.h"
#import "CertManager.h"

typedef enum PASSWORD_TYPE
{
    CURRENT_PASSWORD = 300,
    NEW_PASSWORD,
    NEW_PASSWORD_CHECK
}PASSWORD_TYPE;

@interface CertPasswordChangeViewController : CommonViewController<UIAlertViewDelegate, UITextFieldDelegate>
{
    NSString *currentPassword;
    NSString *newPassword;
    NSString *newCheckPassword;
}

@property (strong, nonatomic) CertInfo *certInfo;
@property (strong, nonatomic) IBOutlet UITextField *currentPasswordInput;
@property (strong, nonatomic) IBOutlet UITextField *passwordNewInput;
@property (strong, nonatomic) IBOutlet UITextField *passwordNewCheck;

- (IBAction)passwordChangeClick:(id)sender;
- (IBAction)cancelClick:(id)sender;
@end
