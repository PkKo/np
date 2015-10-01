//
//  HomeViewController.h
//  mp
//
//  Created by Infobank1 on 2015. 9. 9..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "HomeTimeLineView.h"

typedef enum HomeViewType
{
    TIMELINE    = 0,
    BANKING,
    OTHER,
    INBOX
} HomeViewType;

@interface HomeViewController : UIViewController

@property (assign, nonatomic) HomeViewType viewType;
// 타임라인 탭
@property (strong, nonatomic) HomeTimeLineView  *mTimeLineView;
// 실제 내용을 보여줄 뷰
@property (strong, nonatomic) IBOutlet UIView *mMainContentView;
@property (strong, nonatomic) IBOutlet UILabel *indexView;
@end
