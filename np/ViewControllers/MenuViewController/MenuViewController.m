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
#import "NotiSettingMenuViewController.h"
#import "EnvMgmtViewController.h"
#import "CustomerCenterViewController.h"
#import "AppZoneViewController.h"
#import "SplashViewController.h"
#import "CertificateMenuViewController.h"
#import "AccountManageViewController.h"
#import "ExchangeSettingViewController.h"
#import "SimplePwMgntChangeViewController.h"
#import "DrawPatternMgmtViewController.h"
#import "LoginSettingsViewController.h"
#import "NoticeBackgroundSettingsViewController.h"

#define MENU_CELL_HEIGHT    37
#define MENU_ICON_HEIGHT    27
#define TABLE_VIEW_HEADER_HEIGHT    15
#define TABLE_VIEW_FOOTER_HEIGHT    80

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
                       @[@"알림 받기 설정"],          //5
                       @[@"계좌 추가/변경/삭제"], //6
                       @[@"환율알림 설정"],           //7
  @[@"환경 설정", @"icon_settings_01_dft.png", @"icon_settings_01_on.png"],
                       @[@"간편보기 사용"],           //9
                       @[@"간편비밀번호 관리"],        //10
                       @[@"패턴 관리"],              //11
                       @[@"로그인 설정"],             //12
                       @[@"알림배경 설정"],           //13
                       @[@"데이터 초기화"],           //14
  @[@"고객센터", @"icon_customer_01_dft.png", @"icon_customer_01_on.png"],
  @[@"공인인증센터", @"icon_certificate_01_dft.png", @"icon_certificate_01_on.png"],
  @[@"NH 앱존", @"icon_app_zone_01_dft.png", @"icon_app_zone_01_on.png"], nil];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuTableView.frame.size.width, TABLE_VIEW_HEADER_HEIGHT)];
    [menuTableView setTableHeaderView:headerView];
    ///*
	// 빈 리스트 안보이게 하기 위해 height 0인 뷰를 붙여준다.
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuTableView.frame.size.width, 0)];
    [menuTableView setTableFooterView:footerView];
    
    bottomMenu = [MenuTableEtcView view];
    [bottomMenu setFrame:CGRectMake(0, 0, bottomMenuView.frame.size.width, bottomMenu.frame.size.height)];
    [bottomMenuView addSubview:bottomMenu];//*/
    /*
    bottomMenu = [MenuTableEtcView view];
    [[bottomMenu nongminButton] setDelegateLabel:[bottomMenu nongminLabel]];
    [[bottomMenu telButton] setDelegateLabel:[bottomMenu telLabel]];
    [[bottomMenu faqButton] setDelegateLabel:[bottomMenu faqLabel]];
    [[bottomMenu noticeButton] setDelegateLabel:[bottomMenu noticeLabel]];
    [bottomMenu setFrame:CGRectMake(0, 0, menuTableView.frame.size.width, TABLE_VIEW_FOOTER_HEIGHT)];
    [menuTableView setTableFooterView:bottomMenu];
    [menuTableView bringSubviewToFront:bottomMenu];*/
    
    if([[[LoginUtil alloc] init] isLoggedIn])
    {
        [loginTextLabel setText:[NSString stringWithFormat:@"%@님 환영합니다.", [CommonUtil decrypt3DES:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_USER_NAME] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey]]];
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"로그아웃 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        [alertView setTag:30000];
        [alertView show];
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
    
    /*
    if(cellHeight > MENU_CELL_HEIGHT)
    {
        [menuTableView setScrollEnabled:NO];
    }
    else
    {
        [menuTableView setScrollEnabled:YES];
        [menuTableView setContentSize:CGSizeMake(menuTableView.frame.size.width, TABLE_VIEW_HEADER_HEIGHT + (cellHeight * [mMenuTitleArray count]) + TABLE_VIEW_FOOTER_HEIGHT)];
        [menuTableView bringSubviewToFront:menuTableView.tableFooterView];
    }*/
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
    
    [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, cellHeight)];
    
    NSString *title = [[mMenuTitleArray objectAtIndex:indexPath.row] objectAtIndex:0];
    
    if((indexPath.row >= NOTI_ONOFF_SETTING && indexPath.row <= NOTI_EXCHANGE_SETTING) ||
       (indexPath.row >= SETTINGS_QUICKVIEW_ONOFF && indexPath.row <= SETTINGS_DELETE_DATA))
    {
//        [cell.mMenuTitleLabel setText:[NSString stringWithFormat:@"- %@", title]];
        [cell.mMenuTitleLabel setHidden:YES];
        [cell.menuSubTitleLabel setText:[NSString stringWithFormat:@"-  %@", title]];
        [cell.menuTitleImg setHidden:YES];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:245.0/255.0f green:246.0/255.0f blue:249.0/255.0f alpha:1.0f]];
        [cell.menuSeparateLine setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [cell.mMenuTitleLabel setText:title];
        [cell.menuSubTitleLabel setHidden:YES];
        CGFloat iconHeight = (cellHeight * MENU_ICON_HEIGHT) / MENU_CELL_HEIGHT;
        [cell.menuTitleImg setImage:[UIImage imageNamed:[[mMenuTitleArray objectAtIndex:indexPath.row] objectAtIndex:1]]];
        [cell.menuTitleImg setHighlightedImage:[UIImage imageNamed:[[mMenuTitleArray objectAtIndex:indexPath.row] objectAtIndex:2]]];
        if(iconHeight > MENU_ICON_HEIGHT)
        {
            [cell.menuTitleImg setFrame:CGRectMake(cell.menuTitleImg.frame.origin.x,
                                                   cell.menuTitleImg.frame.origin.y,
                                                   iconHeight, iconHeight)];
        }
    }
    
    if (indexPath.row == [mMenuTitleArray count] - 1)
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
//    cellHeight = ((menuTableView.frame.size.height - TABLE_VIEW_HEADER_HEIGHT - TABLE_VIEW_FOOTER_HEIGHT) / [mMenuTitleArray count]);
//    if(cellHeight < MENU_CELL_HEIGHT)
//    {
//        cellHeight = MENU_CELL_HEIGHT;
//    }
    
    cellHeight = MENU_CELL_HEIGHT;
    
    return cellHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.mMenuTitleLabel setTextColor:[UIColor colorWithRed:0.0/255.0f green:101.0/255.0f blue:179.0/255.0f alpha:1.0f]];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.mMenuTitleLabel setTextColor:[UIColor colorWithRed:96.0/255.0f green:97.0/255.0f blue:102.0/255.0f alpha:1.0f]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIViewController *newTopViewController = nil;
    UIViewController *pushViewController = nil;
    
    if([[[LoginUtil alloc] init] isLoggedIn])
    {
        switch (indexPath.row)
        {
            case ALL_TIMELINE: // 전체
            {
                newTopViewController = [[MainPageViewController alloc] init];
                [(MainPageViewController *)newTopViewController setStartPageIndex:TIMELINE];
                break;
            }
            case DEPOSIT_TIMELINE: // 입출금
            {
                newTopViewController = [[MainPageViewController alloc] init];
                [(MainPageViewController *)newTopViewController setStartPageIndex:BANKING];
                // 임시 공인인증서 뷰 컨트롤러 적용
                //            pushViewController = [[CertificateMenuViewController alloc] init];
                break;
            }
            case ETC_TIMELINE: // 기타
            {
                newTopViewController = [[MainPageViewController alloc] init];
                [(MainPageViewController *)newTopViewController setStartPageIndex:OTHER];
                break;
            }
            case STORAGE: // 보관함
            {
                newTopViewController = [[MainPageViewController alloc] init];
                [(MainPageViewController *)newTopViewController setStartPageIndex:INBOX];
                break;
            }
            case NOTI_SETTING: // 알림설정
            {
                pushViewController = [[NotiSettingMenuViewController alloc] init];
                break;
            }
            //////////////////////////////////////////////////////////////////////////////
            case NOTI_ONOFF_SETTING: // 알림 받기 설정 - 서브메뉴
            {
                pushViewController = [[NotiSettingMenuViewController alloc] init];
                break;
            }
            case NOTI_ACCOUNT_SETTING: // 입출금 계좌 추가/변경/삭제 - 서브메뉴
            {
                pushViewController = [[AccountManageViewController alloc] init];
                break;
            }
            case NOTI_EXCHANGE_SETTING: // 환율 알림 설정
            {
                pushViewController = [[ExchangeSettingViewController alloc] init];
                break;
            }
            ///////////////////////////////////////////////////////////////////////////////
            case SETTINGS: // 환경설정
            {
                pushViewController = [[EnvMgmtViewController alloc] initWithNibName:@"EnvMgmtViewController" bundle:nil];
                break;
            }
            ///////////////////////////////////////////////////////////////////////////////
            case SETTINGS_QUICKVIEW_ONOFF:  // 간편보기 사용 - 서브메뉴
            {
                pushViewController = [[EnvMgmtViewController alloc] initWithNibName:@"EnvMgmtViewController" bundle:nil];
                break;
            }
            case SETTINGS_PIN: // 간편비밀번호 관리 - 서브메뉴
            {
                pushViewController = [[SimplePwMgntChangeViewController alloc] initWithNibName:@"SimplePwMgntChangeViewController" bundle:nil];
                break;
            }
            case SETTINGS_PATTERN: // 패턴관리 - 서브메뉴
            {
                pushViewController = [[DrawPatternMgmtViewController alloc] initWithNibName:@"DrawPatternMgmtViewController" bundle:nil];
                break;
            }
            case SETTINGS_LOGIN: // 로그인 설정 - 서브메뉴
            {
                pushViewController = [[LoginSettingsViewController alloc] initWithNibName:@"LoginSettingsViewController" bundle:nil];
                break;
            }
            case SETTINGS_BG: // 알림배경 설정 - 서브메뉴
            {
                pushViewController = [[NoticeBackgroundSettingsViewController alloc] initWithNibName:@"NoticeBackgroundSettingsViewController" bundle:nil];
                break;
            }
            case SETTINGS_DELETE_DATA: // 데이터 초기화 - 서브메뉴
            {
                pushViewController = [[EnvMgmtViewController alloc] initWithNibName:@"EnvMgmtViewController" bundle:nil];
                break;
            }
            ///////////////////////////////////////////////////////////////////////////////
            case CUSTOMER_CENTER: // 고객센터
            {
                pushViewController = [[CustomerCenterViewController alloc] initWithNibName:@"CustomerCenterViewController" bundle:nil];
                break;
            }
            case CERTIFICATE_CENTER: // 공인인증센터
            {
                pushViewController = [[CertificateMenuViewController alloc] initWithNibName:@"CertificateMenuViewController" bundle:nil];
                break;
            }
            case NH_APPZONE: // NH APPZONE
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
            
            if(![((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController isKindOfClass:[MainPageViewController class]])
            {
                ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
                MainPageViewController *vc = [[MainPageViewController alloc] init];
                [vc setStartPageIndex:0];
                slidingViewController.topViewController = vc;
                
                [self.navigationController setViewControllers:@[slidingViewController] animated:NO];
                ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;
            }
            
            ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:pushViewController];
            [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController popToRootViewControllerAnimated:NO];
            [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController pushViewController:eVC animated:YES];
        }
    }
    else
    {
        [self closeMenu:nil];
        
        switch (indexPath.row)
        {
            case CERTIFICATE_CENTER: // 공인인증센터
            {
                pushViewController = [[CertificateMenuViewController alloc] initWithNibName:@"CertificateMenuViewController" bundle:nil];
                [self closeMenu:nil];
                ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:pushViewController];
                [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController popToRootViewControllerAnimated:NO];
                [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController pushViewController:eVC animated:YES];
                break;
            }
            case NH_APPZONE: // NH APPZONE
            {
                pushViewController = [[AppZoneViewController alloc] initWithNibName:@"AppZoneViewController" bundle:nil];
                [self closeMenu:nil];
                ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:pushViewController];
                [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController popToRootViewControllerAnimated:NO];
                [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController pushViewController:eVC animated:YES];
                break;
            }
            default:
            {
                // Login
                [[[LoginUtil alloc] init] showLoginPage:self.navigationController];
                break;
            }
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == 30000 && buttonIndex == BUTTON_INDEX_OK)
    {
        // 로그 아웃 시킨다
        [[[LoginUtil alloc] init] setLogInStatus:NO];
        // Login
        [[[LoginUtil alloc] init] showLoginPage:self.navigationController];
    }
}
@end
