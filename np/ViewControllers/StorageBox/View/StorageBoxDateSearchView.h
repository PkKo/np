//
//  StorageBoxDateSearchView.h
//  np
//
//  Created by Infobank2 on 10/6/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StorageBoxDateSearchViewDelegate <NSObject>

- (void)searchTransFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate account:(NSString *)account transType:(NSString *)transType memo:(NSString *)memo;
- (void)showDatePickerForStartDate:(NSDate *)startDate;
- (void)showDatePickerForEndDate:(NSDate *)endDate;

- (void)showDataPickerToSelectAccountWithSelectedValue:(NSString *)sltedValue;
- (void)showDataPickerToSelectTransTypeWithSelectedValue:(NSString *)sltedValue;
- (void)closeSearchView;

@end


@interface StorageBoxDateSearchView : UIView

@property (weak) id<StorageBoxDateSearchViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField * fakeAllAccounts;
@property (weak, nonatomic) IBOutlet UIButton    * accountBtn;

@property (weak, nonatomic) IBOutlet UIButton    * transBtn;
@property (weak, nonatomic) IBOutlet UITextField * fakeTrans;
@property (weak, nonatomic) IBOutlet UITextField * fakeMemo;
@property (weak, nonatomic) IBOutlet UITextField * memoTextField;

@property (weak, nonatomic) IBOutlet UITextField * fakeStartDate;
@property (weak, nonatomic) IBOutlet UITextField * fakeEndDate;
@property (weak, nonatomic) IBOutlet UITextField * startDate;
@property (weak, nonatomic) IBOutlet UITextField * endDate;

- (IBAction)clickToSelectAccount;
- (IBAction)clickToSelectTransType;
- (void)updateSelectedAccount:(NSString *)selectedAccount;
- (void)updateSelectedTransType:(NSString *)selectedTransType;
    
- (IBAction)validateTextEditing:(UITextField *)sender;

@property (weak, nonatomic) IBOutlet UIButton    * dateSearch1WeekBtn;
@property (weak, nonatomic) IBOutlet UIButton    * dateSearch1MonthBtn;
@property (weak, nonatomic) IBOutlet UIButton    * dateSearch3MonthBtn;
@property (weak, nonatomic) IBOutlet UIButton    * dateSearch6MonthBtn;
- (IBAction)choose1Week;
- (IBAction)choose1Month;
- (IBAction)choose3Month;
- (IBAction)choose6Month;

- (IBAction)chooseStartDate;
- (IBAction)chooseEndDate;
- (void)updateStartDate:(NSDate *)startDate;
- (void)updateEndDate:(NSDate *)endDate;

- (IBAction)searchTransactions;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)closeSearchView;

-(void)updateUI;

@end
