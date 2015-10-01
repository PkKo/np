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

@interface HomeQuickViewController ()

@end

@implementation HomeQuickViewController

// 입출금 알림 선택 버튼
@synthesize pushMenuButton;
// 신규 입출금 알림 갯수 표시
@synthesize pushCountLabel;
// 공지사항 선택 버튼
@synthesize noticeMenuButton;
// 신규 공지사항 갯수 표시
@synthesize noticeCountLabel;
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
// 농민 뉴스 및 배너 영역
@synthesize bannerView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
    [pushMenuButton setEnabled:NO];
    [noticeMenuButton setEnabled:YES];
    
    // 1. IPS를 통해 신규 알림 및 공지사항 리스트를 가져온다.
    pushList = [[NSMutableArray alloc] init];
    noticeList = [[NSMutableArray alloc] init];
    [pushTableView setHidden:YES];
    [noticeTableView setHidden:YES];
    
    // 2. 최신순으로 5개만 선택해 보여준다.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
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
        
        NSDictionary *info = [pushList objectAtIndex:indexPath.row];
        
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
        
        return cell;
    }
    else
    {
        return nil;
    }
}

@end
