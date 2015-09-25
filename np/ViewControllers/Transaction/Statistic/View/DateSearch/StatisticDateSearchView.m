//
//  StatisticDateSearchView.m
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import "StatisticDateSearchView.h"

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
    
    if (_currentMonth - LATEST_MAX_MONTH <= 0) {
        
        _lastLatestMaxMonthMonth    = _currentMonth - LATEST_MAX_MONTH + 12;
        _lastLatestMaxMonthYear     = _currentYear - 1;
        
    } else {
        
        _lastLatestMaxMonthMonth    = _currentMonth - LATEST_MAX_MONTH;
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
    
    // displayed date
    _displayedYear  = _currentYear;
    _displayedMonth = _currentMonth;
    
    [self refreshSelectedYearMonth];
}

- (NSInteger) getLastDayOfMonth:(NSInteger)month year:(NSInteger)year {
    
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

- (void)refreshSelectedYearMonth {
    [self.selectedMonth setText:[NSString stringWithFormat:@"%ld년 %ld월", _displayedYear, _displayedMonth]];
}

- (void)refreshChartDataOfMonth:(NSInteger)month year:(NSInteger)year {
    
    NSDate * fromDate;
    NSString * fromDateStr;
    
    NSDate * toDate;
    NSString * toDateStr;
    
    NSDateFormatter *dateFormatter = [self getDateFormatter];
    
    if (month != _lastLatestMaxMonthMonth && month != _currentMonth) {
        
        fromDateStr = [NSString stringWithFormat:@"%ld/%ld/01 00:00:00", year, month];
        toDateStr = [NSString stringWithFormat:@"%ld/%ld/%ld 23:59:59", year, month, [self getLastDayOfMonth:month year:year]];
        
    } else if (month == _lastLatestMaxMonthMonth) {
        
        fromDateStr = [NSString stringWithFormat:@"%ld/%ld/%ld 00:00:00", year, month, _lastLatestMaxMonthDay];
        toDateStr = [NSString stringWithFormat:@"%ld/%ld/%ld 23:59:59", year, month, [self getLastDayOfMonth:month year:year]];
        
    } else if (month == _currentMonth) {
        
        fromDateStr = [NSString stringWithFormat:@"%ld/%ld/01 00:00:00", year, month];
        toDateStr = [NSString stringWithFormat:@"%ld/%ld/%ld 23:59:59", year, month, _currentDay];
    }
    
    fromDate = [dateFormatter dateFromString:fromDateStr];
    toDate = [dateFormatter dateFromString:toDateStr];
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
        NSLog(@"should be within the latest 6 months");
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
        NSLog(@"greater than current month");
    }
    
}
- (IBAction)chooseStartDate {
    [self.delegate showDatePickerForStartDate];
}

- (IBAction)chooseEndDate {
    [self.delegate showDatePickerForEndDate];
}

- (IBAction)searchTransactions {
    
    if (![self.startDate text] || ![self.endDate text]) {
        [self invalidSelectedDatesAlert];
        return;
    }
    
    NSString * fromDateStr;
    NSString * toDateStr;
    
    NSDateFormatter * dateFormatter = [self getDateFormatter];
    
    fromDateStr = [NSString stringWithFormat:@"%@ 00:00:00", [self.startDate text]];
    toDateStr = [NSString stringWithFormat:@"%@ 23:59:59", [self.endDate text]];
    
    [self.delegate refreshChartFromDate:[dateFormatter dateFromString:fromDateStr]
                                 toDate:[dateFormatter dateFromString:toDateStr]];
}

- (BOOL)isWithinAMonthStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    
    NSDateComponents *components;
    NSInteger differentDays;
    
    NSInteger maxDaysOfStartMonth;
    NSDateComponents *startDateComps = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear
                                                                       fromDate:startDate];
    maxDaysOfStartMonth = [self getLastDayOfMonth:[startDateComps month] year:[startDateComps year]];
    
    
    components          = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                 fromDate:startDate toDate:endDate
                                                  options:NSCalendarWrapComponents];
    differentDays        = [components day];
    
    return YES;
}

- (void)invalidSelectedDatesAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                     message:@"검색 기간이 잘못 설정되었습니다. 기간을 다시 설정한 후 검색하시기바랍니다."
                                                    delegate:nil
                                           cancelButtonTitle:@"확인"
                                           otherButtonTitles:nil];
    [alert show];
}

- (NSDateFormatter *)getDateFormatter {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    return dateFormatter;
}

@end
