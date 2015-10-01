//
//  MainPageViewController.m
//  np
//
//  Created by Infobank1 on 2015. 9. 24..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "MainPageViewController.h"
#import "HomeViewController.h"

#define PAGE_VIEWCONTROLLER_MAX     3

@interface MainPageViewController ()

@end

@implementation MainPageViewController

@synthesize startPageIndex;
@synthesize pageViewController;
@synthesize pageViewControllerArray;
@synthesize tabButtonView;

@synthesize timeLineButton;
@synthesize incomeButton;
@synthesize etcButton;
@synthesize inboxButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:YES];
    
    HomeViewController *homeVc = [self viewControllerAtIndex:startPageIndex];
    pageViewControllerArray = [NSArray arrayWithObject:homeVc];
    
    pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [pageViewController setDelegate:self];
    [pageViewController setDataSource:self];
    [pageViewController.view setFrame:CGRectMake(0, tabButtonView.frame.origin.y + tabButtonView.frame.size.height,
                                                 self.view.frame.size.width, self.view.frame.size.height)];
//    [pageViewController setViewControllers:pageViewControllerArray direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self tabSelect:startPageIndex];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
    
    [self tabButtonChange:startPageIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewDataSource
- (HomeViewController *)viewControllerAtIndex:(NSInteger)index
{
    HomeViewController *vc = [[HomeViewController alloc] init];
    [vc setViewType:(HomeViewType)index];
    
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((HomeViewController *)viewController).viewType;
    
    if(index == 0)
    {
        index = PAGE_VIEWCONTROLLER_MAX;
    }
    else
    {
        index--;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = ((HomeViewController *)viewController).viewType;
    
    if(index == PAGE_VIEWCONTROLLER_MAX)
    {
        index = 0;
    }
    else
    {
        index++;
    }
    
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)currentPageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(finished)
    {
        startPageIndex = ((HomeViewController *)[currentPageViewController.viewControllers objectAtIndex:0]).viewType;
        [self tabButtonChange:startPageIndex];
    }
}

#pragma mark - TabButtonAction
- (void)tabSelect:(NSInteger)index
{
    HomeViewController *homeVc = [self viewControllerAtIndex:index];
    
    if(startPageIndex <= index)
    {
        [pageViewController setViewControllers:@[homeVc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    else
    {
        [pageViewController setViewControllers:@[homeVc] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    
    startPageIndex = index;
    [self tabButtonChange:startPageIndex];
}

- (IBAction)tabButtonClick:(id)sender
{
    [self tabSelect:[sender tag]];
}

- (void)tabButtonChange:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            [timeLineButton setEnabled:NO];
            [incomeButton setEnabled:YES];
            [etcButton setEnabled:YES];
            [inboxButton setEnabled:YES];
            break;
        }
        case 1:
        {
            [timeLineButton setEnabled:YES];
            [incomeButton setEnabled:NO];
            [etcButton setEnabled:YES];
            [inboxButton setEnabled:YES];
            break;
        }
        case 2:
        {
            [timeLineButton setEnabled:YES];
            [incomeButton setEnabled:YES];
            [etcButton setEnabled:NO];
            [inboxButton setEnabled:YES];
            break;
        }
        case 3:
        {
            [timeLineButton setEnabled:YES];
            [incomeButton setEnabled:YES];
            [etcButton setEnabled:YES];
            [inboxButton setEnabled:NO];
            break;
        }
        default:
            break;
    }
}
@end
