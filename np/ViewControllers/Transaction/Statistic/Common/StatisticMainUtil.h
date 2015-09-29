//
//  StatisticMainUtil.h
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StatisticDateSearchView.h"
#import "PieChartWithInputData.h"
#import "ChartDataView.h"
#import "CustomizedDatePickerViewController.h"

@interface StatisticMainUtil : NSObject

- (StatisticDateSearchView *)hasDateSearchViewInScrollView:(UIScrollView *)scrollView;
- (StatisticDateSearchView *)showDateSearchViewInScrollView:(UIScrollView *)scrollView atY:(CGFloat)dateSearchViewY;
- (void)hideDateSearchView:(StatisticDateSearchView *)dateSearchView;
- (void)showDatePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate
           inParentViewController:(UIViewController *)parentVC
                       doneAction:(SEL)doneAction;

- (PieChartWithInputData *)addPieChartToView:(UIScrollView *)scrollView belowDateLabel:(UILabel *)selectedDateLabel;
- (ChartDataView *) addViewWithDataSource:(NSArray *)dataSource toView:(UIScrollView *)scrollView atY:(CGFloat)y;
- (void)setContentSizeOfScrollView:(UIScrollView *)scroll;

+ (NSDate *)getExactDate:(NSInteger)months beforeThisDate:(NSDate *)thisDate;
+ (NSInteger) getLastDayOfMonth:(NSInteger)month year:(NSInteger)year;

+ (NSDateFormatter *)getDateFormatterDateHourStyle;
+ (NSDateFormatter *)getDateFormatterDateStyle;
+ (NSDateFormatter *)getDateFormatterWithStyle:(NSString *)style;
+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
