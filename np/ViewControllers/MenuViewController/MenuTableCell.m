//
//  MenuTableCell.m
//  np
//
//  Created by Infobank1 on 2015. 9. 14..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "MenuTableCell.h"

@implementation MenuTableCell

@synthesize mMenuTitleLabel;
@synthesize menuTitleImg;
@synthesize menuSeparateLine;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
