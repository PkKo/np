//
//  BannerInfoView.m
//  np
//
//  Created by Infobank1 on 2015. 11. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "BannerInfoView.h"

#define SCROLL_TIMER_MAX        3
#define SCROLL_TIMER_INTERVAL   1

@implementation BannerInfoView

@synthesize scrollView;
@synthesize pageControl;
@synthesize nongminBanner;
@synthesize noticeBanner;

@synthesize leftView;
@synthesize centerView;
@synthesize rightView;

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [scrollView setContentSize:CGSizeMake(rect.size.width * 2, rect.size.height)];

    [nongminBanner setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [noticeBanner setFrame:CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height)];
    /*
    [scrollView scrollRectToVisible:CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height) animated:NO];
    
    nongminColor = [UIColor redColor];
    noticeColor = [UIColor blueColor];
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [leftView setBackgroundColor:noticeColor];
    centerView = [[UIView alloc] initWithFrame:CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height)];
    [centerView setBackgroundColor:nongminColor];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(rect.size.width*2, 0, rect.size.width, rect.size.height)];
    [rightView setBackgroundColor:noticeColor];
    
    [scrollView addSubview:leftView];
    [scrollView addSubview:centerView];
    [scrollView addSubview:rightView];*/
}

- (void)bannerTimerStart
{
    if(scrollTimer != nil)
    {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
    
    bannerCount = 0;
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:SCROLL_TIMER_INTERVAL target:self selector:@selector(bannerTimerOnTime) userInfo:nil repeats:YES];
    [scrollTimer fire];
}

- (void)bannerTimerStop
{
    if(scrollTimer != nil)
    {
        [scrollTimer invalidate];
        scrollTimer = nil;
    }
}

- (void)bannerTimerOnTime
{
    bannerCount++;
    
    if(bannerCount == SCROLL_TIMER_MAX)
    {
        bannerCount = 0;
        if(pageControl.currentPage == 0)
        {
            pageControl.currentPage = 1;
        }
        else
        {
            pageControl.currentPage = 0;
        }
        [self changePage];
    }
}

- (void)changePage
{
    CGFloat scrollViewWith      = nongminBanner.frame.size.width;
    CGFloat scrollViewHeight    = scrollView.frame.size.height;
    CGFloat scrollViewY         = scrollView.frame.origin.y;
    
    [scrollView scrollRectToVisible:CGRectMake(scrollViewWith * pageControl.currentPage, scrollViewY, scrollViewWith, scrollViewHeight) animated:YES];
}

- (void)setIndicatorForCurrentPage
{
    CGFloat scrollViewWith  = self.scrollView.frame.size.width;
    float pagePos           =  self.scrollView.contentOffset.x * 1.0f  / scrollViewWith;
    [self.pageControl setCurrentPage:round(pagePos)];
}

#pragma mark - scrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setIndicatorForCurrentPage];
    [self changePage];
}
@end
