//
//  AccountManageViewController.m
//  입출금 알림 계좌관리 뷰 컨트롤러
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "AccountManageViewController.h"
#import "AccountOptionSettingViewController.h"
#import "AccountAddViewController.h"
#import "CertMenuCell.h"

@interface AccountManageViewController ()

@end

@implementation AccountManageViewController

@synthesize emptyView;
@synthesize contentView;
@synthesize accountListTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:NO];
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"입출금 알림 계좌관리"];
    
    // 로그인 할 때 받아온 계좌번호 리스트를 가져온다
    accountList = [[NSArray alloc] initWithObjects:@"1111-22-333333", @"1111-23-123321", nil];
    
    if([accountList count] == 0)
    {
        [emptyView setHidden:NO];
        [contentView setHidden:YES];
    }
    else
    {
        [emptyView setHidden:YES];
        [contentView setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [accountList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = [NSString stringWithFormat:@"%@", [CertMenuCell class]];
    CertMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [CertMenuCell cell];
    }
    
    NSString *accountNumber = [accountList objectAtIndex:indexPath.row];
    [cell.titleLabel setText:accountNumber];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 계좌번호가 있으면 옵션 설정 뷰 컨트롤러로 이동한다.
    AccountOptionSettingViewController *vc = [[AccountOptionSettingViewController alloc] init];
    [vc setAccountNumber:[accountList objectAtIndex:indexPath.row]];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
    
    [self.navigationController pushViewController:eVC animated:YES];
}

- (IBAction)addAccount:(id)sender
{
    AccountAddViewController *vc = [[AccountAddViewController alloc] init];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
    
    [self.navigationController pushViewController:eVC animated:YES];
}
@end