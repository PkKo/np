//
//  HomeViewController.h
//  mp
//
//  Created by Infobank1 on 2015. 9. 9..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "HomeTimeLineView.h"
#import "HomeBankingView.h"
#import "DepositStickerView.h"
#import "WithdrawStickerSettingView.h"

typedef enum HomeViewType
{
    TIMELINE    = 0,
    BANKING,
    OTHER,
    INBOX
} HomeViewType;

@interface HomeViewController : UIViewController<IBInboxProtocol, StickerSettingDelegate>
{
    // 푸시 날짜 데이터 리스트
    NSMutableArray *sectionList;
    // 날짜를 키로 한 푸시 데이터 딕셔너리 리스트
    NSMutableArray *timelineMessageList;
    
    // 입금 스티커 뷰
    DepositStickerView *depositStickerView;
    // 출금 스티커 뷰
    WithdrawStickerSettingView *withdrawStickerView;
    // 선택한 스티커 인덱스
    NSIndexPath *currentStickerIndexPath;
}

@property (assign, nonatomic) HomeViewType viewType;
// 타임라인 탭
@property (strong, nonatomic) HomeTimeLineView  *mTimeLineView;
// 입출금 탭 뷰
@property (strong, nonatomic) HomeBankingView *bankingView;
// 실제 내용을 보여줄 뷰
@property (strong, nonatomic) IBOutlet UIView *mMainContentView;

- (void)refreshData:(BOOL)newData;
@end
