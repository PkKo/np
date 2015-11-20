//
//  ServiceFunctionInfoView.m
//  np
//
//  Created by Infobank1 on 2015. 11. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "ServiceFunctionInfoView.h"

@implementation ServiceFunctionInfoView

@synthesize infoViewButton;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    switch ([infoViewButton tag])
    {
        case 0:
        {
            [infoViewButton setBackgroundImage:[UIImage imageNamed:@"tutorial_01.png"] forState:UIControlStateNormal];
            break;
        }
        case 3:
        {
            [infoViewButton setBackgroundImage:[UIImage imageNamed:@"tutorial_04.png"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

- (IBAction)infoButtonClick:(id)sender
{
    switch ([sender tag])
    {
        case 0:
        {
            [infoViewButton setBackgroundImage:[UIImage imageNamed:@"tutorial_02.png"] forState:UIControlStateNormal];
            [infoViewButton setTag:1];
            break;
        }
        case 1:
        {
            [infoViewButton setBackgroundImage:[UIImage imageNamed:@"tutorial_03.png"] forState:UIControlStateNormal];
            [infoViewButton setTag:2];
            break;
        }
        case 2:
        {
            [self removeFromSuperview];
            break;
        }
        case 3:
        {
            [self removeFromSuperview];
            break;
        }
        default:
            break;
    }
}
@end
