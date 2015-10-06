//
//  ArchivedTransactionItemsViewController.h
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface ArchivedTransactionItemsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *sortByDateBtn;
- (IBAction)sortByDate;
- (IBAction)toggleRemovementView:(id)sender;
- (IBAction)toggleSearchView;
@property (weak, nonatomic) IBOutlet UILabel *topViewSeperator;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
