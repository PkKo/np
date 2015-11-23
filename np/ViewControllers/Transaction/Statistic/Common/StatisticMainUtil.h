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
#import "CustomizedPickerViewController.h"

@interface StatisticMainUtil : NSObject

+ (instancetype)sharedInstance;

- (void)showStatisticView:(UINavigationController * )nav;
- (StatisticDateSearchView *)hasDateSearchViewInScrollView:(UIView *)view;
- (StatisticDateSearchView *)showDateSearchViewInScrollView:(UIView *)view atY:(CGFloat)dateSearchViewY;
- (void)hideDateSearchView:(StatisticDateSearchView *)dateSearchView;

- (void)showDatePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate
                      initialDate:(NSDate *)initialDate
           inParentViewController:(UIViewController *)parentVC
                       doneAction:(SEL)doneAction;
- (void)showDatePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate
                      initialDate:(NSDate *)initialDate
           inParentViewController:(UIViewController *)parentVC
                           target:(UIViewController *)target
                       doneAction:(SEL)doneAction;

- (void)showDataPickerInParentViewController:(UIViewController *)parentVC
                                      target:(UIViewController *)targetVC
                                  dataSource:(NSArray *)items
                                selectAction:(SEL)selectAction selectRow:(NSString *)value;

- (void)showDataPickerInParentViewController:(UIViewController *)parentVC
                                  dataSource:(NSArray *)items
                                selectAction:(SEL)selectAction selectRow:(NSString *)value;

- (PieChartWithInputData *)addPieChartToView:(UIScrollView *)scrollView belowDateLabel:(UILabel *)selectedDateLabel;
- (ChartDataView *) addViewWithDataSource:(NSArray *)dataSource toView:(UIScrollView *)scrollView atY:(CGFloat)y;
- (void)setContentSizeOfScrollView:(UIScrollView *)scroll;

+ (NSDate *)getExactDateOfMonthsAgo:(NSInteger)months beforeThisDate:(NSDate *)thisDate;
+ (NSDate *)getExactDateOfDaysAgo:(NSInteger)days beforeThisDate:(NSDate *)thisDate;

+ (NSString *)getWeekdayOfDate:(NSDate *)date;
+ (NSString *)getWeekdayOfDateStr:(NSString *)dateStr; // yyyy.MM.dd
+ (NSInteger) getLastDayOfMonth:(NSInteger)month year:(NSInteger)year;

+ (NSDateFormatter *)getDateFormatterDateHourStyle;
+ (NSDateFormatter *)getDateFormatterDateHourMinuteStyle;
+ (NSDateFormatter *)getDateFormatterDateStyle;
+ (NSDateFormatter *)getDateFormatterHourMinuteStyle;
+ (NSDateFormatter *)getDateFormatterDateServerStyle;
+ (NSDateFormatter *)getDateFormatterWithStyle:(NSString *)style;

#pragma mark - General
- (NSString *)getAccountNumberWithoutDash:(NSString *)accountNoWithDash;
+ (NSNumberFormatter *)getNumberFormatter;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (NSString *)hexStringFromColor:(UIColor *)color;
@end
