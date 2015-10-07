//
//  ArchivedTransactionItemsViewController.m
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ArchivedTransactionItemsViewController.h"
#import "ArchivedTransItemCell.h"
#import "StorageBoxController.h"
#import "StorageBoxUtil.h"
#import "TransactionObject.h"
#import "ConstantMaster.h"
#import "ArchivedTransHeaderCell.h"
#import "StatisticMainUtil.h"
#import "ArchivedTransItemRemoveAllSelectView.h"
#import "ArchivedTransItemRemoveActionView.h"
#import "DBManager.h"
#import "StorageBoxDateSearchView.h"

@interface ArchivedTransactionItemsViewController () <ArchivedTransItemCellDelegate> {
    NSDictionary    * _transactions;
    NSArray         * _transactionTitles;
}

@end

@implementation ArchivedTransactionItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
    // create table & insert dummy data.
    /*
    [[DBManager sharedInstance] deleteAllTransactions];
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    NSArray * arr = [controller getArchivedItems];
    for (TransactionObject * tranObj in arr) {
        tranObj.transactionId = [NSString stringWithFormat:@"%d", (arc4random() * 1000)];
        
        [[DBManager sharedInstance] saveTransaction:tranObj];
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - top controller
- (IBAction)sortByDate {
    NSLog(@"%s", __func__);
}

- (IBAction)toggleRemovalView:(id)sender {
    NSLog(@"%s", __func__);
    
    StorageBoxUtil *selectToRemoveUtil = [[StorageBoxUtil alloc] init];
    
    if (![selectToRemoveUtil hasSelectAllViewInParentView:self.view]) {
        
        [selectToRemoveUtil addSelectToRemoveViewToParent:self.view
                                 moveTopViewSeperatorDown:self.topViewSeperator
                                        moveTableviewDown:(self.tableview.isHidden ? self.noDataView : self.tableview)
                                                   target:self
                                          selectAllAction:@selector(selectAllItems:)
                                removeSelectedItemsAction:@selector(removeSelectedItems)
                            closeSelectToRemoveViewAction:@selector(closeSelectToRemoveView)];
        
    } else {
        [selectToRemoveUtil removeSelectToRemoveViewFromParentView:self.view
                                          moveTopViewSeperatorBack:self.topViewSeperator moveTableviewBack:(self.tableview.isHidden ? self.noDataView : self.tableview)];
    }
    [self.tableview reloadData];
}

- (void)removeSelectedItems {
    
    BOOL hasSelectedItems = NO;
    
    for (NSString * sectionTitle in _transactionTitles) {
        
        NSArray * sectionItems = [_transactions objectForKey:sectionTitle];
        NSMutableArray * mutableSectionItems = [NSMutableArray arrayWithArray:sectionItems];
        
        for (TransactionObject * transacObj in mutableSectionItems) {
            if ([[transacObj transactionMarkAsDeleted] boolValue]) {
                hasSelectedItems = YES;
                [[DBManager sharedInstance] deleteTransactionById:[transacObj transactionId]];
            }
        }
    }
    
    if (!hasSelectedItems) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"삭제할 메시지를 선택해주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
    } else {
        [self refreshData];
        [self.tableview reloadData];
    }
}

- (void)closeSelectToRemoveView {
    StorageBoxUtil *selectToRemoveUtil = [[StorageBoxUtil alloc] init];
    [selectToRemoveUtil removeSelectToRemoveViewFromParentView:self.view
                                      moveTopViewSeperatorBack:self.topViewSeperator moveTableviewBack:self.tableview];
}

- (void)selectAllItems:(id)sender {
    
    BOOL isSelectAll = [(NSNumber *)sender boolValue];
    
    for (NSString * sectionTitle in _transactionTitles) {
        NSMutableArray  * sectionItems  = [_transactions objectForKey:sectionTitle];
        
        for (TransactionObject * transacObj in sectionItems) {
            [transacObj setTransactionMarkAsDeleted:[NSNumber numberWithBool:isSelectAll]];
        }
    }
    [self.tableview reloadData];
}

- (IBAction)toggleSearchView {
    NSLog(@"%s", __func__);
    /*
    NSArray * nibArr = [[NSBundle mainBundle] loadNibNamed:@"StorageBoxDateSearchView" owner:self options:nil];
    StorageBoxDateSearchView * dateSearchView = [nibArr objectAtIndex:0];
    CGRect dateSearchViewFrame = dateSearchView.frame;
    [self.view addSubview:dateSearchView];
    */
}

#pragma mark - data source
- (void)refreshData {
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    _transactions = [controller getIndexDicOutOfArray:[controller getArchivedItems]];
    [self sortDataByAscending:NO];
    
    [self.tableview setHidden:([[_transactions allKeys] count] == 0)];
    [self.noDataView setHidden:!self.tableview.hidden];
    
}

- (void)sortDataByAscending:(BOOL)ascending {
    
    _transactionTitles  = [[_transactions allKeys] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self"
                                                                                                               ascending:ascending]]];
    for (NSString * key in _transactionTitles) {
        
        NSMutableArray * items = [_transactions objectForKey:key];
        NSArray * itemsArr = [[items copy] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"transactionDate"
                                                                                                       ascending:ascending]]];
        [_transactions setValue:itemsArr forKey:key];
    }
}

#pragma mark - table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"ArchivedTransItemCell" owner:self options:nil];
    ArchivedTransItemCell * cell = (ArchivedTransItemCell *)[nibArr objectAtIndex:0];
    return cell.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_transactionTitles count];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headerIdentifier = @"ArchivedTransHeaderCell";
    ArchivedTransHeaderCell * headerCell = (ArchivedTransHeaderCell *)[tableView dequeueReusableCellWithIdentifier:headerIdentifier];
    
    if (headerCell == nil) {
        NSArray * nibArr    = [[NSBundle mainBundle] loadNibNamed:@"ArchivedTransHeaderCell" owner:self options:nil];
        headerCell          = (ArchivedTransHeaderCell *)[nibArr objectAtIndex:0];
        [headerCell.dateLabel setText:[_transactionTitles objectAtIndex:section]];
        [headerCell.weekdayLabel setText:[StatisticMainUtil getWeekdayOfDateStr:[_transactionTitles objectAtIndex:section]]];
    }
    
    return headerCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString        * sectionTitle = [_transactionTitles objectAtIndex:section];
    NSMutableArray  * sectionItems = [_transactions objectForKey:sectionTitle];
    
    return [sectionItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ArchivedTransItemCell";
    
    ArchivedTransItemCell *cell = (ArchivedTransItemCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    StorageBoxUtil *selectToRemoveUtil = [[StorageBoxUtil alloc] init];
    
    if (cell == nil) {
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"ArchivedTransItemCell" owner:self options:nil];
        cell            = (ArchivedTransItemCell *)[nibArr objectAtIndex:0];
        cell.delegate   = self;
        
        NSString        * sectionTitle = [_transactionTitles objectAtIndex:indexPath.section];
        NSMutableArray  * sectionItems = [_transactions objectForKey:sectionTitle];
        
        TransactionObject * transacObj = [sectionItems objectAtIndex:[indexPath row]];
        
        // these following two variables are used for delete & edit.
        [cell setSection:indexPath.section];
        [cell setRow:indexPath.row];
        
        if ([selectToRemoveUtil hasSelectAllViewInParentView:self.view]) {
            
            [cell.deleteBtn setHidden:NO];
            [cell.transacTypeImageView setHidden:YES];
            cell.deleteBtn.selected = [transacObj.transactionMarkAsDeleted boolValue];
            
        } else {
            
            [cell.deleteBtn setHidden:YES];
            [cell.transacTypeImageView setHidden:NO];
            
            [cell.transacTypeImageView setImage:[UIImage imageNamed:[transacObj.transactionType isEqualToString:INCOME] ? @"icon_sticker_01" : @"icon_sticker_02"]];
        }
        [cell.transacTime setText:[transacObj getTransactionHourMinute]];
        [cell.transacName setText:[transacObj transactionDetails]];
        
        [cell.transacAmount setText:[NSString stringWithFormat:@"%@ %@", [[transacObj transactionType] isEqualToString:INCOME] ? @"입금" : @"출금", [transacObj formattedTransactionAmount]]];
        [cell.transacAmount setTextColor:[[transacObj transactionType] isEqualToString:INCOME] ? [UIColor colorWithRed:29.0f/255.0f green:149.0f/255.0f blue:240.0f/255.0f alpha:1] : [UIColor colorWithRed:244.0f/255.0f green:96.0f/255.0f blue:124.0f/255.0f alpha:1]];
        
        [cell.transacBalance setText:[transacObj formattedTransactionBalance]];
        [cell.transacMemo setText:[transacObj transactionMemo]];
    }
    return cell;
}

- (void)markAsDeleted:(BOOL)isMarkedAsDeleted ofItemSection:(NSInteger)section row:(NSInteger)row {
    
    NSString        * sectionTitle  = [_transactionTitles objectAtIndex:section];
    NSMutableArray  * sectionItems  = [_transactions objectForKey:sectionTitle];
    
    TransactionObject * transacObj = [sectionItems objectAtIndex:row];
    [transacObj setTransactionMarkAsDeleted:[NSNumber numberWithBool:isMarkedAsDeleted]];
}

@end
