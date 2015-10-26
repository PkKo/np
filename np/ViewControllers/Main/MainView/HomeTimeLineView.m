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
#import "ConstantMaster.h"
#import "MainPageViewController.h"
#import "HomeViewController.h"
#import "StorageBoxController.h"

@implementation HomeTimeLineView

@synthesize delegate;

@synthesize mTimeLineSection;
@synthesize mTimeLineDic;
@synthesize mTimeLineTable;
@synthesize sortLabel;

@synthesize deleteAllView;
@synthesize deleteAllImg;
@synthesize deleteAllLabel;
@synthesize deleteButtonView;

@synthesize searchView;

@synthesize storageCountLabel;

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
    deleteIdList = [[NSMutableArray alloc] init];
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
    
    [self addPullToRefreshHeader];
}

- (IBAction)listSortChange:(id)sender
{
    listSortType = !listSortType;
    
    // section을 먼저 sorting한다.
    mTimeLineSection = (NSMutableArray *)[[mTimeLineSection reverseObjectEnumerator] allObjects];
    // sorting된 section을 가지고 dictionary를 구성한다.
    NSMutableDictionary *reverseDic = [[NSMutableDictionary alloc] init];
    for(TimelineSectionData *data in mTimeLineSection)
    {
        NSArray *reverseArray = [[[mTimeLineDic objectForKey:data.date] reverseObjectEnumerator] allObjects];
        [reverseDic setObject:reverseArray forKey:data.date];
    }
    mTimeLineDic = reverseDic;
    
    if(listSortType)
    {
        [sortLabel setText:@"최신순"];
    }
    else
    {
        [sortLabel setText:@"과거순"];
    }
    
    [mTimeLineTable reloadData];
}

- (IBAction)searchViewShow:(id)sender
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [searchView setHidden:NO];
        [searchView setFrame:CGRectMake(0, 0, self.frame.size.width, searchView.frame.size.height)];
    }completion:nil];
}

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
            
            /*
            for(NSString *key in mTimeLineSection)
            {
                NSArray *list = [mTimeLineDic objectForKey:key];
                for (NSDictionary *item in list)
                {
                    [deleteIdList addObject:[item objectForKey:@"pushId"]];
                }
            }*/
            
            [deleteAllImg setHighlighted:YES];
            [deleteAllLabel setTextColor:[UIColor colorWithRed:48.0f/255.0f green:49.0f/255.0f blue:54.0f/255.0f alpha:1.0f]];
        }
    }
}

- (IBAction)deleteSelectedList:(id)sender
{
    // deleteIdList로 삭제를 진행한다.
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
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [deleteButtonView setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, deleteButtonView.frame.size.height)];
    }
                     completion:^(BOOL finished){
                         [deleteButtonView setHidden:YES];
    }];
    
    [mTimeLineTable reloadData];
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

- (IBAction)storageMoveClick:(id)sender
{
    MainPageViewController *newTopViewController = [[MainPageViewController alloc] init];
    [newTopViewController setStartPageIndex:INBOX];
    
    CGRect frame = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController = newTopViewController;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame = frame;
    [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController resetTopViewAnimated:NO];
}

- (void)addPullToRefreshHeader
{
    textPull = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textRelease = @"화면을 당기면 알림 내역이 업데이트 됩니다.";
    textLoading = @"Loading";
    
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, mTimeLineTable.frame.size.width, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
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
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshIndicator];
    [mTimeLineTable addSubview:refreshHeaderView];
}

- (void)startLoading
{
    NSLog(@"%s", __FUNCTION__);
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
    NSLog(@"%s", __FUNCTION__);
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
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
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
        return [(NSArray *)[mTimeLineDic objectForKey:((TimelineSectionData *)[mTimeLineSection objectAtIndex:section]).date] count];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = [NSString stringWithFormat:@"%@", [HomeTimeLineTableViewCell class]];
    HomeTimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [HomeTimeLineTableViewCell cell];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSString *section = ((TimelineSectionData *)[mTimeLineSection objectAtIndex:indexPath.section]).date;
    NHInboxMessageData *inboxData = [[mTimeLineDic objectForKey:section] objectAtIndex:indexPath.row];
    
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
        [cell.stickerButton setImage:[CommonUtil getStickerImage:(StickerType)[inboxData.inboxType integerValue]] forState:UIControlStateNormal];
        [cell.stickerButton setImage:nil forState:UIControlStateSelected];
    }
    
    [cell.stickerButton setTag:(StickerType)[inboxData.inboxType integerValue]];
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
    CGSize amountSize = [CommonUtil getStringFrameSize:amount fontSize:AMOUNT_FONT_SIZE bold:NO];
    
    switch ([inboxData.inboxType integerValue])
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
            break;
        }
            
        default:
            break;
    }
    
    // 계좌별명 + 계좌명
    [cell.accountLabel setText:inboxData.nhAccountNumber];
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
    else if ([(NSArray *)[mTimeLineDic objectForKey:section] count] - 1 == indexPath.row)
    {
        [cell.underLine setHidden:YES];
    }
    
    NSMutableArray *pinIdList = [[NSUserDefaults standardUserDefaults] objectForKey:TIMELINE_PIN_MESSAGE_ID];
    if(pinIdList != nil && [pinIdList containsObject:inboxData.serverMessageKey])
    {
        [cell.pinButton setSelected:YES];
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
            mTimeLineTable.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            mTimeLineTable.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
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
    else if(scrollView.contentOffset.y + mTimeLineTable.frame.size.height >= mTimeLineTable.contentSize.height)
    {
        NSLog(@"scrollView.contentOffset.y = %f, tableViewContentSize = %f, tableViewHeight = %f", scrollView.contentOffset.y, mTimeLineTable.contentSize.height, mTimeLineTable.frame.size.height);
        NSLog(@"offset + height = %f, tableViewContentSize = %f", scrollView.contentOffset.y + mTimeLineTable.frame.size.height, mTimeLineTable.contentSize.height);
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
    }
    else
    {
        if(delegate != nil && [delegate respondsToSelector:@selector(stickerButtonClick:)])
        {
            [delegate performSelector:@selector(stickerButtonClick:) withObject:sender];
        }
        /*
        if(indexPath.row % 2 == 0)
        {
            // 입금 스티커
            if(depositStickerView == nil)
            {
                depositStickerView = [DepositStickerView view];
                [depositStickerView setFrame:CGRectMake(0, 0, self.frame.size.width, ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame.size.height)];
                [depositStickerView setDelegate:self];
            }
            [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view addSubview:depositStickerView];
        }
        else
        {
            // 출금 스티커
            if(withdrawStickerView == nil)
            {
                withdrawStickerView = [WithdrawStickerSettingView view];
                [withdrawStickerView setFrame:CGRectMake(0, 0, self.frame.size.width, ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame.size.height)];
                [withdrawStickerView setDelegate:self];
            }
            [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view addSubview:withdrawStickerView];
        }*/
    }
}

- (void)pinButtonClick:(id)sender
{
    IndexPathButton *currentBtn = (IndexPathButton *)sender;
    NSLog(@"button indexPath = %@", currentBtn.indexPath);
    NSIndexPath *indexPath = currentBtn.indexPath;
    
    NHInboxMessageData *inboxData = [[mTimeLineDic objectForKey:((TimelineSectionData *)[mTimeLineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row];
    
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
    
    NHInboxMessageData *inboxData = [[mTimeLineDic objectForKey:((TimelineSectionData *)[mTimeLineSection objectAtIndex:indexPath.section]).date] objectAtIndex:indexPath.row];
    HomeTimeLineTableViewCell *cell = [mTimeLineTable cellForRowAtIndexPath:indexPath];
    
    TransactionObject * transation = [[TransactionObject alloc] initTransactionObjectWithTransactionId:inboxData.serverMessageKey
                                                                                       transactionDate:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]
                                                                              transactionAccountNumber:inboxData.nhAccountNumber
                                                                                transactionAccountType:@""
                                                                                    transactionDetails:inboxData.oppositeUser
                                                                                       transactionType:inboxData.inboxType
                                                                                     transactionAmount:@(inboxData.amount)
                                                                                    transactionBalance:@(inboxData.balance)
                                                                                       transactionMemo:@""
                                                                                  transactionActivePin:[NSNumber numberWithBool:[cell.pinButton isSelected]]];
    StorageBoxUtil * util = [[StorageBoxUtil alloc] init];
    [util showMemoComposerInViewController:((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController withTransationObject:transation];
}

@end
