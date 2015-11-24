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
#import "ArchivedTransHeaderCell.h"
#import "StatisticMainUtil.h"
#import "ArchivedTransItemRemoveAllSelectView.h"
#import "ArchivedTransItemRemoveActionView.h"
#import "DBManager.h"
#import "CustomizedPickerViewController.h"
#import "MainPageViewController.h"
#import "ServiceFunctionInfoView.h"

@interface ArchivedTransactionItemsViewController () <ArchivedTransItemCellDelegate> {
    NSDictionary    * _transactions;
    NSArray         * _transactionTitles;
    UITextField     * _editingTextField;
    NSArray         * _prvSearchedCriteria;
    BOOL              _isSearch;
}

@end

@implementation ArchivedTransactionItemsViewController

@synthesize scrollMoveTopButton;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:FIRST_LOGIN_FLAG_FOR_STORAGE] == nil)
    {
        ServiceFunctionInfoView *guideView = [ServiceFunctionInfoView view];
        [guideView setDelegate:self];
        [guideView setFrame:CGRectMake(0, 0,
                                       ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame.size.width,
                                       ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame.size.height)];
        [[guideView infoViewButton] setTag:3];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view addSubview:guideView];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view bringSubviewToFront:guideView];
        [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:FIRST_LOGIN_FLAG_FOR_STORAGE];
    }
    else
    {
        [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) startIndicator];
        
        _prvSearchedCriteria    = nil;
        _isSearch               = NO;
        [self performSelector:@selector(getAllTransactions) withObject:nil afterDelay:0.06];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removedServiceFunctionInfoView
{
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) startIndicator];
    
    _prvSearchedCriteria    = nil;
    _isSearch               = NO;
    [self performSelector:@selector(getAllTransactions) withObject:nil afterDelay:0.06];
}

#pragma mark - top controller
- (IBAction)clickSortByDate {
    
    StatisticMainUtil * util = [[StatisticMainUtil alloc] init];
    [util showDataPickerInParentViewController:((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController
                                        target:self
                                    dataSource:@[TIME_DECSENDING_ORDER, TIME_ACSENDING_ORDER]
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
    
    UIView * itemRemoveActionView = [[self.view subviews] objectAtIndex:self.view.subviews.count - 1];
    if (itemRemoveActionView  && [itemRemoveActionView isKindOfClass:[ArchivedTransItemRemoveActionView class]]) {
        
        if (![(ArchivedTransItemRemoveActionView *)itemRemoveActionView hasItemsToRemove]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"삭제할 메시지를 선택해주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"선택한 메시지를 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alert show];
}

- (void)doRemoveSelectedItems {
    
    for (NSString * sectionTitle in _transactionTitles) {
        
        NSArray * sectionItems = [_transactions objectForKey:sectionTitle];
        NSMutableArray * mutableSectionItems = [NSMutableArray arrayWithArray:sectionItems];
        
        for (TransactionObject * transacObj in mutableSectionItems) {
            if ([[transacObj transactionMarkAsDeleted] boolValue]) {
                [[DBManager sharedInstance] deleteTransactionById:[transacObj transactionId]];
            }
        }
    }
    
    if (_prvSearchedCriteria) {
        [self searchTransByCriteria:_prvSearchedCriteria];
    } else {
        [self getAllTransactions];
    }
    
    // highlight delete button
    [self highlightDeleteBtn];
    
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) stopIndicator];
}

- (void)closeSelectToRemoveView {
    StorageBoxUtil *selectToRemoveUtil = [[StorageBoxUtil alloc] init];
    [selectToRemoveUtil removeSelectToRemoveViewFromParentView:self.view];
    [self selectAllItems:[NSNumber numberWithBool:NO]];
}

- (void)selectAllItems:(id)sender {
    
    BOOL isSelectAll = [(NSNumber *)sender boolValue];
    
    for (NSString * sectionTitle in _transactionTitles) {
        NSMutableArray  * sectionItems  = [_transactions objectForKey:sectionTitle];
        
        for (TransactionObject * transacObj in sectionItems) {
            if (![[transacObj transactionActivePin] boolValue]) {
                [transacObj setTransactionMarkAsDeleted:[NSNumber numberWithBool:isSelectAll]];
            }
        }
    }
    
    // highlight delete button
    [self highlightDeleteBtn];
    
    [self.tableview reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) startIndicator];
        [self performSelector:@selector(doRemoveSelectedItems) withObject:nil afterDelay:0.06];
    }
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
                                                                           outsideOfKeyboardView:self.toolbarView];
        dateSearch.delegate                 = self;
        dateSearch.memoTextField.delegate   = self;
        
    } else {
        [dateSearchUtil removeStorageDateSearchViewFromParentView:self.view];
    }
}

-(void)closeSearchView {
    [self toggleSearchView];
}

- (void)showDataPickerToSelectAccountWithSelectedValue:(NSString *)sltedValue {
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    
    StatisticMainUtil * util = [[StatisticMainUtil alloc] init];
    [util showDataPickerInParentViewController:((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController
                                        target:self
                                    dataSource:[controller getAllAccounts]
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
    [util showDataPickerInParentViewController:((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController
                                        target:self
                                    dataSource:@[TRANS_TYPE_GENERAL, TRANS_TYPE_INCOME, TRANS_TYPE_EXPENSE]
                                  selectAction:@selector(updateTransType:)
                                     selectRow:sltedValue];
}

- (void)updateTransType:(NSString *)type {
    StorageBoxUtil * dateSearchUtil = [[StorageBoxUtil alloc] init];
    StorageBoxDateSearchView * dateSearch = [dateSearchUtil hasStorageDateSearchViewInParentView:self.view];
    [dateSearch updateSelectedTransType:type];
}

#pragma mark - date picker
- (void)showDatePickerForStartDate:(NSDate *)initialDate {
    
    StatisticMainUtil *datePickerUtil = [[StatisticMainUtil alloc] init];
    [datePickerUtil showDatePickerWithMinDate:nil maxDate:nil
                                  initialDate:initialDate
                       inParentViewController:((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController
                                       target:self
                                   doneAction:@selector(chooseStartDate:)];
}

- (void)showDatePickerForEndDate:(NSDate *)initialDate {
    
    StatisticMainUtil *datePickerUtil = [[StatisticMainUtil alloc] init];
    [datePickerUtil showDatePickerWithMinDate:nil maxDate:nil
                                  initialDate:initialDate
                       inParentViewController:((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController
                                       target:self
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
    
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) startIndicator];
    _isSearch = YES;
    [[[StorageBoxUtil alloc] init] removeStorageDateSearchViewFromParentView:self.view];
    
    [self performSelector:@selector(searchTransByCriteria:) withObject:@[fromDate, toDate, account, transType, memo] afterDelay:0.06];
}

- (void)searchTransByCriteria:(NSArray *)criteriaArr {
    
    _prvSearchedCriteria    = criteriaArr;
    
    NSDate      * fromDate  = (NSDate *)  [criteriaArr objectAtIndex:0];
    NSDate      * toDate    = (NSDate *)  [criteriaArr objectAtIndex:1];
    NSString    * account   = (NSString *)[criteriaArr objectAtIndex:2];
    NSString    * transType = (NSString *)[criteriaArr objectAtIndex:3];
    NSString    * memo      = (NSString *)[criteriaArr objectAtIndex:4];
    
    NSDateFormatter * dateFormatter = [StatisticMainUtil getDateFormatterDateStyle];
    
    NSString * startDate    = [dateFormatter stringFromDate:fromDate];
    NSString * endDate      = [dateFormatter stringFromDate:toDate];
    startDate               = [NSString stringWithFormat:@"%@ 00:00:00", startDate];
    endDate                 = [NSString stringWithFormat:@"%@ 23:59:59", endDate];
    
    NSString * checkedAccountNo = [account isEqualToString:TRANS_ALL_ACCOUNT] ? nil : account;
    NSString * checkedTransType = [transType isEqualToString:TRANS_TYPE_GENERAL] ? nil : ([transType isEqualToString:INCOME_TYPE_STRING] ? @"1" : @"2");
    NSString * checkedMemo = [memo isEqualToString:@""] ? nil : memo;
    
    NSArray * searchedItems = [[DBManager sharedInstance] selectByTransactionsStartDate:startDate endDate:endDate
                                                                              accountNo:checkedAccountNo
                                                                              transType:checkedTransType
                                                                                   memo:checkedMemo];
    [self refreshData:searchedItems
      sortByAscending:[[self.sortByDateBtn titleForState:UIControlStateNormal] isEqualToString:TIME_ACSENDING_ORDER] ? YES : NO];
    
    [self.tableview reloadData];
    
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) stopIndicator];
}

#pragma mark - data source
- (void)getAllTransactions {
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    [self refreshData:[controller getAllTransactions] sortByAscending:NO];
    [self.tableview reloadData];
    
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) stopIndicator];
}

- (void)refreshData:(NSArray *)dataArr sortByAscending:(BOOL)isAscending {
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    _transactions = [controller getIndexDicOutOfArray:dataArr];//[controller getArchivedItems]
    [self sortDataByAscending:isAscending]; //NO
    
    [self.tableview setHidden:([[_transactions allKeys] count] == 0)];
    [self.noDataView setHidden:!self.tableview.hidden];
    
    if (![self.noDataView isHidden]) {
        [self.noDataImageView setImage:[UIImage imageNamed:_isSearch ? @"icon_noresult_01" : @"icon_noresult_02"]];
        [self.noDataNotice setText: _isSearch ? @"해당기간 내 검색 결과가 없습니다." : @"보관함에 저장된 내역이 없습니다."];
    }
    _isSearch = NO;
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
        [cell setPinnable:[[transacObj transactionActivePin] boolValue]];
        
        if ([selectToRemoveUtil hasSelectAllViewInParentView:self.view]) {
            
            [cell.deleteBtn setHidden:NO];
            [cell.transacTypeBtn setHidden:YES];
            cell.deleteBtn.selected = [transacObj.transactionMarkAsDeleted boolValue];
            [cell.editMemoBtn setHidden:YES];
            [cell.pinupBtn setHidden:![[transacObj transactionActivePin] boolValue]];
        } else {
            
            [cell.deleteBtn setHidden:YES];
            [cell.transacTypeBtn setHidden:NO];
            [cell.editMemoBtn setHidden:NO];
            [cell updateTransTypeImageBtnByStickerCode:(StickerType)[transacObj.transactionType intValue]];
        }
        
        [cell.pinupBtn setSelected:[[transacObj transactionActivePin] boolValue]];
        [cell.transacTime setText:[transacObj getTransactionHourMinute]];
        [cell.transacName setText:[transacObj transactionDetails]];
        
        NSString *accountNickName = [[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_NICKNAME_DICTIONARY] objectForKey:[[StatisticMainUtil sharedInstance] getAccountNumberWithoutDash:[transacObj transactionAccountNumber]]];
        
        if(accountNickName != nil && [accountNickName length] > 0) {
            [cell.transacAccountNo setText:[NSString stringWithFormat:@"%@ %@", accountNickName, [transacObj transactionAccountNumber]]];
        } else {
            [cell.transacAccountNo setText:[transacObj transactionAccountNumber]];
        }
        
        [cell.transacAmountType setText:[transacObj transactionTypeDesc]];
        [cell.transacAmount setText:[transacObj formattedTransactionAmount]];
        
        CGSize transacAmountSize = [StorageBoxUtil contentSizeOfLabel:cell.transacAmount];
        CGRect transacAmountRect = cell.transacAmount.frame;
        transacAmountRect.size.width = transacAmountSize.width;
        [cell.transacAmount setFrame:transacAmountRect];
        
        CGRect transacAmountUnitRect = cell.transacAmountUnit.frame;
        transacAmountUnitRect.origin.x = transacAmountRect.origin.x + transacAmountRect.size.width;
        [cell.transacAmountUnit setFrame:transacAmountUnitRect];
        
        [cell.transacAmount setTextColor:[[transacObj transactionTypeDesc] isEqualToString:TRANS_TYPE_INCOME] ? [UIColor colorWithRed:36.0f/255.0f green:132.0f/255.0f blue:199.0f/255.0f alpha:1] : [UIColor colorWithRed:222.0f/255.0f green:69.0f/255.0f blue:98.0f/255.0f alpha:1]];
        [cell.transacAmountUnit setTextColor:cell.transacAmount.textColor];
        [cell.transacAmountType setTextColor:cell.transacAmount.textColor];
        
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
    
    // highlight delete button
    [self highlightDeleteBtn];
}

- (void)markAsPinup:(BOOL)isPinnable ofItemSection:(NSInteger)section row:(NSInteger)row {
    
    NSString        * sectionTitle  = [_transactionTitles objectAtIndex:section];
    NSMutableArray  * sectionItems  = [_transactions objectForKey:sectionTitle];
    
    TransactionObject * transacObj  = [sectionItems objectAtIndex:row];
    [transacObj setTransactionActivePin:[NSNumber numberWithBool:isPinnable]];
    [[DBManager sharedInstance] updateTransactionPinnable:isPinnable byTransId:transacObj.transactionId];
}

- (void)highlightDeleteBtn {
    
    UIView * itemRemoveActionView = [[self.view subviews] objectAtIndex:self.view.subviews.count - 1];
    if (itemRemoveActionView  && [itemRemoveActionView isKindOfClass:[ArchivedTransItemRemoveActionView class]]) {
        
        for (NSString * sectionTitle in _transactionTitles) {
            
            NSMutableArray  * sectionItems  = [_transactions objectForKey:sectionTitle];
            
            for (TransactionObject * transacObj in sectionItems) {
                if ([transacObj.transactionMarkAsDeleted boolValue]) {
                    [(ArchivedTransItemRemoveActionView *)itemRemoveActionView toggleDeleteBgColor:YES];
                    return;
                }
            }
        }
        
        [(ArchivedTransItemRemoveActionView *)itemRemoveActionView toggleDeleteBgColor:NO];
    }
}

-(void)updateMemo:(NSString *)memo ofItemSection:(NSInteger)section row:(NSInteger)row {
    
    NSString        * sectionTitle  = [_transactionTitles objectAtIndex:section];
    NSMutableArray  * sectionItems  = [_transactions objectForKey:sectionTitle];
    
    TransactionObject * transacObj = [sectionItems objectAtIndex:row];
    [transacObj setTransactionMemo:memo];
    [[DBManager sharedInstance] updateTransactionMemo:memo byTransId:transacObj.transactionId];
}

- (void)updateSticker:(StickerType)sticker ofItemSection:(NSInteger)section row:(NSInteger)row {
    NSString        * sectionTitle  = [_transactionTitles objectAtIndex:section];
    NSMutableArray  * sectionItems  = [_transactions objectForKey:sectionTitle];
    
    TransactionObject * transacObj = [sectionItems objectAtIndex:row];
    [transacObj setTransactionType:[@(sticker) stringValue]];
    [[DBManager sharedInstance] updateTransactionType:transacObj.transactionType byTransId:transacObj.transactionId];
}

#pragma mark - Keyboard
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    _editingTextField = textField;
    [self.keyboardBgView setHidden:NO];
    
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
    
    [self.keyboardBgView setHidden:YES];
    
    if ([textField.superview.superview.superview isKindOfClass:[UITableViewCell class]]) {
        
        UITableViewCell * cell      = (UITableViewCell*)textField.superview.superview.superview;
        NSIndexPath     * indexPath = [self.tableview indexPathForCell:cell];
        
        [self.tableview scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
    }
    return YES;
}


- (IBAction)tapToHideKeyboard:(UITapGestureRecognizer *)sender {
    
    [_editingTextField resignFirstResponder];
    [self.keyboardBgView setHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [self.keyboardBgView setHidden:YES];
    
    if ([textField.superview.superview.superview isKindOfClass:[UITableViewCell class]]) {
        
        ArchivedTransItemCell * cell      = (ArchivedTransItemCell *)textField.superview.superview.superview;
        [cell saveNewMemo];
    }
    
    return YES;
}

#pragma mark - Go Top
- (IBAction)scrollToTopOfTableView {
    [self.tableview setContentOffset:CGPointZero animated:YES];
}

- (void)showScrollTopButton
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [scrollMoveTopButton setHidden:NO];
        [scrollMoveTopButton setFrame:CGRectMake(self.view.frame.size.width - scrollMoveTopButton.frame.size.width,
                                                 scrollMoveTopButton.frame.origin.y,
                                                 scrollMoveTopButton.frame.size.width,
                                                 scrollMoveTopButton.frame.size.height)];
    }completion:nil];
}

- (void)hideScrollTopButton {
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [scrollMoveTopButton setFrame:CGRectMake(self.view.frame.size.width,
                                                 scrollMoveTopButton.frame.origin.y,
                                                 scrollMoveTopButton.frame.size.width,
                                                 scrollMoveTopButton.frame.size.height)];
    }
                     completion:^(BOOL finished){
                         [scrollMoveTopButton setHidden:YES];
                     }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView * myTableView = (UITableView *)scrollView;
        CGPoint myTableViewPosition =  myTableView.contentOffset;
        
        if (myTableViewPosition.y > 0 && self.scrollMoveTopButton.isHidden) {
            [self showScrollTopButton];
            
        } else if (myTableViewPosition.y <= 0 && !self.scrollMoveTopButton.isHidden) {
            [self hideScrollTopButton];
        }
    }
}

@end
