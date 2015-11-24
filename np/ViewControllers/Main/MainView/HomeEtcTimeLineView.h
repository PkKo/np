//
//  HomeEtcTimeLineView.h
//  np
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeEtcTimeLineView : UIView<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
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
    
    NSMutableArray *deleteIdList;
    BOOL isDeleteMode;
    
    NSString *searchStartDate;
    NSString *searchEndDate;
    BOOL searchDateSelectType;
    
    UIView *pickerBgView;
}

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) IBOutlet UIView *listEmptyView;
@property (strong, nonatomic) NSMutableArray *timelineSection;
@property (strong, nonatomic) NSMutableDictionary *timelineDic;
@property (strong, nonatomic) IBOutlet UIView *deleteAllView;
@property (strong, nonatomic) IBOutlet UIView *deleteButtonView;
@property (strong, nonatomic) IBOutlet UIImageView *deleteAllImg;
@property (strong, nonatomic) IBOutlet UILabel *deleteAllLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

// 검색관련 View
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UILabel *searchStartDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *searchEndDateLabel;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (assign, nonatomic) BOOL isSearchResult;
@property (assign, nonatomic) BOOL isMoreList;
@property (strong, nonatomic) IBOutlet UIButton *periodOneWeekBtn;
@property (strong, nonatomic) IBOutlet UIButton *periodOneMonthBtn;
@property (strong, nonatomic) IBOutlet UIButton *periodThreeMonthBtn;
@property (strong, nonatomic) IBOutlet UIButton *periodSixMonthBtn;

@property (strong, nonatomic) IBOutlet UIImageView *emptyListImageView;

@property (strong, nonatomic) IBOutlet UILabel *serviceSelectLabel;

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data;
- (void)refreshData;

// 검색 관련 Action
- (IBAction)searchViewShow:(id)sender;
- (IBAction)searchViewHide:(id)sender;
- (IBAction)searchPeriodSelect:(id)sender;
- (IBAction)searchStart:(id)sender;
- (IBAction)searchDateSelect:(id)sender;
- (IBAction)searchDatePickerShow:(id)sender;
- (IBAction)searchDatePickerHide:(id)sender;
// 삭제 관련 Action
- (IBAction)deleteMode:(id)sender;
- (IBAction)deleteSelectAll:(id)sender;
- (IBAction)deleteSelectedList:(id)sender;
- (IBAction)deleteViewHide:(id)sender;
// 서비스별 선택 Action
- (IBAction)serviceSelectShow:(id)sender;

@end
