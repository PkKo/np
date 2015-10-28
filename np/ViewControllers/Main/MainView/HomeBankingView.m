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

@implementation HomeBankingView

@synthesize delegate;
@synthesize timeLineSection;
@synthesize timeLineDic;
@synthesize bankingListTable;
@synthesize statisticButton;
@synthesize sortLabel;

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
    
    [sectionHeaderView setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:225.0f/255.0f blue:230.0f/255.0f alpha:1.0f]];
    
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
    
    NSString *section = ((TimelineSectionData *)[timeLineSection objectAtIndex:indexPath.section]).date;
    NHInboxMessageData *inboxData = [[timeLineDic objectForKey:section] objectAtIndex:indexPath.row];
    
    // 스티커 버튼
    [cell.stickerButton setIndexPath:indexPath];
    [cell.stickerButton setImage:[CommonUtil getStickerImage:(StickerType)inboxData.stickerCode] forState:UIControlStateNormal];
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
    
    NSMutableArray *pinIdList = [[NSUserDefaults standardUserDefaults] objectForKey:TIMELINE_PIN_MESSAGE_ID];
    if(pinIdList != nil && [pinIdList containsObject:inboxData.serverMessageKey])
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
- (void)pinButtonClick:(id)sender
{
    IndexPathButton *currentBtn = (IndexPathButton *)sender;
    NSIndexPath *indexPath = currentBtn.indexPath;
    
    NSLog(@"button indexPath = %@", currentBtn.indexPath);
    
    NHInboxMessageData *inboxData = [[timeLineDic objectForKey:((TimelineSectionData *)[timeLineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row];
    
    NSMutableArray *pinIdList = [[NSUserDefaults standardUserDefaults] objectForKey:TIMELINE_PIN_MESSAGE_ID];
    
    if(pinIdList == nil)
    {
        pinIdList = [[NSMutableArray alloc] init];
    }
    
    if([currentBtn isSelected])
    {
        // 고정핀 해제를 위해 디바이스에서 해당 인덱스패스에 있는 푸시 아이디를 삭제한다.
        if([pinIdList containsObject:inboxData.serverMessageKey])
        {
            [pinIdList removeObject:inboxData.serverMessageKey];
            [[NSUserDefaults standardUserDefaults] setObject:pinIdList forKey:TIMELINE_PIN_MESSAGE_ID];
        }
    }
    else
    {
        // 고정핀 적용을 위해 디바이스에 해당 인덱스패스의 푸시 아이디를 저장한다.
        if([pinIdList containsObject:inboxData.serverMessageKey])
        {
            [pinIdList addObject:inboxData.serverMessageKey];
            [[NSUserDefaults standardUserDefaults] setObject:pinIdList forKey:TIMELINE_PIN_MESSAGE_ID];
        }
    }
    
    [currentBtn setSelected:![currentBtn isSelected]];
}

- (void)moreButtonClick:(id)sender
{
    IndexPathButton *currentButton = (IndexPathButton *)sender;
    NSIndexPath *indexPath = currentButton.indexPath;
    NHInboxMessageData *inboxData = [[timeLineDic objectForKey:((TimelineSectionData *)[timeLineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row];
    HomeTimeLineTableViewCell *cell = [bankingListTable cellForRowAtIndexPath:indexPath];
    
    TransactionObject * transation = [[TransactionObject alloc] initTransactionObjectWithTransactionId:inboxData.serverMessageKey
                                                                                       transactionDate:[NSDate dateWithTimeIntervalSince1970:inboxData.regDate]
                                                                              transactionAccountNumber:inboxData.nhAccountNumber
                                                                                transactionAccountType:@""
                                                                                    transactionDetails:inboxData.oppositeUser
                                                                                           transactionType:inboxData.inboxType
                                                                                     transactionAmount:@(inboxData.amount)
                                                                                    transactionBalance:@(inboxData.balance)
                                                                                       transactionMemo:@""
                                                                                  transactionActivePin:[NSNumber numberWithBool:[cell isSelected]]];
    StorageBoxUtil * util = [[StorageBoxUtil alloc] init];
    [util showMemoComposerInViewController:((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController withTransationObject:transation];
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
