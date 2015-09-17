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

- (IBAction)passwordChangeClick:(id)sender;
@end
