//
//  HomeEtcTimeLineView.h
//  np
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeEtcTimeLineView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshIndicator;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    NSMutableArray *deleteIdList;
    BOOL isDeleteMode;
    
    NSString *searchStartDate;
    NSString *searchEndDate;
    BOOL searchDateSelectType;
}

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) IBOutlet UIView *listEmptyView;
@property (strong, nonatomic) NSMutableArray *timelineSection;
@property (strong, nonatomic) NSMutableDictionary *timelineDic;
@property (strong, nonatomic) IBOutlet UIView *deleteAllView;
@property (strong, nonatomic) IBOutlet UIView *deleteButtonView;
// 검색관련 View
@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UILabel *searchStartDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *searchEndDateLabel;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (assign, nonatomic) BOOL isSearchResult;


- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data;

// 검색 관련 Action
- (IBAction)searchViewShow:(id)sender;
- (IBAction)searchViewHide:(id)sender;
- (IBAction)searchPeriodSelect:(id)sender;
- (IBAction)searchStart:(id)sender;
- (IBAction)searchDateSelect:(id)sender;
- (IBAction)searchDatePickerShow:(id)sender;
- (IBAction)searchDatePickerHide:(id)sender;

@end
