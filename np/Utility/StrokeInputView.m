//
//  StrokeInputView.m
//  np
//
//  Created by Infobank1 on 2015. 11. 17..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "StrokeInputView.h"

@implementation StrokeInputView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f].CGColor];
}

@end
