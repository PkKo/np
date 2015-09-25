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
- (void)showDatePickerForStartDate;
- (void)showDatePickerForEndDate;

@end

@interface StatisticDateSearchView : UIView

@property (weak) id<StatisticDateSearchViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *selectedMonth;
- (IBAction)choosePrvMonth;
- (IBAction)chooseNxtMonth;

@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
- (IBAction)chooseStartDate;
- (IBAction)chooseEndDate;

- (IBAction)searchTransactions;

- (void)updateCurrentYearMonth;

@end
