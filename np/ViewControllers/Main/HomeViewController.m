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
@synthesize mMainContentView;

@synthesize indexView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
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
            
            [indexView setText:[NSString stringWithFormat:@"%d", viewType]];
            break;
        }
        case BANKING:
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
            
            [indexView setText:[NSString stringWithFormat:@"%d", viewType]];
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
            
            [indexView setText:[NSString stringWithFormat:@"%d", viewType]];
            break;
        }
        case INBOX:
        {
            // 보관함 구현
            UIStoryboard        * archivedItemsStoryBoard       = [UIStoryboard storyboardWithName:@"ArchivedTransactionItems" bundle:nil];
            UIViewController    * archivedItemsViewController   = [archivedItemsStoryBoard instantiateViewControllerWithIdentifier:@"archivedTransactionItems"];
            
            archivedItemsViewController.view.frame             = mMainContentView.bounds;
            archivedItemsViewController.view.autoresizingMask  = mMainContentView.autoresizingMask;
            
            [self addChildViewController:archivedItemsViewController];
            [mMainContentView addSubview:archivedItemsViewController.view];
            [archivedItemsViewController didMoveToParentViewController:self];
            
            [indexView setText:[NSString stringWithFormat:@"%d", viewType]];
            
            break;
        }
            
        default:
            break;
    }
    
    if(viewType == INBOX)
    {
        // 보관함 뷰 생성
        
        // mMainContentView addSubview
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
