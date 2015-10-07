//
//  HomeBankingView.m
//  입출금 내역 뷰
//
//  Created by Infobank1 on 2015. 10. 6..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "HomeBankingView.h"
#import "HomeTimeLineTableViewCell.h"

#define REFRESH_HEADER_HEIGHT   76.0f
#define SECTION_HEADER_HEIGHT   31.0f
#define SECTION_FOOTER_HEIGHT   93.0f

#define AMOUNT_FONT_SIZE        18.0f

@implementation HomeBankingView

@synthesize delegate;
@synthesize timeLineSection;
@synthesize timeLineDic;
@synthesize bankingListTable;
@synthesize statisticButton;

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
    
    [self addPullToRefreshHeader];
}

#pragma mark - UIButton Action
- (IBAction)listSortChange:(id)sender
{
    listSortType = !listSortType;
    
    // section을 먼저 sorting한다.
    timeLineSection = (NSMutableArray *)[[timeLineSection reverseObjectEnumerator] allObjects];
    // sorting된 section을 가지고 dictionary를 구성한다.
    NSMutableDictionary *reverseDic = [[NSMutableDictionary alloc] init];
    for(NSString *key in timeLineSection)
    {
        NSArray *reverseArray = [[[timeLineDic objectForKey:key] reverseObjectEnumerator] allObjects];
        [reverseDic setObject:reverseArray forKey:key];
    }
    timeLineDic = reverseDic;
    
    [bankingListTable reloadData];
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
    NSLog(@"%s", __FUNCTION__);
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
    NSLog(@"%s", __FUNCTION__);
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
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
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
        return [[timeLineDic objectForKey:[timeLineSection objectAtIndex:section]] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEADER_HEIGHT)];
    
    [sectionHeaderView setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:225.0f/255.0f blue:230.0f/255.0f alpha:1.0f]];
    
    NSString *date = [timeLineSection objectAtIndex:section];
    NSString *day = @"일요일";
    
    CGSize dateSize = [CommonUtil getStringFrameSize:date fontSize:12.0 bold:YES];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, dateSize.width, SECTION_HEADER_HEIGHT)];
    [dateLabel setTextColor:[UIColor colorWithRed:96.0f/255.0f green:97.0f/255.0f blue:102.0f/255.0f alpha:1.0f]];
    [dateLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [dateLabel setText:date];
    [sectionHeaderView addSubview:dateLabel];
    
    CGSize daySize = [CommonUtil getStringFrameSize:date fontSize:12 bold:NO];
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateLabel.frame.origin.x + dateSize.width, 0, daySize.width, SECTION_HEADER_HEIGHT)];
    [dayLabel setTextColor:[UIColor colorWithRed:96.0f/255.0f green:97.0f/255.0f blue:102.0f/255.0f alpha:1.0f]];
    [dayLabel setFont:[UIFont systemFontOfSize:12.0F]];
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
    
    NSString *section = [timeLineSection objectAtIndex:indexPath.section];
    NSString *desc = [[timeLineDic objectForKey:section] objectAtIndex:indexPath.row];
    
    // 스티커 버튼
    [cell.stickerButton setIndexPath:indexPath];
    // 푸시 시간
    [cell.timeLabel setText:@"09:05"];
    // 거래명
    [cell.nameLabel setText:@"김농협"];
    
    if(indexPath.row % 2 == 0)
    {
        // 입출금 타입
        [cell.typeLabel setText:@"입금"];
        [cell.typeLabel setTextColor:INCOME_STRING_COLOR];
        // 금액
        CGSize amountSize = [CommonUtil getStringFrameSize:@"100,000,000" fontSize:AMOUNT_FONT_SIZE bold:NO];
        [cell.amountLabel setFrame:CGRectMake(cell.amountLabel.frame.origin.x,
                                              cell.amountLabel.frame.origin.y,
                                              amountSize.width, cell.amountLabel.frame.size.height)];
        [cell.amountLabel setText:@"100,000,000"];
        [cell.amountLabel setTextColor:INCOME_STRING_COLOR];
        
        [cell.amountDescLabel setFrame:CGRectMake(cell.amountLabel.frame.origin.x + amountSize.width,
                                                  cell.amountDescLabel.frame.origin.y,
                                                  cell.amountDescLabel.frame.size.width,
                                                  cell.amountDescLabel.frame.size.height)];
    }
    else
    {
        // 입출금 타입
        [cell.typeLabel setText:@"출금"];
        [cell.typeLabel setTextColor:WITHDRAW_STRING_COLOR];
        // 금액
        CGSize amountSize = [CommonUtil getStringFrameSize:@"50,000,000" fontSize:AMOUNT_FONT_SIZE bold:NO];
        [cell.amountLabel setFrame:CGRectMake(cell.amountLabel.frame.origin.x,
                                              cell.amountLabel.frame.origin.y,
                                              amountSize.width, cell.amountLabel.frame.size.height)];
        [cell.amountLabel setText:@"50,000,000"];
        [cell.amountLabel setTextColor:WITHDRAW_STRING_COLOR];
        
        [cell.amountDescLabel setFrame:CGRectMake(cell.amountLabel.frame.origin.x + amountSize.width,
                                                  cell.amountDescLabel.frame.origin.y,
                                                  cell.amountDescLabel.frame.size.width,
                                                  cell.amountDescLabel.frame.size.height)];
    }
    
    // 계좌별명 + 계좌명
    [cell.accountLabel setText:@"급여통장 111-2458-1123-45"];
    // 잔액
    [cell.remainAmountLabel setText:@"잔액 123,432,000원"];
    
    // 고정핀
    // 고정핀
    [cell.pinButton setIndexPath:indexPath];
    [cell.pinButton addTarget:self action:@selector(pinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // more 버튼
    [cell.moreButton setIndexPath:indexPath];
    
    
    if(indexPath.row == 0)
    {
        [cell.upperLine setHidden:YES];
    }
    else if ([[timeLineDic objectForKey:section] count] - 1 == indexPath.row)
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
            bankingListTable.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            bankingListTable.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
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
    else if(scrollView.contentOffset.y + bankingListTable.frame.size.height >= bankingListTable.contentSize.height)
    {
        NSLog(@"scrollView.contentOffset.y = %f, tableViewContentSize = %f, tableViewHeight = %f", scrollView.contentOffset.y, bankingListTable.contentSize.height, bankingListTable.frame.size.height);
        // 스크롤이 끝까지 내려가면 이전 목록을 불러와 리프레쉬 한다.
    }
}
@end
