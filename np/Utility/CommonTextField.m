//
//  CommonTextField.m
//  np
//
//  Created by Infobank1 on 2015. 10. 12..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonTextField.h"

@implementation CommonTextField


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.layer.borderColor = [UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1.0f].CGColor;
    self.layer.borderWidth = 1.0f;
    
    [self setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:241.0f/255.0f blue:246.0f/255.0f alpha:1.0f]];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, self.frame.size.height)];
    [self setLeftView:leftView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
}


@end
