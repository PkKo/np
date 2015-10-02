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
#import "TransactionObject.h"
#import "ConstantMaster.h"

@interface ArchivedTransactionItemsViewController () {
    NSDictionary    * _transactions;
    NSArray         * _transactionTitles;
}

@end

@implementation ArchivedTransactionItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    
    _transactions       = [controller getIndexDicOutOfArray:[controller getArchivedItems]];
    [self sortDataByAscending:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"ArchivedTransItemCell" owner:self options:nil];
    ArchivedTransItemCell * cell = (ArchivedTransItemCell *)[nibArr objectAtIndex:0];
    return cell.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_transactionTitles count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_transactionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString        * sectionTitle = [_transactionTitles objectAtIndex:section];
    NSMutableArray  * sectionItems = [_transactions objectForKey:sectionTitle];
    
    return [sectionItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ArchivedTransItemCell";
    
    ArchivedTransItemCell *cell = (ArchivedTransItemCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"ArchivedTransItemCell" owner:self options:nil];
        cell = (ArchivedTransItemCell *)[nibArr objectAtIndex:0];
        
        NSString        * sectionTitle = [_transactionTitles objectAtIndex:indexPath.section];
        NSMutableArray  * sectionItems = [_transactions objectForKey:sectionTitle];
        
        TransactionObject * transacObj = [sectionItems objectAtIndex:[indexPath row]];
        
        [cell.transacTypeImageView setImage:[UIImage imageNamed:[transacObj.transactionType isEqualToString:INCOME] ? @"icon_sticker_01" : @"icon_sticker_02"]];
        [cell.transacTime setText:[transacObj getTransactionHourMinute]];
        [cell.transacName setText:[transacObj transactionDetails]];
        
        [cell.transacAmount setText:[NSString stringWithFormat:@"%@ %@", [[transacObj transactionType] isEqualToString:INCOME] ? @"입금" : @"출금", [transacObj formattedTransactionAmount]]];
        [cell.transacAmount setTextColor:[[transacObj transactionType] isEqualToString:INCOME] ? [UIColor colorWithRed:29.0f/255.0f green:149.0f/255.0f blue:240.0f/255.0f alpha:1] : [UIColor colorWithRed:244.0f/255.0f green:96.0f/255.0f blue:124.0f/255.0f alpha:1]];
        
        [cell.transacBalance setText:[transacObj formattedTransactionBalance]];
        [cell.transacMemo setText:[transacObj transactionMemo]];
    }
    
    return cell;
}


- (void)sortDataByAscending:(BOOL)ascending {
    
    _transactionTitles  = [[_transactions allKeys] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:ascending]]];
    
    for (NSString * key in _transactionTitles) {
        
        NSMutableArray * items = [_transactions objectForKey:key];
        NSArray * itemsArr = [[items copy] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"transactionDate" ascending:ascending]]];
        [_transactions setValue:itemsArr forKey:key];
    }
}

@end
