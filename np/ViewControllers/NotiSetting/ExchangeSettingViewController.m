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

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:NO];
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"환율 알림 설정"];

    countryList = [[NSMutableArray alloc] init];
    
    // 서버에서 환율알림 국가 목록을 조회해온다.
    [self currencyCountryListRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)currencyCountryListRequest
{
    [self startIndicator];
    
    HttpRequest *req = [HttpRequest getInstance];
    
    [self performSelector:@selector(currencyCountryListResponse:) withObject:nil afterDelay:1.0f];
}

- (void)currencyCountryListResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    // 통화 국가 목록 생성
    
    if([countryList count] == 0)
    {
        [emptyView setHidden:NO];
    }
    else
    {
        [listView setHidden:NO];
    }
}

- (IBAction)addCurrencyCountry:(id)sender
{
    ExchangeCountryAddViewController *vc = [[ExchangeCountryAddViewController alloc] init];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
    
    [self.navigationController pushViewController:eVC animated:YES];
}

#pragma mark - UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [countryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = [NSString stringWithFormat:@"%@", [CertMenuCell class]];
    CertMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [CertMenuCell cell];
    }
    
    NSString *countryName = [countryList objectAtIndex:indexPath.row];
    
    [cell.titleLabel setText:countryName];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 통화 옵션 뷰로 이동
}
@end
