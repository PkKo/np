//
//  SplashLayerPopupView.m
//  np
//
//  Created by Infobank1 on 2015. 11. 11..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "SplashLayerPopupView.h"

@implementation SplashLayerPopupView

@synthesize delegate;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize closeDayOptionButton;
@synthesize closeButton;
@synthesize contentImage;

- (IBAction)closeWithCloseDayOption:(id)sender
{
    
}

- (IBAction)closeLayerView:(id)sender
{
    [self removeFromSuperview];
    if(delegate != nil && [delegate respondsToSelector:@selector(closeLayerPopup:)])
    {
        [delegate performSelector:@selector(closeLayerPopup:) withObject:(UIButton *)sender];
    }
}
@end
