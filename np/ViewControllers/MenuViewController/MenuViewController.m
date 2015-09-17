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
#import "SNSViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mMenuTitleArray = [[NSArray alloc] initWithObjects:@[@"타임라인", @"HomeViewController"], @[@"공인인증서 관리", @"CertificateMenuViewController"], @[@"입출금", @"StatisticMainViewController"], @[@"공유하기", @"SMSViewController"], nil];
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
        case 3:
        {
            newTopViewController = [[SNSViewController alloc] initWithNibName:@"SNSViewController" bundle:nil];
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
