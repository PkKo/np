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

@synthesize mViewType;

@synthesize mTimeLineButton;
@synthesize mTimeLineView;

@synthesize mIncomeButton;
@synthesize mEtcButton;

@synthesize mMainContentView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:YES];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)tabButtonClick:(id)sender
{
    if(mViewType == [sender tag])
    {
        return;
    }
    
    switch ([sender tag])
    {
        case TIMELINE:
        {
            break;
        }
            
        case BANKING:
        {
            break;
        }
            
        case OTHER:
        {
            break;
        }
            
        default:
            break;
    }
}
@end
