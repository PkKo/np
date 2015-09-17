//
//  MenuViewController.m
//  메뉴 화면
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableCell.h"
#import "HomeViewController.h"
#import "CertificateMenuViewController.h"
#import "StatisticMainViewController.h"
#import "StatisticMainUtil.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize menuTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mMenuTitleArray = [[NSArray alloc] initWithObjects:@[@"타임라인", @"HomeViewController"], @[@"공인인증서 관리", @"CertificateMenuViewController"], @[@"입출금", @"StatisticMainViewController"], nil];
    
    // 빈 리스트 안보이게 하기 위해 height 0인 뷰를 붙여준다.
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [menuTableView setTableFooterView:footerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeMenu:(id)sender
{
    [self.slidingViewController.topViewController performSelector:@selector(closeMenuView) withObject:nil];
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
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mMenuTitleArray count];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIViewController *newTopViewController = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            newTopViewController = [[HomeViewController alloc] init];
            break;
        }
        case 1:
        {
            newTopViewController = [[CertificateMenuViewController alloc] init];
            break;
        }
        case 2:
        {
            
            UIStoryboard * statisticStoryBoard = [UIStoryboard storyboardWithName:@"StatisticMainStoryboard" bundle:nil];
            newTopViewController = [statisticStoryBoard instantiateViewControllerWithIdentifier:@"statisticMain"];
            
            break;
        }
            
        default:
            break;
    }
    
    if(newTopViewController)
    {
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopViewAnimated:NO];
    }
    
}
@end
