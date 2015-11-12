//
//  HomeQuickViewController.m
//  간편보기
//
//  Created by Infobank1 on 2015. 9. 17..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "HomeQuickViewController.h"
#import "HomeQuickPushTableViewCell.h"
#import "HomeQuickNoticeTableViewCell.h"

#define HOME_QUICKVIEW_CELL_HEIGHT  64

@interface HomeQuickViewController ()

@end

@implementation HomeQuickViewController

// 입출금 알림 선택 버튼
@synthesize pushMenuButton;
// 신규 입출금 알림 갯수 표시
@synthesize pushCountLabel;
@synthesize pushCountBg;
// 공지사항 선택 버튼
@synthesize noticeMenuButton;
// 신규 공지사항 갯수 표시
@synthesize noticeCountLabel;
@synthesize noticeCountBg;
// 알림 내역 add subView 한다
@synthesize listContentView;
// 알림 내역이 없는 경우 보여줄 알림
@synthesize emptyListView;
// 입출금 내역 테이블뷰
@synthesize pushTableView;
// 공지사항 테이블뷰
@synthesize noticeTableView;
// 최근 공지사항 표시
@synthesize noticeView;
@synthesize noticeIconView;
@synthesize noticeTitleLabel;
// 농민 뉴스 및 배너 영역
@synthesize bannerView;
@synthesize tabOneBg;
@synthesize tabTwoBg;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
    [pushMenuButton setEnabled:NO];
    [noticeMenuButton setEnabled:YES];
    [tabOneBg setHidden:[pushMenuButton isEnabled]];
    [tabTwoBg setHidden:[noticeMenuButton isEnabled]];
    
    [noticeIconView.layer setCornerRadius:(noticeIconView.frame.size.height /2)];
    [noticeIconView setAlpha:0.9f];
    
    // 1. IPS를 통해 신규 알림 및 공지사항 리스트를 가져온다.
    pushList = [[NSMutableArray alloc] init];
    noticeList = [[NSMutableArray alloc] init];
    recentNotice = [[NSMutableDictionary alloc] init];
    [pushTableView setHidden:YES];
    [noticeTableView setHidden:YES];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pushTableView.frame.size.width, 0)];
    [pushTableView setTableFooterView:footerView];
    [noticeTableView setTableFooterView:footerView];
    
    // 2. 최신순으로 5개만 선택해 보여준다.
    isPushListRequest = YES;
    [IBInbox loadWithListener:self];
    AccountInboxRequestData *reqData = [[AccountInboxRequestData alloc] init];
    [reqData setAscending:YES];
    [reqData setAccountNumberList:[[[LoginUtil alloc] init] getAllAccounts]];
    [reqData setQueryType:@"1,2"];
    [reqData setSize:5];
    [IBInbox reqQueryAccountInboxListWithSize:reqData];
    
    NSInteger pushCount = [CommonUtil getUnreadCountForBanking];
    if(pushCount > 99)
    {
        [pushCountLabel setText:@"99+"];
        [pushCountLabel setFrame:CGRectMake(pushCountLabel.frame.origin.x - 10,
                                            pushCountLabel.frame.origin.y,
                                            pushCountLabel.frame.size.width + 10,
                                            pushCountLabel.frame.size.height)];
        [pushCountBg setFrame:pushCountLabel.frame];
    }
    else if (pushCount > 9)
    {
        [pushCountLabel setText:[NSString stringWithFormat:@"%d", (int)pushCount]];
        [pushCountLabel setFrame:CGRectMake(pushCountLabel.frame.origin.x - 7,
                                            pushCountLabel.frame.origin.y,
                                            pushCountLabel.frame.size.width + 7,
                                            pushCountLabel.frame.size.height)];
        [pushCountBg setFrame:pushCountLabel.frame];
    }
    else
    {
        [pushCountLabel setText:[NSString stringWithFormat:@"%d", (int)pushCount]];
    }
    
    if(pushCount == 0)
    {
        [pushCountBg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    }
    
    NSInteger noticeCount = [CommonUtil getUnreadCountForEtc];
    if(noticeCount > 99)
    {
        [noticeCountLabel setText:@"99+"];
        [noticeCountLabel setFrame:CGRectMake(noticeCountLabel.frame.origin.x - 10,
                                              noticeCountLabel.frame.origin.y,
                                              noticeCountLabel.frame.size.width + 10,
                                              noticeCountLabel.frame.size.height)];
        [noticeCountBg setFrame:noticeCountLabel.frame];
    }
    else if(noticeCount > 9)
    {
        [noticeCountLabel setText:[NSString stringWithFormat:@"%d", (int)noticeCount]];
        [noticeCountLabel setFrame:CGRectMake(noticeCountLabel.frame.origin.x - 7,
                                              noticeCountLabel.frame.origin.y,
                                              noticeCountLabel.frame.size.width + 7,
                                              noticeCountLabel.frame.size.height)];
        [noticeCountBg setFrame:noticeCountLabel.frame];
    }
    else
    {
        [noticeCountLabel setText:[NSString stringWithFormat:@"%d", (int)noticeCount]];
    }
    
    if(noticeCount == 0)
    {
        [noticeCountBg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    }
    
    [self getRecentNoticeRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    cellHeight = pushTableView.frame.size.height / 5;
    if(cellHeight < HOME_QUICKVIEW_CELL_HEIGHT)
    {
        cellHeight = HOME_QUICKVIEW_CELL_HEIGHT;
        [pushTableView setScrollEnabled:YES];
    }
    
    bannerInfoView = [BannerInfoView view];
    [bannerInfoView setFrame:CGRectMake(0, 0, bannerView.frame.size.width, bannerView.frame.size.height)];
    [bannerView addSubview:bannerInfoView];
    [bannerInfoView bannerTimerStart];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [bannerInfoView bannerTimerStop];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [bannerInfoView bannerTimerStop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestNoticeList
{
    isPushListRequest = NO;
    AccountInboxRequestData *reqData = [[AccountInboxRequestData alloc] init];
    [reqData setAscending:YES];
    [reqData setAccountNumberList:[[[LoginUtil alloc] init] getAllAccounts]];
    [reqData setQueryType:@"E"];
    [reqData setSize:5];
    [IBInbox reqQueryAccountInboxListWithSize:reqData];
}

#pragma mark - Server Request
- (void)getRecentNoticeRequest
{
    HttpRequest *req = [HttpRequest getInstance];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_RECENT_NOTICE];
    [req setDelegate:self selector:@selector(getRecentNoticeResponse:)];
    [req requestUrl:url bodyString:@""];
}

- (void)getRecentNoticeResponse:(NSDictionary *)response
{
    NSLog(@"%s, %@", __FUNCTION__, response);
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        if([(NSArray*)[[response objectForKey:@"list"] objectForKey:@"voList"] count] > 0)
        {
            recentNotice = [[[response objectForKey:@"list"] objectForKey:@"voList"] objectAtIndex:0];
            [self noticeUpdate];
        }
    }
}

- (void)noticeUpdate
{
    [noticeTitleLabel setText:[recentNotice objectForKey:@"BBRD_TINM"]];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == pushTableView)
    {
        return [pushList count];
    }
    else if(tableView == noticeTableView)
    {
        return [noticeList count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == pushTableView)
    {
        NSString *reuseId = [NSString stringWithFormat:@"%@", [HomeQuickPushTableViewCell class]];
        HomeQuickPushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        
        if(cell == nil)
        {
            cell = [HomeQuickPushTableViewCell cell];
        }
        
        [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, cellHeight)];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NHInboxMessageData *inboxData = [pushList objectAtIndex:indexPath.row];
        
        [cell.stickerImg setImage:[CommonUtil getStickerImage:(StickerType)inboxData.stickerCode]];
        
        /*
        amountLabel;
        typeLabel;
        accountLabel;
        dateLabel;
        amountDescLabel;
*/
        // 푸시 시간
        [cell.dateLabel setText:[CommonUtil getQuickViewDateString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]]];
        
        [cell.accountLabel setText:[NSString stringWithFormat:@"/ %@", [CommonUtil getMaskingNumber:inboxData.nhAccountNumber]]];
        
        NSNumberFormatter *numFomatter = [NSNumberFormatter new];
        [numFomatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *amount = [numFomatter stringFromNumber:[NSNumber numberWithInt:(int)inboxData.amount]];
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
                [cell.amountLabel setText:amount];
                [cell.amountLabel setTextColor:INCOME_STRING_COLOR];
                [cell.amountLabel setFrame:CGRectMake(cell.amountDescLabel.frame.origin.x - amountSize.width,
                                                      cell.amountLabel.frame.origin.y,
                                                      amountSize.width, cell.amountLabel.frame.size.height)];
                [cell.typeLabel setFrame:CGRectMake(cell.amountLabel.frame.origin.x - cell.typeLabel.frame.size.width,
                                                    cell.typeLabel.frame.origin.y,
                                                    cell.typeLabel.frame.size.width,
                                                    cell.typeLabel.frame.size.height)];
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
                // 금액
                [cell.amountLabel setText:amount];
                [cell.amountLabel setTextColor:WITHDRAW_STRING_COLOR];
                
                [cell.amountLabel setFrame:CGRectMake(cell.amountDescLabel.frame.origin.x - amountSize.width,
                                                      cell.amountLabel.frame.origin.y,
                                                      amountSize.width, cell.amountLabel.frame.size.height)];
                [cell.typeLabel setFrame:CGRectMake(cell.amountLabel.frame.origin.x - cell.typeLabel.frame.size.width,
                                                    cell.typeLabel.frame.origin.y,
                                                    cell.typeLabel.frame.size.width,
                                                    cell.typeLabel.frame.size.height)];

                [cell.amountDescLabel setTextColor:WITHDRAW_STRING_COLOR];
                break;
            }
                
            default:
                break;
        }
        
        return cell;
    }
    else if(tableView == noticeTableView)
    {
        NSString *reuseId = [NSString stringWithFormat:@"%@", [HomeQuickNoticeTableViewCell class]];
        HomeQuickNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        
        if(cell == nil)
        {
            cell = [HomeQuickNoticeTableViewCell cell];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NHInboxMessageData *inboxData = [noticeList objectAtIndex:indexPath.row];
        
        // 푸시 시간
        [cell.noticeDateLabel setText:[CommonUtil getTimeString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate/1000)]]];
        // 공지 타이틀
        [cell.noticeTitleLabel setText:inboxData.title];
        
        return cell;
    }
    else
    {
        return nil;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // Login
    [[[LoginUtil alloc] init] showLoginPage:self.navigationController];
}

#pragma mark - IBInboxProtocol
- (void)loadedAccountQueryInboxList:(BOOL)success messageList:(NSArray *)messageList
{
    if(success)
    {
        if(isPushListRequest)
        {
            if([messageList count] > 0)
            {
                [pushTableView setHidden:[pushMenuButton isEnabled]];
                [noticeTableView setHidden:[noticeMenuButton isEnabled]];
                [emptyListView setHidden:YES];
                
                pushList = [NSMutableArray arrayWithArray:messageList];
                [pushTableView reloadData];
            }
            else
            {
                [pushTableView setHidden:YES];
                [noticeTableView setHidden:YES];
                [emptyListView setHidden:NO];
            }
            isPushListLoadingEnd = YES;
        }
        else
        {
            if([messageList count] > 0)
            {
                noticeList = [NSMutableArray arrayWithArray:messageList];
            }
            
            if([noticeList count] > 0)
            {
                [pushTableView setHidden:[pushMenuButton isEnabled]];
                [noticeTableView setHidden:[noticeMenuButton isEnabled]];
                [emptyListView setHidden:YES];
                [noticeTableView reloadData];
            }
            else
            {
                [pushTableView setHidden:YES];
                [noticeTableView setHidden:YES];
                [emptyListView setHidden:NO];
            }
            
            isNoticeListLoadingEnd = YES;
        }
    }
}

- (void)loadingInboxList
{
    NSLog(@"%s", __FUNCTION__);
}

- (IBAction)selectTabButton:(id)sender
{
    UIButton *currentButton = (UIButton *)sender;
    
    [pushMenuButton setEnabled:![pushMenuButton isEnabled]];
    [noticeMenuButton setEnabled:![noticeMenuButton isEnabled]];
    [tabOneBg setHidden:[pushMenuButton isEnabled]];
    [tabTwoBg setHidden:[noticeMenuButton isEnabled]];
    
    if(currentButton == pushMenuButton)
    {
        if(isPushListLoadingEnd)
        {
            if([pushList count] > 0)
            {
                [pushTableView setHidden:[pushMenuButton isEnabled]];
                [noticeTableView setHidden:[noticeMenuButton isEnabled]];
                [emptyListView setHidden:YES];
                [pushTableView reloadData];
            }
            else
            {
                [pushTableView setHidden:YES];
                [noticeTableView setHidden:YES];
                [emptyListView setHidden:NO];
            }
        }
    }
    else if (currentButton == noticeMenuButton)
    {
        if(isNoticeListLoadingEnd)
        {
            if([noticeList count] > 0)
            {
                [pushTableView setHidden:[pushMenuButton isEnabled]];
                [noticeTableView setHidden:[noticeMenuButton isEnabled]];
                [emptyListView setHidden:YES];
                [noticeTableView reloadData];
            }
            else
            {
                [pushTableView setHidden:YES];
                [noticeTableView setHidden:YES];
                [emptyListView setHidden:NO];
            }
        }
        else
        {
            [self requestNoticeList];
        }
    }
}
@end
