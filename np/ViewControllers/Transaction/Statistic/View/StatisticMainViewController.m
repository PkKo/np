//
//  StatisticMainViewController.m
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import "StatisticMainViewController.h"
#import "StatisticMainUtil.h"
#import "ChartController.h"
#import "StorageBoxUtil.h"
#import "StatisticMainUtil.h"
#import "ChartDataView.h"
#import "ChartItemData.h"
#import "CustomizedDatePickerViewController.h"
#import "ConstantMaster.h"
#import "StorageBoxController.h"

@interface StatisticMainViewController () {
    
    CustomizedDatePickerViewController * _datePicker;
    
    PieChartWithInputData   * _doughnutChart;
    ChartDataView           * _incomeDataView;
    ChartDataView           * _expenseDataView;
    
    NSArray * _dataSource; // array of ChartItemData
    NSArray * _incomeDataSource;
    NSArray * _expenseDataSource;
}

@end

@implementation StatisticMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"입금/지출 통계"];
    
    NSDate * today          = [NSDate date];
    NSDate * dateAmonthAgo  = [StatisticMainUtil getExactDateOfMonthsAgo:1 beforeThisDate:today];
    [self updateSelectedDates:dateAmonthAgo toDate:today];
    
    ChartController * dataCtr   = [[ChartController alloc] init];
    _dataSource                 = [dataCtr getChartDataFromDate:dateAmonthAgo toDate:today];
    [self loadDataWithDataSource:_dataSource];
    [self addChart];
    [self addChartData];
    [self replaceNoticeView];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%s:%d", __func__, __LINE__);
}


#pragma mark - Date Search View

- (IBAction)clickSearchButton {
    
    StatisticMainUtil       * dateSearchUtil        = [[StatisticMainUtil alloc] init];
    StatisticDateSearchView * existedDateSearchView = [dateSearchUtil hasDateSearchViewInScrollView:self.scrollView];
    
    if (existedDateSearchView) {
        [dateSearchUtil hideDateSearchView:existedDateSearchView];
    } else {
        
        CGFloat belowSearchButtonY      = self.topView.frame.origin.y + self.topView.frame.size.height;
        existedDateSearchView           = [dateSearchUtil showDateSearchViewInScrollView:self.scrollView atY:belowSearchButtonY];
        existedDateSearchView.delegate  = self;
    }
}

- (void)showDatePickerForStartDateWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate {
    
    StatisticMainUtil *datePickerUtil = [[StatisticMainUtil alloc] init];
    [datePickerUtil showDatePickerWithMinDate:minDate maxDate:maxDate inParentViewController:self
                                   doneAction:@selector(chooseStartDate:)];
}

- (void)showDatePickerForEndDateWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate {
    
    StatisticMainUtil *datePickerUtil = [[StatisticMainUtil alloc] init];
    [datePickerUtil showDatePickerWithMinDate:minDate maxDate:maxDate inParentViewController:self
                                   doneAction:@selector(chooseEndDate:)];
}

- (void)chooseStartDate:(id)sender {
    StatisticMainUtil * dateSearchUtil = [[StatisticMainUtil alloc] init];
    StatisticDateSearchView * existedDateSearchView = [dateSearchUtil hasDateSearchViewInScrollView:self.scrollView];
    [existedDateSearchView updateStartDate:(NSDate *)sender];
}

- (void)chooseEndDate:(id)sender {
    StatisticMainUtil * dateSearchUtil = [[StatisticMainUtil alloc] init];
    StatisticDateSearchView * existedDateSearchView = [dateSearchUtil hasDateSearchViewInScrollView:self.scrollView];
    [existedDateSearchView updateEndDate:(NSDate *)sender];
}

- (void)updateSelectedDates:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    [self.selectedDatesLabel setText:[NSString stringWithFormat:@"%@ ~ %@",
                                      [[StatisticMainUtil getDateFormatterDateStyle] stringFromDate:fromDate],
                                      [[StatisticMainUtil getDateFormatterDateStyle] stringFromDate:toDate]]];
}

- (void)closeDatePicker {
    [self clickSearchButton];
}

#pragma mark - refresh
- (void)refreshChartFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    [self updateSelectedDates:fromDate toDate:toDate];
    
    ChartController * dataCtr   = [[ChartController alloc] init];
    [self refreshViewWithDataSource:[dataCtr getChartDataFromDate:fromDate toDate:toDate]];
}

- (void)refreshViewWithDataSource:(NSArray *)ds {
    
    [self removeChart];
    [self removeChartData];
    
    [self loadDataWithDataSource:ds];
    [self addChart];
    [self addChartData];
    [self replaceNoticeView];
}

#pragma mark - Select Account
- (IBAction)selectAccount {
    [self showDataPickerToSelectAccountWithSelectedValue:[self.selectAccountBtn titleForState:UIControlStateNormal]];
}

- (void)showDataPickerToSelectAccountWithSelectedValue:(NSString *)sltedValue {
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    
    StatisticMainUtil * util = [[StatisticMainUtil alloc] init];
    [util showDataPickerInParentViewController:self dataSource:[controller getAllAccounts]
                                  selectAction:@selector(updateAccount:)
                                     selectRow:sltedValue];
}

- (void)updateAccount:(NSString *)account {
    
    [self.selectAccountBtn setTitle:account forState:UIControlStateNormal];
    ChartController * dataCtr   = [[ChartController alloc] init];
    [self refreshViewWithDataSource:[dataCtr getChartDataByAccountNo:[self.selectAccountBtn titleForState:UIControlStateNormal]]];
}

-(void)updateUI {
    [self.fakeAllAccounts.layer setBorderWidth:1];
    [self.fakeAllAccounts.layer setBorderColor:[[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1] CGColor]];
}

#pragma mark - Chart

- (void)loadDataWithDataSource:(NSArray *)ds {
    _dataSource = ds;
    NSMutableArray * _incomeMutableArr  = [[NSMutableArray alloc] init];
    NSMutableArray * _expenseMutableArr = [[NSMutableArray alloc] init];
    
    for (ChartItemData * item in _dataSource) {
        
        if ([item.itemType isEqualToString:TRANS_TYPE_INCOME]) {
            [_incomeMutableArr addObject:item];
        } else {
            [_expenseMutableArr addObject:item];
        }
    }
    
    _incomeDataSource   = [_incomeMutableArr copy];
    _expenseDataSource  = [_expenseMutableArr copy];
}

- (void)removeChart {
    if (_doughnutChart) {
        [_doughnutChart removeFromSuperview];
    }
}

- (void)addChart {
    
    StatisticMainUtil * chartUtil        = [[StatisticMainUtil alloc] init];
    _doughnutChart = [chartUtil addPieChartToView:self.scrollView belowDateLabel:self.selectedDatesLabel];
    
    NSMutableArray * colors     = [[NSMutableArray alloc] init]; // array of UIColor
    NSMutableArray * percents   = [[NSMutableArray alloc] init];
    for (ChartItemData *item in _dataSource ) {
        [colors addObject: [StatisticMainUtil colorFromHexString:item.itemColor]];
        [percents addObject:[NSNumber numberWithFloat:[item.itemPercent floatValue]]];
    }
    
    [_doughnutChart reloadChartWithColorArray:[colors copy] sliceArr:[percents copy]];
}

- (void)removeChartData {
    if (_incomeDataView) {
        [_incomeDataView removeFromSuperview];
    }
    
    if (_expenseDataView) {
        [_expenseDataView removeFromSuperview];
    }
}

- (void)addChartData {
    
    StatisticMainUtil * chartViewUtil = [[StatisticMainUtil alloc] init];
    
    CGFloat incomeDataViewY = _doughnutChart.frame.origin.y + _doughnutChart.frame.size.height + 23;
    _incomeDataView         = [chartViewUtil addViewWithDataSource:_incomeDataSource toView:self.scrollView atY:incomeDataViewY];
    
    CGFloat expenseDataViewY    = _incomeDataView.frame.origin.y + _incomeDataView.frame.size.height + 13;
    _expenseDataView            = [chartViewUtil addViewWithDataSource:_expenseDataSource toView:self.scrollView atY:expenseDataViewY];
}

- (void)replaceNoticeView {
    
    StatisticMainUtil * chartViewUtil = [[StatisticMainUtil alloc] init];
    
    CGRect noticeViewFrame = self.noticeView.frame;
    noticeViewFrame.origin.y = _expenseDataView.frame.origin.y + _expenseDataView.frame.size.height + 15; // spacing
    [self.noticeView setFrame:noticeViewFrame];
    
    CGPoint noticeViewCenterPoint = CGPointMake(self.scrollView.center.x, self.noticeView.center.y);
    [self.noticeView setCenter:noticeViewCenterPoint];
    
    [chartViewUtil setContentSizeOfScrollView:self.scrollView];
}

@end
