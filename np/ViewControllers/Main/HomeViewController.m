//
//  HomeViewController.m
//  메인화면
//
//  Created by Infobank1 on 2015. 9. 9..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize viewType;

@synthesize mTimeLineView;
@synthesize bankingView;

@synthesize mMainContentView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [IBInbox loadWithListener:self];
//    [IBInbox requestInboxList];
    
    /*
    mTimeLineView = [HomeTimeLineView view];
    [mTimeLineView setDelegate:self];
    [mTimeLineView setFrame:CGRectMake(0, 0, mMainContentView.frame.size.width, mMainContentView.frame.size.height)];
    NSMutableArray *section = [[NSMutableArray alloc] init];
    NSMutableDictionary *timeLine = [[NSMutableDictionary alloc] init];
    [section addObject:@"09/15"];
    [section addObject:@"09/16"];
    [timeLine setObject:@[@"입금:100000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000"] forKey:@"09/15"];
    [timeLine setObject:@[@"입금:10000", @"입금:10000",@"입금:10000",@"입금:10000",@"입금:10000",@"입금:10000",@"출금:23000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000"] forKey:@"09/16"];
    [mTimeLineView initData:section timeLineDic:timeLine];
    [mMainContentView addSubview:mTimeLineView];
    
    [indexView setText:[NSString stringWithFormat:@"%d", viewType]];*/
    
    switch (viewType)
    {
        case TIMELINE:
        {
            mTimeLineView = [HomeTimeLineView view];
            [mTimeLineView setDelegate:self];
            [mTimeLineView setFrame:CGRectMake(0, 0, mMainContentView.frame.size.width, mMainContentView.frame.size.height)];
            NSMutableArray *section = [[NSMutableArray alloc] init];
            NSMutableDictionary *timeLine = [[NSMutableDictionary alloc] init];
            [section addObject:@"09/15"];
            [section addObject:@"09/16"];
            [timeLine setObject:@[@"입금:100000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000"] forKey:@"09/15"];
            [timeLine setObject:@[@"입금:10000", @"입금:10000",@"입금:10000",@"입금:10000",@"입금:10000",@"입금:10000",@"출금:23000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000"] forKey:@"09/16"];
            [mTimeLineView initData:section timeLineDic:timeLine];
            [mMainContentView addSubview:mTimeLineView];
            
            break;
        }
        case BANKING:
        {
            bankingView = [HomeBankingView view];
            [bankingView setDelegate:self];
            [bankingView setFrame:CGRectMake(0, 0, mMainContentView.frame.size.width, mMainContentView.frame.size.height)];
            NSMutableArray *section = [[NSMutableArray alloc] init];
            NSMutableDictionary *timeLine = [[NSMutableDictionary alloc] init];
            [section addObject:@"09/15"];
            [section addObject:@"09/16"];
            [timeLine setObject:@[@"입금:100000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000"] forKey:@"09/15"];
            [timeLine setObject:@[@"입금:10000", @"입금:10000",@"입금:10000",@"입금:10000",@"입금:10000",@"입금:10000",@"출금:23000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000"] forKey:@"09/16"];
            [bankingView initData:section timeLineDic:timeLine];
            // 수입/지출 통계 뷰컨트롤러 액션 붙여줌
            [bankingView.statisticButton addTarget:self action:@selector(moveStatisticViewController:) forControlEvents:UIControlEventTouchUpInside];
            [mMainContentView addSubview:bankingView];
            
            break;
        }
        case OTHER:
        {
            mTimeLineView = [HomeTimeLineView view];
            [mTimeLineView setDelegate:self];
            [mTimeLineView setFrame:CGRectMake(0, 0, mMainContentView.frame.size.width, mMainContentView.frame.size.height)];
            NSMutableArray *section = [[NSMutableArray alloc] init];
            NSMutableDictionary *timeLine = [[NSMutableDictionary alloc] init];
            [section addObject:@"09/15"];
            [section addObject:@"09/16"];
            [timeLine setObject:@[@"입금:100000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000"] forKey:@"09/15"];
            [timeLine setObject:@[@"입금:10000", @"입금:10000",@"입금:10000",@"입금:10000",@"입금:10000",@"입금:10000",@"출금:23000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000", @"출금:50000"] forKey:@"09/16"];
            [mTimeLineView initData:section timeLineDic:timeLine];
            [mMainContentView addSubview:mTimeLineView];

            break;
        }
        case INBOX:
        {
            // 보관함 구현
            UIStoryboard        * archivedItemsStoryBoard       = [UIStoryboard storyboardWithName:@"ArchivedTransactionItems" bundle:nil];
            UIViewController    * archivedItemsViewController   = [archivedItemsStoryBoard instantiateViewControllerWithIdentifier:@"archivedTransactionItems"];
            
            archivedItemsViewController.view.frame  = mMainContentView.bounds;
            archivedItemsViewController.view.autoresizingMask  = mMainContentView.autoresizingMask;
            
            [self addChildViewController:archivedItemsViewController];
            [mMainContentView addSubview:archivedItemsViewController.view];
            [archivedItemsViewController didMoveToParentViewController:self];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 @brief 데이터 갱신
 */
- (void)refreshData:(BOOL)newData
{
    if(newData)
    {
        // 최신 데이터를 가져온다.
    }
    else
    {
        // 현재 이전 데이터를 가져온다.
    }
}

/**
 @brief 수입/지출 통계뷰 컨트롤러로 이동
 */
- (void)moveStatisticViewController:(id)sender
{
    UIStoryboard * statisticStoryBoard = [UIStoryboard storyboardWithName:@"StatisticMainStoryboard" bundle:nil];
    UIViewController *vc = [statisticStoryBoard instantiateViewControllerWithIdentifier:@"statisticMain"];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
    [self.navigationController pushViewController:eVC animated:YES];
}

#pragma mark - IBInbox Protocol
- (void)loadedInboxList:(BOOL)success messageList:(NSArray *)messageList
{
    NSLog(@"%s, %@", __FUNCTION__, messageList);
    [IBInbox requestInboxCategoryInfo];
}

- (void)inboxLoadFailed:(int)responseCode
{
    NSLog(@"%s, %d", __FUNCTION__, responseCode);
    [IBInbox requestInboxCategoryInfo];
}

- (void)loadedInboxCategoryList:(NSArray *)categoryList
{
    NSLog(@"%s, %@", __FUNCTION__, categoryList);
}
@end
