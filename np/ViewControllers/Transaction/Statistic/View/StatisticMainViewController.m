//
//  StatisticMainViewController.m
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import "StatisticMainViewController.h"
#import "StatisticMainUtil.h"
#import "StatisticDateSearchView.h"
#import "ChartMainView.h"
#import "ChartController.h"

@interface StatisticMainViewController ()

@end

@implementation StatisticMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"입금/지출 통계"];
    
    [self addChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToPrvView:(UIBarButtonItem *)sender {
    [StatisticMainUtil hideStatisticView];
}

- (IBAction)showMenu:(id)sender {
    NSLog(@"showMenu");
}

/*
 #pragma mark - Date Search View
 */
- (IBAction)clickSearchButton {
    
    StatisticDateSearchView *existedDateSearchView = [self hasDateSearchView];
    
    if (existedDateSearchView) {
        
        [self hideDateSearchView:existedDateSearchView];
        
    } else {
        [self showDateSearchView];
    }
}

- (void)showDateSearchView {
    
    // add date search view
    NSArray * subviewArray = [[NSBundle mainBundle] loadNibNamed:@"StatisticDateSearchView" owner:self options:nil];
    StatisticDateSearchView * dateSearchView = (StatisticDateSearchView *)[subviewArray objectAtIndex:0];
    
    CGRect dateSearchViewFrame = dateSearchView.frame;
    CGFloat belowSearchButtonY = self.searchButton.frame.origin.y + self.searchButton.frame.size.height;
    [dateSearchView setFrame:CGRectMake(0, belowSearchButtonY, self.mainView.frame.size.width, dateSearchViewFrame.size.height)];
    
    dateSearchViewFrame = dateSearchView.frame;
    CGRect fromDateSearchViewFrame = CGRectMake(dateSearchViewFrame.origin.x, dateSearchViewFrame.origin.y, dateSearchViewFrame.size.width, 0);
    CGRect toDateSearchViewFrame = CGRectMake(dateSearchViewFrame.origin.x, dateSearchViewFrame.origin.y, dateSearchViewFrame.size.width, dateSearchViewFrame.size.height);
    
    [dateSearchView setFrame:fromDateSearchViewFrame];
    [self.mainView addSubview:dateSearchView];
    
    // move Date Search view down and reduce its height
    ChartMainView *chartMainView = [self getChartMainView];
    CGRect chartMainViewFrame = chartMainView.frame;
    CGRect shrunkChartMainViewFrame = CGRectMake(chartMainViewFrame.origin.x, chartMainViewFrame.origin.y + dateSearchViewFrame.size.height, chartMainViewFrame.size.width, chartMainViewFrame.size.height - dateSearchViewFrame.size.height);
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         [dateSearchView setFrame:toDateSearchViewFrame];
                         [chartMainView setFrame:shrunkChartMainViewFrame];
    }
                     completion:^(BOOL finished) {}];
}

- (void)hideDateSearchView:(StatisticDateSearchView *)dateSearchView {
    
    CGRect dateSearchViewFrame = dateSearchView.frame;
    CGRect toDateSearchViewFrame = CGRectMake(dateSearchViewFrame.origin.x, dateSearchViewFrame.origin.y, dateSearchViewFrame.size.width, 0);
    
    // move Date Search view back to the original position
    ChartMainView *chartMainView = [self getChartMainView];
    CGRect chartMainViewFrame = chartMainView.frame;
    CGRect originalChartMainViewFrame = CGRectMake(chartMainViewFrame.origin.x, chartMainViewFrame.origin.y - dateSearchViewFrame.size.height, chartMainViewFrame.size.width, chartMainViewFrame.size.height + dateSearchViewFrame.size.height);
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [dateSearchView setFrame:toDateSearchViewFrame];
                         [chartMainView setFrame:originalChartMainViewFrame];
                     }
                     completion:^(BOOL finished) {
                         [dateSearchView removeFromSuperview];
                     }];
}

- (StatisticDateSearchView *)hasDateSearchView {
    
    NSArray *subviewArray = [self.mainView subviews];
    
    for (UIView *subview in subviewArray) {
        if ([subview isKindOfClass:[StatisticDateSearchView class]]) {
            return (StatisticDateSearchView *)subview;
        }
    }
    return nil;
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

@end
