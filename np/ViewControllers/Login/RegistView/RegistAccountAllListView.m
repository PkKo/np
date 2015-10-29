//
//  RegistAccountAllListVIew.m
//  np
//
//  Created by Infobank1 on 2015. 10. 13..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistAccountAllListView.h"
#import "RegistAllAccountListCellTableViewCell.h"

@implementation RegistAccountAllListView

@synthesize titleLabel;
@synthesize accountListTable;
@synthesize accountList;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, accountListTable.frame.size.width, 9)];
    [accountListTable setTableHeaderView:paddingView];
    [accountListTable setTableFooterView:paddingView];
}

- (void)initAccountList:(NSMutableArray *)list customerName:(NSString *)customerName
{
    accountList = list;
    [titleLabel setText:[NSString stringWithFormat:@"%@님의 보유 계좌", customerName]];
    
    selectedIndex = 0;
}

- (NSInteger)getSelectedIndex
{
    return selectedIndex;
}

#pragma mark - UITableViewDataSource
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
    
    [cell.accountNum setText:[[accountList objectAtIndex:indexPath.row] objectForKey:@"EAAPAL00R0_OUT_SUB.acno"]];
    
    [cell.selectImg.layer setCornerRadius:50];
    
    if(selectedIndex == indexPath.row)
    {
        [cell.accountNum setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [cell.selectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    }
    else
    {
        [cell.accountNum setTextColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
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

@end
