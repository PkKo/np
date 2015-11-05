//
//  BannerInfoView.h
//  np
//
//  Created by Infobank1 on 2015. 11. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerInfoView : UIView<UIScrollViewDelegate>
{
    NSTimer *scrollTimer;
    NSInteger bannerCount;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *nongminBanner;
@property (strong, nonatomic) IBOutlet UIButton *noticeBanner;

- (void)bannerTimerStart;
- (void)bannerTimerStop;
@end
