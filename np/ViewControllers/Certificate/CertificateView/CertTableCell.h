//
//  CertTableCell.h
//  np
//
//  Created by Infobank1 on 2015. 9. 23..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *issuerLabel;
@property (strong, nonatomic) IBOutlet UILabel *policyLabel;
@property (strong, nonatomic) IBOutlet UILabel *notAfterLabel;

@end
