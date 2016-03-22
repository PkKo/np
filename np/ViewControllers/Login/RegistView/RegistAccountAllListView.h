//
//  RegistAccountAllListVIew.h
//  np
//
//  Created by Infobank1 on 2015. 10. 13..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountObject.h"
#import "RegistAccountAllRowCell.h"

@interface RegistAccountAllListView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger selectedIndex;
}
@property (strong, nonatomic) IBOutlet UILabel *pushDescLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *accountListTable;
@property (strong, nonatomic) NSMutableArray *accountList;

- (void)initAccountList:(NSMutableArray *)list customerName:(NSString *)customerName;
- (NSInteger)getSelectedIndex;

- (void)highlightDefaultAccount;
- (NSArray<AccountObject *> *)getSelectedAccounts; // array of AccountObject
- (NSString *)getFirstSelectedAccount;
- (CGFloat)getContentHeight;
@end
