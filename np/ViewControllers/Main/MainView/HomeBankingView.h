//
//  HomeBankingView.h
//  np
//
//  Created by Infobank1 on 2015. 10. 6..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeBankingView : UIView
{
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshIndicator;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    BOOL listSortType;
}

@property (strong, nonatomic) id delegate;
// 날짜별 섹션 구분
@property (strong, nonatomic) NSMutableArray        *timeLineSection;
// 날짜를 키로
@property (strong, nonatomic) NSMutableDictionary   *timeLineDic;
@property (strong, nonatomic) IBOutlet UITableView *bankingListTable;
@property (strong, nonatomic) IBOutlet UIButton *statisticButton;
@property (strong, nonatomic) IBOutlet UILabel *sortLabel;

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data;
- (IBAction)listSortChange:(id)sender;
@end
