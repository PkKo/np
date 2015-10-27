//
//  StatisticMainViewController.h
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "StatisticDateSearchView.h"
#import "PieChartWithInputData.h"

@interface StatisticMainViewController : CommonViewController <StatisticDateSearchViewDelegate, IBInboxProtocol>

@property (weak, nonatomic) IBOutlet UIScrollView   * scrollView;
@property (weak, nonatomic) IBOutlet UIView         * topView;
@property (weak, nonatomic) IBOutlet UIView         * noDataView;
@property (weak, nonatomic) IBOutlet UIButton       * selectAccountBtn;
@property (weak, nonatomic) IBOutlet UITextField    * fakeAllAccounts;
@property (weak, nonatomic) IBOutlet UILabel        * selectedDatesLabel;
@property (weak, nonatomic) IBOutlet UIView         * noticeView;

- (IBAction)clickSearchButton;
- (IBAction)selectAccount;
- (void)updateUI;
@end
