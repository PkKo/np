//
//  StatisticMainUtil.m
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import "StatisticMainUtil.h"
#import "AppDelegate.h"

@implementation StatisticMainUtil

#pragma mark - Date Search
- (StatisticDateSearchView *)hasDateSearchViewInScrollView:(UIScrollView *)scrollView {
    
    NSArray *subviewArray = [scrollView subviews];
    
    for (UIView *subview in subviewArray) {
        if ([subview isKindOfClass:[StatisticDateSearchView class]]) {
            return (StatisticDateSearchView *)subview;
        }
    }
    return nil;
}

- (StatisticDateSearchView *)showDateSearchViewInScrollView:(UIScrollView *)scrollView atY:(CGFloat)dateSearchViewY {
    
    NSArray * subviewArray = [[NSBundle mainBundle] loadNibNamed:@"StatisticDateSearchView" owner:self options:nil];
    StatisticDateSearchView * dateSearchView = (StatisticDateSearchView *)[subviewArray objectAtIndex:0];
    
    CGRect dateSearchViewFrame = dateSearchView.frame;
    [dateSearchView setFrame:CGRectMake(0, dateSearchViewY, scrollView.frame.size.width, dateSearchViewFrame.size.height)];
    
    // move other subviews downward
    for (UIView * subview in [scrollView subviews]) {
        
        CGRect subviewFrame = subview.frame;
        BOOL doNothingWithSubviewsAboveDateSearchView = subviewFrame.origin.y < dateSearchViewY;
        
        if (doNothingWithSubviewsAboveDateSearchView) {
            continue;
        }
        
        subviewFrame.origin.y += dateSearchViewFrame.size.height;
        [subview setFrame:subviewFrame];
    }
    
    [scrollView addSubview:dateSearchView];
    [dateSearchView updateCurrentYearMonth];
    [dateSearchView updateUI];
    
    [self setContentSizeOfScrollView:scrollView];
    
    return dateSearchView;
}

- (void)hideDateSearchView:(StatisticDateSearchView *)dateSearchView {
    
    UIScrollView * scrollView   = (UIScrollView *)dateSearchView.superview;
    CGRect dateSearchViewFrame  = dateSearchView.frame;
    
    for (UIView * subview in [scrollView subviews]) {
        
        CGRect subviewFrame = subview.frame;
        BOOL doNothingWithSubviewsAboveDateSearchView = subviewFrame.origin.y <= dateSearchViewFrame.origin.y;
        
        if (doNothingWithSubviewsAboveDateSearchView) {
            continue;
        }
        
        subviewFrame.origin.y -= dateSearchViewFrame.size.height;
        [subview setFrame:subviewFrame];
    }
    
    [dateSearchView removeFromSuperview];
    
    [self setContentSizeOfScrollView:scrollView];
}

- (void)showDatePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate
                                           inParentViewController:(UIViewController *)parentVC
                                                       doneAction:(SEL)doneAction {
    
    CustomizedDatePickerViewController * datePickerViewController = [[CustomizedDatePickerViewController alloc] initWithNibName:@"CustomizedDatePickerViewController" bundle:nil];
    
    datePickerViewController.view.frame             = parentVC.view.bounds;
    datePickerViewController.view.autoresizingMask  = parentVC.view.autoresizingMask;
    
    [parentVC addChildViewController:datePickerViewController];
    [parentVC.view addSubview:datePickerViewController.view];
    [datePickerViewController didMoveToParentViewController:parentVC];
    
    if (maxDate && minDate) {
        [datePickerViewController setMinMaxDateToSelectWithMinDate:minDate maxDate:maxDate];
    }
    
    [datePickerViewController addTargetForDoneButton:parentVC action:doneAction];
}

- (void)showDataPickerInParentViewController:(UIViewController *)parentVC
                                  dataSource:(NSArray *)items
                                selectAction:(SEL)selectAction selectRow:(NSString *)value {
    
    CustomizedPickerViewController * pickerViewController = [[CustomizedPickerViewController alloc] initWithNibName:@"CustomizedPickerViewController" bundle:nil];
    
    [pickerViewController setItems:items];
    
    pickerViewController.view.frame             = parentVC.view.bounds;
    pickerViewController.view.autoresizingMask  = parentVC.view.autoresizingMask;
    
    [parentVC addChildViewController:pickerViewController];
    [parentVC.view addSubview:pickerViewController.view];
    [pickerViewController didMoveToParentViewController:parentVC];
    
    [pickerViewController addTarget:parentVC action:selectAction];
    [pickerViewController selectRowByValue:value];
}

#pragma mark - Doughnut Chart
- (PieChartWithInputData *)addPieChartToView:(UIScrollView *)scrollView belowDateLabel:(UILabel *)selectedDateLabel {
    
    PieChartWithInputData * chart = [[PieChartWithInputData alloc] initWithFrame:CGRectMake(0, selectedDateLabel.frame.origin.y, 185, 185)];
    CGPoint chartCenter = CGPointMake(scrollView.center.x, chart.center.y);
    chart.center        = chartCenter;
    
    [scrollView addSubview:chart];
    return chart;
}

#pragma mark - Doughnut Chart Data
- (ChartDataView *) addViewWithDataSource:(NSArray *)dataSource toView:(UIScrollView *)scrollView atY:(CGFloat)y {
    
    // income
    CGFloat chartDataViewY       = y;
    CGPoint chartDataViewCenter;
    
    ChartDataView *chartDataView = [[ChartDataView alloc] init];
    [chartDataView reloadData:dataSource];
    
    CGRect chartDataViewFrame        = chartDataView.frame;
    chartDataViewFrame.origin.y      = chartDataViewY;
    [chartDataView setFrame:chartDataViewFrame];
    [chartDataView setBackgroundColor:[UIColor whiteColor]];
    
    chartDataViewCenter              = CGPointMake(scrollView.center.x, chartDataView.center.y);
    chartDataView.center             = chartDataViewCenter;
    
    [scrollView addSubview:chartDataView];
    
    return chartDataView;
}

- (void)setContentSizeOfScrollView:(UIScrollView *)scroll {
    CGRect rect = CGRectZero;
    for (UIView * view in [scroll subviews]) {
        rect = CGRectUnion(rect, view.frame);
    }
    [scroll setContentSize:CGSizeMake(rect.size.width, rect.size.height)];
}

#pragma mark - Date Util
+ (NSDate *)getExactDateOfDaysAgo:(NSInteger)days beforeThisDate:(NSDate *)thisDate {
    
    NSInteger _resultYear;
    NSInteger _resultMonth;
    NSInteger _resultDay;
    
    
    NSInteger _currentYear;
    NSInteger _currentMonth;
    NSInteger _currentDay;
    
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:
                                         NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                        fromDate:thisDate];
    _currentYear    = [dateComponents year];
    _currentMonth   = [dateComponents month];
    _currentDay     = [dateComponents day];
    
    if (_currentDay - days > 0) {
        
        _resultDay      = _currentDay - days;
        _resultMonth    = _currentMonth;
        _resultYear     = _currentYear;
        
    } else if (_currentMonth - 1 > 0) {
        
        _resultMonth    = _currentMonth - 1;
        _resultYear     = _currentYear;
        _resultDay      = _currentDay - days + [StatisticMainUtil getLastDayOfMonth:_resultMonth year:_resultYear];
        
    } else {
        
        _resultMonth    = 12;
        _resultYear     = _currentYear - 1;
        _resultDay      = _currentDay - days + [StatisticMainUtil getLastDayOfMonth:_resultMonth year:_resultYear];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [dateComponents setMonth:_resultMonth];
    [dateComponents setYear:_resultYear];
    [dateComponents setDay:_resultDay];
    
    return [calendar dateFromComponents:dateComponents];
}

+ (NSDate *)getExactDateOfMonthsAgo:(NSInteger)months beforeThisDate:(NSDate *)thisDate {
    
    NSInteger _lastLatestMaxMonthYear;
    NSInteger _lastLatestMaxMonthMonth;
    NSInteger _lastLatestMaxMonthDay;
    
    NSInteger _currentYear;
    NSInteger _currentMonth;
    NSInteger _currentDay;
    
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:
                                         NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                        fromDate:thisDate];
    _currentYear    = [dateComponents year];
    _currentMonth   = [dateComponents month];
    _currentDay     = [dateComponents day];
    
    if (_currentMonth - months <= 0) {
        
        _lastLatestMaxMonthMonth    = _currentMonth - months + 12;
        _lastLatestMaxMonthYear     = _currentYear - 1;
        
    } else {
        
        _lastLatestMaxMonthMonth    = _currentMonth - months;
        _lastLatestMaxMonthYear     = _currentYear;
    }
    
    _lastLatestMaxMonthDay = _currentDay + 1;
    if (_lastLatestMaxMonthDay > [self getLastDayOfMonth:_lastLatestMaxMonthMonth year:_lastLatestMaxMonthYear]) {
        _lastLatestMaxMonthDay = 1;
        _lastLatestMaxMonthMonth++;
        if (_lastLatestMaxMonthMonth > 12) {
            _lastLatestMaxMonthMonth = 1;
            _lastLatestMaxMonthYear++;
        }
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *newDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                      fromDate:thisDate];
    [newDateComponents setMonth:_lastLatestMaxMonthMonth];
    [newDateComponents setYear:_lastLatestMaxMonthYear];
    [newDateComponents setDay:_lastLatestMaxMonthDay];
    
    return [calendar dateFromComponents:newDateComponents];
}

+ (NSString *)getWeekdayOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday
                                                   fromDate:date];
    
    NSArray * weekdays = @[@"일요일", @"월요일", @"화요일", @"수요일", @"목요일", @"금요일", @"토요일", @"일요일"];
    
    return [weekdays objectAtIndex:((int)[dateComponents weekday] - 1)];
}

+ (NSString *)getWeekdayOfDateStr:(NSString *)dateStr { // yyyy.MM.dd
    
    NSDateFormatter *dateFormatter = [StatisticMainUtil getDateFormatterDateStyle];
    NSDate * date = [dateFormatter dateFromString:dateStr];
    return [StatisticMainUtil getWeekdayOfDate:date];
}

+ (NSInteger) getLastDayOfMonth:(NSInteger)month year:(NSInteger)year {
    
    NSDate *curDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                   fromDate:curDate];
    [dateComponents setMonth:month];
    [dateComponents setYear:year];
    [dateComponents setDay:1];
    
    NSDate *dateOfSelectedMonth = [calendar dateFromComponents:dateComponents];
    NSRange daysRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dateOfSelectedMonth];
    
    return daysRange.length;
}

#pragma mark - Date Formatter
+ (NSDateFormatter *)getDateFormatterDateHourStyle {
    return [StatisticMainUtil getDateFormatterWithStyle:@"yyyy.MM.dd HH:mm:ss"];
}

+ (NSDateFormatter *)getDateFormatterDateHourMinuteStyle {
    return [StatisticMainUtil getDateFormatterWithStyle:@"yyyy.MM.dd HH:mm"];
}

+ (NSDateFormatter *)getDateFormatterHourMinuteStyle {
    return [StatisticMainUtil getDateFormatterWithStyle:@"HH:mm"];
}

+ (NSDateFormatter *)getDateFormatterDateStyle {
    return [StatisticMainUtil getDateFormatterWithStyle:@"yyyy.MM.dd"];
}

+ (NSDateFormatter *)getDateFormatterWithStyle:(NSString *)style {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:style];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    return dateFormatter;
}

#pragma mark - General
+ (NSNumberFormatter *)getNumberFormatter {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return numberFormatter;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
