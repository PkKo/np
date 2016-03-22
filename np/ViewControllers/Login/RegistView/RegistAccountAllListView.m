//
//  RegistAccountAllListVIew.m
//  np
//
//  Created by Infobank1 on 2015. 10. 13..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistAccountAllListView.h"
#import "RegistAllAccountListCellTableViewCell.h"
#import "RegistAccountOptionSettingView.h"
#import "RegistAccountAllHeaderCell.h"
#import "StatisticMainUtil.h"

@interface RegistAccountAllListView() {
    NSMutableDictionary * indexedAccountList;
    NSArray             * sortedSectionTitles;
    NSString            * selectedSectionTitle;
    NSInteger           numberOfSelectedAccount;
}

@end

@implementation RegistAccountAllListView

@synthesize pushDescLabel;
@synthesize titleLabel;
@synthesize accountListTable;
@synthesize accountList;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, accountListTable.frame.size.width, 9)];
    [accountListTable setTableHeaderView:paddingView];
    [accountListTable setTableFooterView:paddingView];
}
*/
- (void)initAccountList:(NSMutableArray *)list customerName:(NSString *)customerName
{
    selectedSectionTitle    = nil;
    numberOfSelectedAccount = 0;
    
    accountList = list;
    [titleLabel setText:[NSString stringWithFormat:@"%@님의 보유 계좌", customerName]];
    selectedIndex = 0;
    
    indexedAccountList = [self getIndexDicOutOfArray:accountList];
}

- (CGFloat)getContentHeight {
    
    if (!indexedAccountList) {
        return 0;
    }
    
    CGFloat contentHeight = 0;
    CGFloat numberOfSections = 0;
    CGFloat numberOfAccounts = 0;
    
    NSArray * allSections = [indexedAccountList allKeys];
    if (allSections) {
        numberOfSections = allSections.count;
        if (numberOfSections > 0) {
            for (NSString * section in allSections) {
                numberOfAccounts += [(NSArray *)[indexedAccountList objectForKey:section] count];
            }
        }
    }
    
    NSArray                     * nibArr    = [[NSBundle mainBundle] loadNibNamed:@"RegistAccountAllHeaderCell" owner:self options:nil];
    RegistAccountAllHeaderCell  * headerCell= (RegistAccountAllHeaderCell *)[nibArr objectAtIndex:0];
    
    NSArray * nibArr2                       = [[NSBundle mainBundle] loadNibNamed:@"RegistAccountAllRowCell" owner:self options:nil];
    RegistAccountAllRowCell * rowCell       = (RegistAccountAllRowCell *)[nibArr2 objectAtIndex:0];
    
    contentHeight = numberOfSections * headerCell.frame.size.height + numberOfAccounts * rowCell.frame.size.height;
    
    return contentHeight;
}

- (NSMutableDictionary *)getIndexDicOutOfArray:(NSArray *)arr { // array of Account Info NSDictionary
    
    NSMutableDictionary * indexDic = [NSMutableDictionary dictionary];
    
    if (!arr || [arr count] == 0) {
        return nil;
    }
    
    for (NSDictionary * accountInfoDic in arr) {
        
        AccountType accountType     = [accountInfoDic[@"EAAPAL00R0_OUT_SUB.account_type"] intValue];
        NSString * umsRegistered    = (NSString *)accountInfoDic[@"EAAPAL00R0_OUT_SUB.isUmsRegister"]; // Y or N
        
        if (umsRegistered && [umsRegistered isEqualToString:@"Y"]) {
            accountType = REGISTERED;
        }
        
        NSString * accountTypeDes = [self getAccountTypeDesc:accountType];
        
        if (!accountTypeDes) {
            continue;
        }
        
        NSMutableArray * sameDateArr = [indexDic objectForKey:accountTypeDes];
        if (!sameDateArr) {
            sameDateArr = [[NSMutableArray alloc] init];
            [indexDic setValue:sameDateArr forKey:accountTypeDes];
        }
        
        AccountObject * accountObj  = [[AccountObject alloc] init];
        accountObj.accountNo        = (NSString *)accountInfoDic[@"EAAPAL00R0_OUT_SUB.acno"];
        accountObj.accountDesc      = (NSString *)accountInfoDic[@"EAAPAL00R0_OUT_SUB.io_ea_wrsnm5"];
        accountObj.registeredAccount= umsRegistered ? umsRegistered : @"N";
        accountObj.accountTypeDesc  = accountTypeDes;
        accountObj.accountType      = accountType;
        
        [sameDateArr addObject:accountObj];
    }
    
    sortedSectionTitles = [self sortAccountSections:indexDic];
    
    return indexDic;
}

-(NSArray *)sortAccountSections:(NSMutableDictionary *)accounts {
    
    NSArray * sortedAccountSections = [[accounts allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull sectionTitle1, id  _Nonnull sectionTitle2) {
        
        if ([self getAccountTypeIndex:sectionTitle1] > [self getAccountTypeIndex:sectionTitle2]) {
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
    }];
    
    return sortedAccountSections;
}


//
- (NSString *)getAccountTypeDesc:(AccountType)accountType {
    
    if (accountType >=REGISTERED && accountType <= TRUST) {
        
        return (NSString *)[ACCOUNT_TYPE_DESCRIPTION objectAtIndex:accountType];
    }
    return nil;
}

- (AccountType)getAccountTypeIndex:(NSString *)accountTypeDes {
    return (AccountType)[ACCOUNT_TYPE_DESCRIPTION indexOfObject:accountTypeDes];
}


- (NSInteger)getSelectedIndex
{
    return selectedIndex;
}

#pragma mark - UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!indexedAccountList) {
        return nil;
    }
    
    RegistAccountAllHeaderCell * headerCell = (RegistAccountAllHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"RegistAccountAllHeaderCell"];
    
    if (headerCell == nil) {
        NSArray * nibArr    = [[NSBundle mainBundle] loadNibNamed:@"RegistAccountAllHeaderCell" owner:self options:nil];
        headerCell          = (RegistAccountAllHeaderCell *)[nibArr objectAtIndex:0];
        
    }
    
    NSString *sectionTitle  = [sortedSectionTitles objectAtIndex:section];
    [headerCell.accountCategory setText:sectionTitle];
    
    NSString * currentSection   = (NSString *)[sortedSectionTitles objectAtIndex:section];
    
    BOOL isHighlighted          = false;
    if ( selectedSectionTitle && [selectedSectionTitle isEqualToString:currentSection]) {
        isHighlighted = true;
    }
    
    AccountType accountType = [self getAccountTypeIndex:sectionTitle];
    
    [headerCell highlightSectionHeader:isHighlighted isRegisteredAccount:accountType == REGISTERED ? YES : NO];
    
    return headerCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numberOfSections = indexedAccountList ? [sortedSectionTitles count] : 0;
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!indexedAccountList) {
        return 0;
    }
    
    NSString    * sectionTitle  = [sortedSectionTitles objectAtIndex:section];
    NSArray     * accounts      = [indexedAccountList objectForKey:sectionTitle];
    return [accounts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSArray * nibArr                        = [[NSBundle mainBundle] loadNibNamed:@"RegistAccountAllHeaderCell" owner:self options:nil];
    RegistAccountAllHeaderCell *headerCell  = (RegistAccountAllHeaderCell *)[nibArr objectAtIndex:0];
    
    return headerCell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray * nibArr                    = [[NSBundle mainBundle] loadNibNamed:@"RegistAccountAllRowCell" owner:self options:nil];
    RegistAccountAllRowCell * rowCell   = (RegistAccountAllRowCell *)[nibArr objectAtIndex:0];
    
    return rowCell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RegistAccountAllRowCell * rowCell   = (RegistAccountAllRowCell *)[tableView dequeueReusableCellWithIdentifier:@"RegistAccountAllRowCell"];
    
    if (rowCell == nil) {
        NSArray * nibArr    = [[NSBundle mainBundle] loadNibNamed:@"RegistAccountAllRowCell" owner:self options:nil];
        rowCell             = (RegistAccountAllRowCell *)[nibArr objectAtIndex:0];
    }
    
    NSString        * sectionTitle  = [sortedSectionTitles objectAtIndex:[indexPath section]];
    NSArray         * accounts      = [indexedAccountList objectForKey:sectionTitle];
    
    AccountObject   * accountObj    = (AccountObject *)[accounts objectAtIndex:indexPath.row];
    [rowCell.accountNo setText:[NSString stringWithFormat:@"%@(%@)", [CommonUtil getAccountNumberAddDash:accountObj.accountNo], accountObj.accountDesc]];
    [rowCell setAccountState:accountObj.accountCheckState];
    [[rowCell btmLine] setHidden:YES];
    
    if ((indexPath.section == sortedSectionTitles.count - 1) && (indexPath.row == accounts.count - 1)) {
        [[rowCell btmLine] setHidden:NO];
    }
    
    return rowCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RegistAccountAllRowCell * selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString        * sectionTitle  = [sortedSectionTitles objectAtIndex:[indexPath section]];
    NSArray         * accounts      = indexedAccountList[sectionTitle];
    AccountObject   * accountObj    = [accounts objectAtIndex:indexPath.row];
    
    UIControlState accountState     = [selectedCell accountState];
    
    if (!selectedSectionTitle) {
        
        selectedSectionTitle    = sectionTitle;
        numberOfSelectedAccount = 1;
        
        // highlight the current selected account
        [self updateStateOfAccount:accountObj controlState:accountState];
        // disable other section
        [self setStateOfOtherSectionsExceptSectionTitle:sectionTitle controlState:UIControlStateDisabled];
        
        if (accountObj.accountType == REGISTERED) {
            [self setStateOfOtherAccountsExceptSelectedAccountsOfSectionTitle:sectionTitle controlState:UIControlStateDisabled];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                             message:@"이미 가입된 계좌를 선택하셨습니다.\n기가입된 계좌와 미가입 계좌는 동시에\n등록할 수 없습니다."
                                                            delegate:nil
                                                   cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
        }
        
        [tableView reloadData];
        return;
    }
    
    if (![selectedSectionTitle isEqualToString:sectionTitle]) {
        return;
    }
    
    if (accountState == UIControlStateDisabled) {
        return;
    }
    
    if (accountState == UIControlStateNormal) {
        
        // highlight the current selected account
        [self updateStateOfAccount:accountObj controlState:accountState];
        numberOfSelectedAccount++;
        
        // disable the rest of accounts except the MAX_NUM_OF_SELECTED_ACCOUNT selected account
        if (numberOfSelectedAccount == MAX_NUM_OF_SELECTED_ACCOUNT) {
            [self setStateOfOtherAccountsExceptSelectedAccountsOfSectionTitle:sectionTitle controlState:UIControlStateDisabled];
        }
        
        [tableView reloadData];
        return;
    }
    
    if (accountState == UIControlStateSelected) {
        
        // deselect the current selected account
        [self updateStateOfAccount:accountObj controlState:accountState];
        numberOfSelectedAccount--;
        
        if (numberOfSelectedAccount == MAX_NUM_OF_SELECTED_ACCOUNT - 1) {
            
            [self setStateOfOtherAccountsExceptSelectedAccountsOfSectionTitle:sectionTitle controlState:UIControlStateNormal];
            
        } else if (numberOfSelectedAccount == 0) {
            
            [self setStateOfOtherSectionsExceptSectionTitle:sectionTitle controlState:UIControlStateNormal];
            
            if (accountObj.accountType == REGISTERED) {
                [self setStateOfOtherAccountsExceptSelectedAccountsOfSectionTitle:sectionTitle controlState:UIControlStateNormal];
            }
            
            selectedSectionTitle = nil;
        }
        
        [tableView reloadData];
        return;
    }
}

- (void)updateStateOfAccount:(AccountObject *)accountObj controlState:(UIControlState)accountState {
    switch (accountState) {
            
        case UIControlStateNormal:
            [accountObj setAccountCheckState:UIControlStateSelected];
            break;
            
        case UIControlStateSelected:
            [accountObj setAccountCheckState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)setStateOfOtherSectionsExceptSectionTitle:(NSString *)sectionTitle controlState:(UIControlState)controlState {
    
    for (NSString * title in sortedSectionTitles) {
        
        if (![sectionTitle isEqualToString:title]) {
            
            NSArray * accounts = indexedAccountList[title];
            for (AccountObject * accountObj in accounts) {
                [accountObj setAccountCheckState:controlState];
            }
        }
    }
}

- (void)setStateOfOtherAccountsExceptSelectedAccountsOfSectionTitle:(NSString *)sectionTitle controlState:(UIControlState)controlState {
    
    NSArray * accounts = indexedAccountList[sectionTitle];
    
    for (AccountObject * accountObj in accounts) {
        if (accountObj.accountCheckState != UIControlStateSelected) {
            [accountObj setAccountCheckState:controlState];
        }
    }
}

- (void)highlightDefaultAccount {
    
    if (!indexedAccountList) {
        return;
    }
    
    if (!sortedSectionTitles || [sortedSectionTitles count] == 0) {
        return;
    }
    
    NSString * firstSection = (NSString *)[sortedSectionTitles objectAtIndex:0];
    
    
    
    NSArray * accounts = (NSArray *)[indexedAccountList objectForKey:firstSection];
    
    if (!accounts || [accounts count] == 0) {
        return;
    }
    
    AccountObject * firstAccount    = [accounts objectAtIndex:0];
    firstAccount.accountCheckState  = UIControlStateSelected;
    selectedSectionTitle            = firstSection;
    numberOfSelectedAccount++;
    
    [self setStateOfOtherSectionsExceptSectionTitle:firstSection controlState:UIControlStateDisabled];
    
    // disable the rest of accounts except the MAX_NUM_OF_SELECTED_ACCOUNT selected account
    if (numberOfSelectedAccount == MAX_NUM_OF_SELECTED_ACCOUNT
        || [self getAccountTypeIndex:firstSection] == REGISTERED) {
        [self setStateOfOtherAccountsExceptSelectedAccountsOfSectionTitle:firstSection controlState:UIControlStateDisabled];
    }
}

- (NSArray<AccountObject *> *)getSelectedAccounts {
    
    return [self getSelectedAccounts:MAX_NUM_OF_SELECTED_ACCOUNT];
}

- (NSString *)getFirstSelectedAccount {
    
    NSArray * selectedAccounts = [self getSelectedAccounts:1];
    
    return (selectedAccounts && selectedAccounts.count > 0) ? [(AccountObject *)[selectedAccounts objectAtIndex:0] accountNo] : nil;
}

- (NSArray *)getSelectedAccounts:(NSInteger)numberOfAccounts {
    
    NSMutableArray * selectedAccounts = [NSMutableArray array];
    
    if (!selectedSectionTitle) {
        return nil;
    }
    
    NSArray * allAccountOfSltedSection = indexedAccountList[selectedSectionTitle];
    
    for (AccountObject * account in allAccountOfSltedSection) {
        if (account.accountCheckState == UIControlStateSelected) {
            [selectedAccounts addObject:account];
            
            if (selectedAccounts.count == numberOfAccounts) {
                break;
            }
        }
    }
    
    return selectedAccounts.count > 0 ? [selectedAccounts copy] : nil;
}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [accountList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = [NSString stringWithFormat:@"%@", [RegistAllAccountListCellTableViewCell class]];
    RegistAllAccountListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [RegistAllAccountListCellTableViewCell cell];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.accountNum setText:[NSString stringWithFormat:@"%@(%@)", [CommonUtil getAccountNumberAddDash:[[accountList objectAtIndex:indexPath.row] objectForKey:@"EAAPAL00R0_OUT_SUB.acno"]], [[accountList objectAtIndex:indexPath.row] objectForKey:@"EAAPAL00R0_OUT_SUB.io_ea_wrsnm5"]]];
    [cell.accountNum setLineBreakMode:NSLineBreakByTruncatingTail];
    
    if(selectedIndex == indexPath.row)
    {
        [cell.accountNum setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [cell.selectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    }
    else
    {
        [cell.accountNum setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [cell.selectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    
    
    [tableView reloadData];
}
*/
@end
