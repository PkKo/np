//
//  CertificateMenuViewController.m
//  공인인증서 관리 리스트 화면
//
//  Created by Infobank1 on 2015. 9. 9..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CertificateMenuViewController.h"
#import "CertificateRoamingViewController.h"
#import "CertificateRoamingPhoneViewController.h"
#import "CertificateListViewController.h"
#import "CertMenuCell.h"
#import "CertificateRoamingPassViewController.h"

#define CELL_HEIGHT     48

@interface CertificateMenuViewController ()

@end

@implementation CertificateMenuViewController

@synthesize mCertMenuTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mTitleLabel setText:@"공인인증센터"];
    [self.mNaviView.mMenuButton setHidden:YES];
    
    mCertMenuArray = [[NSArray alloc] initWithObjects:@"PC > 스마트폰 인증서 가져오기", @"스마트폰 > 스마트폰 인증서 가져오기", @"인증서 관리", nil];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mCertMenuTableView.frame.size.width, 0)];
    [mCertMenuTableView setTableHeaderView:headerView];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mCertMenuTableView.frame.size.width, 0)];
    [mCertMenuTableView setTableFooterView:footerView];
    
    [mCertMenuTableView.layer setBorderColor:[UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1.0f].CGColor];
    [mCertMenuTableView.layer setBorderWidth:1.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    cellHeight = CELL_HEIGHT * (self.view.bounds.size.height / IPHONE_FIVE_FRAME_HEIGHT);
    
    CGFloat totalCellHeight = cellHeight * [mCertMenuArray count];
    [mCertMenuTableView setFrame:CGRectMake(mCertMenuTableView.frame.origin.x,
                                            mCertMenuTableView.frame.origin.y,
                                            mCertMenuTableView.frame.size.width,
                                            totalCellHeight)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mCertMenuTableView setContentInset:UIEdgeInsetsZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = [NSString stringWithFormat:@"%@", [CertMenuCell class]];
    CertMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [CertMenuCell cell];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, cellHeight)];
    [cell.titleLabel setText:[mCertMenuArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mCertMenuArray count];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIViewController *vc = nil;
    switch (indexPath.row)
    {
        case 0:// pc에서 인증서 가져오기
        {
            vc = [[CertificateRoamingViewController alloc] init];
            break;
        }
        case 1:// 스마트폰에서 인증서 가져오기
        {
            vc = [[CertificateRoamingPhoneViewController alloc] init];
            break;
        }
            
        case 2: // 인증서 관리
        {
            if([[[LoginUtil alloc] init] isLoggedIn])
            {
                vc = [[CertificateListViewController alloc] init];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"로그인 상태가 아닙니다.\n로그인 후 이용해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
                return;
            }
            break;
        }
            
        default:
            break;
    }
    
    if(vc != nil)
    {
        ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
        [self.navigationController pushViewController:eVC animated:YES];
    }
}
@end
