//
//  TopLeftLabel.m
//  np
//
//  Created by Infobank1 on 2015. 10. 12..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "TopLeftLabel.h"

@implementation TopLeftLabel

-(void) drawTextInRect:(CGRect)inFrame
{
    CGRect      draw = [self textRectForBounds:inFrame limitedToNumberOfLines:[self numberOfLines]];
    draw.origin = CGPointZero;
    [super drawTextInRect:draw];
}

@end
