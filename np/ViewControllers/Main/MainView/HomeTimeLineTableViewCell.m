//
//  HomeTimeLineTableViewCell.m
//  np
//
//  Created by Infobank1 on 2015. 10. 1..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "HomeTimeLineTableViewCell.h"

@implementation HomeTimeLineTableViewCell

@synthesize upperLine;
@synthesize underLine;

@synthesize typeLabel;
@synthesize stickerButton;
@synthesize timeLabel;
@synthesize nameLabel;
@synthesize amountLabel;
@synthesize accountLabel;
@synthesize remainAmountLabel;
@synthesize amountDescLabel;
@synthesize separateLine;

@synthesize pinButton;
@synthesize moreButton;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
