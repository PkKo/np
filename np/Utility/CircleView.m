//
//  CircleView.m
//  np
//
//  Created by Infobank1 on 2015. 10. 13..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.alpha = 0.9f;
    // Drawing code
    self.layer.cornerRadius = rect.size.width / 2;
}

@end
