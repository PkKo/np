//
//  HomeBankingView.h
//  np
//
//  Created by Infobank1 on 2015. 10. 6..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawStickerSettingView.h"
#import "DepositStickerView.h"

@interface HomeBankingView : UIView
{
    BOOL isDeleteMode;
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshIndicator;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    BOOL listSortType;
    NSMutableArray *pinnedIdList;
    NSMutableArray *deleteIdList;
    
    NSInteger storageCount;
    
    DepositStickerView *depositStickerView;
    WithdrawStickerSettingView *withdrawStickerView;
    NSIndexPath *currentStickerIndexPath;
}

@property (strong, nonatomic) id delegate;
// 날짜별 섹션 구분
@property (strong, nonatomic) NSMutableArray        *timeLineSection;
// 날짜를 키로
@property (strong, nonatomic) NSMutableDictionary   *timeLineDic;
@property (strong, nonatomic) IBOutlet UITableView *bankingListTable;
@property (strong, nonatomic) IBOutlet UIButton *statisticButton;
@property (strong, nonatomic) IBOutlet UILabel *sortLabel;

@property (strong, nonatomic) IBOutlet UIView *deleteAllView;
@property (strong, nonatomic) IBOutlet UIView *deleteButtonView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIImageView *deleteAllImg;
@property (strong, nonatomic) IBOutlet UILabel *deleteAllLabel;

@property (strong, nonatomic) IBOutlet UILabel *storageCountLabel;

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data;
- (void)refreshData;

- (IBAction)listSortChange:(id)sender;

// 삭제 모드
- (IBAction)deleteMode:(id)sender;
- (IBAction)deleteSelectAll:(id)sender;
- (IBAction)deleteSelectedList:(id)sender;
- (IBAction)deleteViewHide:(id)sender;
// 보관함 이동
- (IBAction)storageMoveClick:(id)sender;
@end
