//
//  StorageBoxDateSearchView.m
//  np
//
//  Created by Infobank2 on 10/6/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "StorageBoxDateSearchView.h"
#import "StatisticMainUtil.h"
#import "UIButton+BackgroundColor.h"

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
- (IBAction)choose1Week {
    
    NSDate * today              = [NSDate date];
    NSDate * dateOf1WeekAgo    = [StatisticMainUtil getExactDateOfDaysAgo:6 beforeThisDate:today];
    
    [self updateStartDate:dateOf1WeekAgo];
    [self updateEndDate:today];
}

- (IBAction)choose1Month {
    
    NSDate * today              = [NSDate date];
    NSDate * dateOf1MonthAgo    = [StatisticMainUtil getExactDateOfMonthsAgo:1 beforeThisDate:today];
    
    [self updateStartDate:dateOf1MonthAgo];
    [self updateEndDate:today];
}

- (IBAction)choose3Month {
    NSDate * today              = [NSDate date];
    NSDate * dateOf3MonthAgo    = [StatisticMainUtil getExactDateOfMonthsAgo:3 beforeThisDate:today];
    
    [self updateStartDate:dateOf3MonthAgo];
    [self updateEndDate:today];
}

- (IBAction)choose6Month {
    NSDate * today              = [NSDate date];
    NSDate * dateOf6MonthAgo    = [StatisticMainUtil getExactDateOfMonthsAgo:6 beforeThisDate:today];
    
    [self updateStartDate:dateOf6MonthAgo];
    [self updateEndDate:today];
}

- (IBAction)chooseStartDate {
    [self.delegate showDatePickerForStartDate];
}

- (IBAction)chooseEndDate {
    [self.delegate showDatePickerForEndDate];
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
    
    [self.cancelBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9] forState:UIControlStateHighlighted];
}

@end
