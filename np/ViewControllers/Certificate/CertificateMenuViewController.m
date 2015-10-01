//
//  CertificateMenuViewController.m
//  공인인증서 관리 리스트 화면
//
//  Created by Infobank1 on 2015. 9. 9..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CertificateMenuViewController.h"
#import "CertificateRoamingViewController.h"
#import "CertificateListViewController.h"
#import "MenuTableCell.h"

@interface CertificateMenuViewController ()

@end

@implementation CertificateMenuViewController

@synthesize mCertMenuTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"공인인증서센터"];
    
    mCertMenuArray = [[NSArray alloc] initWithObjects:@"PC -> 스마트폰 인증서 가져오기", @"스마트폰 -> 스마트폰 인증서 가져오기", @"인증서 관리", nil];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    [mCertMenuTableView setTableFooterView:footerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [mCertMenuTableView setFrame:CGRectMake(0, self.mNaviView.frame.origin.y + self.mNaviView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.mNaviView.frame.origin.y + self.mNaviView.frame.size.height))];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = [NSString stringWithFormat:@"%@", [MenuTableCell class]];
    MenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [MenuTableCell cell];
    }
    
    [cell.mMenuTitleLabel setText:[mCertMenuArray objectAtIndex:indexPath.row]];
    
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
            
        case 2: // 인증서 관리
        {
            vc = [[CertificateListViewController alloc] init];
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
