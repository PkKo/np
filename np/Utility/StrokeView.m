//
//  StrokeView.m
//  np
//
//  Created by Infobank1 on 2015. 10. 14..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "StrokeView.h"

@implementation StrokeView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:[UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1.0f].CGColor];
}

@end
