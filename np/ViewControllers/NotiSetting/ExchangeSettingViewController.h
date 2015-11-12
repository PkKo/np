//
//  ExchangeSettingViewController.h
//  np
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface ExchangeSettingViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *countryList;
    NSMutableArray *regCountryList;
    NSMutableArray *chargeList;
    NSMutableArray *payAlarmList;
    CGFloat countryCellHeight;
    CGFloat payAlarmCellHeight;
}

@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) IBOutlet UIView *listView;
@property (strong, nonatomic) IBOutlet UITableView *countryListTable;
@property (strong, nonatomic) IBOutlet UIView *serviceNotiAlertView;

@property (strong, nonatomic) IBOutlet UIView *payAlarmView;
@property (strong, nonatomic) IBOutlet UITableView *payAlarmListTable;

- (IBAction)addCurrencyCountry:(id)sender;
- (IBAction)serviceNotiButtonClick:(id)sender;
@end
