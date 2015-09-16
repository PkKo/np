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
    TIMELINE    = 100,
    BANKING,
    OTHER
} HomeViewType;

@interface HomeViewController : CommonViewController

@property (assign, nonatomic) HomeViewType mViewType;

// 타임라인 탭
@property (strong, nonatomic) IBOutlet UIButton *mTimeLineButton;
@property (strong, nonatomic) HomeTimeLineView  *mTimeLineView;
// 입출금내역 탭
@property (strong, nonatomic) IBOutlet UIButton *mIncomeButton;
// 기타메시지 탭
@property (strong, nonatomic) IBOutlet UIButton *mEtcButton;
// 실제 내용을 보여줄 뷰
@property (strong, nonatomic) IBOutlet UIView *mMainContentView;

- (IBAction)tabButtonClick:(id)sender;
@end
