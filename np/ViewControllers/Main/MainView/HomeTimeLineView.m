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

#define REFRESH_HEADER_HEIGHT   52.0f
#define SECTION_HEADER_HEIGHT   31.0f
#define SECTION_FOOTER_HEIGHT   93.0f

#define AMOUNT_FONT_SIZE        18.0f

@implementation HomeTimeLineView

@synthesize delegate;

@synthesize mTimeLineSection;
@synthesize mTimeLineDic;
@synthesize mTimeLineTable;

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        mTimeLineSection = [[NSMutableArray alloc] init];
        mTimeLineDic = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data
{
    mTimeLineSection = section;
    mTimeLineDic = data;
    
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

- (IBAction)searchViewShow:(id)sender {
}

- (IBAction)deleteMode:(id)sender {
}

- (void)addPullToRefreshHeader
{
    textPull = @"Pull down to refresh...";
    textRelease = @"Release to refresh...";
    textLoading = @"Loading...";
    
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
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
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
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
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete
{
    // Reset the header
    refreshLabel.text = textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
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
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
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
    NSLog(@"%s", __func__);
    IndexPathButton *currentBtn = (IndexPathButton *)sender;
    
    TransactionObject * transation = [[TransactionObject alloc] initTransactionObjectWithTransactionId:@"9374397493"
                                                                                       transactionDate:[NSDate date]
                                                                              transactionAccountNumber:@"111-22-***33"
                                                                                    transactionDetails:@"당풍니"
                                                                                       transactionType:INCOME
                                                                                     transactionAmount:[NSNumber numberWithFloat:100000.0f]
                                                                                    transactionBalance:[NSNumber numberWithFloat:200000.0f]
                                                                                       transactionMemo:@""];
    StorageBoxUtil * util = [[StorageBoxUtil alloc] init];
    [util showMemoComposerInViewController:self.delegate withTransationObject:transation];
}

@end
