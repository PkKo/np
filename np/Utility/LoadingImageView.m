//
//  LoadingImageView.m
//  np
//
//  Created by Infobank1 on 2015. 11. 26..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "LoadingImageView.h"

@implementation LoadingImageView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        animationBg = [[CircleView alloc] initWithFrame:CGRectMake((frame.size.width - 36) / 2,
                                                                   (frame.size.height - 36) / 2, 36, 36)];
        [animationBg setBackgroundColor:[UIColor colorWithRed:62.0/255.0f green:155.0/255.0f blue:233.0/255.0f alpha:1.0f]];
        [animationBg setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        [self addSubview:animationBg];
        loadingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading.png"]];
        [loadingImage setFrame:CGRectMake((animationBg.frame.size.width - 16) / 2,
                                          (animationBg.frame.size.height - 16) / 2, 16, 16)];
        [loadingImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
        [animationBg addSubview:loadingImage];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)startLoadingAnimation
{
    [CommonUtil runSpinAnimationWithDuration:loadingImage duration:10.0f];
}

- (void)stopLoadingAnimation
{
    [CommonUtil stopSpinAnimation:loadingImage];
    [animationBg removeFromSuperview];
}

@end
