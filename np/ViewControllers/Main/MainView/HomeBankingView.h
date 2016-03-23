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

@interface HomeBankingView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL isDeleteMode;
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshIndicator;
    
    UILabel *refreshEmptyLabel;
    UIImageView *refreshEmptyIndicator;
    
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    UIView *refreshFooterView;
    UILabel *refreshFooterLabel;
    
    BOOL listSortType;
    NSMutableArray *pinnedIdList;
    NSMutableArray *deleteIdList;
    
    NSInteger storageCount;
    
    DepositStickerView *depositStickerView;
    WithdrawStickerSettingView *withdrawStickerView;
    NSIndexPath *currentStickerIndexPath;
    
    NSString *searchStartDate;
    NSString *searchEndDate;
    BOOL searchDateSelectType;
    
    NSMutableArray *allAccountList;
    NSArray *inboxTypeList;
    NSInteger inboxAccountsIndex;
    NSInteger inboxTypeIndex;
    NSInteger inboxTypePickerMode;
    
    UIView *pickerBgView;
}

@property (strong, nonatomic) id delegate;
// 날짜별 섹션 구분
@property (strong, nonatomic) NSMutableArray        *mTimeLineSection;
// 날짜를 키로
@property (strong, nonatomic) NSMutableDictionary   *mTimeLineDic;
@property (strong, nonatomic) IBOutlet UITableView *bankingListTable;
@property (strong, nonatomic) IBOutlet UIView *listEmptyView;
@property (strong, nonatomic) IBOutlet UILabel *emptyLabel;
@property (strong, nonatomic) IBOutlet UITableView *emptyScrollView;

@property (strong, nonatomic) IBOutlet UIButton *statisticButton;
@property (strong, nonatomic) IBOutlet UILabel *sortLabel;

@property (strong, nonatomic) IBOutlet UIView *deleteAllView;
@property (strong, nonatomic) IBOutlet UIView *deleteButtonView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIImageView *deleteAllImg;
@property (strong, nonatomic) IBOutlet UILabel *deleteAllLabel;

// 검색 뷰
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UILabel *searchStartDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *searchEndDateLabel;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *searchTypePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *searchTypePicker;
@property (strong, nonatomic) IBOutlet UILabel *searchTypeAccountLabel;
@property (strong, nonatomic) IBOutlet UILabel *searchTypeInboxLabel;
@property (assign, nonatomic) BOOL isSearchResult;
@property (assign, nonatomic) BOOL isMoreList;
@property (strong, nonatomic) IBOutlet UIButton *periodOneWeekBtn;
@property (strong, nonatomic) IBOutlet UIButton *periodOneMonthBtn;
@property (strong, nonatomic) IBOutlet UIButton *periodThreeMonthBtn;
@property (strong, nonatomic) IBOutlet UIButton *periodSixMonthBtn;

@property (strong, nonatomic) IBOutlet CircleView *storageCountBg;
@property (strong, nonatomic) IBOutlet UILabel *storageCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *emptyListImageView;

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data;
- (void)refreshData;

- (IBAction)listSortChange:(id)sender;

// 삭제 모드
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
- (IBAction)showInboxTypePickerShow:(id)sender;
- (IBAction)inboxTypeSelect:(id)sender;
- (IBAction)inboxTypePickerHide:(id)sender;

// 보관함 이동
- (IBAction)storageMoveClick:(id)sender;
@end
