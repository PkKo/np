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
    
    AccountInboxRequestData *reqData = [[AccountInboxRequestData alloc] init];
    reqData.size = 20;
    /*
     필수 설정값
     */
    // 정렬 순서
//    reqData.ascending;
    // 알림받는 계좌번호 리스트
//    reqData.accountNumberList;
    // 입출금 구분
//    reqData.queryType;
    [IBInbox reqQueryAccountInboxListWithSize:reqData];
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

- (void)stickerButtonClick:(id)sender
{
    currentStickerIndexPath = ((IndexPathButton *)sender).indexPath;
    
    switch ([sender tag])
    {
        case STICKER_DEPOSIT_NORMAL:
        case STICKER_DEPOSIT_SALARY:
        case STICKER_DEPOSIT_POCKET:
        case STICKER_DEPOSIT_ETC:
        {
            // 입금 스티커
            if(depositStickerView == nil)
            {
                depositStickerView = [DepositStickerView view];
                [depositStickerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame.size.height)];
                [depositStickerView setDelegate:self];
            }
            [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view addSubview:depositStickerView];
            break;
        }
        case STICKER_WITHDRAW_NORMAL:
        case STICKER_WITHDRAW_FOOD:
        case STICKER_WITHDRAW_TELEPHONE:
        case STICKER_WITHDRAW_HOUSING:
        case STICKER_WITHDRAW_SHOPPING:
        case STICKER_WITHDRAW_CULTURE:
        case STICKER_WITHDRAW_EDUCATION:
        case STICKER_WITHDRAW_CREDIT:
        case STICKER_WITHDRAW_SAVING:
        case STICKER_WITHDRAW_ETC:
        {
            // 출금 스티커
            if(withdrawStickerView == nil)
            {
                withdrawStickerView = [WithdrawStickerSettingView view];
                [withdrawStickerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame.size.height)];
                [withdrawStickerView setDelegate:self];
            }
            [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view addSubview:withdrawStickerView];
            break;
        }
            
        default:
            break;
    }
}

- (void)selectedStickerIndex:(NSNumber *)index
{
    NSInteger stickerIndex = index.integerValue;
    NSLog(@"%s, %ld", __FUNCTION__, (long)stickerIndex);
    /*
    if(currentStickerIndexPath != nil)
    {
        // 스티커 정보 세팅
        currentStickerIndexPath = nil;
        
        // 인박스에 스티커 정보를 저장한다.
        [IBInbox reqAddStickerInfoWithMsgKey:@"serverMessageKey" stickerCode:(int)stickerIndex];
    }*/
}

#pragma mark - IBInbox Protocol
- (void)loadedInboxList:(BOOL)success messageList:(NSArray *)messageList
{
    NSLog(@"%s, %@", __FUNCTION__, messageList);
    for(InboxMessageData *data in messageList)
    {
        NSLog(@"inbox message data = %@", data);
    }
    [IBInbox requestInboxCategoryInfo];
}

- (void)loadedAccountQueryInboxList:(BOOL)success messageList:(NSArray *)messageList
{
    NSLog(@"%s, %@", __FUNCTION__, messageList);
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
