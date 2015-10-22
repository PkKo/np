//
//  AccountAddViewController.h
//  np
//
//  Created by Infobank1 on 2015. 10. 21..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "RegistCertListView.h"

@interface AccountAddViewController : CommonViewController<UITextFieldDelegate, RegistCertListDelegate>
{
    BOOL isCertRegist;
}

@property (strong, nonatomic) IBOutlet UIButton *accountCertTab;
@property (strong, nonatomic) IBOutlet UIButton *CertTab;
@property (strong, nonatomic) IBOutlet UIView *accountInputView;
@property (strong, nonatomic) IBOutlet CommonTextField *accountInputField;
@property (strong, nonatomic) IBOutlet CommonTextField *accountPasswordField;
@property (strong, nonatomic) IBOutlet CommonTextField *birthdayInputField;
@property (strong, nonatomic) IBOutlet UIView *certMenuView;

- (IBAction)changeCertView:(id)sender;
- (IBAction)nextButtonClick:(id)sender;
@end
