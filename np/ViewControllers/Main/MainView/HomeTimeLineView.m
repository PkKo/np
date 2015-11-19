//
//  HomeTimeLineView.m
//  np
//
//  Created by Infobank1 on 2015. 9. 16..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "HomeTimeLineView.h"
#import "HomeTimeLineTableViewCell.h"
#import "TransactionObject.h"
#import "StorageBoxUtil.h"
#import "MainPageViewController.h"
#import "HomeViewController.h"
#import "StorageBoxController.h"
#import "HomeEtcTimeLineCell.h"
#import "TimelineBannerView.h"
#import "LoginUtil.h"
#import "StatisticMainUtil.h"

@implementation HomeTimeLineView

@synthesize delegate;

@synthesize mTimeLineSection;
@synthesize mTimeLineDic;
@synthesize mTimeLineTable;
@synthesize listEmptyView;
@synthesize sortLabel;

@synthesize topMenuView;
@synthesize deleteAllView;
@synthesize deleteAllImg;
@synthesize deleteAllLabel;
@synthesize deleteButtonView;
@synthesize deleteButton;

@synthesize searchView;
@synthesize searchStartDateLabel;
@synthesize searchEndDateLabel;
@synthesize datePickerView;
@synthesize datePicker;
@synthesize isSearchResult;
@synthesize isMoreList;
@synthesize periodOneWeekBtn;
@synthesize periodOneMonthBtn;
@synthesize periodThreeMonthBtn;
@synthesize periodSixMonthBtn;

@synthesize storageCountBg;
@synthesize storageCountLabel;

@synthesize bannerIndex;

@synthesize emptyListImageView;

- (id)init
{
    self = [super init];
    
    if(self)
    {
        mTimeLineSection = [[NSMutableArray alloc] init];
        mTimeLineDic = [[NSMutableDictionary alloc] init];
        deleteIdList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data
{
    mTimeLineSection = section;
    mTimeLineDic = data;
    listSortType = YES;
    isMoreList = YES;
    deleteIdList = [[NSMutableArray alloc] init];
    pinnedIdList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:TIMELINE_PIN_MESSAGE_ID]];
    [self refreshBadges];
    
    if([mTimeLineSection count] > 0)
    {
        NSArray *firstSectionArray = [mTimeLineDic objectForKey:((TimelineSectionData *)[mTimeLineSection objectAtIndex:0]).date];
        if([firstSectionArray count] >= 2)
        {
            bannerIndex = 1;
        }
        else if([firstSectionArray count] == 1)
        {
            bannerIndex = 0;
        }
    }
    else
    {
        bannerIndex = 0;
    }
    
    [self addPullToRefreshHeader];
    
    if([mTimeLineSection count] == 0)
    {
        [mTimeLineTable setHidden:YES];
        [listEmptyView setHidden:NO];
    }
    else
    {
        [mTimeLineTable setHidden:NO];
        [listEmptyView setHidden:YES];
    }
}

- (void)refreshData
{
    pinnedIdList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:TIMELINE_PIN_MESSAGE_ID]];
    
    [self refreshBadges];
    
    if([mTimeLineSection count] == 0)
    {
        [mTimeLineTable setHidden:YES];
        [listEmptyView setHidden:NO];
        if(isSearchResult)
        {
            [emptyListImageView setImage:[UIImage imageNamed:@"icon_noresult_01.png"]];
        }
        else
        {
            [emptyListImageView setImage:[UIImage imageNamed:@"icon_notice_06.png"]];
        }
    }
    else
    {
        [mTimeLineTable setHidden:NO];
        [listEmptyView setHidden:YES];
    }
    
    if(!listSortType)
    {
        // section을 먼저 sorting한다.
        mTimeLineSection = (NSMutableArray *)[[mTimeLineSection reverseObjectEnumerator] allObjects];
        // sorting된 section을 가지고 dictionary를 구성한다.
        NSMutableDictionary *reverseDic = [[NSMutableDictionary alloc] init];
        for(TimelineSectionData *data in mTimeLineSection)
        {
            if([mTimeLineDic objectForKey:data.date] != nil)
            {
                NSArray *reverseArray = [[[mTimeLineDic objectForKey:data.date] reverseObjectEnumerator] allObjects];
                [reverseDic setObject:reverseArray forKey:data.date];
            }
        }
        mTimeLineDic = reverseDic;
    }
    
    if(mTimeLineSection != nil && [mTimeLineSection count] > 0)
    {
        NSArray *firstSectionArray = [mTimeLineDic objectForKey:((TimelineSectionData *)[mTimeLineSection objectAtIndex:0]).date];
        if([firstSectionArray count] >= 2)
        {
            bannerIndex = 1;
        }
        else if([firstSectionArray count] == 1)
        {
            bannerIndex = 0;
        }
        else
        {
            bannerIndex = -1;
        }
    }
    
    [self stopLoading];
    
    isDeleteMode = NO;
    [self deleteViewHide:nil];
}

- (void)refreshBadges {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_REFRESH_BADGES object:nil];
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    storageCount = [[controller getAllTransactions] count];
    if(storageCount == 0)
    {
        [storageCountBg setHidden:YES];
        [storageCountLabel setHidden:YES];
    }
    else if(storageCount < 100)
    {
        [storageCountBg setHidden:NO];
        [storageCountLabel setHidden:NO];
        [storageCountLabel setText:[NSString stringWithFormat:@"%ld", (long)storageCount]];
    }
    else
    {
        [storageCountBg setHidden:NO];
        [storageCountLabel setHidden:NO];
        [storageCountLabel setText:@"99+"];
    }
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"%s", __FUNCTION__);
    // Drawing code
    LoginUtil *loginUtil = [[LoginUtil alloc] init];
    [self setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
    [mTimeLineTable setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
}

- (void)addPullToRefreshHeader
{
    textPull = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textRelease = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textLoading = @"Loading";
    
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, mTimeLineTable.frame.size.width, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:241.0/255.0f blue:246.0/255.0f alpha:1.0f];
    [refreshHeaderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    refreshIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_refresh_01.png"]];
    [refreshIndicator setFrame:CGRectMake(floorf(floorf(refreshHeaderView.frame.size.width - 20) / 2), 11, 30, 30)];
    [refreshIndicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [refreshIndicator setContentMode:UIViewContentModeCenter];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, refreshIndicator.frame.origin.y + refreshIndicator.frame.size.height, mTimeLineTable.frame.size.width, 16)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [refreshLabel setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    [refreshLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, REFRESH_HEADER_HEIGHT - 1, mTimeLineTable.frame.size.width, 1)];
    [separateLine setBackgroundColor:[UIColor colorWithRed:208.0/255.0f green:209.0/255.0f blue:214.0/255.0f alpha:1.0f]];
    [separateLine setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshIndicator];
    [refreshHeaderView addSubview:separateLine];
    [mTimeLineTable addSubview:refreshHeaderView];
}

#pragma mark - 리스트 정렬 변경
- (IBAction)listSortChange:(id)sender
{
    CustomizedPickerViewController * pickerViewController = [[CustomizedPickerViewController alloc] initWithNibName:@"CustomizedPickerViewController" bundle:nil];
    
    [pickerViewController setItems:@[TIME_DECSENDING_ORDER, TIME_ACSENDING_ORDER]];
    
    pickerViewController.view.frame             = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.bounds;
    pickerViewController.view.autoresizingMask  = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.autoresizingMask;
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController addChildViewController:pickerViewController];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view addSubview:pickerViewController.view];
    [pickerViewController didMoveToParentViewController:((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController];
    
    [pickerViewController addTarget:self action:@selector(sortByOrder:)];
    [pickerViewController selectRowByValue:[sortLabel text]];
}

-(void)sortByOrder:(NSString *)order
{
    if([order isEqualToString:TIME_ACSENDING_ORDER])
    {
        listSortType = NO;
    }
    else
    {
        listSortType = YES;
    }
    
    if([mTimeLineSection count] > 0)
    {
        // section을 먼저 sorting한다.
        mTimeLineSection = (NSMutableArray *)[[mTimeLineSection reverseObjectEnumerator] allObjects];
        // sorting된 section을 가지고 dictionary를 구성한다.
        NSMutableDictionary *reverseDic = [[NSMutableDictionary alloc] init];
        for(TimelineSectionData *data in mTimeLineSection)
        {
            if([mTimeLineDic objectForKey:data.date] != nil)
            {
                NSArray *reverseArray = [[[mTimeLineDic objectForKey:data.date] reverseObjectEnumerator] allObjects];
                [reverseDic setObject:reverseArray forKey:data.date];
            }
        }
        mTimeLineDic = reverseDic;
        
        NSArray *firstSectionArray = [mTimeLineDic objectForKey:((TimelineSectionData *)[mTimeLineSection objectAtIndex:0]).date];
        if([firstSectionArray count] >= 2)
        {
            bannerIndex = 1;
        }
        else if([firstSectionArray count] == 1)
        {
            bannerIndex = 0;
        }
        else
        {
            bannerIndex = 0;
        }
        
        [mTimeLineTable reloadData];
    }
    
    if(listSortType)
    {
        [sortLabel setText:@"최신순"];
    }
    else
    {
        [sortLabel setText:@"과거순"];
    }
}

#pragma mark - 삭제 Action
- (IBAction)deleteMode:(id)sender
{
    isDeleteMode = YES;
    
    if(searchView.frame.origin.y > 0)
    {
        [self searchViewHide:nil];
    }
    [deleteAllView setHidden:NO];
    [deleteAllImg setHighlighted:NO];
    [deleteAllLabel setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [deleteButtonView setHidden:NO];
        [deleteButtonView setFrame:CGRectMake(0, self.frame.size.height - deleteButtonView.frame.size.height, self.frame.size.width, deleteButtonView.frame.size.height)];
    }completion:nil];
    
    [mTimeLineTable reloadData];
}

- (IBAction)deleteSelectAll:(id)sender
{
    if([deleteAllImg isHighlighted])
    {
        // 전체선택 해제
        if([deleteIdList count] > 0)
        {
            [deleteIdList removeAllObjects];
        }
        
        [deleteAllImg setHighlighted:NO];
        [deleteAllLabel setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
        [deleteButton setEnabled:NO];
        [deleteButton setBackgroundColor:[UIColor colorWithRed:208.0/255.0f green:209.0/255.0f blue:214.0/255.0f alpha:1.0f]];
    }
    else
    {
        // 전체선택 모드
        if([mTimeLineSection count] > 0)
        {
            // 리스트가 있는 경우에만 진행한다
            if([deleteIdList count] > 0)
            {
                [deleteIdList removeAllObjects];
            }
            
            for(TimelineSectionData *sectionData in mTimeLineSection)
            {
                NSString *key = sectionData.date;
                NSArray *list = [mTimeLineDic objectForKey:key];
                for (NHInboxMessageData *item in list)
                {
                    [deleteIdList addObject:item.serverMessageKey];
                }
            }
            
            [deleteAllImg setHighlighted:YES];
            [deleteAllLabel setTextColor:[UIColor colorWithRed:48.0f/255.0f green:49.0f/255.0f blue:54.0f/255.0f alpha:1.0f]];
            [deleteButton setEnabled:YES];
            [deleteButton setBackgroundColor:[UIColor colorWithRed:213.0/255.0f green:42.0/255.0f blue:58.0/255.0f alpha:1.0f]];
        }
    }
    
    if([deleteIdList count] > 0)
    {
        [deleteButton setEnabled:YES];
        [deleteButton setBackgroundColor:[UIColor colorWithRed:213.0/255.0f green:42.0/255.0f blue:58.0/255.0f alpha:1.0f]];
    }
    else
    {
        [deleteButton setEnabled:NO];
        [deleteButton setBackgroundColor:[UIColor colorWithRed:208.0/255.0f green:209.0/255.0f blue:214.0/255.0f alpha:1.0f]];
    }
    
    [mTimeLineTable reloadData];
}

- (IBAction)deleteSelectedList:(id)sender
{
    // deleteIdList로 삭제를 진행한다.
    if([deleteIdList count] > 0)
    {
        for(NSString *serverMessageKey in deleteIdList)
        {
            if([pinnedIdList containsObject:serverMessageKey])
            {
                [deleteIdList removeObject:serverMessageKey];
            }
        }
        
        if(delegate != nil && [delegate respondsToSelector:@selector(deletePushItems:)])
        {
            [delegate performSelector:@selector(deletePushItems:) withObject:deleteIdList];
        }
    }
    
//    [self deleteViewHide:nil];
}

- (IBAction)deleteViewHide:(id)sender
{
    // 삭제모드 해제
    isDeleteMode = NO;
    if([deleteIdList count] > 0)
    {
        [deleteIdList removeAllObjects];
    }
    [deleteAllImg setHighlighted:NO];
    [deleteAllLabel setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
    [deleteAllView setHidden:YES];
    
    [deleteButton setEnabled:NO];
    [deleteButton setBackgroundColor:[UIColor colorWithRed:208.0/255.0f green:209.0/255.0f blue:214.0/255.0f alpha:1.0f]];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [deleteButtonView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, deleteButtonView.frame.size.height)];
    }
                     completion:^(BOOL finished){
                         [deleteButtonView setHidden:YES];
    }];
    
    [mTimeLineTable reloadData];
}

#pragma mark - 검색 Action
- (IBAction)searchViewShow:(id)sender
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [searchView setHidden:NO];
        [searchView setFrame:CGRectMake(0, TOP_MENU_BAR_HEIGHT, self.frame.size.width, searchView.frame.size.height)];
        [self searchPeriodSelect:periodOneWeekBtn];
    }completion:nil];
}

- (IBAction)searchViewHide:(id)sender
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [searchView setFrame:CGRectMake(0, -searchView.frame.size.height + TOP_MENU_BAR_HEIGHT, self.frame.size.width, searchView.frame.size.height)];
    }
                     completion:^(BOOL finished){
                         [searchView setHidden:YES];
                     }];
}

// 기간 설정 버튼 클릭
- (IBAction)searchPeriodSelect:(id)sender
{
    NSString *toDateString = [CommonUtil getFormattedTodayString:@"yyyy.MM.dd"];
    [searchEndDateLabel setText:toDateString];
    searchEndDate = [toDateString stringByReplacingOccurrencesOfString:@"." withString:@""];
    [searchEndDateLabel setTextColor:[UIColor colorWithRed:96/255.0f green:97/255.0f blue:102/255.0f alpha:1.0f]];
    NSString *fromDateString = [CommonUtil getFormattedDateStringWithIndex:@"yyyy.MM.dd" indexDay:-[sender tag]];
    [searchStartDateLabel setText:fromDateString];
    [searchStartDateLabel setTextColor:[UIColor colorWithRed:96/255.0f green:97/255.0f blue:102/255.0f alpha:1.0f]];
    searchStartDate = [fromDateString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    switch ([sender tag])
    {
        case 7:
        {
            [periodOneWeekBtn setSelected:YES];
            [periodOneMonthBtn setSelected:NO];
            [periodThreeMonthBtn setSelected:NO];
            [periodSixMonthBtn setSelected:NO];
            break;
        }
        case 30:
        {
            [periodOneWeekBtn setSelected:NO];
            [periodOneMonthBtn setSelected:YES];
            [periodThreeMonthBtn setSelected:NO];
            [periodSixMonthBtn setSelected:NO];
            break;
        }
        case 90:
        {
            [periodOneWeekBtn setSelected:NO];
            [periodOneMonthBtn setSelected:NO];
            [periodThreeMonthBtn setSelected:YES];
            [periodSixMonthBtn setSelected:NO];
            break;
        }
        case 180:
        {
            [periodOneWeekBtn setSelected:NO];
            [periodOneMonthBtn setSelected:NO];
            [periodThreeMonthBtn setSelected:NO];
            [periodSixMonthBtn setSelected:YES];
            break;
        }
        default:
            break;
    }
}

// 검색 실행
- (IBAction)searchStart:(id)sender
{
    AccountInboxRequestData *reqData = [[AccountInboxRequestData alloc] init];
    reqData.accountNumberList = [[[LoginUtil alloc] init] getAllAccounts];
    reqData.ascending = listSortType;
    reqData.startDate = searchStartDate;
    reqData.endDate = searchEndDate;
    reqData.queryType = @"1,2,3,4,5,6";
    
    if(delegate != nil && [delegate respondsToSelector:@selector(searchInboxDataWithQuery:)])
    {
        [delegate performSelector:@selector(searchInboxDataWithQuery:) withObject:reqData];
    }
    
    [self searchViewHide:nil];
}

// DatePicker 확인 버튼
- (IBAction)searchDateSelect:(id)sender
{
    NSString *selectedDateString = [CommonUtil getFormattedDateStringWithDate:@"yyyy.MM.dd" date:datePicker.date];
    if(searchDateSelectType)
    {
        [searchEndDateLabel setText:selectedDateString];
        [searchEndDateLabel setTextColor:[UIColor colorWithRed:96/255.0f green:97/255.0f blue:102/255.0f alpha:1.0f]];
        searchEndDate = [selectedDateString stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
    else
    {
        [searchStartDateLabel setText:selectedDateString];
        searchStartDate = [selectedDateString stringByReplacingOccurrencesOfString:@"." withString:@""];
        [searchStartDateLabel setTextColor:[UIColor colorWithRed:96/255.0f green:97/255.0f blue:102/255.0f alpha:1.0f]];
    }
    
    [datePickerView setHidden:YES];
}

// DatePickerView 보여줌
- (IBAction)searchDatePickerShow:(id)sender
{
    if(pickerBgView == nil)
    {
        CGRect frame = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.bounds;
        pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - datePickerView.frame.size.height)];
        [pickerBgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    }
    [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view addSubview:pickerBgView];
    
    searchDateSelectType = (BOOL)[sender tag];
    
    [datePickerView setHidden:NO];
    
    if(datePicker == nil)
    {
        datePicker = [[UIDatePicker alloc] init];
    }
    
    if(searchDateSelectType)
    {
        // 종료일
        if(searchEndDate == nil || [searchEndDate length] == 0)
        {
            [datePicker setDate:[NSDate date]];
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMdd"];
            NSDate *currentDate = [formatter dateFromString:searchEndDate];
            [datePicker setDate:currentDate];
        }
    }
    else
    {
        // 시작일
        if(searchStartDate == nil || [searchStartDate length] == 0)
        {
            [datePicker setDate:[NSDate date]];
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMdd"];
            NSDate *currentDate = [formatter dateFromString:searchStartDate];
            [datePicker setDate:currentDate animated:NO];
        }
    }
}

// DatePickerView 숨김
- (IBAction)searchDatePickerHide:(id)sender
{
    [pickerBgView removeFromSuperview];
    [datePickerView setHidden:YES];
}

#pragma mark - 보관함 이동 Action
- (IBAction)storageMoveClick:(id)sender
{
    MainPageViewController *newTopViewController = [[MainPageViewController alloc] init];
    [newTopViewController setStartPageIndex:INBOX];
    
    CGRect frame = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController = newTopViewController;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame = frame;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController resetTopViewAnimated:NO];
}

#pragma mark - 새로고침
- (void)startLoading
{
//    NSLog(@"%s", __FUNCTION__);
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        mTimeLineTable.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = textLoading;
        [CommonUtil runSpinAnimationWithDuration:refreshIndicator duration:10.0f];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading
{
//    NSLog(@"%s", __FUNCTION__);
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        mTimeLineTable.contentInset = UIEdgeInsetsZero;
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete
{
    // Reset the header
    refreshLabel.text = textPull;
    [CommonUtil stopSpinAnimation:refreshIndicator];
}

- (void)refresh
{
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    if(delegate != nil && [delegate respondsToSelector:@selector(refreshData:)])
    {
        [delegate refreshData:YES];
    }
//    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mTimeLineSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([mTimeLineSection count] == 0)
    {
        return 0;
    }
    else
    {
        NSArray *array = [mTimeLineDic objectForKey:((TimelineSectionData *)[mTimeLineSection objectAtIndex:section]).date];
        
        return [array count];
        /*
        if(section == 0 && [array count] == 0)
        {
            return 1;
        }
        else
        {
            return [array count];
        }*/
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEADER_HEIGHT)];
    
    [sectionHeaderView setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:241.0f/255.0f blue:246.0f/255.0f alpha:1.0f]];
    
    TimelineSectionData *sectionData = [mTimeLineSection objectAtIndex:section];
    NSString *date = sectionData.date;
    NSString *day = sectionData.day;
    
    CGSize dateSize = [CommonUtil getStringFrameSize:date fontSize:12 bold:YES];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, dateSize.width, SECTION_HEADER_HEIGHT)];
    [dateLabel setTextColor:[UIColor colorWithRed:96.0f/255.0f green:97.0f/255.0f blue:102.0f/255.0f alpha:1.0f]];
    [dateLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [dateLabel setText:date];
    [sectionHeaderView addSubview:dateLabel];
    
    CGSize daySize = [CommonUtil getStringFrameSize:date fontSize:12 bold:NO];
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateLabel.frame.origin.x + dateSize.width, 0, daySize.width, SECTION_HEADER_HEIGHT)];
    [dayLabel setTextColor:[UIColor colorWithRed:96.0f/255.0f green:97.0f/255.0f blue:102.0f/255.0f alpha:1.0f]];
    [dayLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [dayLabel setText:day];
    [sectionHeaderView addSubview:dayLabel];
    
    return sectionHeaderView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *section = ((TimelineSectionData *)[mTimeLineSection objectAtIndex:indexPath.section]).date;
    NHInboxMessageData *inboxData = [[mTimeLineDic objectForKey:section] objectAtIndex:indexPath.row];
    
    if(indexPath.section == 0 && indexPath.row == bannerIndex && inboxData == nil)
    {
        return TIMELINE_BANNER_HEIGHT;
    }
    else if(indexPath.section == 0 && indexPath.row == bannerIndex && !isSearchResult)
    {
        return [self getTimelineCellHeight:(StickerType)inboxData.stickerCode] + TIMELINE_BANNER_HEIGHT;
    }
    else
    {
        return [self getTimelineCellHeight:(StickerType)inboxData.stickerCode];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *section = ((TimelineSectionData *)[mTimeLineSection objectAtIndex:indexPath.section]).date;
    NHInboxMessageData *inboxData = [[mTimeLineDic objectForKey:section] objectAtIndex:indexPath.row];
    
    if(inboxData == nil)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, TIMELINE_BANNER_HEIGHT)];
        TimelineBannerView *bannerView = [TimelineBannerView view];
        [bannerView setFrame:CGRectMake(0, TIMELINE_BANNER_HEIGHT - bannerView.frame.size.height, cell.frame.size.width, bannerView.frame.size.height)];
        NSLog(@"%s, banner frame = %f", __FUNCTION__, bannerView.frame.size.height);
        [cell addSubview:bannerView];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if(bannerInfoView == nil)
        {
            bannerInfoView = [BannerInfoView view];
        }
        else
        {
            [bannerInfoView bannerTimerStop];
        }
        [bannerInfoView setFrame:CGRectMake(0, 0, bannerView.bannerContentView.frame.size.width, bannerView.bannerContentView.frame.size.height)];
        [bannerView.bannerContentView addSubview:bannerInfoView];
        [bannerInfoView bannerTimerStart];
        
        LoginUtil *loginUtil = [[LoginUtil alloc] init];
        [cell setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
        
        return cell;
    }
    else
    {
        if([self isBankingNoti:(StickerType)inboxData.stickerCode])
        {
            NSString *reuseId = [NSString stringWithFormat:@"%@", [HomeTimeLineTableViewCell class]];
            HomeTimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            
            if(cell == nil)
            {
                cell = [HomeTimeLineTableViewCell cell];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            LoginUtil *loginUtil = [[LoginUtil alloc] init];
            [cell setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
            
            /* 데이터 구성
             NHInboxMessageData
             NSString * serverMessageKey;
             int64_t regDate;
             NSString * inboxType;
             NSString * title;
             NSString * text;
             NSString * linkUrl;
             NSString * nhAccountNumber;
             int64_t amount;
             int64_t balance;
             NSString * oppositeUser;
             int32_t stickerCode;*/
            
            // 스티커 버튼
            [cell.stickerButton setIndexPath:indexPath];
            if(isDeleteMode)
            {
                // 삭제 버튼으로 바꿔줌
                [cell.stickerButton setImage:[UIImage imageNamed:@"icon_sticker_05_dft.png"] forState:UIControlStateNormal];
                [cell.stickerButton setImage:[UIImage imageNamed:@"icon_sticker_05_sel.png"] forState:UIControlStateSelected];
                if(deleteIdList != nil && [deleteIdList containsObject:inboxData.serverMessageKey])
                {
                    [cell.stickerButton setSelected:YES];
                }
                
                [cell.pinButton setHidden:YES];
                [cell.moreButton setHidden:YES];
                [cell.upperLine setHidden:YES];
                [cell.underLine setHidden:YES];
            }
            else
            {
                [cell.stickerButton setImage:[CommonUtil getStickerImage:(StickerType)inboxData.stickerCode] forState:UIControlStateNormal];
                [cell.stickerButton setImage:nil forState:UIControlStateSelected];
                
                [cell.pinButton setHidden:NO];
                [cell.moreButton setHidden:NO];
                if(indexPath.row == 0)
                {
                    [cell.upperLine setHidden:YES];
                }
                
                if ([(NSArray *)[mTimeLineDic objectForKey:section] count] - 1 == indexPath.row)
                {
                    [cell.underLine setHidden:YES];
                }
            }
            
            [cell.stickerButton setTag:(StickerType)inboxData.stickerCode];
            [cell.stickerButton addTarget:self action:@selector(stickerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            // 푸시 시간
            [cell.timeLabel setText:[CommonUtil getTimeString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]]];
            // 거래명
            [cell.nameLabel setText:inboxData.oppositeUser];
            
            NSNumberFormatter *numFomatter = [NSNumberFormatter new];
            [numFomatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *amount = [numFomatter stringFromNumber:[NSNumber numberWithInteger:inboxData.amount]];
            NSString *balance = [numFomatter stringFromNumber:[NSNumber numberWithInteger:inboxData.balance]];
            // 금액 String size
            CGSize amountSize = [CommonUtil getStringFrameSize:amount fontSize:AMOUNT_FONT_SIZE bold:YES];
            
            switch (inboxData.stickerCode)
            {
                case STICKER_DEPOSIT_NORMAL:
                case STICKER_DEPOSIT_SALARY:
                case STICKER_DEPOSIT_POCKET:
                case STICKER_DEPOSIT_ETC:
                {
                    // 입출금 타입
                    [cell.typeLabel setText:@"입금"];
                    [cell.typeLabel setTextColor:INCOME_STRING_COLOR];
                    // 금액
                    [cell.amountLabel setFrame:CGRectMake(cell.amountLabel.frame.origin.x,
                                                          cell.amountLabel.frame.origin.y,
                                                          amountSize.width, cell.amountLabel.frame.size.height)];
                    [cell.amountLabel setText:amount];
                    [cell.amountLabel setTextColor:INCOME_STRING_COLOR];
                    
                    [cell.amountDescLabel setFrame:CGRectMake(cell.amountLabel.frame.origin.x + amountSize.width,
                                                              cell.amountDescLabel.frame.origin.y,
                                                              cell.amountDescLabel.frame.size.width,
                                                              cell.amountDescLabel.frame.size.height)];
                    [cell.amountDescLabel setTextColor:INCOME_STRING_COLOR];
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
                    // 입출금 타입
                    [cell.typeLabel setText:@"출금"];
                    [cell.typeLabel setTextColor:WITHDRAW_STRING_COLOR];
                    [cell.amountLabel setFrame:CGRectMake(cell.amountLabel.frame.origin.x,
                                                          cell.amountLabel.frame.origin.y,
                                                          amountSize.width, cell.amountLabel.frame.size.height)];
                    // 금액
                    [cell.amountLabel setText:amount];
                    [cell.amountLabel setTextColor:WITHDRAW_STRING_COLOR];
                    
                    [cell.amountDescLabel setFrame:CGRectMake(cell.amountLabel.frame.origin.x + amountSize.width,
                                                              cell.amountDescLabel.frame.origin.y,
                                                              cell.amountDescLabel.frame.size.width,
                                                              cell.amountDescLabel.frame.size.height)];
                    [cell.amountDescLabel setTextColor:WITHDRAW_STRING_COLOR];
                    break;
                }
                    
                default:
                    break;
            }
            
            // 계좌별명 + 계좌명
            NSString *accountNickName = [[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_NICKNAME_DICTIONARY] objectForKey:inboxData.nhAccountNumber];
            
            if(accountNickName != nil && [accountNickName length] > 0)
            {
                [cell.accountLabel setText:[NSString stringWithFormat:@"%@ %@", accountNickName, [CommonUtil getAccountNumberAddDash:inboxData.nhAccountNumber]]];
            }
            else
            {
                [cell.accountLabel setText:[CommonUtil getAccountNumberAddDash:inboxData.nhAccountNumber]];
            }
            
            // 잔액
            if(balance != nil && [balance length] > 0)
            {
                [cell.remainAmountLabel setText:[NSString stringWithFormat:@"잔액 %@원", balance]];
            }
            else
            {
                [cell.remainAmountLabel setText:@""];
            }
            
            // 고정핀
            [cell.pinButton setIndexPath:indexPath];
            [cell.pinButton addTarget:self action:@selector(pinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            // more 버튼
            [cell.moreButton setIndexPath:indexPath];
            [cell.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if(pinnedIdList != nil && [pinnedIdList containsObject:inboxData.serverMessageKey])
            {
                [cell.pinButton setSelected:YES];
            }
            
            if(indexPath.section == 0 && indexPath.row == bannerIndex && !isSearchResult)
            {
                TimelineBannerView *bannerView = [TimelineBannerView view];
                if(bannerInfoView == nil)
                {
                    bannerInfoView = [BannerInfoView view];
                    [bannerInfoView.nongminBanner setBackgroundImage:((AppDelegate *)[UIApplication sharedApplication].delegate).nongminBannerImg forState:UIControlStateNormal];
                    [bannerInfoView.noticeBanner setBackgroundImage:((AppDelegate *)[UIApplication sharedApplication].delegate).noticeBannerImg forState:UIControlStateNormal];
                }
                else
                {
                    [bannerInfoView bannerTimerStop];
                }
                [bannerView setFrame:CGRectMake(0, cell.frame.size.height, cell.frame.size.width, bannerView.frame.size.height)];
                [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height + TIMELINE_BANNER_HEIGHT)];
                [cell addSubview:bannerView];
                
                [bannerInfoView setFrame:CGRectMake(0, 0, bannerView.bannerContentView.frame.size.width, bannerView.bannerContentView.frame.size.height)];
                [bannerView.bannerContentView addSubview:bannerInfoView];
                [bannerInfoView bannerTimerStart];
            }
            /*
            if(indexPath.section == 0 && indexPath.row == bannerIndex + 1 && !isSearchResult)
            {
                [cell.upperLine setHidden:YES];
            }*/
            
            CGFloat viewHeight = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame.size.height;
            if(viewHeight > IPHONE_FIVE_FRAME_HEIGHT)
            {
                CGFloat pinButtonHeight = cell.pinButton.frame.size.height * (viewHeight / IPHONE_FIVE_FRAME_HEIGHT);
                [cell.pinButton setFrame:CGRectMake(cell.pinButton.frame.origin.x
                                                    - (pinButtonHeight / 2),
                                                   cell.pinButton.frame.origin.y - (pinButtonHeight / 2),
                                                    pinButtonHeight, pinButtonHeight)];
                [cell.moreButton setFrame:CGRectMake(cell.moreButton.frame.origin.x
                                                    - (pinButtonHeight / 2),
                                                    cell.moreButton.frame.origin.y - (pinButtonHeight / 2),
                                                    pinButtonHeight, pinButtonHeight)];
            }
            
            return cell;
        }
        else
        {
            NSString *reuseId = [NSString stringWithFormat:@"%@", [HomeEtcTimeLineCell class]];
            HomeEtcTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            
            if(cell == nil)
            {
                cell = [HomeEtcTimeLineCell cell];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            LoginUtil *loginUtil = [[LoginUtil alloc] init];
            [cell setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
            
            // 스티커 버튼
            [cell.stickerButton setIndexPath:indexPath];
            if(isDeleteMode)
            {
                // 삭제 버튼으로 바꿔줌
                [cell.stickerButton setImage:[UIImage imageNamed:@"icon_sticker_05_dft.png"] forState:UIControlStateNormal];
                [cell.stickerButton setImage:[UIImage imageNamed:@"icon_sticker_05_sel.png"] forState:UIControlStateSelected];
                if(deleteIdList != nil && [deleteIdList containsObject:inboxData.serverMessageKey])
                {
                    [cell.stickerButton setSelected:YES];
                }
                
                [cell.upperLine setHidden:YES];
                [cell.underLine setHidden:YES];
            }
            else
            {
                // 기존 스티커 버튼
                [cell.stickerButton setImage:[CommonUtil getStickerImage:(StickerType)inboxData.stickerCode] forState:UIControlStateNormal];
                [cell.stickerButton setImage:nil forState:UIControlStateSelected];
                
                if(indexPath.row == 0)
                {
                    [cell.upperLine setHidden:YES];
                }
                
                if ([(NSArray *)[mTimeLineDic objectForKey:section] count] - 1 == indexPath.row)
                {
                    [cell.underLine setHidden:YES];
                }
            }
            
            [cell.stickerButton setTag:(StickerType)inboxData.stickerCode];
            [cell.stickerButton addTarget:self action:@selector(stickerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            // 푸시 시간
            [cell.timeLabel setText:[CommonUtil getTimeString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]]];
            // 공지 타이틀
            [cell.titleLabel setText:inboxData.title];
            // 공지 내용
            [cell.contentLabel setText:inboxData.text];
            [cell.contentLabel sizeToFit];
            
            if(indexPath.section == 0 && indexPath.row == bannerIndex && !isSearchResult)
            {
                TimelineBannerView *bannerView = [TimelineBannerView view];
                if(bannerInfoView == nil)
                {
                    bannerInfoView = [BannerInfoView view];
                }
                else
                {
                    [bannerInfoView bannerTimerStop];
                }
                [bannerView setFrame:CGRectMake(0, cell.frame.size.height, cell.frame.size.width, bannerView.frame.size.height)];
                [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height + TIMELINE_BANNER_HEIGHT)];
                [cell addSubview:bannerView];
                
                [bannerInfoView setFrame:CGRectMake(0, 0, bannerView.bannerContentView.frame.size.width, bannerView.bannerContentView.frame.size.height)];
                [bannerView.bannerContentView addSubview:bannerInfoView];
                [bannerInfoView bannerTimerStart];
            }
            /*
            if(indexPath.section == 0 && indexPath.row == bannerIndex + 1 && !isSearchResult)
            {
                [cell.upperLine setHidden:YES];
            }*/
            
            return cell;
        }
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
    if(isDeleteMode) return;
    if(isSearchResult) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isLoading)
    {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            mTimeLineTable.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            mTimeLineTable.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (isDragging && scrollView.contentOffset.y <= 0)
    {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = textRelease;
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = textPull;
            }
        }];
        
        if(delegate != nil && [delegate respondsToSelector:@selector(hideScrollTopButton)])
        {
            [delegate performSelector:@selector(hideScrollTopButton) withObject:nil];
        }
    }
    else if(isDragging && scrollView.contentOffset.y > 0)
    {
        if(delegate != nil && [delegate respondsToSelector:@selector(showScrollTopButton)])
        {
            [delegate performSelector:@selector(showScrollTopButton) withObject:nil];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(isLoading) return;
    if(isDeleteMode) return;
    if(isSearchResult) return;
    isDragging = NO;
    
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT)
    {
        // Released above the header
        [self startLoading];
    }
    else if(scrollView.contentOffset.y + mTimeLineTable.frame.size.height >= mTimeLineTable.contentSize.height)
    {
//        NSLog(@"scrollView.contentOffset.y = %f, tableViewContentSize = %f, tableViewHeight = %f", scrollView.contentOffset.y, mTimeLineTable.contentSize.height, mTimeLineTable.frame.size.height);
//        NSLog(@"offset + height = %f, tableViewContentSize = %f", scrollView.contentOffset.y + mTimeLineTable.frame.size.height, mTimeLineTable.contentSize.height);
        // 스크롤이 끝까지 내려가면 이전 목록을 불러와 리프레쉬 한다.
        if(delegate != nil && [delegate respondsToSelector:@selector(refreshData:)] && isMoreList)
        {
            [delegate refreshData:NO];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= 0)
    {
        if(delegate != nil && [delegate respondsToSelector:@selector(hideScrollTopButton)])
        {
            [delegate performSelector:@selector(hideScrollTopButton) withObject:nil];
        }
    }
}

#pragma mark - CellButtonClickEvent
- (void)stickerButtonClick:(id)sender
{
    IndexPathButton *currentBtn = (IndexPathButton *)sender;
    NSIndexPath *indexPath = currentBtn.indexPath;
    
    if(isDeleteMode)
    {
        NSString *pushId = ((NHInboxMessageData *)[[mTimeLineDic objectForKey:((TimelineSectionData *)[mTimeLineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row]).serverMessageKey;
        
        if([currentBtn isSelected])
        {
            if([deleteIdList containsObject:pushId])
            {
                [deleteIdList removeObject:pushId];
            }
        }
        else
        {
            if(![deleteIdList containsObject:pushId])
            {
                [deleteIdList addObject:pushId];
            }
        }
        [currentBtn setSelected:![currentBtn isSelected]];
        
        if([deleteIdList count] > 0)
        {
            [deleteButton setEnabled:YES];
            [deleteButton setBackgroundColor:[UIColor colorWithRed:213.0/255.0f green:42.0/255.0f blue:58.0/255.0f alpha:1.0f]];
        }
        else
        {
            [deleteButton setEnabled:NO];
            [deleteButton setBackgroundColor:[UIColor colorWithRed:208.0/255.0f green:209.0/255.0f blue:214.0/255.0f alpha:1.0f]];
        }
    }
    else
    {
        if(delegate != nil && [delegate respondsToSelector:@selector(stickerButtonClick:)])
        {
            [delegate performSelector:@selector(stickerButtonClick:) withObject:sender];
        }
    }
}

- (void)pinButtonClick:(id)sender
{
    IndexPathButton *currentBtn = (IndexPathButton *)sender;
//    NSLog(@"button indexPath = %@", currentBtn.indexPath);
    NSIndexPath *indexPath = currentBtn.indexPath;
    
    NHInboxMessageData *inboxData = [[mTimeLineDic objectForKey:((TimelineSectionData *)[mTimeLineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row];
    
    if(pinnedIdList == nil)
    {
        pinnedIdList = [[NSMutableArray alloc] init];
    }
    
    if([currentBtn isSelected])
    {
        // 고정핀 해제를 위해 디바이스에서 해당 인덱스패스에 있는 푸시 아이디를 삭제한다.
        if([pinnedIdList containsObject:inboxData.serverMessageKey])
        {
            NSInteger index = [pinnedIdList indexOfObject:inboxData.serverMessageKey];
            [pinnedIdList removeObjectAtIndex:index];
            [[NSUserDefaults standardUserDefaults] setObject:pinnedIdList forKey:TIMELINE_PIN_MESSAGE_ID];
        }
    }
    else
    {
        // 고정핀 적용을 위해 디바이스에 해당 인덱스패스의 푸시 아이디를 저장한다.
        if(![pinnedIdList containsObject:inboxData.serverMessageKey])
        {
            [pinnedIdList addObject:inboxData.serverMessageKey];
            [[NSUserDefaults standardUserDefaults] setObject:pinnedIdList forKey:TIMELINE_PIN_MESSAGE_ID];
        }
    }
    
    [currentBtn setSelected:![currentBtn isSelected]];
}

- (void)moreButtonClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBadges) name:NOTIFICATION_REFRESH_BADGES object:nil];
    
    IndexPathButton *currentButton = (IndexPathButton *)sender;
    NSIndexPath *indexPath = currentButton.indexPath;
    
    NHInboxMessageData *inboxData = [[mTimeLineDic objectForKey:((TimelineSectionData *)[mTimeLineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row];
    HomeTimeLineTableViewCell *cell = [mTimeLineTable cellForRowAtIndexPath:indexPath];
    
    TransactionObject * transation = [[TransactionObject alloc] initTransactionObjectWithTransactionId:inboxData.serverMessageKey
                                                                                       transactionDate:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]
                                                                              transactionAccountNumber:[CommonUtil getAccountNumberAddDash:inboxData.nhAccountNumber]
                                                                                transactionAccountType:@""
                                                                                    transactionDetails:inboxData.oppositeUser
                                                                                       transactionType:[NSString stringWithFormat:@"%d", inboxData.stickerCode]
                                                                                     transactionAmount:@(inboxData.amount)
                                                                                    transactionBalance:@(inboxData.balance)
                                                                                       transactionMemo:@""
                                                                                  transactionActivePin:[NSNumber numberWithBool:[cell.pinButton isSelected]]];
    StorageBoxUtil * util = [[StorageBoxUtil alloc] init];
    [util showMemoComposerInViewController:((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController withTransationObject:transation];
}

#pragma mark - Util
- (float)getTimelineCellHeight:(StickerType)type
{
    switch (type)
    {
        case STICKER_DEPOSIT_NORMAL:
        case STICKER_DEPOSIT_SALARY:
        case STICKER_DEPOSIT_POCKET:
        case STICKER_DEPOSIT_ETC:
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
            return TIMELINE_BANKING_HEIGHT;
            break;
        }
            
        default:
            return TIMELINE_ETC_HEIGHT;
            break;
    }
}

- (BOOL)isBankingNoti:(StickerType)type
{
    switch (type)
    {
        case STICKER_DEPOSIT_NORMAL:
        case STICKER_DEPOSIT_SALARY:
        case STICKER_DEPOSIT_POCKET:
        case STICKER_DEPOSIT_ETC:
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
            return YES;
            break;
        }
            
        default:
            return NO;
            break;
    }
}

- (void)bannerTimerStop
{
    if(bannerInfoView != nil)
    {
        [bannerInfoView bannerTimerStop];
        bannerInfoView = nil;
    }
}
@end
