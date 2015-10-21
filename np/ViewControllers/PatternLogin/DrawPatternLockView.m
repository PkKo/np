//
//  DrawPatternLockView.m
//  AndroidLock
//
//  Created by Purnama Santo on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DrawPatternLockView.h"

@implementation DrawPatternLockView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    if (self.isIncorrectPattern) {
        [self drawLineAutomatically];
    } else {
        [self drawLineManually];
    }
}

- (void)drawLineFromLastDotTo:(CGPoint)pt {
    _trackPointValue = [NSValue valueWithCGPoint:pt];
    [self setNeedsDisplay];
}

- (void)clearDotViews {
  [_dotViews removeAllObjects];
}

- (void)addDotView:(UIView *)view {
  if (!_dotViews)
    _dotViews = [NSMutableArray array];

  [_dotViews addObject:view];
}

- (void)drawLineManually {
    
    if (!_trackPointValue)
        return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0);
    
    CGColorRef color = self.strokeColor.CGColor;
    CGContextSetStrokeColorWithColor(context, color);
    
    CGPoint from;
    UIView * lastDot;
    for (UIView * dotView in _dotViews) {
        
        from = dotView.center;
        
        if (!lastDot) {
            
            CGContextMoveToPoint(context, from.x, from.y);
            
        } else {
            CGContextAddLineToPoint(context, from.x, from.y);
        }
        
        lastDot = dotView;
    }
    
    CGPoint pt = [_trackPointValue CGPointValue];
    CGContextAddLineToPoint(context, pt.x, pt.y);
    
    CGContextStrokePath(context);
    _trackPointValue = nil;
}

- (void)drawLineAutomatically {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0);
    
    CGColorRef color =  self.strokeColor.CGColor;
    CGContextSetStrokeColorWithColor(context, color);
    
    CGPoint from, to;
    
    for (int dotIndex = 0; dotIndex < [_dotViews count] - 1; dotIndex++) {
        
        UIView * fromdotView    = [_dotViews objectAtIndex:dotIndex];
        UIView * todotView      = [_dotViews objectAtIndex:(dotIndex + 1)];
        
        from    = fromdotView.center;
        to      = todotView.center;
        
        CGContextMoveToPoint(context, from.x, from.y);
        CGContextAddLineToPoint(context, to.x, to.y);
    }
    
    CGContextStrokePath(context);
}

@end
