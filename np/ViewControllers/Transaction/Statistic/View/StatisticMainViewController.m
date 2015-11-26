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
#import "StorageBoxController.h"

@interface StatisticMainViewController () {
    
    CustomizedDatePickerViewController * _datePicker;
    
    PieChartWithInputData   * _doughnutChart;
    ChartDataView           * _incomeDataView;
    ChartDataView           * _expenseDataView;
    
    NSArray * _dataSource; // array of ChartItemData
    NSArray * _incomeDataSource;
    NSArray * _expenseDataSource;
    
    NSString * _startDate;
    NSString * _endDate;
    BOOL _isSearch;
}

@end

@implementation StatisticMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"수입/지출 통계"];
    
    NSDate * today          = [NSDate date];
    NSDate * dateAmonthAgo  = [StatisticMainUtil getExactDateOfMonthsAgo:1 beforeThisDate:today];
    
    [self updateSelectedDates:dateAmonthAgo toDate:today];
    [self getChartData];
    [self resizeNoticeContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Date Search View

- (IBAction)clickSearchButton {
    
    StatisticMainUtil       * dateSearchUtil        = [[StatisticMainUtil alloc] init];
    StatisticDateSearchView * existedDateSearchView = [dateSearchUtil hasDateSearchViewInScrollView:self.view];
    
    if (existedDateSearchView) {
        [dateSearchUtil hideDateSearchView:existedDateSearchView];
    } else {
        
        CGFloat belowSearchButtonY      = self.topView.frame.origin.y + self.topView.frame.size.height;
        existedDateSearchView           = [dateSearchUtil showDateSearchViewInScrollView:self.view atY:belowSearchButtonY];
        existedDateSearchView.delegate  = self;
    }
}

- (void)showDatePickerForStartDateWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate initialDate:(NSDate *)initialDate{
    
    StatisticMainUtil *datePickerUtil = [[StatisticMainUtil alloc] init];
    [datePickerUtil showDatePickerWithMinDate:minDate maxDate:maxDate
                                  initialDate:initialDate
                       inParentViewController:self
                                   doneAction:@selector(chooseStartDate:)];
}

- (void)showDatePickerForEndDateWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate initialDate:(NSDate *)initialDate {
    
    StatisticMainUtil *datePickerUtil = [[StatisticMainUtil alloc] init];
    [datePickerUtil showDatePickerWithMinDate:minDate maxDate:maxDate
                                  initialDate:initialDate
                       inParentViewController:self
                                   doneAction:@selector(chooseEndDate:)];
}

- (void)chooseStartDate:(id)sender {
    StatisticMainUtil * dateSearchUtil = [[StatisticMainUtil alloc] init];
    StatisticDateSearchView * existedDateSearchView = [dateSearchUtil hasDateSearchViewInScrollView:self.view];
    [existedDateSearchView updateStartDate:(NSDate *)sender];
}

- (void)chooseEndDate:(id)sender {
    StatisticMainUtil * dateSearchUtil = [[StatisticMainUtil alloc] init];
    StatisticDateSearchView * existedDateSearchView = [dateSearchUtil hasDateSearchViewInScrollView:self.view];
    [existedDateSearchView updateEndDate:(NSDate *)sender];
}

- (void)updateSelectedDates:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    NSDateFormatter * dateToDisplayFormatter = [StatisticMainUtil getDateFormatterDateStyle];
    
    [self.selectedDatesLabel setText:[NSString stringWithFormat:@"%@ ~ %@",
                                      [dateToDisplayFormatter stringFromDate:fromDate],
                                      [dateToDisplayFormatter stringFromDate:toDate]]];
    
    NSDateFormatter * dateToSendToServerFormatter = [StatisticMainUtil getDateFormatterDateServerStyle];
    _startDate  = [dateToSendToServerFormatter stringFromDate:fromDate];
    _endDate    = [dateToSendToServerFormatter stringFromDate:toDate];
}

- (void)closeDatePicker {
    [self clickSearchButton];
}

#pragma mark - refresh
- (void)refreshChartFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    [self clickSearchButton];
    [self updateSelectedDates:fromDate toDate:toDate];
    _isSearch = YES;
    [self getChartData];
}

- (void)drawChartWithDataSource:(NSArray *)ds {
    
    [self loadDataWithDataSource:ds];
    [self addChart];
    [self addChartData];
    [self replaceNoticeView];
}

#pragma mark - Select Account
- (NSArray *)getAccountList {
    
    if ([[self.selectAccountLabel text] isEqualToString:TRANS_ALL_ACCOUNT]) {
        
        StorageBoxController    * controller    = [[StorageBoxController alloc] init];
        NSArray                 * allAccounts   = [controller getAllTransAccounts];
        
        if ([allAccounts count] == 1) {
            return nil;
        }
        
        return [[[LoginUtil alloc] init] getAllTransAccounts];
        
    } else {
        
        NSString * accountNo = [self.selectAccountLabel text];
        return @[[[StatisticMainUtil sharedInstance] getAccountNumberWithoutDash:accountNo]];
    }
}

- (IBAction)selectAccount {
    [self showDataPickerToSelectAccountWithSelectedValue:[self.selectAccountLabel text]];
}

- (void)showDataPickerToSelectAccountWithSelectedValue:(NSString *)sltedValue {
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    
    StatisticMainUtil * util = [[StatisticMainUtil alloc] init];
    [util showDataPickerInParentViewController:self dataSource:[controller getAllTransAccounts]
                                  selectAction:@selector(updateAccount:)
                                     selectRow:sltedValue];
}

- (void)updateAccount:(NSString *)account {
    
    [self.selectAccountLabel setText:account];
    
    // resize account label
    CGSize selectAccountLabelSize       = [StorageBoxUtil contentSizeOfLabel:self.selectAccountLabel];
    CGRect selectAccountLabelRect       = self.selectAccountLabel.frame;
    selectAccountLabelRect.size.width   = selectAccountLabelSize.width;
    [self.selectAccountLabel setFrame:selectAccountLabelRect];
    
    // replace down arrow
    CGRect selectAccountArrowRect   = self.selectAccountArrow.frame;
    selectAccountArrowRect.origin.x = selectAccountLabelRect.origin.x + selectAccountLabelRect.size.width;
    [self.selectAccountArrow setFrame:selectAccountArrowRect];
    
    // resize account button
    CGRect selectAccountBtnRect     = self.selectAccountBtn.frame;
    CGFloat startAccountButtonX     = selectAccountLabelRect.origin.x;
    CGFloat endAccountButtonX       = selectAccountArrowRect.origin.x + selectAccountArrowRect.size.width;
    selectAccountBtnRect.size.width = endAccountButtonX - startAccountButtonX;
    [self.selectAccountBtn setFrame:selectAccountBtnRect];
    
    
    NSDate * today          = [NSDate date];
    NSDate * dateAmonthAgo  = [StatisticMainUtil getExactDateOfMonthsAgo:1 beforeThisDate:today];
    [self updateSelectedDates:dateAmonthAgo toDate:today];
    [self getChartData];
}

- (void)showNoDataView:(BOOL)isShown {
    
    [self.noDataView setHidden:!isShown];
    
    if (![self.noDataView isHidden]) {
        
        [self.noDataImageView setImage:[UIImage imageNamed:_isSearch ? @"icon_noresult_01" : @"icon_noresult_03"]];
        [self.noDataNotice setText: _isSearch ? @"해당기간 내 검색 결과가 없습니다." : @"통계 내역이 없습니다."];
        
        _isSearch = NO;
    }
    
    [self.selectedDatesLabel setHidden:isShown];
    [self.noticeView setHidden:isShown];
    
    [self removeChart];
    [self removeChartData];
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
        [percents addObject:[NSNumber numberWithDouble:[item.itemPercent doubleValue]]];
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
    
    if (_incomeDataSource && [_incomeDataSource count] > 0) {
        CGFloat incomeDataViewY = _doughnutChart.frame.origin.y + _doughnutChart.frame.size.height + 23;
        _incomeDataView         = [chartViewUtil addViewWithDataSource:_incomeDataSource toView:self.scrollView atY:incomeDataViewY];
    }
    
    if (_expenseDataSource && [_expenseDataSource count] > 0) {
        
        CGFloat expenseDataViewY;
        
        if (_incomeDataSource && [_incomeDataSource count] > 0) {
            expenseDataViewY    = _incomeDataView.frame.origin.y + _incomeDataView.frame.size.height + 13;
        } else {
            expenseDataViewY    = _doughnutChart.frame.origin.y + _doughnutChart.frame.size.height + 23;
        }
        
        _expenseDataView        = [chartViewUtil addViewWithDataSource:_expenseDataSource toView:self.scrollView atY:expenseDataViewY];
    }
}

- (void)replaceNoticeView {
    
    StatisticMainUtil * chartViewUtil = [[StatisticMainUtil alloc] init];
    
    CGRect noticeViewFrame      = self.noticeView.frame;
    CGFloat noticeViewY         = 0;
    
    if (_expenseDataSource && _expenseDataSource.count > 0) {
        noticeViewY             = _expenseDataView.frame.origin.y + _expenseDataView.frame.size.height + 15; // spacing
    } else if (_incomeDataSource && _incomeDataSource.count > 0) {
        noticeViewY             = _incomeDataView.frame.origin.y + _incomeDataView.frame.size.height + 15; // spacing
    }
    
    noticeViewFrame.origin.y    = noticeViewY;
    [self.noticeView setFrame:noticeViewFrame];
    
    [chartViewUtil setContentSizeOfScrollView:self.scrollView];
}

- (void)resizeNoticeContent {
    
    CGFloat screenWidth         = [[UIScreen mainScreen] bounds].size.width;
    CGFloat contentWidth        = screenWidth - (self.noticeView.frame.origin.x * 2 + self.noteContent1.frame.origin.x);
    
    CGRect noteContent1Rect     = self.noteContent1.frame;
    noteContent1Rect.size.width = contentWidth;
    [self.noteContent1 setFrame:noteContent1Rect];
    
    [self.noteContent1 sizeToFit];
    noteContent1Rect            = self.noteContent1.frame;
    
    CGRect noteAsterisk1Rect    = self.noteAsterisk1.frame;
    noteAsterisk1Rect.origin.y  = noteContent1Rect.origin.y + 3;
    [self.noteAsterisk1 setFrame:noteAsterisk1Rect];
    
    CGRect noteContent2Rect     = self.noteContent2.frame;
    noteContent2Rect.size.width = contentWidth;
    noteContent2Rect.origin.y   = noteContent1Rect.origin.y + noteContent1Rect.size.height + 4;
    [self.noteContent2 setFrame:noteContent2Rect];
    [self.noteContent2 sizeToFit];
    noteContent2Rect            = self.noteContent2.frame;
    
    CGRect noteAsterisk2Rect    = self.noteAsterisk2.frame;
    noteAsterisk2Rect.origin.y  = noteContent2Rect.origin.y + 3;
    [self.noteAsterisk2 setFrame:noteAsterisk2Rect];
    
    CGRect noteContent3Rect     = self.noteContent3.frame;
    noteContent3Rect.size.width = contentWidth;
    noteContent3Rect.origin.y   = noteContent2Rect.origin.y + noteContent2Rect.size.height + 4;
    [self.noteContent3 setFrame:noteContent3Rect];
    [self.noteContent3 sizeToFit];
    noteContent3Rect            = self.noteContent3.frame;
    
    CGRect noteAsterisk3Rect    = self.noteAsterisk3.frame;
    noteAsterisk3Rect.origin.y  = noteContent3Rect.origin.y + 3;
    [self.noteAsterisk3 setFrame:noteAsterisk3Rect];
    
    CGRect noticeViewFrame      = self.noticeView.frame;
    noticeViewFrame.size.height = noteContent3Rect.origin.y + noteContent3Rect.size.height + 20;
    [self.noticeView setFrame:noticeViewFrame];
}

#pragma mark - Get data
- (void)getChartData {
    [self startIndicator];
    [self performSelector:@selector(doGetChartDataAfterDelay) withObject:nil afterDelay:0.06];
}

- (void)doGetChartDataAfterDelay {
    
    NSArray * accounts = [self getAccountList];
    
    if (!accounts || [accounts count] == 0) {
        
        [self showNoDataView:YES];
        [self stopIndicator];
        
    } else {
        
        [IBInbox loadWithListener:self];
        [IBInbox reqGetStickerSummaryWithAccountNumberList:accounts startDate:_startDate endDate:_endDate];
    }
}


#pragma mark - IBInbox Protocol
- (void)stickerSummaryList:(BOOL)success summaryList:(NSArray *)summaryList
{
    if (!summaryList || [summaryList count] == 0) {
        [self showNoDataView:YES];
        [self stopIndicator];
        return;
    }
    
    [self showNoDataView:NO];
    
    NSInteger numberOfItems = [summaryList count];
    NSMutableArray * items  = [NSMutableArray arrayWithCapacity:numberOfItems];
    double total               = [[summaryList valueForKeyPath:@"@sum.sum"] doubleValue];
    
    double addUpPercentage     = 0;
    
    for (int itemIdx = 0; itemIdx < numberOfItems; itemIdx++) {
        
        StickerSummaryData * chartData = (StickerSummaryData *)[summaryList objectAtIndex:itemIdx];
        
        if(chartData.stickerCode < STICKER_DEPOSIT_NORMAL ||
           chartData.stickerCode == STICKER_EXCHANGE_RATE ||
           chartData.stickerCode == STICKER_NOTICE_NORMAL ||
           chartData.stickerCode == STICKER_ETC ||
           (chartData.stickerCode >= STICKER_DEPOSIT_MODIFY && chartData.stickerCode < STICKER_DEPOSIT_SALARY))
        {
            continue;
        }
        
        double percentage;
        if (itemIdx == numberOfItems - 1) {
            percentage       = 100 - addUpPercentage;
        } else {
            percentage       = floor(([@(chartData.sum) doubleValue] / total * 100) * 100) / 100;
            addUpPercentage += percentage;
        }
        
        StickerInfo * stickerInfo = [CommonUtil getStickerInfo:(StickerType)chartData.stickerCode];
        ChartItemData * item = [[ChartItemData alloc] initWithColor:stickerInfo.stickerColorHexString
                                                                name:stickerInfo.stickerName
                                                            percent:[NSString stringWithFormat: (percentage == 100 ? @"%.0lf" : @"%.2lf"), percentage]
                                                               value:[NSString stringWithFormat:@"%lf", [@(chartData.sum) doubleValue]]
                                                                type:[CommonUtil getTransactionTypeByStickerType:(StickerType)chartData.stickerCode]];
        [items addObject:item];
    }
    
    _dataSource = [items copy];
    _dataSource = [_dataSource sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"itemType"
                                                                                           ascending:YES]]];
    [self drawChartWithDataSource:_dataSource];
    [self stopIndicator];
}

- (void)inboxLoadFailed:(int)responseCode
{
    NSLog(@"%s,responseCode: %d", __FUNCTION__, responseCode);
    [self stopIndicator];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서버 오류 발생되었습니다.\n다시 시도해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alert show];
}

@end
