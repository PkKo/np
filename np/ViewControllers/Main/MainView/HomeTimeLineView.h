//
//  HomeTimeLineView.h
//  np
//
//  Created by Infobank1 on 2015. 9. 16..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTimeLineView : UIView<UITableViewDataSource, UITableViewDelegate>
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
    
    NSMutableArray *deleteIdList;
    BOOL isDeleteMode;
}

@property (strong, nonatomic) id delegate;
// 날짜별 섹션 구분
@property (strong, nonatomic) NSMutableArray        *mTimeLineSection;
// 날짜를 키로 
@property (strong, nonatomic) NSMutableDictionary   *mTimeLineDic;
@property (strong, nonatomic) IBOutlet UITableView  *mTimeLineTable;

// 삭제시 전체선택 뷰
@property (strong, nonatomic) IBOutlet UIView *deleteAllView;
@property (strong, nonatomic) IBOutlet UIImageView *deleteAllImg;
@property (strong, nonatomic) IBOutlet UILabel *deleteAllLabel;
// 삭제 하단 버튼 뷰
@property (strong, nonatomic) IBOutlet UIView *deleteButtonView;
// 검색 뷰
@property (strong, nonatomic) IBOutlet UIView *searchView;
// 보관함에 저장된 갯수 표시
@property (strong, nonatomic) IBOutlet UILabel *storageCountLabel;

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data;

/**
 @brief 리스트 정렬 순서 변경
 */
- (IBAction)listSortChange:(id)sender;
- (IBAction)searchViewShow:(id)sender;
- (IBAction)deleteMode:(id)sender;

- (IBAction)deleteSelectAll:(id)sender;
- (IBAction)deleteSelectedList:(id)sender;
- (IBAction)deleteViewHide:(id)sender;

- (IBAction)searchViewHide:(id)sender;
- (IBAction)storageMoveClick:(id)sender;
@end
