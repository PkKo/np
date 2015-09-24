//
//  CertTableCell.m
//  np
//
//  Created by Infobank1 on 2015. 9. 23..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CertTableCell.h"

@implementation CertTableCell

@synthesize nameLabel;
@synthesize issuerLabel;
@synthesize policyLabel;
@synthesize notAfterLabel;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
