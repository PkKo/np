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
#import "HomeEtcTimeLineView.h"
#import "DepositStickerView.h"
#import "WithdrawStickerSettingView.h"
#import "TimelineSectionData.h"
#import "MainPageViewController.h"
#import "ArchivedTransactionItemsViewController.h"

#define kNotificationAlarmDeleted	@"NOTIFICATION_ALARM_DELETED"
#define kMsgKeyArray @"msgKeyArray"	
#define TOP_MENU_BAR_HEIGHT     27

#define DELETE_MESSAGE(x)	[NSString stringWithFormat:@"%u개의 메시지를 삭제하시겠습니까? 전체 삭제는 메뉴의 데이터 초기화를 이용바랍니다.", x]


@interface HomeViewController : CommonViewController<IBInboxProtocol, StickerSettingDelegate>
{
    // 푸시 날짜 데이터 리스트
    NSMutableArray *sectionList;
    // 날짜를 키로 한 푸시 데이터 딕셔너리 리스트
    NSMutableDictionary *timelineMessageList;
    // 읽음 표시할 리스트
    NSMutableArray *unreadMessageList;
    
    // 입금 스티커 뷰
    DepositStickerView *depositStickerView;
    // 출금 스티커 뷰
    WithdrawStickerSettingView *withdrawStickerView;
    // 선택한 스티커 인덱스
    NSIndexPath *currentStickerIndexPath;
    int selectedStickerCode;
    
    BOOL isRefresh;
    BOOL isNewData;
    BOOL isAscending;
    BOOL isSearch;
    BOOL isMoreList;
	BOOL isFirstRequest;
}

@property (assign, nonatomic) HomeViewType viewType;
// 타임라인 탭
@property (strong, nonatomic) HomeTimeLineView  *mTimeLineView;
// 입출금 탭 뷰
@property (strong, nonatomic) HomeBankingView *bankingView;
// 기타 알림 탭 뷰
@property (strong, nonatomic) HomeEtcTimeLineView *etcTimeLineView;
// 보관함 뷰컨트롤러
@property (strong, nonatomic) ArchivedTransactionItemsViewController *archivedItemsViewController;
// 실제 내용을 보여줄 뷰
@property (strong, nonatomic) IBOutlet UIView *mMainContentView;
// 스크롤 위로 버튼
@property (strong, nonatomic) IBOutlet UIButton *scrollMoveTopButton;

- (void)refreshData:(BOOL)newData requestData:(AccountInboxRequestData *)requestData;
- (void)searchInboxDataWithQuery:(AccountInboxRequestData *)reqData;
- (IBAction)scrollToTop:(id)sender;
- (void)showScrollTopButton;
- (void)hideScrollTopButton;
@end
