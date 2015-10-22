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
    
    BOOL listSortType;
    
    NSMutableArray *deleteIdList;
    BOOL isDeleteMode;
}

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) NSMutableArray *timelineSection;
@property (strong, nonatomic) NSMutableDictionary *timelineDic;
@property (strong, nonatomic) IBOutlet UIView *deleteAllView;
@property (strong, nonatomic) IBOutlet UIView *deleteButtonView;
@property (strong, nonatomic) IBOutlet UIView *searchView;

- (void)initData:(NSMutableArray *)section timeLineDic:(NSMutableDictionary *)data;
@end
