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
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"입금/지출 통계"];
    
    NSDate * today          = [NSDate date];
    NSDate * dateAmonthAgo  = [StatisticMainUtil getExactDate:1 beforeThisDate:today];
    [self updateSelectedDates:dateAmonthAgo toDate:today];
    
    [self loadData];
    [self addChart];
    [self addChartData];
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
        
        CGFloat belowSearchButtonY      = self.searchButton.frame.origin.y + self.searchButton.frame.size.height;
        existedDateSearchView           = [dateSearchUtil showDateSearchViewInScrollView:self.scrollView atY:belowSearchButtonY];
        existedDateSearchView.delegate  = self;
    }
}

- (void)refreshChartFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    [self updateSelectedDates:fromDate toDate:toDate];
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
    NSLog(@"%s %d: %@", __func__, __LINE__, sender);
    StatisticMainUtil * dateSearchUtil = [[StatisticMainUtil alloc] init];
    StatisticDateSearchView * existedDateSearchView = [dateSearchUtil hasDateSearchViewInScrollView:self.scrollView];
    [existedDateSearchView updateStartDate:(NSDate *)sender];
}

- (void)chooseEndDate:(id)sender {
    NSLog(@"%s %d: %@", __func__, __LINE__, sender);
    StatisticMainUtil * dateSearchUtil = [[StatisticMainUtil alloc] init];
    StatisticDateSearchView * existedDateSearchView = [dateSearchUtil hasDateSearchViewInScrollView:self.scrollView];
    [existedDateSearchView updateEndDate:(NSDate *)sender];
}

- (void)updateSelectedDates:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    [self.selectedDatesLabel setText:[NSString stringWithFormat:@"%@ ~ %@",
                                      [[StatisticMainUtil getDateFormatterDateStyle] stringFromDate:fromDate],
                                      [[StatisticMainUtil getDateFormatterDateStyle] stringFromDate:toDate]]];
}

#pragma mark - Chart

- (void)loadData {
    ChartController * dataCtr = [[ChartController alloc] init];
    _dataSource = [dataCtr getChartData];
    NSMutableArray * _incomeMutableArr  = [[NSMutableArray alloc] init];
    NSMutableArray * _expenseMutableArr = [[NSMutableArray alloc] init];
    
    for (ChartItemData * item in _dataSource) {
        
        if ([item.itemType isEqualToString:INCOME]) {
            [_incomeMutableArr addObject:item];
        } else {
            [_expenseMutableArr addObject:item];
        }
    }
    
    _incomeDataSource   = [_incomeMutableArr copy];
    _expenseDataSource  = [_expenseMutableArr copy];
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

- (void)addChartData {
    
    StatisticMainUtil * chartViewUtil = [[StatisticMainUtil alloc] init];
    
    CGFloat incomeDataViewY = _doughnutChart.frame.origin.y + _doughnutChart.frame.size.height + 50;
    _incomeDataView         = [chartViewUtil addViewWithDataSource:_incomeDataSource toView:self.scrollView atY:incomeDataViewY];
    
    CGFloat expenseDataViewY    = _incomeDataView.frame.origin.y + _incomeDataView.frame.size.height + 20;
    _expenseDataView            = [chartViewUtil addViewWithDataSource:_expenseDataSource toView:self.scrollView atY:expenseDataViewY];
    
    [chartViewUtil setContentSizeOfScrollView:self.scrollView];
}

- (IBAction)showMemoComposer {
    
    TransactionObject * transation = [[TransactionObject alloc] init];
    [transation setTransactionDate:[NSDate date]];
    [transation setTransactionAccountNumber:@"111-22-***33"];
    [transation setTransactionDetails:@"당풍니"];
    [transation setTransactionType:@"입금"];
    [transation setTransactionAmount:[NSNumber numberWithFloat:100000.0f]];
    
    
    StorageBoxUtil * util = [[StorageBoxUtil alloc] init];
    [util showMemoComposerInViewController:self withTransationObject:transation];
}

@end
