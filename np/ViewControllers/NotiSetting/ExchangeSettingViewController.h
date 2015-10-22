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
    NSMutableArray *countryList;
}

@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) IBOutlet UIView *listView;
@property (strong, nonatomic) IBOutlet UITableView *countryListTable;

- (IBAction)addCurrencyCountry:(id)sender;
@end
