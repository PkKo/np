//
//  RegistAccountAllHeaderCell.m
//  np
//
//  Created by Infobank1 on 1/14/16.
//  Copyright © 2016 Infobank1. All rights reserved.
//

#import "RegistAccountAllHeaderCell.h"

@implementation RegistAccountAllHeaderCell

- (void)highlightSectionHeader:(BOOL)isHighlighted isRegisteredAccount:(BOOL)isRegisteredAccount {
    
    [self.sectionIcon setHighlighted:isHighlighted];
    [self.accountCategory setTextColor:(isHighlighted ? [UIColor colorWithRed:48.0f/255.0f green:158.0f/255.0f blue:251.0f/255.0f alpha:1]
                                      : [UIColor colorWithRed:144.0f/255.0f green:145.0f/255.0f blue:150.0f/255.0f alpha:1])];
    
    if (isRegisteredAccount) {
        //[self.contentView setBackgroundColor:[UIColor cyanColor]];
    }
}

@end
