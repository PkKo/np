//
//  AccountAddViewController.h
//  np
//
//  Created by Infobank1 on 2015. 10. 21..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "RegistCertListView.h"
#import "RegistAccountAllListView.h"

@interface AccountAddViewController : CommonViewController<UITextFieldDelegate, RegistCertListDelegate>
{
    BOOL isCertRegist;
    NSArray *certControllArray;
    
    NSString *certNumOneString;
    NSString *certNumTwoString;
    NSString *certNumThreeString;
    NSString *certNumFourString;
    
    RegistAccountAllListView *allListView;
    NSMutableArray *allAccountList;
}

@property (strong, nonatomic) IBOutlet UIButton *accountCertTab;
@property (strong, nonatomic) IBOutlet UIButton *CertTab;
@property (strong, nonatomic) IBOutlet UIView *accountInputView;
@property (strong, nonatomic) IBOutlet CommonTextField *accountInputField;
@property (strong, nonatomic) IBOutlet CommonTextField *accountPasswordField;
@property (strong, nonatomic) IBOutlet CommonTextField *birthdayInputField;
@property (strong, nonatomic) IBOutlet UIView *certMenuView;
@property (strong, nonatomic) IBOutlet UIView *certMenuContentView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)changeCertView:(id)sender;
- (IBAction)nextButtonClick:(id)sender;
@end
