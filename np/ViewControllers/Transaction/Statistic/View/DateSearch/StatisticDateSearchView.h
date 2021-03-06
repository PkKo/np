//
//  StatisticDateSearchView.h
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatisticDateSearchViewDelegate <NSObject>

- (void)refreshChartFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (void)showDatePickerForStartDateWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate initialDate:(NSDate *)initialDate;
- (void)showDatePickerForEndDateWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate initialDate:(NSDate *)initialDate;
- (void)closeDatePicker;

@end

@interface StatisticDateSearchView : UIView

@property (weak) id<StatisticDateSearchViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *selectedMonth;
- (IBAction)choosePrvMonth;
- (IBAction)chooseNxtMonth;

@property (weak, nonatomic) IBOutlet UITextField *fakeStartDate;
@property (weak, nonatomic) IBOutlet UITextField *fakeEndDate;

@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)chooseStartDate;
- (IBAction)chooseEndDate;

- (IBAction)searchTransactions;
- (IBAction)closeSearchView;

-(void)updateUI;
- (void)updateCurrentYearMonth;
- (void)updateStartDate:(NSDate *)startDate;
- (void)updateEndDate:(NSDate *)endDate;

@end
