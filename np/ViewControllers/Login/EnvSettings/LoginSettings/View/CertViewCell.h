//
//  CertViewCell.h
//  np
//
//  Created by Infobank2 on 10/14/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *certName;
@property (weak, nonatomic) IBOutlet UILabel *certIssuer;
@property (weak, nonatomic) IBOutlet UILabel *certType;
@property (weak, nonatomic) IBOutlet UILabel *issueDate;
@property (weak, nonatomic) IBOutlet UILabel *expiryDate;

@end
