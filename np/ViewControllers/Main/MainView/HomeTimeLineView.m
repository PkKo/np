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

#define REFRESH_HEADER_HEIGHT   76.0f
#define SECTION_HEADER_HEIGHT   31.0f
#define SECTION_FOOTER_HEIGHT   93.0f

#define AMOUNT_FONT_SIZE        18.0f

@implementation HomeTimeLineView

@synthesize delegate;

@synthesize mTimeLineSection;
@synthesize mTimeLineDic;
@synthesize mTimeLineTable;

@synthesize deleteAllView;
@synthesize deleteAllImg;
@synthesize deleteAllLabel;
@synthesize deleteButtonView;

@synthesize searchView;

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
    deleteIdList = [[NSMutableArray alloc] init];
    
    [self addPullToRefreshHeader];
}

- (IBAction)listSortChange:(id)sender
{
    listSortType = !listSortType;
    
    // section을 먼저 sorting한다.
    mTimeLineSection = (NSMutableArray *)[[mTimeLineSection reverseObjectEnumerator] allObjects];
    // sorting된 section을 가지고 dictionary를 구성한다.
    NSMutableDictionary *reverseDic = [[NSMutableDictionary alloc] init];
    for(NSString *key in mTimeLineSection)
    {
        NSArray *reverseArray = [[[mTimeLineDic objectForKey:key] reverseObjectEnumerator] allObjects];
        [reverseDic setObject:reverseArray forKey:key];
    }
    mTimeLineDic = reverseDic;
    
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
        return [[mTimeLineDic objectForKey:[mTimeLineSection objectAtIndex:section]] count];
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
    
    NSString *date = [mTimeLineSection objectAtIndex:section];
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
    
    NSString *section = [mTimeLineSection objectAtIndex:indexPath.section];
    NSString *desc = [[mTimeLineDic objectForKey:section] objectAtIndex:indexPath.row];
    
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
        if(indexPath.row % 2 == 0)
        {
            [cell.stickerButton setImage:[UIImage imageNamed:@"icon_sticker_01.png"] forState:UIControlStateNormal];
            [cell.stickerButton setImage:nil forState:UIControlStateSelected];
        }
        else
        {
            [cell.stickerButton setImage:[UIImage imageNamed:@"icon_sticker_02.png"] forState:UIControlStateNormal];
            [cell.stickerButton setImage:nil forState:UIControlStateSelected];
        }
    }
    
    
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
    [cell.pinButton setIndexPath:indexPath];
    [cell.pinButton addTarget:self action:@selector(pinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    // more 버튼
    [cell.moreButton setIndexPath:indexPath];
    [cell.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if(indexPath.row == 0)
    {
        [cell.upperLine setHidden:YES];
    }
    else if ([[mTimeLineDic objectForKey:section] count] - 1 == indexPath.row)
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
        NSString *pushId = [[[mTimeLineDic objectForKey:[mTimeLineSection objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"pushId"];
        
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
- (void)pinButtonClick:(id)sender
{
    IndexPathButton *currentBtn = (IndexPathButton *)sender;
    NSIndexPath *indexPath = currentBtn.indexPath;
    
    NSLog(@"button indexPath = %@", currentBtn.indexPath);
    
    if([currentBtn isSelected])
    {
        // 고정핀 해제를 위해 디바이스에서 해당 인덱스패스에 있는 푸시 아이디를 삭제한다.
    }
    else
    {
        // 고정핀 적용을 위해 디바이스에 해당 인덱스패스의 푸시 아이디를 저장한다.
    }
    
    [currentBtn setSelected:![currentBtn isSelected]];
}

- (void)moreButtonClick:(id)sender
{
    TransactionObject * transation = [[TransactionObject alloc] initTransactionObjectWithTransactionId:@"9374797493"
                                                                                       transactionDate:[NSDate date]
                                                                              transactionAccountNumber:@"442-83-3535"
                                                                                transactionAccountType:@"급여통장"
                                                                                    transactionDetails:@"당풍니"
                                                                                       transactionType:TRANS_TYPE_INCOME
                                                                                     transactionAmount:[NSNumber numberWithFloat:100000.0f]
                                                                                    transactionBalance:[NSNumber numberWithFloat:200000.0f]
                                                                                       transactionMemo:@""
                                                                                  transactionActivePin:[NSNumber numberWithBool:TRANS_ACTIVE_PIN_NO]];
    StorageBoxUtil * util = [[StorageBoxUtil alloc] init];
    [util showMemoComposerInViewController:((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController withTransationObject:transation];
}

@end
