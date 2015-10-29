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

@implementation HomeEtcTimeLineView

@synthesize delegate;
@synthesize timelineTableView;
@synthesize timelineSection;
@synthesize timelineDic;
@synthesize deleteAllView;
@synthesize deleteButtonView;
@synthesize searchView;

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data
{
    timelineSection = section;
    timelineDic = data;
    deleteIdList = [[NSMutableArray alloc] init];
    
    [self addPullToRefreshHeader];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    LoginUtil *loginUtil = [[LoginUtil alloc] init];
    [self setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
    [timelineTableView setBackgroundColor:[loginUtil getNoticeBackgroundColour]];
}

- (void)addPullToRefreshHeader
{
    textPull = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textRelease = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textLoading = @"Loading";
    
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, timelineTableView.frame.size.width, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
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
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshIndicator];
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
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    // 스티커 버튼
    [cell.stickerButton setIndexPath:indexPath];
    if(isDeleteMode)
    {
        // 삭제 버튼으로 바꿔줌
        [cell.stickerButton setImage:[UIImage imageNamed:@"icon_sticker_05_dft.png"] forState:UIControlStateNormal];
        [cell.stickerButton setImage:[UIImage imageNamed:@"icon_sticker_05_sel.png"] forState:UIControlStateSelected];
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
    
    if(indexPath.row == 0)
    {
        [cell.upperLine setHidden:YES];
    }
    else if ([(NSArray *)[timelineDic objectForKey:section] count] - 1 == indexPath.row)
    {
        [cell.underLine setHidden:YES];
    }
    
    return cell;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
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
    else if (isDragging && scrollView.contentOffset.y < 0)
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
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT)
    {
        // Released above the header
        [self startLoading];
    }
    else if(scrollView.contentOffset.y + timelineTableView.frame.size.height >= timelineTableView.contentSize.height)
    {
        NSLog(@"scrollView.contentOffset.y = %f, tableViewContentSize = %f, tableViewHeight = %f", scrollView.contentOffset.y, timelineTableView.contentSize.height, timelineTableView.frame.size.height);
        NSLog(@"offset + height = %f, tableViewContentSize = %f", scrollView.contentOffset.y + timelineTableView.frame.size.height, timelineTableView.contentSize.height);
        // 스크롤이 끝까지 내려가면 이전 목록을 불러와 리프레쉬 한다.
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
    }
}

@end
