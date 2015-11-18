//
//  HomeEtcTimeLineView.m
//  알림 - 기타
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "HomeEtcTimeLineView.h"
#import "HomeEtcTimeLineCell.h"
#import "TimelineSectionData.h"
#import "LoginUtil.h"
#import "HomeViewController.h"
#import "HomeEtcDetailViewController.h"

@implementation HomeEtcTimeLineView

@synthesize delegate;
@synthesize timelineTableView;
@synthesize listEmptyView;
@synthesize timelineSection;
@synthesize timelineDic;

@synthesize deleteAllView;
@synthesize deleteButtonView;
@synthesize deleteAllImg;
@synthesize deleteAllLabel;
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

@synthesize emptyListImageView;

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data
{
    timelineSection = section;
    timelineDic = data;
    deleteIdList = [[NSMutableArray alloc] init];
    isSearchResult = NO;
    isMoreList = YES;
    
    if([timelineSection count] == 0)
    {
        [timelineTableView setHidden:YES];
        [listEmptyView setHidden:NO];
    }
    else
    {
        [timelineTableView setHidden:NO];
        [listEmptyView setHidden:YES];
    }
    
    [self addPullToRefreshHeader];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    LoginUtil *loginUtil = [[LoginUtil alloc] init];
    [self setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
    [timelineTableView setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
}

- (void)refreshData
{
    if([timelineSection count] == 0)
    {
        [timelineTableView setHidden:YES];
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
        [timelineTableView setHidden:NO];
        [listEmptyView setHidden:YES];
    }
    
    [self stopLoading];
    isDeleteMode = NO;
    [self deleteViewHide:nil];
}

- (void)addPullToRefreshHeader
{
    textPull = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textRelease = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textLoading = @"Loading";
    
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, timelineTableView.frame.size.width, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:241.0/255.0f blue:246.0/255.0f alpha:1.0f];
    [refreshHeaderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    refreshIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_refresh_01.png"]];
    [refreshIndicator setFrame:CGRectMake(floorf(floorf(refreshHeaderView.frame.size.width - 20) / 2), 11, 30, 30)];
    [refreshIndicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [refreshIndicator setContentMode:UIViewContentModeCenter];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, refreshIndicator.frame.origin.y + refreshIndicator.frame.size.height, timelineTableView.frame.size.width, 16)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [refreshLabel setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    [refreshLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, REFRESH_HEADER_HEIGHT - 1, timelineTableView.frame.size.width, 1)];
    [separateLine setBackgroundColor:[UIColor colorWithRed:208.0/255.0f green:209.0/255.0f blue:214.0/255.0f alpha:1.0f]];
    [separateLine setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshIndicator];
    [refreshHeaderView addSubview:separateLine];
    [timelineTableView addSubview:refreshHeaderView];
}

- (void)startLoading
{
    NSLog(@"%s", __FUNCTION__);
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        timelineTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = textLoading;
        [CommonUtil runSpinAnimationWithDuration:refreshIndicator duration:10.0f];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading
{
    NSLog(@"%s", __FUNCTION__);
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        timelineTableView.contentInset = UIEdgeInsetsZero;
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

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [timelineSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([timelineSection count] == 0)
    {
        return 0;
    }
    else
    {
        return [(NSArray *)[timelineDic objectForKey:((TimelineSectionData *)[timelineSection objectAtIndex:section]).date] count];
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
    
    TimelineSectionData *sectionData = [timelineSection objectAtIndex:section];
    NSString *date = sectionData.date;
    NSString *day = sectionData.day;
    
    CGSize dateSize = [CommonUtil getStringFrameSize:date fontSize:12 bold:YES];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, dateSize.width, SECTION_HEADER_HEIGHT)];
    [dateLabel setTextColor:[UIColor colorWithRed:96.0f/255.0f green:97.0f/255.0f blue:102.0f/255.0f alpha:1.0f]];
    [dateLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
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
    return TIMELINE_ETC_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = [NSString stringWithFormat:@"%@", [HomeEtcTimeLineCell class]];
    HomeEtcTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [HomeEtcTimeLineCell cell];
    }
    
    LoginUtil *loginUtil = [[LoginUtil alloc] init];
    [cell setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
    
    NSString *section = ((TimelineSectionData *)[timelineSection objectAtIndex:indexPath.section]).date;
    NHInboxMessageData *inboxData = [[timelineDic objectForKey:section] objectAtIndex:indexPath.row];
//    NSArray *payload = inboxMessageData.payloadList;
    
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
    
    if(inboxData.stickerCode == STICKER_EXCHANGE_RATE)
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.depthImage setHidden:YES];
    }
    else
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell.depthImage setHidden:NO];
    }
    
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
    }
    else
    {
        // 기존 스티커 버튼
        [cell.stickerButton setImage:[CommonUtil getStickerImage:(StickerType)inboxData.stickerCode] forState:UIControlStateNormal];
        [cell.stickerButton setImage:nil forState:UIControlStateSelected];
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
    
    if(indexPath.row == 0)
    {
        [cell.upperLine setHidden:YES];
    }
    
    if ([(NSArray *)[timelineDic objectForKey:section] count] - 1 == indexPath.row)
    {
        [cell.underLine setHidden:YES];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *section = ((TimelineSectionData *)[timelineSection objectAtIndex:indexPath.section]).date;
    NHInboxMessageData *inboxData = [[timelineDic objectForKey:section] objectAtIndex:indexPath.row];
    
    if(inboxData.stickerCode == STICKER_EXCHANGE_RATE)
    {
        return;
    }
    
    HomeEtcDetailViewController *vc = [[HomeEtcDetailViewController alloc] init];
    [vc setInboxData:inboxData];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController pushViewController:eVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
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
            timelineTableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            timelineTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
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
    else if(scrollView.contentOffset.y + timelineTableView.frame.size.height >= timelineTableView.contentSize.height)
    {
//        NSLog(@"scrollView.contentOffset.y = %f, tableViewContentSize = %f, tableViewHeight = %f", scrollView.contentOffset.y, timelineTableView.contentSize.height, timelineTableView.frame.size.height);
//        NSLog(@"offset + height = %f, tableViewContentSize = %f", scrollView.contentOffset.y + timelineTableView.frame.size.height, timelineTableView.contentSize.height);
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
        NSString *pushId = ((NHInboxMessageData *)[[timelineDic objectForKey:((TimelineSectionData *)[timelineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row]).serverMessageKey;
        
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
    NSString *fromDateString = [CommonUtil getFormattedDateStringWithIndex:@"yyyy.MM.dd" indexDay:-[sender tag]];
    [searchStartDateLabel setText:fromDateString];
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
    reqData.accountNumberList = [[[LoginUtil alloc] init] getAllAccounts];
    reqData.ascending = YES;
    reqData.startDate = searchStartDate;
    reqData.endDate = searchEndDate;
    reqData.queryType = @"3,4,5,6";
    
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
    if(pickerBgView == nil)
    {
        CGRect frame = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.bounds;
        pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - datePickerView.frame.size.height)];
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

#pragma mark - delete mode
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
    
    [timelineTableView reloadData];
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
        if([timelineSection count] > 0)
        {
            // 리스트가 있는 경우에만 진행한다
            if([deleteIdList count] > 0)
            {
                [deleteIdList removeAllObjects];
            }
            
            for(TimelineSectionData *sectionData in timelineSection)
            {
                NSString *key = sectionData.date;
                NSArray *list = [timelineDic objectForKey:key];
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
    
    [timelineTableView reloadData];
}

- (IBAction)deleteSelectedList:(id)sender
{
    // deleteIdList로 삭제를 진행한다.
    if([deleteIdList count] > 0)
    {
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
    
    [timelineTableView reloadData];
}

@end
