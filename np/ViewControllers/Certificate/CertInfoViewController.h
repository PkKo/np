//
//  CertInfoViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 17..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "CertInfo.h"

@interface CertInfoViewController : CommonViewController<UIAlertViewDelegate>

@property (strong, nonatomic) CertInfo *certInfo;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *issuerLabel;
@property (strong, nonatomic) IBOutlet UILabel *policyLabel;
@property (strong, nonatomic) IBOutlet UILabel *expiredDateLabel;
- (IBAction)deleteCertClick:(id)sender;
- (IBAction)passwordChangeClick:(id)sender;
@end
