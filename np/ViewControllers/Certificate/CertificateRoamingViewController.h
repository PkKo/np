//
//  CertificateRoamingViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 14..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface CertificateRoamingViewController : CommonViewController<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) IBOutlet UILabel *certNum1;
@property (strong, nonatomic) IBOutlet UILabel *certNum2;
@property (strong, nonatomic) IBOutlet UILabel *certNum3;
@property (strong, nonatomic) IBOutlet UILabel *certNum4;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UILabel *descriptionOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionThreeLabel;

- (IBAction)nextButtonClick:(id)sender;
@end
