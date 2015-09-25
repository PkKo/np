//
//  StatisticMainViewController.m
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import "StatisticMainViewController.h"
#import "StatisticMainUtil.h"
#import "ChartMainView.h"
#import "ChartController.h"
#import "StorageBoxUtil.h"
#import "StatisticDateSearchUtil.h"

@interface StatisticMainViewController ()

@end

@implementation StatisticMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"입금/지출 통계"];
    
    //[self addChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%s:%d", __func__, __LINE__);
}


#pragma mark - Date Search View

- (IBAction)clickSearchButton {
    
    StatisticDateSearchUtil * dateSearchUtil        = [[StatisticDateSearchUtil alloc] init];
    StatisticDateSearchView * existedDateSearchView = [dateSearchUtil hasDateSearchViewInScrollView:self.scrollView];
    
    if (existedDateSearchView) {
        [dateSearchUtil hideDateSearchView:existedDateSearchView];
    } else {
        
        CGFloat belowSearchButtonY = self.searchButton.frame.origin.y + self.searchButton.frame.size.height;
        existedDateSearchView = [dateSearchUtil showDateSearchViewInScrollView:self.scrollView atY:belowSearchButtonY];
        existedDateSearchView.delegate = self;
    }
}

- (void)refreshChartFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSLog(@"refreshChartFromDate fromDate: %@ - toDate: %@", [dateFormatter stringFromDate:fromDate], [dateFormatter stringFromDate:toDate]);
}

- (void)showDatePickerForStartDate {
    [self showDatePicker];
}
- (void)showDatePickerForEndDate {
    [self showDatePicker];
}

- (void)showDatePicker {
    
    CGFloat datePickerHeight = 300;
    CGFloat datePickerWith = self.view.frame.size.width;
    CGFloat datePickerY = self.view.frame.size.height - datePickerHeight;
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, datePickerY, datePickerWith, datePickerHeight)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker {
    NSLog(@"onDatePickerValueChanged");
}




- (ChartMainView *)getChartMainView {
    NSArray *subviewArray = [self.mainView subviews];
    
    for (UIView *subview in subviewArray) {
        if ([subview isKindOfClass:[ChartMainView class]]) {
            return (ChartMainView *)subview;
        }
    }
    return nil;
}

/*
 #pragma mark - Chart
 */
- (void)addChartView {
    
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"ChartMainView" owner:self options:nil];
    ChartMainView * chartMainView = (ChartMainView *)[viewArray objectAtIndex:0];
    
    CGRect mainFrame = self.mainView.frame;
    CGFloat chartMainViewY = self.searchButton.frame.origin.y + self.searchButton.frame.size.height;
    CGRect chartMainViewFrame = CGRectMake(mainFrame.origin.x, chartMainViewY, mainFrame.size.width, mainFrame.size.height - chartMainViewY);
    [chartMainView setFrame:chartMainViewFrame];
    
    [self.mainView addSubview:chartMainView];
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
