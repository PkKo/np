//
//  MenuViewController.m
//  메뉴 화면
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableCell.h"
#import "MainPageViewController.h"
#import "HomeViewController.h"
#import "CertificateMenuViewController.h"
#import "StatisticMainViewController.h"
#import "SNSViewController.h"
#import "MenuTableEtcView.h"
#import "NotiSettingMenuViewController.h"

#define MENU_CELL_HEIGHT    37

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize menuTableView;
// 로그인 여부 확인 후 Highlight처리
@synthesize loginImg;
// 로그인 여부 확인 후 메시지 변경
@synthesize loginTextLabel;
// 로그인 여부 확인 후 버튼 텍스트 변경(로그인/로그아웃)
@synthesize loginButtonTextLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Menu name, menu normal icon, menu highlighted icon
    mMenuTitleArray = [[NSArray alloc] initWithObjects:
  @[@"전체 알림", @"icon_notice_01_dft.png", @"icon_notice_01_on.png"],
  @[@"입출금 알림", @"icon_notice_02_dft.png", @"icon_notice_02_on.png"],
  @[@"기타 알림", @"icon_notice_03_dft.png", @"icon_notice_03_on.png"],
  @[@"보관함", @"icon_storage_01_dft.png", @"icon_storage_01_on.png"],
  @[@"알림 설정", @"icon_notice_setting_01_dft.png", @"icon_notice_setting_01_on.png"],
  @[@"환경 설정", @"icon_settings_01_dft.png", @"icon_settings_01_on.png"],
  @[@"고객센터", @"icon_customer_01_dft.png", @"icon_customer_01_on.png"],
  @[@"NH APPZONE", @"icon_app_zone_01_dft.png", @"icon_app_zone_01_on.png"], nil];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuTableView.frame.size.width, 23)];
    [menuTableView setTableHeaderView:headerView];
	// 빈 리스트 안보이게 하기 위해 height 0인 뷰를 붙여준다.
    MenuTableEtcView *footerView = [MenuTableEtcView view];
    [footerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, footerView.frame.size.height)];
    [menuTableView setTableFooterView:footerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeMenu:(id)sender
{
//    NSLog(@"%@", self.slidingViewController.topViewController);
    if([self.slidingViewController.topViewController respondsToSelector:@selector(closeMenuView)])
    {
        [self.slidingViewController.topViewController performSelector:@selector(closeMenuView) withObject:nil];
    }
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
    
    NSString *title = [[mMenuTitleArray objectAtIndex:indexPath.row] objectAtIndex:0];
    
    [cell.mMenuTitleLabel setText:title];
    [cell.menuTitleImg setImage:[UIImage imageNamed:[[mMenuTitleArray objectAtIndex:indexPath.row] objectAtIndex:1]]];
    [cell.menuTitleImg setHighlightedImage:[UIImage imageNamed:[[mMenuTitleArray objectAtIndex:indexPath.row] objectAtIndex:2]]];
    
    if (indexPath.row == 7)
    {
        [cell.menuSeparateLine setHidden:YES];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mMenuTitleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MENU_CELL_HEIGHT;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIViewController *newTopViewController = nil;
    UIViewController *pushViewController = nil;
    
    switch (indexPath.row)
    {
        case 0: // 전체
        {
            newTopViewController = [[MainPageViewController alloc] init];
            [(MainPageViewController *)newTopViewController setStartPageIndex:TIMELINE];
            break;
        }
        case 1: // 입출금
        {
//            newTopViewController = [[MainPageViewController alloc] init];
//            [(MainPageViewController *)newTopViewController setStartPageIndex:BANKING];
            // 임시 공인인증서 뷰 컨트롤러 적용
            newTopViewController = [[CertificateMenuViewController alloc] init];
            break;
        }
        case 2: // 기타
        {
            newTopViewController = [[MainPageViewController alloc] init];
            [(MainPageViewController *)newTopViewController setStartPageIndex:OTHER];
            break;
        }
        case 3: // 보관함
        {
            newTopViewController = [[MainPageViewController alloc] init];
            [(MainPageViewController *)newTopViewController setStartPageIndex:INBOX];
            break;
        }
        case 4: // 알림설정
        {
            pushViewController = [[NotiSettingMenuViewController alloc] init];
            break;
        }
        case 5: // 환경설정
        {   
            break;
        }
        case 6: // 고객센터
        {
            break;
        }
        case 7: // NH APPZONE
        {
            break;
        }
            
        default:
            break;
    }
    
    if(newTopViewController)
    {
        if([[((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController viewControllers] count] > 1)
        {
            [self closeMenu:nil];
            [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController popToRootViewControllerAnimated:YES];
        }
        
        CGRect frame = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame;
        ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController = newTopViewController;
        ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame = frame;
        [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController resetTopViewAnimated:NO];
    }
    else if(pushViewController)
    {
        [self closeMenu:nil];
        ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:pushViewController];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController popToRootViewControllerAnimated:NO];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController pushViewController:eVC animated:YES];
    }
    
}
@end
