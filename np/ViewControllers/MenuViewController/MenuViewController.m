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
#import "EnvMgmtViewController.h"
#import "CustomerCenterViewController.h"
#import "AppZoneViewController.h"
#import "SplashViewController.h"

#define MENU_CELL_HEIGHT    37
#define TABLE_VIEW_HEADER_HEIGHT    23

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize menuTableView;
@synthesize bottomMenuView;
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

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuTableView.frame.size.width, TABLE_VIEW_HEADER_HEIGHT)];
    [menuTableView setTableHeaderView:headerView];
	// 빈 리스트 안보이게 하기 위해 height 0인 뷰를 붙여준다.
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuTableView.frame.size.width, 0)];
    [menuTableView setTableFooterView:footerView];
    
    MenuTableEtcView *bottomMenu = [MenuTableEtcView view];
    [bottomMenu setFrame:CGRectMake(0, 0, menuTableView.frame.size.width, bottomMenu.frame.size.height)];
    [bottomMenuView addSubview:bottomMenu];
    
    if([[[LoginUtil alloc] init] isLoggedIn])
    {
        [loginTextLabel setText:[NSString stringWithFormat:@"%@님 환영합니다.", [[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_USER_NAME]]];
        [loginButtonTextLabel setText:@"로그아웃"];
        [loginImg setHighlighted:YES];
    }
    else
    {
        [loginTextLabel setText:[NSString stringWithFormat:@"로그인해주세요."]];
        [loginButtonTextLabel setText:@"로그인"];
        [loginImg setHighlighted:NO];
    }
    
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

- (IBAction)loginButtonClick:(id)sender
{
    if([[[LoginUtil alloc] init] isLoggedIn])
    {
        // 로그 아웃 시킨다
        [[[LoginUtil alloc] init] setLogInStatus:NO];
        // Login
        SplashViewController *vc = [[SplashViewController alloc] init];
        [self.navigationController setViewControllers:@[vc] animated:NO];
//        [[[LoginUtil alloc] init] showLoginPage:self.navigationController];
    }
    else
    {
        // Login
        [[[LoginUtil alloc] init] showLoginPage:self.navigationController];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(cellHeight > MENU_CELL_HEIGHT)
    {
        [menuTableView setScrollEnabled:NO];
    }
    else
    {
        [menuTableView setScrollEnabled:YES];
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
    
    [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, cellHeight)];
    
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
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
//    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
//    return MENU_CELL_HEIGHT * (self.view.bounds.size.height / IPHONE_FIVE_FRAME_HEIGHT);
    cellHeight = ((menuTableView.frame.size.height - TABLE_VIEW_HEADER_HEIGHT) / [mMenuTitleArray count]);
    if(cellHeight < MENU_CELL_HEIGHT)
    {
        cellHeight = MENU_CELL_HEIGHT;
    }
    return cellHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIViewController *newTopViewController = nil;
    UIViewController *pushViewController = nil;
    
    if([[[LoginUtil alloc] init] isLoggedIn])
    {
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
                newTopViewController = [[MainPageViewController alloc] init];
                [(MainPageViewController *)newTopViewController setStartPageIndex:BANKING];
                // 임시 공인인증서 뷰 컨트롤러 적용
                //            pushViewController = [[CertificateMenuViewController alloc] init];
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
                pushViewController = [[EnvMgmtViewController alloc] initWithNibName:@"EnvMgmtViewController" bundle:nil];
                break;
            }
            case 6: // 고객센터
            {
                pushViewController = [[CustomerCenterViewController alloc] initWithNibName:@"CustomerCenterViewController" bundle:nil];
                break;
            }
            case 7: // NH APPZONE
            {
                pushViewController = [[AppZoneViewController alloc] initWithNibName:@"AppZoneViewController" bundle:nil];
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
    else
    {
        // Login
        [[[LoginUtil alloc] init] showLoginPage:self.navigationController];
    }
    
}
@end
