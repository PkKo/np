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
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
    BOOL listSortType;
}

@property (strong, nonatomic) id delegate;
// 날짜별 섹션 구분
@property (strong, nonatomic) NSMutableArray        *mTimeLineSection;
// 날짜를 키로 
@property (strong, nonatomic) NSMutableDictionary   *mTimeLineDic;
@property (strong, nonatomic) IBOutlet UITableView  *mTimeLineTable;

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data;

/**
 @brief 리스트 정렬 순서 변경
 */
- (IBAction)listSortChange:(id)sender;
- (IBAction)searchViewShow:(id)sender;
- (IBAction)deleteMode:(id)sender;

@end
