//
//  AccountManageViewController.h
//  np
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface AccountManageViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *accountList;
    CGFloat cellHeight;
}

@property (strong, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet StrokeView *tableBgStrokeView;
@property (strong, nonatomic) IBOutlet UITableView *accountListTable;
- (IBAction)addAccount:(id)sender;
@end
