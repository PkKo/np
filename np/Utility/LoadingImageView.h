//
//  LoadingImageView.h
//  np
//
//  Created by Infobank1 on 2015. 11. 26..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingImageView : UIImageView
{
    CircleView *animationBg;
    UIImageView *loadingImage;
}

- (id)initWithFrame:(CGRect)frame;
- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;
@end
