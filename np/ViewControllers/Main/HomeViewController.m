//
//  HomeViewController.m
//  메인화면
//
//  Created by Infobank1 on 2015. 9. 9..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "HomeViewController.h"
#import "MainPageViewController.h"
#import "LoginUtil.h"
#import "ArchivedTransactionItemsViewController.h"
#import "StatisticMainUtil.h"
#import "ServiceFunctionInfoView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize viewType;

@synthesize mTimeLineView;
@synthesize bankingView;
@synthesize etcTimeLineView;

@synthesize mMainContentView;

@synthesize scrollMoveTopButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sectionList = [NSMutableArray array];
    timelineMessageList = [NSMutableDictionary dictionary];
    unreadMessageList = [NSMutableArray array];
    isSearch = NO;
    isMoreList = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IBInbox loadWithListener:self];
    
    LoginUtil *loginUtil = [[LoginUtil alloc] init];
    [mMainContentView setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
//    [self makeTimelineView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([[[LoginUtil alloc] init] getAllAccounts] != nil && [[[[LoginUtil alloc] init] getAllAccounts] count] > 0)
    {
        [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) startIndicator];
        
        /*
         필수 설정값
         */
        // 정렬 순서
        //    reqData.ascending;
        // 알림받는 계좌번호 리스트
        //    reqData.accountNumberList;
        // 입출금 구분
        //    reqData.queryType;
        AccountInboxRequestData *reqData = [[AccountInboxRequestData alloc] init];
        reqData.accountNumberList = [[[LoginUtil alloc] init] getAllAccounts];
        reqData.ascending = YES;
        reqData.size = TIMELINE_LOAD_COUNT;
        
        switch (viewType)
        {
            case TIMELINE:
            {
                reqData.queryType = @"ALL";
                break;
            }
            case BANKING:
            {
                reqData.queryType = @"1,2";
                break;
            }
            case OTHER:
            {
                reqData.queryType = @"ETC";
                break;
            }
            default:
            {
                reqData = nil;
                break;
            }
        }
        
        if(reqData != nil)
        {
            [IBInbox reqQueryAccountInboxListWithSize:reqData];
        }
        else
        {
            [self makeTimelineView];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if(viewType == TIMELINE)
    {
        [mTimeLineView bannerTimerStop];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)makeTimelineView
{
    switch (viewType)
    {
        case TIMELINE:
        {
            if(mTimeLineView == nil)
            {
                mTimeLineView = [HomeTimeLineView view];
                [mTimeLineView setDelegate:self];
                [mTimeLineView setFrame:CGRectMake(0, 0, mMainContentView.frame.size.width, mMainContentView.frame.size.height)];
                [mTimeLineView initData:sectionList timeLineDic:timelineMessageList];
                [mMainContentView addSubview:mTimeLineView];
            }
            else
            {
                mTimeLineView.mTimeLineSection = sectionList;
                mTimeLineView.mTimeLineDic = timelineMessageList;
                [mTimeLineView setIsSearchResult:isSearch];
                isSearch = NO;
                [mTimeLineView setIsMoreList:isMoreList];
                isMoreList = YES;
                [mTimeLineView refreshData];
                [mTimeLineView.mTimeLineTable reloadData];
            }
            
            break;
        }
        case BANKING:
        {
            if(bankingView == nil)
            {
                bankingView = [HomeBankingView view];
                [bankingView setDelegate:self];
                [bankingView setFrame:CGRectMake(0, 0, mMainContentView.frame.size.width, mMainContentView.frame.size.height)];
                [bankingView initData:sectionList timeLineDic:timelineMessageList];
                // 수입/지출 통계 뷰컨트롤러 액션 붙여줌
                [bankingView.statisticButton addTarget:self action:@selector(moveStatisticViewController:) forControlEvents:UIControlEventTouchUpInside];
                [mMainContentView addSubview:bankingView];
            }
            else
            {
                bankingView.timeLineSection = sectionList;
                bankingView.timeLineDic = timelineMessageList;
                [bankingView setIsSearchResult:isSearch];
                isSearch = NO;
                [bankingView setIsMoreList:isMoreList];
                isMoreList = YES;
                [bankingView refreshData];
                [bankingView.bankingListTable reloadData];
            }
            
            break;
        }
        case OTHER:
        {
            if(etcTimeLineView == nil)
            {
                etcTimeLineView = [HomeEtcTimeLineView view];
                [etcTimeLineView setDelegate:self];
                [etcTimeLineView setFrame:CGRectMake(0, 0, mMainContentView.frame.size.width, mMainContentView.frame.size.height)];
                [etcTimeLineView initData:sectionList timeLineDic:timelineMessageList];
                [mMainContentView addSubview:etcTimeLineView];
            }
            else
            {
                etcTimeLineView.timelineSection = sectionList;
                etcTimeLineView.timelineDic = timelineMessageList;
                [etcTimeLineView setIsSearchResult:isSearch];
                isSearch = NO;
                [etcTimeLineView setIsMoreList:isMoreList];
                isMoreList = YES;
                [etcTimeLineView refreshData];
                [etcTimeLineView.timelineTableView reloadData];
            }
            
            break;
        }
        case INBOX:
        {
            // 보관함 구현
            // check if the archivedListView has been added.
            NSArray * childViewControllers = [self childViewControllers];
            BOOL hasArchivedView = NO;
            for (UIViewController * childVC in childViewControllers) {
                if ([childVC isKindOfClass:[ArchivedTransactionItemsViewController class]]) {
                    hasArchivedView = YES;
                    break;
                }
            }
            if (!hasArchivedView) {
                UIStoryboard        * archivedItemsStoryBoard       = [UIStoryboard storyboardWithName:@"ArchivedTransactionItems" bundle:nil];
                UIViewController    * archivedItemsViewController   = [archivedItemsStoryBoard instantiateViewControllerWithIdentifier:@"archivedTransactionItems"];
                
                archivedItemsViewController.view.frame              = mMainContentView.bounds;
                archivedItemsViewController.view.autoresizingMask   = mMainContentView.autoresizingMask;
                
                [self addChildViewController:archivedItemsViewController];
                [mMainContentView addSubview:archivedItemsViewController.view];
                [archivedItemsViewController didMoveToParentViewController:self];
            }
            
            
            break;
        }
            
        default:
            break;
    }
    
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) stopIndicator];
//    [mMainContentView layoutIfNeeded];
}

/**
 @brief 데이터 갱신
 */
- (void)refreshData:(BOOL)newData
{
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) startIndicator];
    
    isRefresh = YES;
    isNewData = newData;
    AccountInboxRequestData *reqData = [[AccountInboxRequestData alloc] init];
    reqData.accountNumberList = [[[LoginUtil alloc] init] getAllAccounts];
    reqData.ascending = !newData;
    reqData.size = TIMELINE_LOAD_COUNT;
    
    switch (viewType)
    {
        case TIMELINE:
        {
            reqData.queryType = @"ALL";
            break;
        }
        case BANKING:
        {
            reqData.queryType = @"1,2";
            break;
        }
        case OTHER:
        {
            reqData.queryType = @"ETC";
            break;
        }
        default:
            break;
    }
    
    if(newData)
    {
        
        // 최신 데이터를 가져온다.
        if(((NHInboxMessageData *)[[timelineMessageList objectForKey:((TimelineSectionData *)[sectionList firstObject]).date] firstObject]).serverMessageKey != nil)
        {
            reqData.nextServerMsgKey = ((NHInboxMessageData *)[[timelineMessageList objectForKey:((TimelineSectionData *)[sectionList firstObject]).date] firstObject]).serverMessageKey;
        }
        else if([sectionList count] > 1)
        {
            reqData.nextServerMsgKey = ((NHInboxMessageData *)[[timelineMessageList objectForKey:((TimelineSectionData *)[sectionList objectAtIndex:1]).date] firstObject]).serverMessageKey;
        }
    }
    else
    {
        // 현재 이전 데이터를 가져온다.
        reqData.nextServerMsgKey = ((NHInboxMessageData *)[[timelineMessageList objectForKey:((TimelineSectionData *)[sectionList lastObject]).date] lastObject]).serverMessageKey;
    }
    
    [IBInbox reqQueryAccountInboxListWithSize:reqData];
}

- (void)searchInboxDataWithQuery:(AccountInboxRequestData *)reqData
{
    isSearch = YES;
    [IBInbox reqQueryAccountInboxListWithSize:reqData];
}

/**
 @brief 수입/지출 통계뷰 컨트롤러로 이동
 */
- (void)moveStatisticViewController:(id)sender
{
    [[StatisticMainUtil sharedInstance] showStatisticView:self.navigationController];
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
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) startIndicator];
    
    selectedStickerCode = (StickerType)index.integerValue;
//    NSLog(@"%s, %d", __FUNCTION__, (int)selectedStickerCode);
    
    if(currentStickerIndexPath != nil)
    {
        // 스티커 정보 세팅
        NHInboxMessageData *inboxData = [[timelineMessageList objectForKey:((TimelineSectionData *)[sectionList objectAtIndex:currentStickerIndexPath.section]).date] objectAtIndex:currentStickerIndexPath.row];
        
        // 인박스에 스티커 정보를 저장한다.
        [IBInbox reqAddStickerInfoWithMsgKey:inboxData.serverMessageKey stickerCode:(int)selectedStickerCode];
    }
}

- (void)deletePushItems:(NSArray *)deleteIdList
{
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) startIndicator];
    
    [IBInbox requestDeleteMessages:deleteIdList];
}

#pragma mark - IBInbox Protocol
- (void)loadedInboxList:(BOOL)success messageList:(NSArray *)messageList
{
//    NSLog(@"%s, %@", __FUNCTION__, messageList);
    if(!isRefresh)
    {
        if([sectionList count] > 0)
        {
            [sectionList removeAllObjects];
        }
        
        if(timelineMessageList)
        {
            [timelineMessageList removeAllObjects];
        }
        
        NSString *todayString = [CommonUtil getTodayDateString];
        TimelineSectionData *todaySectionData = [[TimelineSectionData alloc] init];
        todaySectionData.date = todayString;
        todaySectionData.day = [CommonUtil getDayString:[NSDate date]];
        [sectionList addObject:todaySectionData];
        
        for(InboxMessageData *data in messageList)
        {
            NSString *dateString = [CommonUtil getDateString:[NSDate dateWithTimeIntervalSince1970:(data.date/1000)]];
            
            NHInboxMessageData *inboxData = [[NHInboxMessageData alloc] init];
            
            // message key
            inboxData.serverMessageKey = data.serverMessageKey;
            inboxData.regDate = data.date;
            inboxData.title = data.title;
            inboxData.text = data.text;
            
            for(ContentsPayload *payload in data.payloadList)
            {
                if([payload.key isEqualToString:TIMELINE_EVENT_TYPE])
                {
                    inboxData.inboxType = payload.value;
                }
                
                if([payload.key isEqualToString:TIMELINE_ACCOUNT_NUMBER])
                {
                    inboxData.nhAccountNumber = payload.value;
                }
                
                if([payload.key isEqualToString:TIMELINE_TRN_AMT])
                {
                    inboxData.amount = [payload.value intValue];
                }
                
                if([payload.key isEqualToString:TIMELINE_TRN_AF_AMT])
                {
                    inboxData.balance = [payload.value intValue];
                }
                
                if([payload.key isEqualToString:TIMELINE_TXT_MSG])
                {
                    inboxData.oppositeUser = payload.value;
                }
                /*
                 if([payload.key isEqualToString:TIMELINE_ACCOUNT_GB])
                 {
                 inboxData.accountGb = payload.value;
                 }*/
            }
            
            if(inboxData.inboxType == nil)
            {
                continue;
            }
            
            if(inboxData.stickerCode <= 0)
            {
                inboxData.stickerCode = [inboxData.inboxType intValue];
            }
            
            if([dateString isEqualToString:todayString])
            {
                NSMutableArray *todayItemList = [timelineMessageList objectForKey:todayString];
                if(todayItemList == nil)
                {
                    todayItemList = [[NSMutableArray alloc] init];
                }
                [todayItemList addObject:inboxData];
                [timelineMessageList setObject:todayItemList forKey:todayString];
            }
            else
            {
                NSMutableArray *itemList = [timelineMessageList objectForKey:dateString];
                if(itemList == nil)
                {
                    itemList = [[NSMutableArray alloc] init];
                    NSString *dateDayString = [CommonUtil getDayString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                    TimelineSectionData *dateSectionData = [[TimelineSectionData alloc] init];
                    dateSectionData.date = dateString;
                    dateSectionData.day = dateDayString;
                    [sectionList addObject:dateSectionData];
                }
                [itemList addObject:inboxData];
                [timelineMessageList setObject:itemList forKey:dateString];
            }
        }
    }
    
    [self performSelector:@selector(makeTimelineView) withObject:nil];
}

- (void)loadedAccountQueryInboxList:(BOOL)success messageList:(NSArray *)messageList
{
//    NSLog(@"%s, %@", __FUNCTION__, messageList);
    
    if(success)
    {
        if([unreadMessageList count] > 0)
        {
            [unreadMessageList removeAllObjects];
        }
        
        if(!isRefresh)
        {
            if([sectionList count] > 0)
            {
                [sectionList removeAllObjects];
            }
            
            if(timelineMessageList)
            {
                [timelineMessageList removeAllObjects];
            }
            
            for(NHInboxMessageData *inboxData in messageList)
            {
                if([inboxData.inboxType isEqualToString:@"A"])
                {
                    inboxData.stickerCode = STICKER_EXCHANGE_RATE;
                }
                else if ([inboxData.inboxType isEqualToString:@"B"] || [inboxData.inboxType isEqualToString:@"Z"])
                {
                    inboxData.stickerCode = STICKER_NOTICE_NORMAL;
                }
                else if(inboxData.stickerCode < 0 || (inboxData.stickerCode > 6 && inboxData.stickerCode < 100))
                {
                    inboxData.stickerCode = STICKER_ETC;
                }
                
                NSString *dateString = [CommonUtil getDateString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                
                NSMutableArray *itemList = [timelineMessageList objectForKey:dateString];
                if(itemList == nil)
                {
                    itemList = [[NSMutableArray alloc] init];
                    NSString *dateDayString = [CommonUtil getDayString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                    TimelineSectionData *dateSectionData = [[TimelineSectionData alloc] init];
                    dateSectionData.date = dateString;
                    dateSectionData.day = dateDayString;
                    [sectionList addObject:dateSectionData];
                }
                
                [itemList addObject:inboxData];
                
                [timelineMessageList setObject:itemList forKey:dateString];
                
                if(inboxData.readDate == 0)
                {
                    [unreadMessageList addObject:inboxData.serverMessageKey];
                }
            }
            
            /*
            if(viewType == TIMELINE && !isSearch)
            {
                 NSString *todayString = [CommonUtil getTodayDateString];
                 NSString *todayDayString = [CommonUtil getDayString:[NSDate date]];
                 TimelineSectionData *todaySectionData = [[TimelineSectionData alloc] init];
                 todaySectionData.date = todayString;
                 todaySectionData.day = todayDayString;
                 [sectionList addObject:todaySectionData];
                
                for(NHInboxMessageData *inboxData in messageList)
                {
                    if(inboxData.inboxType == nil || [inboxData.inboxType length] == 0)
                    {
                        inboxData.inboxType = @"4";
                        inboxData.stickerCode = 4;
                    }
                    NSString *dateString = [CommonUtil getDateString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                    
                    if([dateString isEqualToString:todayString])
                    {
                        NSMutableArray *todayItemList = [timelineMessageList objectForKey:todayString];
                        if(todayItemList == nil)
                        {
                            todayItemList = [[NSMutableArray alloc] init];
                        }
                     
                        [todayItemList addObject:inboxData];
                        [timelineMessageList setObject:todayItemList forKey:todayString];
                    }
                    else
                    {
                        NSMutableArray *itemList = [timelineMessageList objectForKey:dateString];
                        if(itemList == nil)
                        {
                            itemList = [[NSMutableArray alloc] init];
                            NSString *dateDayString = [CommonUtil getDayString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                            TimelineSectionData *dateSectionData = [[TimelineSectionData alloc] init];
                            dateSectionData.date = dateString;
                            dateSectionData.day = dateDayString;
                            [sectionList addObject:dateSectionData];
                        }
                        [itemList addObject:inboxData];
                        [timelineMessageList setObject:itemList forKey:dateString];
                    }
                }
            }
            else
            {
                for(NHInboxMessageData *inboxData in messageList)
                {
                    if(inboxData.inboxType == nil || [inboxData.inboxType length] == 0)
                    {
                        inboxData.inboxType = @"4";
                        inboxData.stickerCode = 4;
                    }
                    
                    NSString *dateString = [CommonUtil getDateString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                    
                    NSMutableArray *itemList = [timelineMessageList objectForKey:dateString];
                    if(itemList == nil)
                    {
                        itemList = [[NSMutableArray alloc] init];
                        NSString *dateDayString = [CommonUtil getDayString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                        TimelineSectionData *dateSectionData = [[TimelineSectionData alloc] init];
                        dateSectionData.date = dateString;
                        dateSectionData.day = dateDayString;
                        [sectionList addObject:dateSectionData];
                    }
                    
                    [itemList addObject:inboxData];
                    
                    [timelineMessageList setObject:itemList forKey:dateString];
                }
            }*/
        }
        else
        {
            if(isNewData)
            {
                // 신규 목록
                for(NHInboxMessageData *inboxData in messageList)
                {
                    if([inboxData.inboxType isEqualToString:@"A"])
                    {
                        inboxData.stickerCode = STICKER_EXCHANGE_RATE;
                    }
                    else if ([inboxData.inboxType isEqualToString:@"B"] || [inboxData.inboxType isEqualToString:@"Z"])
                    {
                        inboxData.stickerCode = STICKER_NOTICE_NORMAL;
                    }
                    else if(inboxData.stickerCode < 0 || (inboxData.stickerCode > 6 && inboxData.stickerCode < 100))
                    {
                        inboxData.stickerCode = STICKER_ETC;
                    }
                    
                    NSString *dateString = [CommonUtil getDateString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                    
                    NSMutableArray *itemList = [timelineMessageList objectForKey:dateString];
                    if(itemList == nil)
                    {
                        itemList = [[NSMutableArray alloc] init];
                        NSString *dateDayString = [CommonUtil getDayString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                        TimelineSectionData *dateSectionData = [[TimelineSectionData alloc] init];
                        dateSectionData.date = dateString;
                        dateSectionData.day = dateDayString;
                        [sectionList insertObject:dateSectionData atIndex:0];
                    }
                    
                    [itemList insertObject:inboxData atIndex:0];
                    [timelineMessageList setObject:itemList forKey:dateString];
                    
                    if(inboxData.readDate == 0)
                    {
                        [unreadMessageList addObject:inboxData.serverMessageKey];
                    }
                }
            }
            else
            {
                if ([messageList count] == 0)
                {
                    isMoreList = NO;
                }
                
                for(NHInboxMessageData *inboxData in messageList)
                {
                    if([inboxData.inboxType isEqualToString:@"A"])
                    {
                        inboxData.stickerCode = STICKER_EXCHANGE_RATE;
                    }
                    else if ([inboxData.inboxType isEqualToString:@"B"] || [inboxData.inboxType isEqualToString:@"Z"])
                    {
                        inboxData.stickerCode = STICKER_NOTICE_NORMAL;
                    }
                    else if(inboxData.stickerCode < 0 || (inboxData.stickerCode > 6 && inboxData.stickerCode < 100))
                    {
                        inboxData.stickerCode = STICKER_ETC;
                    }
                    
                    NSString *dateString = [CommonUtil getDateString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                    
                    NSMutableArray *itemList = [timelineMessageList objectForKey:dateString];
                    if(itemList == nil)
                    {
                        itemList = [[NSMutableArray alloc] init];
                        NSString *dateDayString = [CommonUtil getDayString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                        TimelineSectionData *dateSectionData = [[TimelineSectionData alloc] init];
                        dateSectionData.date = dateString;
                        dateSectionData.day = dateDayString;
                        [sectionList addObject:dateSectionData];
                    }
                    
                    [itemList addObject:inboxData];
                    
                    [timelineMessageList setObject:itemList forKey:dateString];
                    
                    if(inboxData.readDate == 0)
                    {
                        [unreadMessageList addObject:inboxData.serverMessageKey];
                    }
                }
                /*
                // 과거 목록
                if(viewType == TIMELINE)
                {
                    NSString *todayString = [CommonUtil getTodayDateString];
                    
                    for(NHInboxMessageData *inboxData in messageList)
                    {
                        if(inboxData.inboxType == nil || [inboxData.inboxType length] == 0)
                        {
                            inboxData.inboxType = @"4";
                            inboxData.stickerCode = 4;
                        }
                        
                        NSString *dateString = [CommonUtil getDateString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                        
                        if([dateString isEqualToString:todayString])
                        {
                            NSMutableArray *todayItemList = [timelineMessageList objectForKey:todayString];
                            if(todayItemList == nil)
                            {
                                todayItemList = [[NSMutableArray alloc] init];
                            }
                            
                            [todayItemList addObject:inboxData];
                            [timelineMessageList setObject:todayItemList forKey:todayString];
                        }
                        else
                        {
                            NSMutableArray *itemList = [timelineMessageList objectForKey:dateString];
                            if(itemList == nil)
                            {
                                itemList = [[NSMutableArray alloc] init];
                                NSString *dateDayString = [CommonUtil getDayString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                                TimelineSectionData *dateSectionData = [[TimelineSectionData alloc] init];
                                dateSectionData.date = dateString;
                                dateSectionData.day = dateDayString;
                                [sectionList addObject:dateSectionData];
                            }
                            [itemList addObject:inboxData];
                            [timelineMessageList setObject:itemList forKey:dateString];
                        }
                    }
                }
                else
                {
                    for(NHInboxMessageData *inboxData in messageList)
                    {
                        if(inboxData.inboxType == nil || [inboxData.inboxType length] == 0)
                        {
                            inboxData.inboxType = @"4";
                            inboxData.stickerCode = 4;
                        }
                        
                        NSString *dateString = [CommonUtil getDateString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                        
                        NSMutableArray *itemList = [timelineMessageList objectForKey:dateString];
                        if(itemList == nil)
                        {
                            itemList = [[NSMutableArray alloc] init];
                            NSString *dateDayString = [CommonUtil getDayString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]];
                            TimelineSectionData *dateSectionData = [[TimelineSectionData alloc] init];
                            dateSectionData.date = dateString;
                            dateSectionData.day = dateDayString;
                            [sectionList addObject:dateSectionData];
                        }
                        
                        [itemList addObject:inboxData];
                        
                        [timelineMessageList setObject:itemList forKey:dateString];
                    }
                }*/
            }
            
            isRefresh = NO;
        }
        
        [self performSelector:@selector(makeTimelineView) withObject:nil];
        
        if([unreadMessageList count] > 0)
        {
            [self sendReadStatus];
        }
    }
}

- (void)inboxLoadFailed:(int)responseCode
{
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) stopIndicator];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"데이터 가져오기에 실패했습니다.\n잠시 후 다시 시도해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alertView show];
    [self performSelector:@selector(makeTimelineView) withObject:nil];
}

- (void)loadedInboxCategoryList:(NSArray *)categoryList
{
//    NSLog(@"%s, %@", __FUNCTION__, categoryList);
}

- (void)stickerSummaryList:(BOOL)success summaryList:(NSArray *)summaryList
{
//    NSLog(@"%s, %@", __FUNCTION__, summaryList);
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) stopIndicator];
    
    float total = 0;
    for(StickerSummaryData *data in summaryList)
    {
        StickerType type = data.stickerCode;
        int sum = (int)data.sum;
        int count = (int)data.count;
        
        total += sum;
    }
}

- (void)sendReadStatus
{
    [IBInbox requestReadMessageWithMsgKey:unreadMessageList readMethod:1];
}

- (void)readMessage:(BOOL)success sMsgKeys:(NSArray *)sMsgKeys
{
//    NSLog(@"%s, %d, keys = %@", __FUNCTION__, success, sMsgKeys);
    if(success)
    {
        [unreadMessageList removeAllObjects];
    }
}

- (void)addedSticker:(BOOL)success
{
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) stopIndicator];
    
    if(success)
    {
        NHInboxMessageData *inboxData = [[timelineMessageList objectForKey:((TimelineSectionData *)[sectionList objectAtIndex:currentStickerIndexPath.section]).date] objectAtIndex:currentStickerIndexPath.row];
        inboxData.stickerCode = selectedStickerCode;
        [[timelineMessageList objectForKey:((TimelineSectionData *)[sectionList objectAtIndex:currentStickerIndexPath.section]).date] setObject:inboxData atIndex:currentStickerIndexPath.row];
        
        // 각 뷰가 있으면 테이블 갱신
        [self makeTimelineView];
    }
    
    currentStickerIndexPath = nil;
    selectedStickerCode = -1;
}

- (void)removedMessages:(BOOL)success sMsgKeys:(NSArray *)sMsgKeys
{
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) stopIndicator];
    
    if(success)
    {
        for(NSString *msgKey in sMsgKeys)
        {
            NSMutableArray *deletedSectionList = sectionList;
            for(TimelineSectionData *sectionData in deletedSectionList)
            {
                NSMutableArray *deletedList = [[NSMutableArray alloc] init];
                for(NHInboxMessageData *inboxData in [timelineMessageList objectForKey:sectionData.date])
                {
                    if(![inboxData.serverMessageKey isEqualToString:msgKey])
                    {
                        [deletedList addObject:inboxData];
                    }
                }
                
                NSString *todayString = [CommonUtil getTodayDateString];
                if(viewType == TIMELINE && [deletedList count] == 0 && [sectionData.date isEqualToString:todayString])
                {
                    [timelineMessageList removeObjectForKey:sectionData.date];
                }
                else
                {
                    if([deletedList count] == 0)
                    {
                        [timelineMessageList removeObjectForKey:sectionData.date];
                        [sectionList removeObject:sectionData];
                    }
                    else
                    {
                        [timelineMessageList setObject:deletedList forKey:sectionData.date];
                    }
                }
            }
        }
        
        // 각 뷰가 있으면 테이블 갱신
        [self makeTimelineView];
    }
}

#pragma mark - 테이블리스트 상단 이동 버튼
- (IBAction)scrollToTop:(id)sender
{
    switch (viewType)
    {
        case TIMELINE:
            if(mTimeLineView != nil)
            {
                [mTimeLineView.mTimeLineTable setContentOffset:CGPointZero animated:YES];
            }
            break;
        case BANKING:
            if(bankingView != nil)
            {
                [bankingView.bankingListTable setContentOffset:CGPointZero animated:YES];
            }
            break;
        case OTHER:
            if(etcTimeLineView != nil)
            {
                [etcTimeLineView.timelineTableView setContentOffset:CGPointZero animated:YES];
            }
            break;
            
        default:
            break;
    }
    
    [self hideScrollTopButton];
}

- (void)showScrollTopButton
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [scrollMoveTopButton setHidden:NO];
        [scrollMoveTopButton setFrame:CGRectMake(self.view.frame.size.width - scrollMoveTopButton.frame.size.width,
                                                 scrollMoveTopButton.frame.origin.y,
                                                 scrollMoveTopButton.frame.size.width,
                                                 scrollMoveTopButton.frame.size.height)];
    }completion:nil];
}

- (void)hideScrollTopButton
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [scrollMoveTopButton setFrame:CGRectMake(self.view.frame.size.width,
                                                 scrollMoveTopButton.frame.origin.y,
                                                 scrollMoveTopButton.frame.size.width,
                                                 scrollMoveTopButton.frame.size.height)];
    }
                     completion:^(BOOL finished){
                         [scrollMoveTopButton setHidden:YES];
                     }];
}
@end
