//
//  ExchangeSettingViewController.m
//  np
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "ExchangeSettingViewController.h"
#import "ExchangeCountryAddViewController.h"
#import "CertMenuCell.h"

#define CELL_HEIGHT     48

@interface ExchangeSettingViewController ()

@end

@implementation ExchangeSettingViewController

@synthesize emptyView;
@synthesize listView;
@synthesize countryListTable;
@synthesize serviceNotiAlertView;

@synthesize payAlarmView;
@synthesize payAlarmListTable;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:NO];
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"환율 알림 설정"];

    regCountryList = [[NSMutableArray alloc] init];
    chargeList = [[NSMutableArray alloc] init];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, countryListTable.frame.size.width, 0)];
    [countryListTable setTableFooterView:footerView];
    [countryListTable.layer setBorderColor:[UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1.0f].CGColor];
    [countryListTable.layer setBorderWidth:1.0f];
    
    [payAlarmListTable.layer setBorderWidth:1.0f];
    [payAlarmListTable.layer setBorderColor:[UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1.0f].CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    countryCellHeight = CELL_HEIGHT * (self.view.bounds.size.height / IPHONE_FIVE_FRAME_HEIGHT);
    payAlarmCellHeight = CELL_HEIGHT * (self.view.bounds.size.height / IPHONE_FIVE_FRAME_HEIGHT);
    
    if(CGRectEqualToRect(regCountryOriginFrame, CGRectNull) || CGRectEqualToRect(regCountryOriginFrame, CGRectZero))
    {
        regCountryOriginFrame = countryListTable.frame;
    }
    
    if(CGRectEqualToRect(payCountryOriginFrame, CGRectNull) || CGRectEqualToRect(payCountryOriginFrame, CGRectZero))
    {
        payCountryOriginFrame = payAlarmListTable.frame;
    }
    
    // 2. 서버에서 환율알림 국가 목록을 조회해온다.
    [self currencyCountryListRequest];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - 환율 알림 전체 국가 목록 요청
- (void)currencyCountryListRequest
{
    [self startIndicator];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_EXCHANGE_CURRENCY_ALL_COUNTRY];
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(currencyCountryListResponse:)];
    [req requestUrl:url bodyString:@""];
}

- (void)currencyCountryListResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    // 전체 통화 국가 목록 생성
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        countryList = [[response objectForKey:@"list"] objectForKey:@"sub"];
    }
    else
    {
        NSString *countryListPath = [[NSBundle mainBundle] pathForResource:@"ExchangeCurrencyCountryList" ofType:@"plist"];
        countryList = [[NSArray alloc] initWithContentsOfFile:countryListPath];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
//        [alertView show];
    }
    
    [self registCurrencyCountryListRequest];
}

#pragma mark - 환율 알림 가입 국가 목록 요청
- (void)registCurrencyCountryListRequest
{
    [self startIndicator];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[CommonUtil decrypt3DES:[[NSUserDefaults standardUserDefaults] stringForKey:RESPONSE_CERT_UMS_USER_ID] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey] forKey:@"user_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_EXCHANGE_CURRENCY_REG_COUNTRY];
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(registCurrencyCountryListResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)registCurrencyCountryListResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        if([regCountryList count] > 0)
        {
            [regCountryList removeAllObjects];
        }
        
        if([chargeList count] > 0)
        {
            [chargeList removeAllObjects];
        }
        
        regCountryList = [NSMutableArray arrayWithArray:[[response objectForKey:@"list"] objectForKey:@"freeList"]];
        chargeList = [NSMutableArray arrayWithArray:[[response objectForKey:@"list"] objectForKey:@"chargeList"]];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
    
    if([regCountryList count] == 0 && [chargeList count] == 0)
    {
        [emptyView setHidden:NO];
        [listView setHidden:YES];
    }
    else
    {
        [emptyView setHidden:YES];
        [listView setHidden:NO];
        
        if([regCountryList count] == 0)
        {
            [countryListTable setHidden:YES];
        }
        else
        {
            [countryListTable setHidden:NO];
        }
        
        if([chargeList count] == 0)
        {
            if([regCountryList count] > 0)
            {
                CGFloat totalCellHeight = countryCellHeight * [regCountryList count];
                CGFloat tableViewHeight = payAlarmView.frame.origin.y + payAlarmView.frame.size.height - 28 - countryListTable.frame.origin.y;
                if(totalCellHeight < tableViewHeight)
                {
                    tableViewHeight = totalCellHeight;
                    [countryListTable setScrollEnabled:NO];
                }
                else
                {
                    [countryListTable setScrollEnabled:YES];
                }
                
                [countryListTable setFrame:CGRectMake(countryListTable.frame.origin.x,
                                                      countryListTable.frame.origin.y,
                                                      countryListTable.frame.size.width,
                                                      tableViewHeight)];
                [countryListTable setHidden:NO];
            }
            [payAlarmView setHidden:YES];
        }
        else
        {
            // 유료알림 국가 목록
            if([chargeList count] < 3)
            {
                CGFloat totalCellHeight = payAlarmCellHeight * [chargeList count];
                [payAlarmListTable setScrollEnabled:NO];
                [payAlarmListTable setFrame:CGRectMake(payAlarmListTable.frame.origin.x,
                                                       payAlarmListTable.frame.origin.y,
                                                       payAlarmListTable.frame.size.width,
                                                       totalCellHeight)];
            }
            else
            {
                [payAlarmListTable setScrollEnabled:YES];
                [payAlarmListTable setFrame:CGRectMake(payAlarmListTable.frame.origin.x,
                                                       payAlarmListTable.frame.origin.y,
                                                       payAlarmListTable.frame.size.width,
                                                       payCountryOriginFrame.size.height)];
            }
            [payAlarmListTable setHidden:NO];
        }
        
        if([regCountryList count] > 0 && [chargeList count] > 0)
        {
            // 푸시알림국가목록
            if([regCountryList count] < 4)
            {
                CGFloat totalCellHeight = countryCellHeight * [regCountryList count];
                [countryListTable setScrollEnabled:NO];
                [countryListTable setFrame:CGRectMake(countryListTable.frame.origin.x,
                                                      countryListTable.frame.origin.y,
                                                      countryListTable.frame.size.width,
                                                      totalCellHeight)];
            }
            else
            {
                [countryListTable setScrollEnabled:YES];
                [countryListTable setFrame:CGRectMake(countryListTable.frame.origin.x,
                                                      countryListTable.frame.origin.y,
                                                      countryListTable.frame.size.width,
                                                      regCountryOriginFrame.size.height)];
            }
            [countryListTable setHidden:NO];
            [payAlarmListTable setHidden:NO];
        }
        
        [countryListTable reloadData];
        [payAlarmListTable reloadData];
    }
}

- (IBAction)addCurrencyCountry:(id)sender
{
    ExchangeCountryAddViewController *vc = [[ExchangeCountryAddViewController alloc] init];
    [vc setIsNewCoutry:YES];
    [vc setIsChargeCountry:NO];
    [vc setCountryAllList:countryList];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
    
    [self.navigationController pushViewController:eVC animated:YES];
}

- (IBAction)serviceNotiButtonClick:(id)sender
{
    if([sender tag] == BUTTON_INDEX_OK)
    {
        // 환율알림 서비스 서버 조회 루틴
    }
    else
    {
        [serviceNotiAlertView removeFromSuperview];
    }
}

#pragma mark - UITableDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == countryListTable)
    {
        return countryCellHeight;
    }
    else if(tableView == payAlarmListTable)
    {
        return payAlarmCellHeight;
    }
    
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == countryListTable)
    {
        return [regCountryList count];
    }
    else if (tableView == payAlarmListTable)
    {
        return [chargeList count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = [NSString stringWithFormat:@"%@", [CertMenuCell class]];
    CertMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [CertMenuCell cell];
    }
    
    if(tableView == countryListTable)
    {
        [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, countryCellHeight)];
        
        NSString *countryName = [[regCountryList objectAtIndex:indexPath.row] objectForKey:@"UMSW023001_OUT_SUB.nation_name"];
        
        [cell.titleLabel setText:countryName];
    }
    else if(tableView == payAlarmListTable)
    {
        [cell setFrame:CGRectMake(0, 0, cell.frame.size.width, payAlarmCellHeight)];
        
        NSString *countryName = [[chargeList objectAtIndex:indexPath.row] objectForKey:@"UMSW023001_OUT_SUB.nation_name"];
        
        [cell.titleLabel setText:countryName];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(tableView == countryListTable)
    {
        // 통화 옵션 뷰로 이동
        ExchangeCountryAddViewController *vc = [[ExchangeCountryAddViewController alloc] init];
        [vc setIsNewCoutry:NO];
        [vc setIsChargeCountry:NO];
        [vc setCountryAllList:countryList];
        [vc setCountryCode:[[regCountryList objectAtIndex:indexPath.row] objectForKey:@"UMSW023001_OUT_SUB.nation_id"]];
        [vc setCountryName:[[regCountryList objectAtIndex:indexPath.row] objectForKey:@"UMSW023001_OUT_SUB.nation_name"]];
        ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
        [self.navigationController pushViewController:eVC animated:YES];
    }
    else if (tableView == payAlarmListTable)
    {
        // 유료 국가 무료로 전환 요청
        ExchangeCountryAddViewController *vc = [[ExchangeCountryAddViewController alloc] init];
        [vc setIsNewCoutry:NO];
        [vc setIsChargeCountry:YES];
        [vc setCountryAllList:countryList];
        [vc setCountryCode:[[chargeList objectAtIndex:indexPath.row] objectForKey:@"UMSW023001_OUT_SUB.nation_id"]];
        [vc setCountryName:[[chargeList objectAtIndex:indexPath.row] objectForKey:@"UMSW023001_OUT_SUB.nation_name"]];
        ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
        [self.navigationController pushViewController:eVC animated:YES];
    }
}
@end
