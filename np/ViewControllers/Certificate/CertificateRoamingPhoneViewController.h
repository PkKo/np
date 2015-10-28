//
//  CertificateRoamingPhoneViewController.h
//  np
//
//  Created by Infobank1 on 2015. 10. 28..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface CertificateRoamingPhoneViewController : CommonViewController<UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet StrokeView *bottomView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) IBOutlet UITextField *certNumOne;
@property (strong, nonatomic) IBOutlet UITextField *certNumTwo;
@property (strong, nonatomic) IBOutlet UITextField *certNumThree;
@property (strong, nonatomic) IBOutlet UITextField *certNumFour;

@property (strong, nonatomic) IBOutlet UILabel *descriptionOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionThreeLabel;
- (IBAction)nextButtonClick:(id)sender;
@end
