//
//  HomeTimeLineView.h
//  np
//
//  Created by Infobank1 on 2015. 9. 16..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawStickerSettingView.h"
#import "DepositStickerView.h"
#import "BannerInfoView.h"

@interface HomeTimeLineView : UIView<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshIndicator;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    UIView *refreshFooterView;
    UILabel *refreshFooterLabel;
    
    BOOL listSortType;
    
    NSMutableArray *deleteIdList;
    NSMutableArray *pinnedIdList;
    BOOL isDeleteMode;
    
    NSInteger storageCount;
    
    DepositStickerView *depositStickerView;
    WithdrawStickerSettingView *withdrawStickerView;
    NSIndexPath *currentStickerIndexPath;
    
    NSString *searchStartDate;
    NSString *searchEndDate;
    BOOL searchDateSelectType;
    
    BannerInfoView *bannerInfoView;
    
    UIView *pickerBgView;
}

@property (strong, nonatomic) id delegate;
// 날짜별 섹션 구분
@property (strong, nonatomic) NSMutableArray        *mTimeLineSection;
// 날짜를 키로 
@property (strong, nonatomic) NSMutableDictionary   *mTimeLineDic;

@property (strong, nonatomic) IBOutlet UITableView  *mTimeLineTable;

@property (strong, nonatomic) IBOutlet UILabel *sortLabel;
@property (strong, nonatomic) IBOutlet UIView *topMenuView;
@property (strong, nonatomic) IBOutlet UIView *listEmptyView;

// 삭제시 전체선택 뷰
@property (strong, nonatomic) IBOutlet UIView *deleteAllView;
@property (strong, nonatomic) IBOutlet UIImageView *deleteAllImg;
@property (strong, nonatomic) IBOutlet UILabel *deleteAllLabel;
// 삭제 하단 버튼 뷰
@property (strong, nonatomic) IBOutlet UIView *deleteButtonView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

// 검색 뷰
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UILabel *searchStartDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *searchEndDateLabel;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (assign, nonatomic) BOOL isSearchResult;
@property (strong, nonatomic) IBOutlet UIButton *periodOneWeekBtn;
@property (strong, nonatomic) IBOutlet UIButton *periodOneMonthBtn;
@property (strong, nonatomic) IBOutlet UIButton *periodThreeMonthBtn;
@property (strong, nonatomic) IBOutlet UIButton *periodSixMonthBtn;


@property (assign, nonatomic) BOOL isMoreList;

// 보관함에 저장된 갯수 표시
@property (strong, nonatomic) IBOutlet CircleView *storageCountBg;
@property (strong, nonatomic) IBOutlet UILabel *storageCountLabel;
@property (assign, nonatomic) NSInteger bannerIndex;
@property (strong, nonatomic) IBOutlet UIView *storageButtonView;

// no list imageView
@property (strong, nonatomic) IBOutlet UIImageView *emptyListImageView;

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data;
- (void)refreshData;

/**
 @brief 리스트 정렬 순서 변경
 */
- (IBAction)listSortChange:(id)sender;
// 삭제 관련 Action
- (IBAction)deleteMode:(id)sender;
- (IBAction)deleteSelectAll:(id)sender;
- (IBAction)deleteSelectedList:(id)sender;
- (IBAction)deleteViewHide:(id)sender;
// 검색 관련 Action
- (IBAction)searchViewShow:(id)sender;
- (IBAction)searchViewHide:(id)sender;
- (IBAction)searchPeriodSelect:(id)sender;
- (IBAction)searchStart:(id)sender;
- (IBAction)searchDateSelect:(id)sender;
- (IBAction)searchDatePickerShow:(id)sender;
- (IBAction)searchDatePickerHide:(id)sender;
// 보관함 이동
- (IBAction)storageMoveClick:(id)sender;
// 배너 타이머 스톱
- (void)bannerTimerStop;
@end
