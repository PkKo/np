//
//  DelegateButton.m
//  np
//
//  Created by Infobank1 on 2015. 11. 24..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "DelegateButton.h"

@implementation DelegateButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if(_delegateLabel != nil)
    {
        if(highlighted)
        {
            [_delegateLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:179/255.0f alpha:1.0f]];
        }
        else
        {
            [_delegateLabel setTextColor:[UIColor colorWithRed:144/255.0f green:145/255.0f blue:150/255.0f alpha:1.0f]];
        }
    }
}
@end
