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
#import "ServiceFunctionInfoView.h"
#import "HomeEtcDetailViewController.h"

// iPhone6+등의 고해상도에서 가로가 늘어남에 따라 배너의 높이도 늘어나게 하기 위함
// 93=배너영역의 총 높이(배너높이69 + 하단여백24)
// TimelineBannerView.xib가 현재 (320x93) 사이즈로 되어 있다.
#define TIMELINE_BANNER_HEIGHT (self.frame.size.width * (93.0 / 320.0))	
#define TIMELINE_BANNER_BOTTOM_MARGIN	(24)


@implementation HomeTimeLineView

@synthesize delegate;

@synthesize mTimeLineSection;
@synthesize mTimeLineDic;
@synthesize deletedKeysFromOtherTab;
@synthesize mTimeLineTable;
@synthesize listEmptyView;
@synthesize emptyLabel;
@synthesize emptyScrollView;
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

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onNotificationAlarmDeleted:) name: kNotificationAlarmDeleted object: nil];
}


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
    
    if(datePicker == nil)
    {
        datePicker = [[UIDatePicker alloc] init];
    }
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
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
    
    if([mTimeLineSection count] == 0)
    {
        [mTimeLineTable setHidden:YES];
        [listEmptyView setHidden:NO];
    }
    else
    {
        [mTimeLineTable setHidden:NO];
        [listEmptyView setHidden:YES];
        [mTimeLineTable reloadData];
    }
    
    [self addPullToRefreshHeader];
    [self addPullToRefreshFooter];
    
    LoginUtil *loginUtil = [[LoginUtil alloc] init];
    [self setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
    [mTimeLineTable setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
    [refreshHeaderView setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
    
    // 기능안내 페이지
    if([[NSUserDefaults standardUserDefaults] objectForKey:FIRST_LOGIN_FLAG_FOR_TIMELINE] == nil)
    {
        ServiceFunctionInfoView *guideView = [ServiceFunctionInfoView view];
        [guideView setFrame:CGRectMake(0, 0,
                                       ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame.size.width,
                                       ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame.size.height)];
        [[guideView infoViewButton] setTag:TIMELINE];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view addSubview:guideView];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view bringSubviewToFront:guideView];
        [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:FIRST_LOGIN_FLAG_FOR_TIMELINE];
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
            [emptyLabel setText:@"해당 기간 내 검색 결과가 없습니다."];
        }
        else
        {
            [emptyListImageView setImage:[UIImage imageNamed:@"icon_notice_06.png"]];
            [emptyLabel setText:@"알림 내역이 없습니다."];
        }
    }
    else
    {
        [mTimeLineTable setHidden:NO];
        [listEmptyView setHidden:YES];
        [mTimeLineTable reloadData];
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
    [self stopFooterLoading];
    
    isDeleteMode = NO;
    [self deleteViewHide:nil];
    
    LoginUtil *loginUtil = [[LoginUtil alloc] init];
    [self setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
    [mTimeLineTable setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
    [refreshHeaderView setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
    [self addPullToRefreshFooter];
    [refreshFooterView setHidden:!isMoreList];
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

- (void)addPullToRefreshHeader
{
    textPull = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textRelease = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textLoading = @"Loading";
    
    LoginUtil *loginUtil = [[LoginUtil alloc] init];
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, mTimeLineTable.frame.size.width, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [loginUtil getNoticeBackgroundColour];
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
    
    UIView *refreshEmptyScrollHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, emptyScrollView.frame.size.width, REFRESH_HEADER_HEIGHT)];
    [refreshEmptyScrollHeaderView setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:241.0f/255.0f blue:246.0/255.0f alpha:1.0f]];
    
    refreshEmptyIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_refresh_01.png"]];
    [refreshEmptyIndicator setFrame:CGRectMake(floorf(floorf(refreshHeaderView.frame.size.width - 20) / 2), 11, 30, 30)];
    [refreshEmptyIndicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    refreshEmptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, refreshIndicator.frame.origin.y + refreshIndicator.frame.size.height, emptyScrollView.frame.size.width, 16)];
    refreshEmptyLabel.backgroundColor = [UIColor clearColor];
    refreshEmptyLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [refreshEmptyLabel setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
    refreshEmptyLabel.textAlignment = NSTextAlignmentCenter;
    [refreshEmptyLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    UIView *separateEmptyLine = [[UIView alloc] initWithFrame:CGRectMake(0, REFRESH_HEADER_HEIGHT - 1, emptyScrollView.frame.size.width, 1)];
    [separateEmptyLine setBackgroundColor:[UIColor colorWithRed:208.0/255.0f green:209.0/255.0f blue:214.0/255.0f alpha:1.0f]];
    [separateEmptyLine setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [refreshEmptyScrollHeaderView addSubview:refreshEmptyLabel];
    [refreshEmptyScrollHeaderView addSubview:refreshEmptyIndicator];
    [refreshEmptyScrollHeaderView addSubview:separateEmptyLine];
    [emptyScrollView addSubview:refreshEmptyScrollHeaderView];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, emptyScrollView.frame.size.width, 0)];
    [emptyScrollView setTableFooterView:footerView];
    [emptyScrollView reloadData];
}

- (void)addPullToRefreshFooter
{
    LoginUtil *loginUtil = [[LoginUtil alloc] init];
    CGFloat originY = mTimeLineTable.frame.size.height;
    if(mTimeLineTable.contentSize.height >= mTimeLineTable.frame.size.height)
    {
        originY = mTimeLineTable.contentSize.height;
    }
    
    if(refreshFooterView == nil)
    {
        refreshFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, mTimeLineTable.frame.size.width, REFRESH_HEADER_HEIGHT / 2)];
        [refreshFooterView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
        
        refreshFooterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mTimeLineTable.frame.size.width, refreshFooterView.frame.size.height)];
        refreshFooterLabel.backgroundColor = [UIColor clearColor];
        refreshFooterLabel.font = [UIFont boldSystemFontOfSize:12.0];
        [refreshFooterLabel setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
        refreshFooterLabel.textAlignment = NSTextAlignmentCenter;
        [refreshFooterLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mTimeLineTable.frame.size.width, 1)];
        [separateLine setBackgroundColor:[UIColor colorWithRed:208.0/255.0f green:209.0/255.0f blue:214.0/255.0f alpha:1.0f]];
        [separateLine setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        [refreshFooterView addSubview:refreshFooterLabel];
        [refreshFooterView addSubview:separateLine];
        [mTimeLineTable addSubview:refreshFooterView];
    }
    else
    {
        [refreshFooterView setFrame:CGRectMake(0, originY, mTimeLineTable.frame.size.width, REFRESH_HEADER_HEIGHT / 2)];
    }
    refreshFooterView.backgroundColor = [loginUtil getNoticeBackgroundColour];
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
    if (!listEmptyView.isHidden) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"삭제할 내역이 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
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
//        [deleteButton setEnabled:NO];
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
                    BOOL isPinnedItem = (pinnedIdList != nil && [pinnedIdList containsObject:item.serverMessageKey]);
                    if(!isPinnedItem) {
                        [deleteIdList addObject:item.serverMessageKey];
                    }
                }
            }
            
            [deleteAllImg setHighlighted:YES];
            [deleteAllLabel setTextColor:[UIColor colorWithRed:48.0f/255.0f green:49.0f/255.0f blue:54.0f/255.0f alpha:1.0f]];
//            [deleteButton setEnabled:YES];
            [deleteButton setBackgroundColor:[UIColor colorWithRed:213.0/255.0f green:42.0/255.0f blue:58.0/255.0f alpha:1.0f]];
        }
    }
    
    if([deleteIdList count] > 0)
    {
//        [deleteButton setEnabled:YES];
        [deleteButton setBackgroundColor:[UIColor colorWithRed:213.0/255.0f green:42.0/255.0f blue:58.0/255.0f alpha:1.0f]];
    }
    else
    {
//        [deleteButton setEnabled:NO];
        [deleteButton setBackgroundColor:[UIColor colorWithRed:208.0/255.0f green:209.0/255.0f blue:214.0/255.0f alpha:1.0f]];
    }
    
    [mTimeLineTable reloadData];
}

- (IBAction)deleteSelectedList:(id)sender
{
    // deleteIdList로 삭제를 진행한다.
    if([deleteIdList count] > 0)
    {
        NSString *msg = DELETE_MESSAGE([deleteIdList count]);
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:msg delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        [alertView setTag:70001];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"확인" message:@"삭제할 메시지를 선택해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
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
    
//    [deleteButton setEnabled:NO];
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
    if([searchView isHidden])
    {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [searchView setHidden:NO];
            [searchView setFrame:CGRectMake(0, TOP_MENU_BAR_HEIGHT, self.frame.size.width, searchView.frame.size.height)];
            [self searchPeriodSelect:periodOneMonthBtn];
        }completion:nil];
    }
    else
    {
        [self searchViewHide:nil];
    }
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

- (BOOL)validateSelectedDates {
    
    BOOL isInvalidSelectedDates = NO;
    
    if ([searchStartDate isEqualToString:@""] || [searchEndDate isEqualToString:@""]) {
        isInvalidSelectedDates = YES;
    }
    
    NSDateFormatter * formatter = [StatisticMainUtil getDateFormatterDateServerStyle];
    
    NSDate * fromDate   = [formatter dateFromString:searchStartDate];
    NSDate * toDate     = [formatter dateFromString:searchEndDate];
    
    if ([fromDate compare:toDate] == NSOrderedDescending) {
        isInvalidSelectedDates = YES;
    }
    return isInvalidSelectedDates;
}

- (void)invalidSelectedDatesAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                     message:@"검색 기간이 잘못 설정되었습니다. 기간을 다시 설정한 후 검색하시기 바랍니다."
                                                    delegate:nil
                                           cancelButtonTitle:@"확인"
                                           otherButtonTitles:nil];
    [alert show];
}

// 검색 실행
- (IBAction)searchStart:(id)sender
{
    BOOL isInvalidSelectedDates = [self validateSelectedDates];
    
    if (isInvalidSelectedDates) {
        [self invalidSelectedDatesAlert];
        return;
    }
    
	[mTimeLineSection removeAllObjects];
    [mTimeLineDic removeAllObjects];
	[mTimeLineTable reloadData];
	
	AccountInboxRequestData *reqData = [[AccountInboxRequestData alloc] init];
    reqData.accountNumberList = [[[LoginUtil alloc] init] getAllAccounts];
    reqData.ascending = listSortType;
    reqData.startDate = searchStartDate;
    reqData.endDate = searchEndDate;
    reqData.size = TIMELINE_LOAD_COUNT;
	reqData.queryType = @"ALL";
    
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
    
    [self searchDatePickerHide:nil];
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
            [datePicker setDate:currentDate animated:NO];
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
    
    [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) tabSelect:INBOX];
    
    /*
    CGRect frame = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController = newTopViewController;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame = frame;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController resetTopViewAnimated:NO];*/
}

#pragma mark - 새로고침
- (void)startLoading
{
//    NSLog(@"%s", __FUNCTION__);
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        mTimeLineTable.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        emptyScrollView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = textLoading;
        refreshEmptyLabel.text = textLoading;
        [CommonUtil runSpinAnimationWithDuration:refreshIndicator duration:10.0f];
        [CommonUtil runSpinAnimationWithDuration:refreshEmptyIndicator duration:10.0f];
    }];


#ifdef REMOVE_ALL_WHEN_TOP_REFRESH
	// 데이터를 모두 비우고 새로 받는다.
	[mTimeLineSection removeAllObjects];
	[mTimeLineDic removeAllObjects];
	[mTimeLineTable reloadData];
#else
	// 삭제된 키만 제거한 다음에 추가 데이터를 요청한다
	if (0 < self.deletedKeysFromOtherTab.count) {
		[self deleteMsgAndEmptySection: self.deletedKeysFromOtherTab];
		self.deletedKeysFromOtherTab = nil;
		[mTimeLineTable reloadData];
	}
#endif

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
        emptyScrollView.contentInset = UIEdgeInsetsZero;
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete
{
    // Reset the header
    refreshLabel.text = textPull;
    refreshEmptyLabel.text = textPull;
    [CommonUtil stopSpinAnimation:refreshIndicator];
    [CommonUtil stopSpinAnimation:refreshEmptyIndicator];
}

- (void)refresh
{
#ifdef REMOVE_ALL_WHEN_TOP_REFRESH
	// 데이터를 모두 비우고 새로 받는다.
	if(delegate != nil && [delegate respondsToSelector:@selector(queryInitData)])
    {
        isSearchResult = NO;
        searchStartDate = nil;
        searchEndDate = nil;
        [delegate queryInitData];
    }
#else
	// 삭제된 키만 제거한 다음에 추가 데이터를 요청한다
	if(delegate != nil && [delegate respondsToSelector:@selector(refreshData:requestData:)])
    {
        isSearchResult = NO;
        searchStartDate = nil;
        searchEndDate = nil;
        [delegate refreshData:YES requestData:nil];
    }
#endif
}

- (void)startFooterLoading
{
    if(!isMoreList)
    {
        return;
    }
  
    isLoading = YES;
    // Show the header
    [UIView animateWithDuration:0.5 animations:^{
        [mTimeLineTable setContentInset:UIEdgeInsetsMake(0, 0, REFRESH_HEADER_HEIGHT / 2, 0)];
        refreshFooterLabel.text = textLoading;
    }];
    
    // Refresh action!
    [self refreshFooter];
}

- (void)stopFooterLoading
{
    isLoading = NO;
    
    // Hide the footer
    [UIView animateWithDuration:0.5 animations:^{
        mTimeLineTable.contentInset = UIEdgeInsetsZero;
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopFooterLoadingComplete)];
                     }];
}

- (void)stopFooterLoadingComplete
{
    // Reset the header
    if(!isMoreList)
    {
        [refreshFooterView setHidden:YES];
    }
    refreshFooterLabel.text = textPull;
}

- (void)refreshFooter
{
    if(delegate != nil && [delegate respondsToSelector:@selector(refreshData:requestData:)] && isMoreList)
    {
        if(isSearchResult)
        {
            AccountInboxRequestData *reqData = [[AccountInboxRequestData alloc] init];
            reqData.ascending = listSortType;
            reqData.startDate = searchStartDate;
            reqData.endDate = searchEndDate;
            reqData.size = TIMELINE_LOAD_COUNT;
            [delegate refreshData:NO requestData:reqData];
        }
        else
        {
            [delegate refreshData:NO requestData:nil];
        }
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == emptyScrollView)
    {
        return 1;
    }
    else
    {
        return [mTimeLineSection count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == emptyScrollView)
    {
        return 1;
    }
    else
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == emptyScrollView)
    {
        return 0;
    }
    else
    {
        return SECTION_HEADER_HEIGHT;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == emptyScrollView)
    {
        return nil;
    }
    else
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == emptyScrollView)
    {
        return 100.0f;
    }
    else
    {
        NSString *section = ((TimelineSectionData *)[mTimeLineSection objectAtIndex:indexPath.section]).date;
        NHInboxMessageData *inboxData = [[mTimeLineDic objectForKey:section] objectAtIndex:indexPath.row];
        
        if(indexPath.section == 0 && indexPath.row == bannerIndex && inboxData == nil)
        {
            return TIMELINE_BANNER_HEIGHT;
        }
        else if(indexPath.section == 0 && indexPath.row == bannerIndex && !isSearchResult && !isDeleteMode)
        {
            return [self getTimelineCellHeight:(StickerType)inboxData.stickerCode] + TIMELINE_BANNER_HEIGHT;
        }
        else
        {
            return [self getTimelineCellHeight:(StickerType)inboxData.stickerCode];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == emptyScrollView)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, emptyScrollView.frame.size.width, 100.0f)];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:emptyListImageView];
        [cell.contentView addSubview:emptyLabel];
        [cell setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:241.0f/255.0f blue:246.0/255.0f alpha:1.0f]];
        
		CGFloat x = (CGRectGetWidth(cell.contentView.frame) - CGRectGetWidth(emptyListImageView.frame)) / 2.0;
		emptyListImageView.frame = CGRectMake(x, emptyListImageView.frame.origin.y, emptyListImageView.frame.size.width, emptyListImageView.frame.size.height);
		x = (CGRectGetWidth(cell.contentView.frame) - CGRectGetWidth(emptyLabel.frame)) / 2.0;
		emptyLabel.frame = CGRectMake(x, emptyLabel.frame.origin.y, emptyLabel.frame.size.width, emptyLabel.frame.size.height);

        return cell;
    }
    else
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
            
			// 배너 컨테이너뷰의 높이 조정
			[bannerView.bannerContentView setFrame: CGRectMake(bannerView.bannerContentView.frame.origin.x,
															   bannerView.bannerContentView.frame.origin.y,
															   bannerView.bannerContentView.frame.size.width,
															   TIMELINE_BANNER_HEIGHT - TIMELINE_BANNER_BOTTOM_MARGIN)];
			
			[bannerInfoView setFrame:CGRectMake(0, 0, bannerView.bannerContentView.frame.size.width, bannerView.bannerContentView.frame.size.height)];
            [bannerView.bannerContentView addSubview:bannerInfoView];
            
            BOOL existNoticeBanner  = ((AppDelegate *)[UIApplication sharedApplication].delegate).noticeBannerImg ? YES : NO;
            if (existNoticeBanner) {
                [bannerInfoView bannerTimerStart];
            }
            
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
                    
                    if(pinnedIdList != nil && [pinnedIdList containsObject:inboxData.serverMessageKey])
                    {
                        [cell.pinButton setHidden:NO];
                        //[cell.stickerButton setEnabled:NO];
                    }
                    else
                    {
                        [cell.pinButton setHidden:YES];
                    }
                    
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
                NSString *amount = @"";
                NSString *balance = @"";
                amount = [numFomatter stringFromNumber:[NSNumber numberWithInteger:inboxData.amount]];
                /*
                if(inboxData.amount >= 0)
                {
                    amount = [numFomatter stringFromNumber:[NSNumber numberWithInteger:inboxData.amount]];
                }*/
                
                balance = [numFomatter stringFromNumber:[NSNumber numberWithInteger:inboxData.balance]];
                /*
                if(inboxData.balance >= 0)
                {
                    balance = [numFomatter stringFromNumber:[NSNumber numberWithInteger:-1000]];
                }*/
                
                // 금액 String size
                CGSize amountSize = [CommonUtil getStringFrameSize:amount fontSize:AMOUNT_FONT_SIZE bold:YES];
                
                // 화폐단위(없을경우 디폴트 : 원)
                if(inboxData.payType != nil && [inboxData.payType length] > 0)
                {
                    CGRect descFrame = cell.amountDescLabel.frame;
                    [cell.amountDescLabel setText:inboxData.payType];
                    [cell.amountDescLabel sizeToFit];
                    [cell.amountDescLabel setFrame:CGRectMake(descFrame.origin.x,
                                                              descFrame.origin.y,
                                                              cell.amountDescLabel.frame.size.width,
                                                              descFrame.size.height)];
                }
                
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
                    case STICKER_DEPOSIT_MODIFY:
                    {
                        // 입금 수정
                        [cell.typeLabel setText:@"입금정정"];
                        [cell.typeLabel setTextColor:INCOME_STRING_COLOR];
                        CGSize typeLabelSize = cell.typeLabel.frame.size;
                        [cell.typeLabel sizeToFit];
                        [cell.typeLabel setFrame:CGRectMake(cell.typeLabel.frame.origin.x,
                                                            cell.typeLabel.frame.origin.y,
                                                            cell.typeLabel.frame.size.width,
                                                            typeLabelSize.height)];
                        // 금액
                        [cell.amountLabel setFrame:CGRectMake(cell.typeLabel.frame.origin.x + cell.typeLabel.frame.size.width + 2,
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
                    case STICKER_DEPOSIT_CANCEL:
                    {
                        // 입금 취소
                        [cell.typeLabel setText:@"입금취소"];
                        [cell.typeLabel setTextColor:INCOME_STRING_COLOR];
                        CGSize typeLabelSize = cell.typeLabel.frame.size;
                        [cell.typeLabel sizeToFit];
                        [cell.typeLabel setFrame:CGRectMake(cell.typeLabel.frame.origin.x,
                                                            cell.typeLabel.frame.origin.y,
                                                            cell.typeLabel.frame.size.width,
                                                            typeLabelSize.height)];
                        // 금액
                        [cell.amountLabel setFrame:CGRectMake(cell.typeLabel.frame.origin.x + cell.typeLabel.frame.size.width + 2,
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
                    case STICKER_WITHDRAW_MODIFY:
                    {
                        // 출금수정
                        [cell.typeLabel setText:@"출금정정"];
                        [cell.typeLabel setTextColor:WITHDRAW_STRING_COLOR];
                        CGSize typeLabelSize = cell.typeLabel.frame.size;
                        [cell.typeLabel sizeToFit];
                        [cell.typeLabel setFrame:CGRectMake(cell.typeLabel.frame.origin.x,
                                                            cell.typeLabel.frame.origin.y,
                                                            cell.typeLabel.frame.size.width,
                                                            typeLabelSize.height)];
                        [cell.amountLabel setFrame:CGRectMake(cell.typeLabel.frame.origin.x + cell.typeLabel.frame.size.width + 2,
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
                    case STICKER_WITHDRAW_CANCEL:
                    {
                        // 출금취소
                        [cell.typeLabel setText:@"출금취소"];
                        [cell.typeLabel setTextColor:WITHDRAW_STRING_COLOR];
                        CGSize typeLabelSize = cell.typeLabel.frame.size;
                        [cell.typeLabel sizeToFit];
                        [cell.typeLabel setFrame:CGRectMake(cell.typeLabel.frame.origin.x,
                                                            cell.typeLabel.frame.origin.y,
                                                            cell.typeLabel.frame.size.width,
                                                            typeLabelSize.height)];
                        [cell.amountLabel setFrame:CGRectMake(cell.typeLabel.frame.origin.x + cell.typeLabel.frame.size.width + 2,
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
                
                if(indexPath.section == 0 && indexPath.row == bannerIndex && !isSearchResult && !isDeleteMode)
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
                    
					// 배너 컨테이너뷰의 높이 조정
					[bannerView.bannerContentView setFrame: CGRectMake(bannerView.bannerContentView.frame.origin.x,
																	   bannerView.bannerContentView.frame.origin.y,
																	   bannerView.bannerContentView.frame.size.width,
																	   TIMELINE_BANNER_HEIGHT - TIMELINE_BANNER_BOTTOM_MARGIN)];
					
					[bannerInfoView setFrame:CGRectMake(0, 0, bannerView.bannerContentView.frame.size.width, bannerView.bannerContentView.frame.size.height)];
                    [bannerView.bannerContentView addSubview:bannerInfoView];
                    
                    
                    //[bannerInfoView bannerTimerStart];
                    BOOL existNoticeBanner  = ((AppDelegate *)[UIApplication sharedApplication].delegate).noticeBannerImg ? YES : NO;
                    if (existNoticeBanner) {
                        [bannerInfoView bannerTimerStart];
                    }
                    
                    
                    
                    if([(NSArray *)[mTimeLineDic objectForKey:section] count] > bannerIndex + 1)
                    {
                        [bannerView.underLine setHidden:NO];
                    }
                    else
                    {
                        [bannerView.underLine setHidden:YES];
                    }
                    
                    [cell.separateLine setHidden:YES];
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
                
                if([inboxData.inboxType isEqualToString:@"A"])
                {
                    [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, TIMELINE_ETC_HEIGHT)];
                    [cell.depthImage setHidden:YES];
                    // 타이틀
                    [cell.titleLabel setText:@"환율알림"];
                    // 내용
                    [cell.contentLabel setText:inboxData.text];
                    [cell.contentLabel sizeToFit];
                    
                }
                else if([inboxData.inboxType isEqualToString:@"B"])
                {
                    [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, TIMELINE_ETC_NOTICE_HEIGHT)];
                    [cell.depthImage setHidden:NO];
                    // 타이틀
                    [cell.titleLabel setText:@"e금융인증번호"];
                    // 내용
                    [cell.contentLabel setText:inboxData.text];
                    [cell.contentLabel setNumberOfLines:1];
                    CGSize cellSize = cell.contentLabel.frame.size;
                    [cell.contentLabel sizeToFit];
                    [cell.contentLabel setFrame:CGRectMake(cell.contentLabel.frame.origin.x,
                                                           cell.contentLabel.frame.origin.y,
                                                           cellSize.width,
                                                           cell.contentLabel.frame.size.height)];
                }
                else if([inboxData.inboxType isEqualToString:@"Z"] || inboxData.stickerCode == STICKER_NOTICE_NORMAL)
                {
                    [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, TIMELINE_ETC_NOTICE_HEIGHT)];
                    [cell.depthImage setHidden:NO];
                    // 타이틀
                    [cell.titleLabel setText:@"농협알림"];
                    // 내용
                    [cell.contentLabel setNumberOfLines:1];
                    [cell.contentLabel setText:inboxData.text];
                    [cell.contentLabel setLineBreakMode:NSLineBreakByTruncatingTail];
                    CGSize cellSize = cell.contentLabel.frame.size;
                    [cell.contentLabel sizeToFit];
                    [cell.contentLabel setFrame:CGRectMake(cell.contentLabel.frame.origin.x,
                                                           cell.contentLabel.frame.origin.y,
                                                           cellSize.width,
                                                           cell.contentLabel.frame.size.height)];
                }
                else
                {
                    [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, TIMELINE_ETC_HEIGHT)];
                    [cell.depthImage setHidden:YES];
                    // 타이틀
                    [cell.titleLabel setText:inboxData.title];
                    // 내용
                    [cell.contentLabel setText:inboxData.text];
                    [cell.contentLabel sizeToFit];
                }
                /*
                 // 공지 타이틀
                 [cell.titleLabel setText:inboxData.title];
                 // 공지 내용
                 [cell.contentLabel setText:inboxData.text];
                 [cell.contentLabel sizeToFit];*/
                
                if(indexPath.section == 0 && indexPath.row == bannerIndex && !isSearchResult && !isDeleteMode)
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
                    
					// 배너 컨테이너뷰의 높이 조정
					[bannerView.bannerContentView setFrame: CGRectMake(bannerView.bannerContentView.frame.origin.x,
																	   bannerView.bannerContentView.frame.origin.y,
																	   bannerView.bannerContentView.frame.size.width,
																	   TIMELINE_BANNER_HEIGHT - TIMELINE_BANNER_BOTTOM_MARGIN)]; 
					
                    [bannerInfoView setFrame:CGRectMake(0, 0, bannerView.bannerContentView.frame.size.width, bannerView.bannerContentView.frame.size.height)];
                    [bannerView.bannerContentView addSubview:bannerInfoView];
                    
                    //[bannerInfoView bannerTimerStart];
                    BOOL existNoticeBanner  = ((AppDelegate *)[UIApplication sharedApplication].delegate).noticeBannerImg ? YES : NO;
                    if (existNoticeBanner) {
                        [bannerInfoView bannerTimerStart];
                    }
                    
                    if([(NSArray *)[mTimeLineDic objectForKey:section] count] > bannerIndex + 1)
                    {
                        [bannerView.underLine setHidden:NO];
                    }
                    else
                    {
                        [bannerView.underLine setHidden:YES];
                    }
                    
//                    [cell.contentLabel sizeToFit];
                    
                    [cell.separateLine setHidden:YES];
                }
                
                return cell;
            }
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *section = ((TimelineSectionData *)[mTimeLineSection objectAtIndex:indexPath.section]).date;
    NHInboxMessageData *inboxData = [[mTimeLineDic objectForKey:section] objectAtIndex:indexPath.row];
    
    if([inboxData.inboxType isEqualToString:@"B"] || [inboxData.inboxType isEqualToString:@"Z"] || inboxData.stickerCode == STICKER_NOTICE_NORMAL)
    {
        HomeEtcDetailViewController *vc = [[HomeEtcDetailViewController alloc] init];
        [vc setInboxData:inboxData];
        ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController pushViewController:eVC animated:YES];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
    if(isDeleteMode) return;
//    if(isSearchResult) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isLoading)
    {
        // Update the content inset, good for section headers
        /*
        else if(scrollView.contentOffset.y + mTimeLineTable.frame.size.height >= mTimeLineTable.contentSize.height)
        {
            mTimeLineTable.contentInset = UIEdgeInsetsMake(0, 0, (scrollView.contentOffset.y + mTimeLineTable.frame.size.height) - mTimeLineTable.contentSize.height, 0);
        }*/
        if (scrollView.contentOffset.y > 0)
        {
            mTimeLineTable.contentInset = UIEdgeInsetsZero;
            emptyScrollView.contentInset = UIEdgeInsetsZero;
        }
        else if (scrollView.contentOffset.y < 0 && scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
        {
            mTimeLineTable.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
            emptyScrollView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        }
    }
    else if (isDragging && scrollView.contentOffset.y <= 0)
    {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = textRelease;
                refreshEmptyLabel.text = textRelease;
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = textPull;
                refreshEmptyLabel.text = textPull;
            }
        }];
        
        if(delegate != nil && [delegate respondsToSelector:@selector(hideScrollTopButton)])
        {
            [delegate performSelector:@selector(hideScrollTopButton) withObject:nil];
        }
    }
    else if (isDragging && scrollView.contentOffset.y + mTimeLineTable.frame.size.height >= mTimeLineTable.contentSize.height && ![mTimeLineTable isHidden])
    {
        refreshFooterLabel.text = textPull;
    }
    
    if(isDragging && scrollView.contentOffset.y > 0 && ![mTimeLineTable isHidden])
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
//    if(isSearchResult) return;
    isDragging = NO;
    
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT)
    {
        // Released above the header
        [self startLoading];
    }
    else if(scrollView.contentOffset.y + mTimeLineTable.frame.size.height - mTimeLineTable.contentSize.height >= REFRESH_HEADER_HEIGHT && ![mTimeLineTable isHidden])
    {
        // 스크롤이 끝까지 내려가면 이전 목록을 불러와 리프레쉬 한다.
        [self startFooterLoading];
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
        
        BOOL isPinnedItem = (pinnedIdList != nil && [pinnedIdList containsObject:pushId]);
        if(isPinnedItem) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"고정핀이 적용된 메시지는 삭제되지 않습니다."
                                                            delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
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
    
    if (isDeleteMode) {
        [currentBtn setHidden:YES];
    }
}

- (void)moreButtonClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBadges) name:NOTIFICATION_REFRESH_BADGES object:nil];
    
    IndexPathButton *currentButton = (IndexPathButton *)sender;
    NSIndexPath *indexPath = currentButton.indexPath;
    
    NHInboxMessageData *inboxData = [[mTimeLineDic objectForKey:((TimelineSectionData *)[mTimeLineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row];
    HomeTimeLineTableViewCell *cell = [mTimeLineTable cellForRowAtIndexPath:indexPath];
    
    NSString * currencyUnit = (!inboxData.payType || [inboxData.payType isEqualToString:@""]) ? @"원" : inboxData.payType;
    TransactionObject * transation = [[TransactionObject alloc] initTransactionObjectWithTransactionId:inboxData.serverMessageKey
                                                                                       transactionDate:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]
                                                                              transactionAccountNumber:[CommonUtil getAccountNumberAddDash:inboxData.nhAccountNumber]
                                                                                transactionAccountType:@""
                                                                                    transactionDetails:inboxData.oppositeUser
                                                                                       transactionType:[NSString stringWithFormat:@"%d", inboxData.stickerCode]
                                                                                     transactionAmount:@(inboxData.amount)
                                                                                    transactionBalance:@(inboxData.balance)
                                                                                          currencyUnit:currencyUnit
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
        case STICKER_DEPOSIT_MODIFY:
        case STICKER_DEPOSIT_CANCEL:
        case STICKER_WITHDRAW_MODIFY:
        case STICKER_WITHDRAW_CANCEL:
        {
            return TIMELINE_BANKING_HEIGHT;
            break;
        }
        case STICKER_EXCHANGE_RATE:
        case STICKER_ETC:
        {
            return TIMELINE_ETC_HEIGHT;
            break;
        }
        case STICKER_NOTICE_NORMAL:
        {
            return TIMELINE_ETC_NOTICE_HEIGHT;
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
        case STICKER_DEPOSIT_MODIFY:
        case STICKER_DEPOSIT_CANCEL:
        case STICKER_WITHDRAW_MODIFY:
        case STICKER_WITHDRAW_CANCEL:
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == 70001 && buttonIndex == BUTTON_INDEX_OK)
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
}

#pragma mark - notification

- (void) onNotificationAlarmDeleted: (NSNotification*)notification {
	NSDictionary* userInfo = [notification userInfo];
	NSArray* keyAry = userInfo[kMsgKeyArray];
	
	// 현재 탭이 삭제모드일 경우만 배열에서 해당하는 키를 제거한다.
	if (YES == isDeleteMode) {
		[self deleteMsgAndEmptySection: keyAry];	
		[self deleteViewHide: nil];
		[mTimeLineTable reloadData];
	}
	
	// 그렇지 않은 경우 삭제된 키드를 저장해 뒀다가 서버에 데이터를 요구할 때 지운다.
	// 안드로이드와 동작을 맞추기 위함이다.
	else {
		self.deletedKeysFromOtherTab = keyAry;
	}

}


#pragma mark - etc

/**
   키배열에서 키들을 삭제한 다음 빈 섹션이 있으면 제거한다.
   @param 
*/
- (void) deleteMsgAndEmptySection:(NSArray*)keyAry {
	for(NSString * key in keyAry) {
		[self deleteMsgByKey: key];
	}
	
	[self removeEmptySection];
}


- (void) deleteMsgByKey:(NSString *)aKey
{
	for(TimelineSectionData* section in mTimeLineSection) {
		NSMutableArray* ary = [mTimeLineDic objectForKey:section.date];
		for(NHInboxMessageData* inboxData in ary) {
			if ([aKey isEqualToString: inboxData.serverMessageKey]) {
				[ary removeObject: inboxData];
				return;
			}
		}
	}
}

- (void) removeEmptySection {
	NSMutableArray *emptySections = [[NSMutableArray alloc] init];
	for(TimelineSectionData* section in mTimeLineSection) {
		NSMutableArray* ary = [mTimeLineDic objectForKey:section.date];
		if (0 == [ary count]) {
			[mTimeLineDic removeObjectForKey: section.date];
			[emptySections addObject: section];
		}
	}

	[mTimeLineSection removeObjectsInArray: emptySections];
}

@end
