//
//  HomeBankingView.m
//  입출금 내역 뷰
//
//  Created by Infobank1 on 2015. 10. 6..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "HomeBankingView.h"
#import "HomeTimeLineTableViewCell.h"
#import "TransactionObject.h"
#import "StorageBoxUtil.h"
#import "MainPageViewController.h"
#import "HomeViewController.h"
#import "StorageBoxController.h"
#import "LoginUtil.h"

@implementation HomeBankingView

@synthesize delegate;
@synthesize timeLineSection;
@synthesize timeLineDic;
@synthesize bankingListTable;
@synthesize listEmptyView;
@synthesize statisticButton;
@synthesize sortLabel;

@synthesize deleteAllView;
@synthesize deleteButtonView;
@synthesize deleteButton;
@synthesize deleteAllImg;
@synthesize deleteAllLabel;

@synthesize searchView;
@synthesize searchStartDateLabel;
@synthesize searchEndDateLabel;
@synthesize datePickerView;
@synthesize datePicker;
@synthesize searchTypePickerView;
@synthesize searchTypePicker;
@synthesize searchTypeAccountLabel;
@synthesize searchTypeInboxLabel;
@synthesize isSearchResult;
@synthesize isMoreList;

@synthesize storageCountLabel;

- (id)init
{
    self = [super init];
    
    if(self)
    {
        timeLineSection = [[NSMutableArray alloc] init];
        timeLineDic = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data
{
    timeLineSection = section;
    timeLineDic = data;
    listSortType = YES;
    isDeleteMode = NO;
    isMoreList = YES;
    pinnedIdList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:TIMELINE_PIN_MESSAGE_ID]];
    if(pinnedIdList == nil)
    {
        pinnedIdList = [[NSMutableArray alloc] init];
    }
    deleteIdList = [[NSMutableArray alloc] init];
    
    [self refreshBadges];
    
    allAccountList = [NSMutableArray arrayWithArray:[[[LoginUtil alloc] init] getAllAccounts]];
    [allAccountList insertObject:@"전체계좌" atIndex:0];
    inboxTypeList = @[@"입출금", @"입금", @"출금"];
    inboxAccountsIndex = 0;
    inboxTypeIndex = 0;
    inboxTypePickerMode = 0;
    [searchTypePicker setDataSource:self];
    [searchTypePicker setDelegate:self];
    
    if([timeLineSection count] == 0)
    {
        [bankingListTable setHidden:YES];
        [listEmptyView setHidden:NO];
    }
    else
    {
        [bankingListTable setHidden:NO];
        [listEmptyView setHidden:YES];
    }
    
    [self addPullToRefreshHeader];
}

- (void)refreshData
{
    pinnedIdList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:TIMELINE_PIN_MESSAGE_ID]];
    
    [self refreshBadges];
    
    if([timeLineSection count] == 0)
    {
        [bankingListTable setHidden:YES];
        [listEmptyView setHidden:NO];
    }
    else
    {
        [bankingListTable setHidden:NO];
        [listEmptyView setHidden:YES];
    }
    
    if(!listSortType)
    {
        // section을 먼저 sorting한다.
        timeLineSection = (NSMutableArray *)[[timeLineSection reverseObjectEnumerator] allObjects];
        // sorting된 section을 가지고 dictionary를 구성한다.
        NSMutableDictionary *reverseDic = [[NSMutableDictionary alloc] init];
        for(TimelineSectionData *sectionData in timeLineSection)
        {
            NSArray *reverseArray = [[[timeLineDic objectForKey:sectionData.date] reverseObjectEnumerator] allObjects];
            [reverseDic setObject:reverseArray forKey:sectionData.date];
        }
        timeLineDic = reverseDic;
    }
    [self stopLoading];
    isDeleteMode = NO;
    [self deleteViewHide:nil];
}

- (void)refreshBadges {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_REFRESH_BADGES object:nil];
    
    StorageBoxController * controller = [[StorageBoxController alloc] init];
    storageCount = [[controller getAllTransactions] count];
    if(storageCount < 100)
    {
        [storageCountLabel setText:[NSString stringWithFormat:@"%ld", (long)storageCount]];
    }
    else
    {
        [storageCountLabel setText:@"99+"];
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    LoginUtil *loginUtil = [[LoginUtil alloc] init];
    [self setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
    [bankingListTable setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
}

#pragma mark - UIButton Action
- (IBAction)listSortChange:(id)sender
{
    listSortType = !listSortType;
    
    // section을 먼저 sorting한다.
    timeLineSection = (NSMutableArray *)[[timeLineSection reverseObjectEnumerator] allObjects];
    // sorting된 section을 가지고 dictionary를 구성한다.
    NSMutableDictionary *reverseDic = [[NSMutableDictionary alloc] init];
    for(TimelineSectionData *sectionData in timeLineSection)
    {
        NSArray *reverseArray = [[[timeLineDic objectForKey:sectionData.date] reverseObjectEnumerator] allObjects];
        [reverseDic setObject:reverseArray forKey:sectionData.date];
    }
    timeLineDic = reverseDic;
    
    if(listSortType)
    {
        [sortLabel setText:@"최신순"];
    }
    else
    {
        [sortLabel setText:@"과거순"];
    }
    
    [bankingListTable reloadData];
}

- (IBAction)storageMoveClick:(id)sender
{
    MainPageViewController *newTopViewController = [[MainPageViewController alloc] init];
    [newTopViewController setStartPageIndex:INBOX];
    
    CGRect frame = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController = newTopViewController;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame = frame;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController resetTopViewAnimated:NO];
}

#pragma mark - UITableView PullToRefreshView
- (void)addPullToRefreshHeader
{
    textPull = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textRelease = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textLoading = @"Loading...";
    
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, bankingListTable.frame.size.width, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    [refreshHeaderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    refreshIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_refresh_01.png"]];
    [refreshIndicator setFrame:CGRectMake(floorf(floorf(refreshHeaderView.frame.size.width - 20) / 2), 11, 30, 30)];
    [refreshIndicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, refreshIndicator.frame.origin.y + refreshIndicator.frame.size.height, bankingListTable.frame.size.width, 16)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [refreshLabel setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    [refreshLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshIndicator];
    [bankingListTable addSubview:refreshHeaderView];
}

- (void)startLoading
{
//    NSLog(@"%s", __FUNCTION__);
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        bankingListTable.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
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
        bankingListTable.contentInset = UIEdgeInsetsZero;
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
//    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    if(delegate != nil && [delegate respondsToSelector:@selector(refreshData:)])
    {
        [delegate refreshData:YES];
    }
}

#pragma mark - 검색 Action
- (IBAction)searchViewShow:(id)sender
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [searchView setHidden:NO];
        [searchView setFrame:CGRectMake(0, 0, self.frame.size.width, searchView.frame.size.height)];
    }completion:nil];
}

- (IBAction)searchViewHide:(id)sender
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [searchView setFrame:CGRectMake(0, -searchView.frame.size.height, self.frame.size.width, searchView.frame.size.height)];
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
    NSString *fromDateString = [CommonUtil getFormattedDateStringWithIndex:@"yyyy.MM.dd" indexDay:-[sender tag]];
    [searchStartDateLabel setText:fromDateString];
    searchStartDate = [fromDateString stringByReplacingOccurrencesOfString:@"." withString:@""];
}

// 검색 실행
- (IBAction)searchStart:(id)sender
{
    /*
    if(searchStartDate == nil || [searchStartDate length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"검색 시작일을 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if(searchEndDate == nil || [searchEndDate length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"검색 종료일을 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }*/
    
    AccountInboxRequestData *reqData = [[AccountInboxRequestData alloc] init];
    if(inboxAccountsIndex == 0)
    {
        // 전체계좌 검색
        NSMutableArray *accountList = [NSMutableArray arrayWithArray:allAccountList];
        [accountList removeObjectAtIndex:0];
        reqData.accountNumberList = accountList;
    }
    else
    {
        reqData.accountNumberList = @[[allAccountList objectAtIndex:inboxAccountsIndex]];
    }

    reqData.ascending = listSortType;
    reqData.startDate = searchStartDate;
    reqData.endDate = searchEndDate;
    
    if(inboxTypeIndex == 0)
    {
        reqData.queryType = @"1,2";
    }
    else if(inboxTypeIndex == 1)
    {
        reqData.queryType = @"1";
    }
    else if(inboxTypeIndex == 2)
    {
        reqData.queryType = @"2";
    }
    
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
        searchEndDate = [selectedDateString stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
    else
    {
        [searchStartDateLabel setText:selectedDateString];
        searchStartDate = [selectedDateString stringByReplacingOccurrencesOfString:@"." withString:@""];
    }
    
    [datePickerView setHidden:YES];
}

// DatePickerView 보여줌
- (IBAction)searchDatePickerShow:(id)sender
{
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
    [datePickerView setHidden:YES];
}

- (IBAction)showInboxTypePickerShow:(id)sender
{
    inboxTypePickerMode = [sender tag];
    [searchTypePickerView setHidden:NO];
    [searchTypePicker reloadAllComponents];
    if(inboxTypePickerMode == 0)
    {
        [searchTypePicker selectRow:inboxAccountsIndex inComponent:0 animated:YES];
    }
    else if(inboxTypePickerMode == 1)
    {
        [searchTypePicker selectRow:inboxTypeIndex inComponent:0 animated:YES];
    }
}

- (IBAction)inboxTypeSelect:(id)sender
{
    if(inboxTypePickerMode == 0)
    {
        [searchTypeAccountLabel setText:[allAccountList objectAtIndex:inboxAccountsIndex]];
    }
    else if(inboxTypePickerMode == 1)
    {
        [searchTypeInboxLabel setText:[inboxTypeList objectAtIndex:inboxTypeIndex]];
    }
    
    [self inboxTypePickerHide:nil];
}

- (IBAction)inboxTypePickerHide:(id)sender
{
    [searchTypePickerView setHidden:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(inboxTypePickerMode == 0)
    {
        return [allAccountList count];
    }
    else if(inboxTypePickerMode == 1)
    {
        return [inboxTypeList count];
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(inboxTypePickerMode == 0)
    {
        return [allAccountList objectAtIndex:row];
    }
    else if(inboxTypePickerMode == 1)
    {
        return [inboxTypeList objectAtIndex:row];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(inboxTypePickerMode == 0)
    {
        inboxAccountsIndex = row;
    }
    else if(inboxTypePickerMode == 1)
    {
        inboxTypeIndex = row;
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [timeLineSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([timeLineSection count] == 0)
    {
        return 0;
    }
    else
    {
        
        NSArray *array = [timeLineDic objectForKey:((TimelineSectionData *)[timeLineSection objectAtIndex:section]).date];
        return [array count];
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
    
    TimelineSectionData *sectionData = [timeLineSection objectAtIndex:section];
    NSString *date = sectionData.date;
    NSString *day = sectionData.day;
    
    CGSize dateSize = [CommonUtil getStringFrameSize:date fontSize:12.0 bold:YES];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    NSString *section = ((TimelineSectionData *)[timeLineSection objectAtIndex:indexPath.section]).date;
    NHInboxMessageData *inboxData = [[timeLineDic objectForKey:section] objectAtIndex:indexPath.row];
    
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
        else if ([(NSArray *)[timeLineDic objectForKey:section] count] - 1 == indexPath.row)
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
        [cell.accountLabel setText:[NSString stringWithFormat:@"%@ %@", accountNickName, inboxData.nhAccountNumber]];
    }
    else
    {
        [cell.accountLabel setText:inboxData.nhAccountNumber];
    }
    
    // 잔액
    [cell.remainAmountLabel setText:[NSString stringWithFormat:@"잔액 %@원", balance]];
    
    // 고정핀
    [cell.pinButton setIndexPath:indexPath];
    [cell.pinButton addTarget:self action:@selector(pinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // more 버튼
    [cell.moreButton setIndexPath:indexPath];
    [cell.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(indexPath.row == 0)
    {
        [cell.upperLine setHidden:YES];
    }
    else if ([(NSArray *)[timeLineDic objectForKey:section] count] - 1 == indexPath.row)
    {
        [cell.underLine setHidden:YES];
    }
    
    if(pinnedIdList != nil && [pinnedIdList containsObject:inboxData.serverMessageKey])
    {
        [cell.pinButton setSelected:YES];
    }
    
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

#pragma mark - UIButtonAction
- (void)stickerButtonClick:(id)sender
{
    IndexPathButton *currentBtn = (IndexPathButton *)sender;
    NSIndexPath *indexPath = currentBtn.indexPath;
    
    if(isDeleteMode)
    {
        NSString *pushId = ((NHInboxMessageData *)[[timeLineDic objectForKey:((TimelineSectionData *)[timeLineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row]).serverMessageKey;
        
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
    NSIndexPath *indexPath = currentBtn.indexPath;
    
//    NSLog(@"button indexPath = %@", currentBtn.indexPath);
    
    NHInboxMessageData *inboxData = [[timeLineDic objectForKey:((TimelineSectionData *)[timeLineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row];
    
    if([currentBtn isSelected])
    {
        // 고정핀 해제를 위해 디바이스에서 해당 인덱스패스에 있는 푸시 아이디를 삭제한다.
        if([pinnedIdList containsObject:inboxData.serverMessageKey])
        {
            [pinnedIdList removeObject:inboxData.serverMessageKey];
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
    NHInboxMessageData *inboxData = [[timeLineDic objectForKey:((TimelineSectionData *)[timeLineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row];
    HomeTimeLineTableViewCell *cell = [bankingListTable cellForRowAtIndexPath:indexPath];
    
    TransactionObject * transation = [[TransactionObject alloc] initTransactionObjectWithTransactionId:inboxData.serverMessageKey
                                                                                       transactionDate:[NSDate dateWithTimeIntervalSince1970:inboxData.regDate/1000]
                                                                              transactionAccountNumber:inboxData.nhAccountNumber
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
            bankingListTable.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            bankingListTable.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
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
    if (isLoading) return;
    if(isDeleteMode) return;
    if(isSearchResult) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT)
    {
        // Released above the header
        [self startLoading];
    }
    else if(scrollView.contentOffset.y + bankingListTable.frame.size.height >= bankingListTable.contentSize.height)
    {
//        NSLog(@"scrollView.contentOffset.y = %f, tableViewContentSize = %f, tableViewHeight = %f", scrollView.contentOffset.y, bankingListTable.contentSize.height, bankingListTable.frame.size.height);
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

#pragma mark - delete mode
- (IBAction)deleteMode:(id)sender
{
    isDeleteMode = YES;
    
    [deleteAllView setHidden:NO];
    [deleteAllImg setHighlighted:NO];
    [deleteAllLabel setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [deleteButtonView setHidden:NO];
        [deleteButtonView setFrame:CGRectMake(0, self.frame.size.height - deleteButtonView.frame.size.height, self.frame.size.width, deleteButtonView.frame.size.height)];
    }completion:nil];
    
    [bankingListTable reloadData];
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
        if([timeLineSection count] > 0)
        {
            // 리스트가 있는 경우에만 진행한다
            if([deleteIdList count] > 0)
            {
                [deleteIdList removeAllObjects];
            }
            
            for(TimelineSectionData *sectionData in timeLineSection)
            {
                NSString *key = sectionData.date;
                NSArray *list = [timeLineDic objectForKey:key];
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
    
    [bankingListTable reloadData];
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
    
    [bankingListTable reloadData];
}
@end
