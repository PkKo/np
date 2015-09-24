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

- (IBAction)nextButtonClick:(id)sender;
@end
