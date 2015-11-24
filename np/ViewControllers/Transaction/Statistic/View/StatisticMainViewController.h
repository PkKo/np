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

@property (weak, nonatomic) IBOutlet UIButton       * selectAccountBtn;
@property (weak, nonatomic) IBOutlet UILabel        * selectAccountLabel;
@property (weak, nonatomic) IBOutlet UIImageView    * selectAccountArrow;
@property (weak, nonatomic) IBOutlet UILabel        * selectedDatesLabel;
@property (weak, nonatomic) IBOutlet UIView         * noticeView;

@property (weak, nonatomic) IBOutlet UILabel *noteAsterisk1;
@property (weak, nonatomic) IBOutlet UILabel *noteAsterisk2;
@property (weak, nonatomic) IBOutlet UILabel *noteAsterisk3;
@property (weak, nonatomic) IBOutlet UILabel *noteContent1;
@property (weak, nonatomic) IBOutlet UILabel *noteContent2;
@property (weak, nonatomic) IBOutlet UILabel *noteContent3;

@property (weak, nonatomic) IBOutlet UIView         * noDataView;
@property (weak, nonatomic) IBOutlet UIImageView    * noDataImageView;
@property (weak, nonatomic) IBOutlet UILabel        * noDataNotice;
- (IBAction)clickSearchButton;
- (IBAction)selectAccount;
@end
