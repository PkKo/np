//
//  StatisticDateSearchView.m
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import "StatisticDateSearchView.h"
#import "StatisticMainUtil.h"
#import "UIButton+BackgroundColor.h"

#define LATEST_MAX_MONTH 6

@interface StatisticDateSearchView() {
    
    NSInteger _lastLatestMaxMonthYear;
    NSInteger _lastLatestMaxMonthMonth;
    NSInteger _lastLatestMaxMonthDay;
    
    NSInteger _currentYear;
    NSInteger _currentMonth;
    NSInteger _currentDay;
    
    NSInteger _displayedYear;
    NSInteger _displayedMonth;
    
    NSDate * _selectedStartDate;
    NSDate * _selectedEndDate;
}
@end


@implementation StatisticDateSearchView


- (void)updateCurrentYearMonth {
    
    NSDate * currentDate = [NSDate date];
    
    NSDateComponents * dateComponents = [[NSCalendar currentCalendar] components:
                                         NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                        fromDate:currentDate];
    _currentYear    = [dateComponents year];
    _currentMonth   = [dateComponents month];
    _currentDay     = [dateComponents day];
    
    NSDateComponents * dateOf6MonthsAgoComponents = [[NSCalendar currentCalendar] components:
                                         NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                        fromDate:[StatisticMainUtil getExactDateOfMonthsAgo:LATEST_MAX_MONTH beforeThisDate:currentDate]];
    _lastLatestMaxMonthYear     = [dateOf6MonthsAgoComponents year];
    _lastLatestMaxMonthMonth    = [dateOf6MonthsAgoComponents month];
    _lastLatestMaxMonthDay      = [dateOf6MonthsAgoComponents day];
    
    // displayed date
    _displayedYear  = _currentYear;
    _displayedMonth = _currentMonth;
    
    [self refreshSelectedYearMonth];
}

- (void)refreshSelectedYearMonth {
    [self.selectedMonth setText:[NSString stringWithFormat:@"%d년 %d월", (int)_displayedYear, (int)_displayedMonth]];
}

- (void)refreshChartDataOfMonth:(NSInteger)month year:(NSInteger)year {
    
    NSDate * fromDate;
    NSString * fromDateStr;
    
    NSDate * toDate;
    NSString * toDateStr;
    
    NSDateFormatter *dateFormatter = [StatisticMainUtil getDateFormatterDateHourStyle];
    
    if (month != _lastLatestMaxMonthMonth && month != _currentMonth) {
        
        fromDateStr = [NSString stringWithFormat:@"%d/%d/01 00:00:00", (int)year, (int)month];
        toDateStr   = [NSString stringWithFormat:@"%d/%d/%d 23:59:59", (int)year, (int)month, (int)[StatisticMainUtil getLastDayOfMonth:month year:year]];
        
    } else if (month == _lastLatestMaxMonthMonth) {
        
        fromDateStr = [NSString stringWithFormat:@"%d/%d/%d 00:00:00", (int)year, (int)month, (int)_lastLatestMaxMonthDay];
        toDateStr   = [NSString stringWithFormat:@"%d/%d/%d 23:59:59", (int)year, (int)month, (int)[StatisticMainUtil getLastDayOfMonth:month year:year]];
        
    } else if (month == _currentMonth) {
        
        fromDateStr = [NSString stringWithFormat:@"%d/%d/01 00:00:00", (int)year, (int)month];
        toDateStr   = [NSString stringWithFormat:@"%d/%d/%d 23:59:59", (int)year, (int)month, (int)_currentDay];
    }
    
    fromDate = [dateFormatter dateFromString:fromDateStr];
    toDate  = [dateFormatter dateFromString:toDateStr];
    
    //NSLog(@"delegate.refreshChartFromDate fromDate: %@ - toDate: %@", [dateFormatter stringFromDate:fromDate] , [dateFormatter stringFromDate:toDate]);
    
    [self.delegate refreshChartFromDate:fromDate toDate:toDate];
}

- (IBAction)choosePrvMonth {
    
    BOOL canChoosePrvMonth = NO;
    
    if (_lastLatestMaxMonthYear < _displayedYear) {
        
        _displayedMonth--;
        
        if (_displayedMonth == 0) {
            _displayedMonth = 12;
            _displayedYear--;
        }
        canChoosePrvMonth = YES;
        
    } else if (_lastLatestMaxMonthMonth < _displayedMonth) {
        
        _displayedMonth--;
        canChoosePrvMonth = YES;
    }
    
    if (canChoosePrvMonth) {
        [self refreshSelectedYearMonth];
        [self refreshChartDataOfMonth:_displayedMonth year:_displayedYear];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:@"당월부터 6개월 이내의 데이터만 조회 가능합니다."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)chooseNxtMonth {
    
    BOOL canChooseNxtMonth = NO;
    if (_displayedYear < _currentYear) {
        
        if (_displayedMonth == 12) {
            _displayedMonth = 1;
            _displayedYear++;
        } else {
            _displayedMonth++;
        }
        canChooseNxtMonth = YES;
        
    } else if (_displayedMonth < _currentMonth) {
        _displayedMonth++;
        canChooseNxtMonth = YES;
    }
    
    if (canChooseNxtMonth) {
        
        [self refreshSelectedYearMonth];
        [self refreshChartDataOfMonth:_displayedMonth year:_displayedYear];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:@"당월 이후에 데이터는 조회할 수 없습니다."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}
- (IBAction)chooseStartDate {
    
    NSDateFormatter *dateFormatter = [StatisticMainUtil getDateFormatterDateHourStyle];
    NSString * minDateStr = [NSString stringWithFormat:@"%d/%d/%d 00:00:00", (int)_lastLatestMaxMonthYear, (int)_lastLatestMaxMonthMonth, (int)_lastLatestMaxMonthDay];
    [self.delegate showDatePickerForStartDateWithMinDate:[dateFormatter dateFromString:minDateStr] maxDate:[NSDate date]];
}

- (IBAction)chooseEndDate {
    
    NSDateFormatter *dateFormatter = [StatisticMainUtil getDateFormatterDateHourStyle];
    NSString * minDateStr = [NSString stringWithFormat:@"%d/%d/%d 00:00:00", (int)_lastLatestMaxMonthYear, (int)_lastLatestMaxMonthMonth, (int)_lastLatestMaxMonthDay];
    [self.delegate showDatePickerForEndDateWithMinDate:[dateFormatter dateFromString:minDateStr] maxDate:[NSDate date]];
}

- (void)updateStartDate:(NSDate *)startDate {
    [self updateNewDate:startDate forTextField:self.startDate];
}

- (void)updateEndDate:(NSDate *)endDate {
    [self updateNewDate:endDate forTextField:self.endDate];
}

- (void)updateNewDate:(NSDate *)newDate forTextField:(UITextField *)dateTextField {
    NSDateFormatter * formatter = [StatisticMainUtil getDateFormatterDateStyle];
    [dateTextField setText:[formatter stringFromDate:newDate]];
}

- (IBAction)searchTransactions {
    
    if ([[self.startDate text] isEqualToString:@""] || [[self.endDate text] isEqualToString:@""]) {
        [self invalidSelectedDatesAlert];
        return;
    }
    
    NSString * fromDateStr;
    NSString * toDateStr;
    
    NSDateFormatter * dateFormatter = [StatisticMainUtil getDateFormatterDateHourStyle];
    
    fromDateStr = [NSString stringWithFormat:@"%@ 00:00:00", [self.startDate text]];
    toDateStr = [NSString stringWithFormat:@"%@ 23:59:59", [self.endDate text]];
    
    NSDate * fromDate   = [dateFormatter dateFromString:fromDateStr];
    NSDate * toDate     = [dateFormatter dateFromString:toDateStr];
    
    
    if ([fromDate compare:toDate] == NSOrderedDescending) {
        [self invalidSelectedDatesAlert];
        return;
    }
    
    if (![self isWithinAMonthStartDate:fromDate endDate:toDate]) {
        [self invalidSelectedDatesAlert];
        return;
    }
    
    [self.delegate refreshChartFromDate:[dateFormatter dateFromString:fromDateStr]
                                 toDate:[dateFormatter dateFromString:toDateStr]];
}

- (BOOL)isWithinAMonthStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    
    NSDateComponents *components;
    NSInteger differentDays;
    
    NSInteger maxDaysOfStartMonth;
    NSDateComponents *startDateComps = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear
                                                                       fromDate:startDate];
    maxDaysOfStartMonth = [StatisticMainUtil getLastDayOfMonth:[startDateComps month] year:[startDateComps year]];
    
    
    components          = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                 fromDate:startDate toDate:endDate
                                                  options:NSCalendarWrapComponents];
    differentDays        = [components day];
    
    if (differentDays >= maxDaysOfStartMonth) {
        return NO;
    }
    
    return YES;
}

- (void)invalidSelectedDatesAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                     message:@"검색 기간이 잘못 설정되었습니다. 기간을 다시 설정한 후 검색하시기바랍니다."
                                                    delegate:nil
                                           cancelButtonTitle:@"확인"
                                           otherButtonTitles:nil];
    [alert show];
}

- (IBAction)closeSearchView {
    [self.delegate closeDatePicker];
    [self removeFromSuperview];
}

-(void)updateUI {
    [self.fakeStartDate.layer setBorderWidth:1];
    [self.fakeStartDate.layer setBorderColor:TEXT_FIELD_BORDER_COLOR];
    [self.fakeEndDate.layer setBorderWidth:1];
    [self.fakeEndDate.layer setBorderColor:TEXT_FIELD_BORDER_COLOR];
    
    [self.cancelBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9] forState:UIControlStateHighlighted];
}

@end
