//
//  StatisticDateSearchUtil.h
//  np
//
//  Created by Infobank2 on 9/24/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatisticDateSearchView.h"


@interface StatisticDateSearchUtil : NSObject

- (StatisticDateSearchView *)hasDateSearchViewInScrollView:(UIScrollView *)scrollView;
- (void)showDateSearchViewInScrollView:(UIScrollView *)scrollView atY:(CGFloat)dateSearchViewY;
- (void)hideDateSearchView:(StatisticDateSearchView *)dateSearchView;

@end
