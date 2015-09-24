//
//  StatisticDateSearchUtil.m
//  np
//
//  Created by Infobank2 on 9/24/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "StatisticDateSearchUtil.h"

@implementation StatisticDateSearchUtil

- (void)dealloc {
    NSLog(@"dealloc StatisticDateSearchUtil");
}

- (StatisticDateSearchView *)hasDateSearchViewInScrollView:(UIScrollView *)scrollView {
    
    NSArray *subviewArray = [scrollView subviews];
    
    for (UIView *subview in subviewArray) {
        if ([subview isKindOfClass:[StatisticDateSearchView class]]) {
            return (StatisticDateSearchView *)subview;
        }
    }
    return nil;
}

- (void)showDateSearchViewInScrollView:(UIScrollView *)scrollView atY:(CGFloat)dateSearchViewY {
    
    // add date search view
    NSArray * subviewArray = [[NSBundle mainBundle] loadNibNamed:@"StatisticDateSearchView" owner:self options:nil];
    StatisticDateSearchView * dateSearchView = (StatisticDateSearchView *)[subviewArray objectAtIndex:0];
    
    CGRect dateSearchViewFrame = dateSearchView.frame;
    
    [dateSearchView setFrame:CGRectMake(0, dateSearchViewY, scrollView.frame.size.width, dateSearchViewFrame.size.height)];
    
    dateSearchViewFrame = dateSearchView.frame;
    CGRect fromDateSearchViewFrame = CGRectMake(dateSearchViewFrame.origin.x, dateSearchViewFrame.origin.y, dateSearchViewFrame.size.width, 0);
    CGRect toDateSearchViewFrame = CGRectMake(dateSearchViewFrame.origin.x, dateSearchViewFrame.origin.y, dateSearchViewFrame.size.width, dateSearchViewFrame.size.height);
    
    [dateSearchView setFrame:fromDateSearchViewFrame];
    [scrollView addSubview:dateSearchView];
    
    // move Date Search view down and reduce its height
    /*
    ChartMainView *chartMainView = [self getChartMainView];
    CGRect chartMainViewFrame = chartMainView.frame;
    CGRect shrunkChartMainViewFrame = CGRectMake(chartMainViewFrame.origin.x, chartMainViewFrame.origin.y + dateSearchViewFrame.size.height, chartMainViewFrame.size.width, chartMainViewFrame.size.height - dateSearchViewFrame.size.height);
    */
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [dateSearchView setFrame:toDateSearchViewFrame];
                         //[chartMainView setFrame:shrunkChartMainViewFrame];
                     }
                     completion:^(BOOL finished) {}];
}

- (void)hideDateSearchView:(StatisticDateSearchView *)dateSearchView {
    
    CGRect dateSearchViewFrame = dateSearchView.frame;
    CGRect toDateSearchViewFrame = CGRectMake(dateSearchViewFrame.origin.x, dateSearchViewFrame.origin.y, dateSearchViewFrame.size.width, 0);
    
    // move Date Search view back to the original position
    /*
    ChartMainView *chartMainView = [self getChartMainView];
    CGRect chartMainViewFrame = chartMainView.frame;
    CGRect originalChartMainViewFrame = CGRectMake(chartMainViewFrame.origin.x, chartMainViewFrame.origin.y - dateSearchViewFrame.size.height, chartMainViewFrame.size.width, chartMainViewFrame.size.height + dateSearchViewFrame.size.height);
    */
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [dateSearchView setFrame:toDateSearchViewFrame];
                         //[chartMainView setFrame:originalChartMainViewFrame];
                     }
                     completion:^(BOOL finished) {
                         [dateSearchView removeFromSuperview];
                     }];
}

@end
