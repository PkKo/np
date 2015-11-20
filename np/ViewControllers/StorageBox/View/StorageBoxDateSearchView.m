//
//  StorageBoxDateSearchView.m
//  np
//
//  Created by Infobank2 on 10/6/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "StorageBoxDateSearchView.h"
#import "StatisticMainUtil.h"

typedef enum DateSearch {
    DATE_SEARCH_BY_NONE = 0,
    DATE_SEARCH_BY_1WEEK,
    DATE_SEARCH_BY_1MONTH,
    DATE_SEARCH_BY_3MONTH,
    DATE_SEARCH_BY_6MONTH
} DateSearch;

@interface StorageBoxDateSearchView() {
    DateSearch _prvSltedDateSearchPeriod;
}
@end

@implementation StorageBoxDateSearchView

- (IBAction)clickToSelectAccount {
    [self.delegate showDataPickerToSelectAccountWithSelectedValue:[self.accountBtn titleForState:UIControlStateNormal]];
}

- (void)updateSelectedAccount:(NSString *)selectedAccount {
    [self.accountBtn setTitle:selectedAccount forState:UIControlStateNormal];
}

- (IBAction)clickToSelectTransType {
    [self.delegate showDataPickerToSelectTransTypeWithSelectedValue:[self.transBtn titleForState:UIControlStateNormal]];
}

- (void)updateSelectedTransType:(NSString *)selectedTransType {
    [self.transBtn setTitle:selectedTransType forState:UIControlStateNormal];
}

#pragma mark - Keyboard
- (IBAction)validateTextEditing:(UITextField *)sender {
    if ([[sender text] length] > 10) {
        [sender setText:[[sender text] substringToIndex:10]];
    }
}

#pragma mark - Date Search
- (void)handleToggleSelectedSearchDate:(DateSearch)dateSearch {
    
    if (dateSearch == _prvSltedDateSearchPeriod) {
        return;
    }
    
    if (_prvSltedDateSearchPeriod != DATE_SEARCH_BY_NONE) {
        [self toggleSelectedSearchDate:_prvSltedDateSearchPeriod];
    }
    
    [self toggleSelectedSearchDate:dateSearch];
    
    _prvSltedDateSearchPeriod = dateSearch;
}

- (void)toggleSelectedSearchDate:(DateSearch)dateSearch {
    
    switch (dateSearch) {
        case DATE_SEARCH_BY_1WEEK:
            self.dateSearch1WeekBtn.selected = !self.dateSearch1WeekBtn.isSelected;
            break;
        case DATE_SEARCH_BY_1MONTH:
            self.dateSearch1MonthBtn.selected = !self.dateSearch1MonthBtn.isSelected;
            break;
        case DATE_SEARCH_BY_3MONTH:
            self.dateSearch3MonthBtn.selected = !self.dateSearch3MonthBtn.isSelected;
            break;
        case DATE_SEARCH_BY_6MONTH:
            self.dateSearch6MonthBtn.selected = !self.dateSearch6MonthBtn.isSelected;
            break;
        default:
            break;
    }
}

- (IBAction)choose1Week {
    
    NSDate * today              = [NSDate date];
    NSDate * dateOf1WeekAgo    = [StatisticMainUtil getExactDateOfDaysAgo:6 beforeThisDate:today];
    
    [self updateStartDate:dateOf1WeekAgo];
    [self updateEndDate:today];
    
    [self handleToggleSelectedSearchDate:DATE_SEARCH_BY_1WEEK];
}

- (IBAction)choose1Month {
    
    NSDate * today              = [NSDate date];
    NSDate * dateOf1MonthAgo    = [StatisticMainUtil getExactDateOfMonthsAgo:1 beforeThisDate:today];
    
    [self updateStartDate:dateOf1MonthAgo];
    [self updateEndDate:today];
    
    [self handleToggleSelectedSearchDate:DATE_SEARCH_BY_1MONTH];
}

- (IBAction)choose3Month {
    NSDate * today              = [NSDate date];
    NSDate * dateOf3MonthAgo    = [StatisticMainUtil getExactDateOfMonthsAgo:3 beforeThisDate:today];
    
    [self updateStartDate:dateOf3MonthAgo];
    [self updateEndDate:today];
    
    [self handleToggleSelectedSearchDate:DATE_SEARCH_BY_3MONTH];
}

- (IBAction)choose6Month {
    NSDate * today              = [NSDate date];
    NSDate * dateOf6MonthAgo    = [StatisticMainUtil getExactDateOfMonthsAgo:6 beforeThisDate:today];
    
    [self updateStartDate:dateOf6MonthAgo];
    [self updateEndDate:today];
    
    [self handleToggleSelectedSearchDate:DATE_SEARCH_BY_6MONTH];
}

- (IBAction)chooseStartDate {
    NSDate * startDate = [[StatisticMainUtil getDateFormatterDateStyle] dateFromString:self.startDate.text];
    [self.delegate showDatePickerForStartDate:startDate];
}

- (IBAction)chooseEndDate {
    NSDate * endDate = [[StatisticMainUtil getDateFormatterDateStyle] dateFromString:self.endDate.text];
    [self.delegate showDatePickerForEndDate:endDate];
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

#pragma mark - Validate Selected Dates
- (IBAction)searchTransactions {
    
    BOOL isInvalidSelectedDates = [self validateSelectedDates];
    
    if (isInvalidSelectedDates) {
        [self invalidSelectedDatesAlert];
        return;
    }
    
    NSDateFormatter * formatter = [StatisticMainUtil getDateFormatterDateStyle];
    [self.delegate searchTransFromDate:[formatter dateFromString:self.startDate.text]
                                toDate:[formatter dateFromString:self.endDate.text]
                               account:[self.accountBtn titleForState:UIControlStateNormal]
                             transType:[self.transBtn titleForState:UIControlStateNormal]
                                  memo:self.memoTextField.text];
}

- (BOOL)validateSelectedDates {
    
    BOOL isInvalidSelectedDates = NO;
    
    if ([self.startDate.text isEqualToString:@""] || [self.endDate.text isEqualToString:@""]) {
        isInvalidSelectedDates = YES;
    }
    
    NSDateFormatter * formatter = [StatisticMainUtil getDateFormatterDateStyle];
    
    NSDate * fromDate   = [formatter dateFromString:self.startDate.text];
    NSDate * toDate     = [formatter dateFromString:self.endDate.text];
    
    if ([fromDate compare:toDate] == NSOrderedDescending) {
        isInvalidSelectedDates = YES;
    }
    return isInvalidSelectedDates;
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
    [self.delegate closeSearchView];
    [self removeFromSuperview];
}

-(void)updateUI {
    _prvSltedDateSearchPeriod = DATE_SEARCH_BY_NONE;
    [self choose1Month];
    
    [self.fakeAllAccounts.layer setBorderWidth:1];
    [self.fakeAllAccounts.layer setBorderColor:TEXT_FIELD_BORDER_COLOR];
    [self.fakeTrans.layer setBorderWidth:1];
    [self.fakeTrans.layer setBorderColor:TEXT_FIELD_BORDER_COLOR];
    [self.fakeMemo.layer setBorderWidth:1];
    [self.fakeMemo.layer setBorderColor:TEXT_FIELD_BORDER_COLOR];
    [self.fakeStartDate.layer setBorderWidth:1];
    [self.fakeStartDate.layer setBorderColor:TEXT_FIELD_BORDER_COLOR];
    [self.fakeEndDate.layer setBorderWidth:1];
    [self.fakeEndDate.layer setBorderColor:TEXT_FIELD_BORDER_COLOR];
}

@end
