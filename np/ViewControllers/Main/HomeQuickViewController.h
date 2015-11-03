//
//  HomeQuickViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 17..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface HomeQuickViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, IBInboxProtocol>
{
    NSMutableArray *pushList;
    NSMutableArray *noticeList;
    NSMutableDictionary *recentNotice;
    CGFloat cellHeight;
    BOOL isPushListRequest;
    BOOL isPushListLoadingEnd;
    BOOL isNoticeListLoadingEnd;
}

@property (strong, nonatomic) IBOutlet UIButton *pushMenuButton;
@property (strong, nonatomic) IBOutlet UILabel *pushCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *noticeMenuButton;
@property (strong, nonatomic) IBOutlet UILabel *noticeCountLabel;
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
- (IBAction)selectTabButton:(id)sender;
@end
