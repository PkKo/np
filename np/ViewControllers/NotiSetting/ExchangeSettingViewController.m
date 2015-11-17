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
    payAlarmList = [[NSMutableArray alloc] init];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, countryListTable.frame.size.width, 0)];
    [countryListTable setTableFooterView:footerView];
    
    // 2. 서버에서 환율알림 국가 목록을 조회해온다.
    [self currencyCountryListRequest];
    
    // 환율 삭제 시 받을 노티 설정
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registCurrencyCountryListRequest) name:@"ExchangeCurrencyCountryUpdateNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    countryCellHeight = countryListTable.frame.size.height / 3;
    payAlarmCellHeight = payAlarmListTable.frame.size.height / 2;
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
    [reqBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_UMS_USER_ID] forKey:@"user_id"];
    
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
        regCountryList = [NSMutableArray arrayWithArray:[[response objectForKey:@"list"] objectForKey:@"freeList"]];
        chargeList = [NSMutableArray arrayWithArray:[[response objectForKey:@"list"] objectForKey:@"chargeList"]];
        
        if([chargeList count] > 0)
        {
            // 1. 기존에 가입된 서비스가 있는지 확인해본다.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"고객님이 이용 중인 UMS 유료 환율 서비스를 해지하고, NH스마트알림으로 환율정보를 받으시겠습니까?" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
            //        [serviceNotiAlertView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            //        [self.view addSubview:serviceNotiAlertView];
        }
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
            [payAlarmListTable reloadData];
        }
        
        if([chargeList count] == 0)
        {
            [countryListTable setFrame:CGRectMake(countryListTable.frame.origin.x,
                                                 countryListTable.frame.origin.y,
                                                 countryListTable.frame.size.width,
                                                  listView.frame.size.height - 28)];
            countryCellHeight = countryListTable.frame.size.height / 6.5;
            [payAlarmView setHidden:YES];
            [countryListTable reloadData];
        }
    }
}

- (IBAction)addCurrencyCountry:(id)sender
{
    ExchangeCountryAddViewController *vc = [[ExchangeCountryAddViewController alloc] init];
    [vc setIsNewCoutry:YES];
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
        return [payAlarmList count];
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
        [vc setCountryAllList:countryList];
        [vc setCountryCode:[[regCountryList objectAtIndex:indexPath.row] objectForKey:@"UMSW023001_OUT_SUB.nation_id"]];
        [vc setCountryName:[[regCountryList objectAtIndex:indexPath.row] objectForKey:@"UMSW023001_OUT_SUB.nation_name"]];
        ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
        [self.navigationController pushViewController:eVC animated:YES];
    }
    else if (tableView == payAlarmListTable)
    {
        // 통화 옵션 뷰로 이동
        ExchangeCountryAddViewController *vc = [[ExchangeCountryAddViewController alloc] init];
        [vc setIsNewCoutry:NO];
        [vc setCountryAllList:countryList];
        [vc setCountryCode:[[payAlarmList objectAtIndex:indexPath.row] objectForKey:@"UMSW023001_OUT_SUB.nation_id"]];
        [vc setCountryName:[[payAlarmList objectAtIndex:indexPath.row] objectForKey:@"UMSW023001_OUT_SUB.nation_name"]];
        ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
        [self.navigationController pushViewController:eVC animated:YES];
    }
}
@end
