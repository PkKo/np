//
//  HomeQuickViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 17..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "BannerInfoView.h"

@interface HomeQuickViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, IBInboxProtocol>
{
    NSMutableArray *pushList;
    NSMutableArray *noticeList;
    NSMutableDictionary *recentNotice;
    CGFloat cellHeight;
    CGFloat firstCellHeight;
    BOOL isPushListRequest;
    BOOL isPushListLoadingEnd;
    BOOL isNoticeListLoadingEnd;
    
    BannerInfoView *bannerInfoView;
}

@property (strong, nonatomic) IBOutlet UIButton *pushMenuButton;
@property (strong, nonatomic) IBOutlet UILabel *pushCountLabel;
@property (strong, nonatomic) IBOutlet CircleView *pushCountBg;
@property (strong, nonatomic) IBOutlet UIButton *noticeMenuButton;
@property (strong, nonatomic) IBOutlet UILabel *noticeCountLabel;
@property (strong, nonatomic) IBOutlet CircleView *noticeCountBg;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *listContentView;
@property (strong, nonatomic) IBOutlet UIView *emptyListView;
@property (strong, nonatomic) IBOutlet UITableView *pushTableView;
@property (strong, nonatomic) IBOutlet UITableView *noticeTableView;
@property (strong, nonatomic) IBOutlet UIView *noticeView;
@property (strong, nonatomic) IBOutlet UIView *bannerView;
@property (strong, nonatomic) IBOutlet UILabel *noticeIconView;
@property (strong, nonatomic) IBOutlet UILabel *noticeTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *tabOneBg;
@property (strong, nonatomic) IBOutlet UIImageView *tabTwoBg;
@property (assign, nonatomic) int64_t lastMessageTimePush;
@property (assign, nonatomic) int64_t lastMessageTimeNotice;

@property (assign, nonatomic) SIMPLE_VIEW_TYPE notifType;

- (IBAction)selectTabButton:(id)sender;
- (IBAction)noticeClick:(id)sender;
- (IBAction)moveMainView:(id)sender;
@end
