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
@synthesize timeLineSelectImg;
@synthesize incomeButton;
@synthesize incomeSelectImg;
@synthesize etcButton;
@synthesize etcSelectImg;
@synthesize inboxButton;
@synthesize inboxSelectImg;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
	pageViewControllerArray = [[NSMutableArray alloc] init];
	for(int i = 0; i <= PAGE_VIEWCONTROLLER_MAX; i ++) {
		[pageViewControllerArray addObject: [NSNull null]];
	}

    startPageIndex = [self getStartPageIndex];
	HomeViewController *homeVc = [self viewControllerAtIndex:startPageIndex];
    // pageViewControllerArray = [NSArray arrayWithObject:homeVc];
	// pageViewControllerArray[startPageIndex] = homeVc;
	
    pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [pageViewController setDelegate:self];
    [pageViewController setDataSource:self];
    [pageViewController.view setFrame:CGRectMake(0, 128, self.view.frame.size.width,
                                                 self.view.frame.size.height - (tabButtonView.frame.origin.y + tabButtonView.frame.size.height))];
    /*
    [pageViewController.view setFrame:CGRectMake(0, tabButtonView.frame.origin.y + tabButtonView.frame.size.height,
                                                 self.view.frame.size.width, self.view.frame.size.height - (tabButtonView.frame.origin.y + tabButtonView.frame.size.height))];*/
//    [pageViewController setViewControllers:pageViewControllerArray direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self tabSelect:startPageIndex];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
    
    [self tabButtonChange:startPageIndex];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPageViewDataSource
- (HomeViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (index < 0 || PAGE_VIEWCONTROLLER_MAX < index) {
		return nil;
	}
	
	if ((id)[NSNull null] == pageViewControllerArray[index]) {
		HomeViewController *vc = [[HomeViewController alloc] init];
		[vc setViewType:(HomeViewType)index];
		pageViewControllerArray[index] = vc;
	}	 
	 
	return pageViewControllerArray[index];
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
        case TIMELINE:
        {
            [timeLineButton setEnabled:NO];
            [incomeButton setEnabled:YES];
            [etcButton setEnabled:YES];
            [inboxButton setEnabled:YES];
            break;
        }
        case BANKING:
        {
            [timeLineButton setEnabled:YES];
            [incomeButton setEnabled:NO];
            [etcButton setEnabled:YES];
            [inboxButton setEnabled:YES];
            break;
        }
        case OTHER:
        {
            [timeLineButton setEnabled:YES];
            [incomeButton setEnabled:YES];
            [etcButton setEnabled:NO];
            [inboxButton setEnabled:YES];
            break;
        }
        case INBOX:
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
    
    [timeLineSelectImg setHidden:[timeLineButton isEnabled]];
    [incomeSelectImg setHidden:[incomeButton isEnabled]];
    [etcSelectImg setHidden:[etcButton isEnabled]];
    [inboxSelectImg setHidden:[inboxButton isEnabled]];

}

#pragma mark - etc

- (HomeViewType) getStartPageIndex {
    NSNumber* num = [[NSUserDefaults standardUserDefaults] valueForKey:kStartPageIndex];
	if(num) {
		return num.integerValue;
	}
	else {
		return TIMELINE;
	}
}

@end
