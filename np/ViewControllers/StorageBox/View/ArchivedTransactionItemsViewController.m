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
#import "CustomizedPickerViewController.h"
#import "LoginCertListViewController.h"
#import "LoginAccountVerificationViewController.h"
#import "LoginSimpleVerificationViewController.h"
#import "DrawPatternLockViewController.h"

@interface ArchivedTransactionItemsViewController () <ArchivedTransItemCellDelegate> {
    NSDictionary    * _transactions;
    NSArray         * _transactionTitles;
}

@end

@implementation ArchivedTransactionItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    [self refreshData:[controller getAllTransactions] sortByAscending:NO];
    /*
    // create table & insert dummy data.
    [[DBManager sharedInstance] deleteAllTransactions];
    NSArray * arr = [controller getAllTransactions];
    for (TransactionObject * tranObj in arr) {
        tranObj.transactionId           = [NSString stringWithFormat:@"%d", (arc4random() * 1000)];
        tranObj.transactionActivePin    = [NSNumber numberWithBool:TRANS_ACTIVE_PIN_YES];
        tranObj.transactionAccountType  = @"급여통장";
        
        [[DBManager sharedInstance] saveTransaction:tranObj];
    }
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - top controller
- (IBAction)clickSortByDate {
    
    StatisticMainUtil * util = [[StatisticMainUtil alloc] init];
    [util showDataPickerInParentViewController:self dataSource:@[TIME_DECSENDING_ORDER, TIME_ACSENDING_ORDER]
                                  selectAction:@selector(sortByOrder:)
                                     selectRow:[self.sortByDateBtn titleForState:UIControlStateNormal]];
}

-(void)sortByOrder:(NSString *)order {
    
    if (![[self.sortByDateBtn titleForState:UIControlStateNormal] isEqualToString:order]) {
        
        [self.sortByDateBtn setTitle:order forState:UIControlStateNormal];
        [self sortDataByAscending:[order isEqualToString:TIME_ACSENDING_ORDER] ? YES : NO];
        [self.tableview reloadData];
    }
}

#pragma mark - select to remove
- (IBAction)toggleRemovalView:(id)sender {
    
    StorageBoxUtil *selectToRemoveUtil = [[StorageBoxUtil alloc] init];
    
    if (![selectToRemoveUtil hasSelectAllViewInParentView:self.view]) {
        
        [selectToRemoveUtil addSelectToRemoveViewToParent:self.view
                                 moveTopViewSeperatorDown:self.topViewSeperator
                                        moveTableviewDown:self.tableview
                                       moveNoDataViewDown:self.noDataView
                                                   target:self
                                          selectAllAction:@selector(selectAllItems:)
                                removeSelectedItemsAction:@selector(removeSelectedItems)
                            closeSelectToRemoveViewAction:@selector(closeSelectToRemoveView)];
        
        [self.tableview reloadData];
    } else {
        [self closeSelectToRemoveView];
    }
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
        
        StorageBoxController * controller = [[StorageBoxController alloc] init];
        [self refreshData:[controller getAllTransactions] sortByAscending:NO];
        
        [self.tableview reloadData];
    }
}

- (void)closeSelectToRemoveView {
    StorageBoxUtil *selectToRemoveUtil = [[StorageBoxUtil alloc] init];
    [selectToRemoveUtil removeSelectToRemoveViewFromParentView:self.view
                                      moveTopViewSeperatorBack:self.topViewSeperator
                                             moveTableviewBack:self.tableview
                                            moveNoDataViewBack:self.noDataView];
    [self selectAllItems:[NSNumber numberWithBool:NO]];
}

- (void)selectAllItems:(id)sender {
    
    BOOL isSelectAll = [(NSNumber *)sender boolValue];
    
    for (NSString * sectionTitle in _transactionTitles) {
        NSMutableArray  * sectionItems  = [_transactions objectForKey:sectionTitle];
        
        for (TransactionObject * transacObj in sectionItems) {
            if ([[transacObj transactionActivePin] boolValue]) {
                [transacObj setTransactionMarkAsDeleted:[NSNumber numberWithBool:isSelectAll]];
            }
        }
    }
    [self.tableview reloadData];
}

#pragma mark - search view
- (IBAction)toggleSearchView {
    
    StorageBoxUtil *dateSearchUtil = [[StorageBoxUtil alloc] init];
    
    if (![dateSearchUtil hasStorageDateSearchViewInParentView:self.view]) {
        
        if ([dateSearchUtil hasSelectAllViewInParentView:self.view]) {
            [self selectAllItems:[NSNumber numberWithBool:NO]];
        }
        
        StorageBoxDateSearchView * dateSearch = [dateSearchUtil addStorageDateSearchViewToParent:self.view
                                                                        moveTopViewSeperatorDown:self.topViewSeperator
                                                                               moveTableviewDown:self.tableview
                                                                              moveNoDataViewDown:self.noDataView];
        dateSearch.delegate                 = self;
        dateSearch.memoTextField.delegate   = self;
        
    } else {
        [dateSearchUtil removeStorageDateSearchViewFromParentView:self.view
                                         moveTopViewSeperatorBack:self.topViewSeperator
                                                moveTableviewBack:self.tableview
                                               moveNoDataViewBack:self.noDataView];
    }
}

-(void)closeSearchView {
    [self toggleSearchView];
}

- (void)showDataPickerToSelectAccountWithSelectedValue:(NSString *)sltedValue {
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    
    StatisticMainUtil * util = [[StatisticMainUtil alloc] init];
    [util showDataPickerInParentViewController:self dataSource:[controller getAllAccounts]
                                  selectAction:@selector(updateAccount:)
                                     selectRow:sltedValue];
}

- (void)updateAccount:(NSString *)account {
    StorageBoxUtil *dateSearchUtil = [[StorageBoxUtil alloc] init];
    StorageBoxDateSearchView * dateSearch = [dateSearchUtil hasStorageDateSearchViewInParentView:self.view];
    [dateSearch updateSelectedAccount:account];
}

- (void)showDataPickerToSelectTransTypeWithSelectedValue:(NSString *)sltedValue {
    
    StatisticMainUtil * util = [[StatisticMainUtil alloc] init];
    [util showDataPickerInParentViewController:self dataSource:@[TRANS_TYPE_GENERAL, TRANS_TYPE_INCOME, TRANS_TYPE_EXPENSE]
                                  selectAction:@selector(updateTransType:)
                                     selectRow:sltedValue];
}

- (void)updateTransType:(NSString *)type {
    StorageBoxUtil * dateSearchUtil = [[StorageBoxUtil alloc] init];
    StorageBoxDateSearchView * dateSearch = [dateSearchUtil hasStorageDateSearchViewInParentView:self.view];
    [dateSearch updateSelectedTransType:type];
}

#pragma mark - date picker
- (void)showDatePickerForStartDate {
    
    StatisticMainUtil *datePickerUtil = [[StatisticMainUtil alloc] init];
    [datePickerUtil showDatePickerWithMinDate:nil maxDate:nil inParentViewController:self
                                   doneAction:@selector(chooseStartDate:)];
}

- (void)showDatePickerForEndDate {
    
    StatisticMainUtil *datePickerUtil = [[StatisticMainUtil alloc] init];
    [datePickerUtil showDatePickerWithMinDate:nil maxDate:nil inParentViewController:self
                                   doneAction:@selector(chooseEndDate:)];
}

- (void)chooseStartDate:(id)sender {
    StorageBoxUtil *dateSearchUtil = [[StorageBoxUtil alloc] init];
    StorageBoxDateSearchView * dateSearch = [dateSearchUtil hasStorageDateSearchViewInParentView:self.view];
    [dateSearch updateStartDate:(NSDate *)sender];
}

- (void)chooseEndDate:(id)sender {
    StorageBoxUtil *dateSearchUtil = [[StorageBoxUtil alloc] init];
    StorageBoxDateSearchView * dateSearch = [dateSearchUtil hasStorageDateSearchViewInParentView:self.view];
    [dateSearch updateEndDate:(NSDate *)sender];
}

#pragma mark - search
- (void)searchTransFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate account:(NSString *)account
                  transType:(NSString *)transType memo:(NSString *)memo {
    
    NSDateFormatter * dateFormatter = [StatisticMainUtil getDateFormatterDateStyle];
    
    NSString * startDate    = [dateFormatter stringFromDate:fromDate];
    NSString * endDate      = [dateFormatter stringFromDate:toDate];
    startDate               = [NSString stringWithFormat:@"%@ 00:00:00", startDate];
    endDate                 = [NSString stringWithFormat:@"%@ 23:59:59", endDate];
    
    NSString * checkedAccountNo = [account isEqualToString:TRANS_ALL_ACCOUNT] ? nil : account;
    NSString * checkedTransType = [transType isEqualToString:TRANS_TYPE_GENERAL] ? nil : transType;
    NSString * checkedMemo = [memo isEqualToString:@""] ? nil : memo;
    
    NSArray * searchedItems = [[DBManager sharedInstance] selectByTransactionsStartDate:startDate endDate:endDate
                                                                              accountNo:checkedAccountNo
                                                                              transType:checkedTransType
                                                                                   memo:checkedMemo];
    [self refreshData:searchedItems
      sortByAscending:[[self.sortByDateBtn titleForState:UIControlStateNormal] isEqualToString:TIME_ACSENDING_ORDER] ? YES : NO];
    
    [self.tableview reloadData];
}

#pragma mark - data source
- (void)refreshData:(NSArray *)dataArr sortByAscending:(BOOL)isAscending {
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    _transactions = [controller getIndexDicOutOfArray:dataArr];//[controller getArchivedItems]
    [self sortDataByAscending:isAscending]; //NO
    
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
        
        cell.delegate               = self;
        cell.editTextField.delegate = self;
        
        NSString        * sectionTitle = [_transactionTitles objectAtIndex:indexPath.section];
        NSMutableArray  * sectionItems = [_transactions objectForKey:sectionTitle];
        
        TransactionObject * transacObj = [sectionItems objectAtIndex:[indexPath row]];
        
        // these following two variables are used for delete & edit.
        [cell setSection:indexPath.section];
        [cell setRow:indexPath.row];
        
        if ([selectToRemoveUtil hasSelectAllViewInParentView:self.view] && [[transacObj transactionActivePin] boolValue]) {
            
            [cell.deleteBtn setHidden:NO];
            [cell.transacTypeImageView setHidden:YES];
            cell.deleteBtn.selected = [transacObj.transactionMarkAsDeleted boolValue];
            
        } else {
            
            [cell.deleteBtn setHidden:YES];
            [cell.transacTypeImageView setHidden:NO];
            
            [cell.transacTypeImageView setImage:[UIImage imageNamed:[transacObj.transactionType isEqualToString:TRANS_TYPE_INCOME] ? @"icon_sticker_01" : @"icon_sticker_02"]];
        }
        
        [cell.pinImageView setImage:[UIImage imageNamed:[[transacObj transactionActivePin] boolValue] ? @"icon_pin_01_sel" : @"icon_pin_01_dft"]];
        
        [cell.transacTime setText:[transacObj getTransactionHourMinute]];
        [cell.transacName setText:[transacObj transactionDetails]];
        [cell.transacAccountNo setText:[NSString stringWithFormat:@"%@ %@", [transacObj transactionAccountType], [transacObj transactionAccountNumber]]];
        [cell.transacAmount setText:[NSString stringWithFormat:@"%@ %@", [[transacObj transactionType] isEqualToString:TRANS_TYPE_INCOME] ? @"입금" : @"출금", [transacObj formattedTransactionAmount]]];
        [cell.transacAmount setTextColor:[[transacObj transactionType] isEqualToString:TRANS_TYPE_INCOME] ? [UIColor colorWithRed:29.0f/255.0f green:149.0f/255.0f blue:240.0f/255.0f alpha:1] : [UIColor colorWithRed:244.0f/255.0f green:96.0f/255.0f blue:124.0f/255.0f alpha:1]];
        
        [cell.transacBalance setText:[transacObj formattedTransactionBalance]];
        [cell.transacMemo setText:[transacObj transactionMemo]];
        [cell updateMemoTextBorder];
    }
    return cell;
}

- (void)markAsDeleted:(BOOL)isMarkedAsDeleted ofItemSection:(NSInteger)section row:(NSInteger)row {
    
    NSString        * sectionTitle  = [_transactionTitles objectAtIndex:section];
    NSMutableArray  * sectionItems  = [_transactions objectForKey:sectionTitle];
    
    TransactionObject * transacObj = [sectionItems objectAtIndex:row];
    [transacObj setTransactionMarkAsDeleted:[NSNumber numberWithBool:isMarkedAsDeleted]];
}

-(void)updateMemo:(NSString *)memo ofItemSection:(NSInteger)section row:(NSInteger)row {
    
    NSString        * sectionTitle  = [_transactionTitles objectAtIndex:section];
    NSMutableArray  * sectionItems  = [_transactions objectForKey:sectionTitle];
    
    TransactionObject * transacObj = [sectionItems objectAtIndex:row];
    [transacObj setTransactionMemo:memo];
    
    [[DBManager sharedInstance] updateTransactionMemo:memo byTransId:transacObj.transactionId];
}

#pragma mark - Keyboard
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField.superview.superview.superview isKindOfClass:[UITableViewCell class]]) {
        
        ArchivedTransItemCell * cell = (ArchivedTransItemCell*)textField.superview.superview.superview;
        
        CGPoint pointInTable    = [cell convertPoint:cell.editView.frame.origin toView:self.tableview];
        CGPoint contentOffset   = self.tableview.contentOffset;
        contentOffset.y         = pointInTable.y - cell.editView.frame.size.height;
        
        [self.tableview setContentOffset:contentOffset animated:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if ([textField.superview.superview.superview isKindOfClass:[UITableViewCell class]]) {
        
        UITableViewCell * cell      = (UITableViewCell*)textField.superview.superview.superview;
        NSIndexPath     * indexPath = [self.tableview indexPathForCell:cell];
        
        [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)gotoPatternLogin:(id)sender {
    
    DrawPatternLockViewController *certLogin = [[DrawPatternLockViewController alloc] initWithNibName:@"DrawPatternLockViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:certLogin];
    [self.navigationController pushViewController:eVC animated:YES];
    
}

- (IBAction)gotoCertLogin:(id)sender {
    
    LoginCertListViewController *certLogin = [[LoginCertListViewController alloc] initWithNibName:@"LoginCertListViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:certLogin];
    [self.navigationController pushViewController:eVC animated:YES];
}

- (IBAction)gotoAccountLogin:(id)sender {
    
    LoginAccountVerificationViewController *accountLogin = [[LoginAccountVerificationViewController alloc] initWithNibName:@"LoginAccountVerificationViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:accountLogin];
    [self.navigationController pushViewController:eVC animated:YES];
}
- (IBAction)gotoSimpleLogin:(id)sender {
    
    LoginSimpleVerificationViewController *simpleLogin = [[LoginSimpleVerificationViewController alloc] initWithNibName:@"LoginSimpleVerificationViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:simpleLogin];
    [self.navigationController pushViewController:eVC animated:YES];
}

@end
