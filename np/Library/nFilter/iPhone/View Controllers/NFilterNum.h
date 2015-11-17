//
//  NFIlterNum.h
//  nFilterNum KeyPad
//
//  Created by NSHC on 2013/07/29
//  Copyright (c) 2013 NSHC. ( http://www.nshc.net )
//  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFilterNum : UIViewController {
    
    IBOutlet UIView *viewPortrait;          // nFilter 메인뷰
	IBOutlet UIView *viewLandscape;         // nFilter 메인뷰 가로모드
    
    IBOutlet UIView *viwNumbPad;            // 숫자패드 뷰
    IBOutlet UIView *viwNumbPadLandscape;   // 숫자패드 뷰 가로모드
    
    IBOutlet UIView *viwToolbar;            // 툴바 뷰
    
    IBOutlet UIView *viwFullMode;           // 풀모드 상단
	
    IBOutlet UIView *vwInputDefalt;         // 기본 입력뷰
    IBOutlet UIView *vwInputIdentityNum;    // 주민등록번호 입력
    IBOutlet UIView *vwInputIdentityId;    // 주민등록번호 입력

    
	IBOutlet UILabel *lblCursor;            // 커서
    IBOutlet UILabel *lblCursorLand;        // 커서 가로모드
	
	IBOutlet UILabel *lblInputValue;        // 마지막 입력문자
    IBOutlet UILabel *lblInputValueLand;    // 마지막 입력문자 가로모드
    
    IBOutlet UILabel *lbltopTitle;          // 상단 타이틀
    IBOutlet UILabel *lbltopBarTitle;       // 탑바 타이틀
    IBOutlet UILabel *lbltopBarTitleLand;   // 탑바 타이틀
    IBOutlet UILabel *lblInputValueIdNum1;  // 주민번호 입력문자
	IBOutlet UILabel *lblInputValueIdNum2;  // 주민번호 입력문자
    IBOutlet UILabel *lblInputValueId;      // 주민번호 입력문자
    
    IBOutlet UILabel *lblCursorIdNum1;      // 주민번호 커서
	IBOutlet UILabel *lblCursorIdNum2;      // 주민번호 커서
    IBOutlet UILabel *lblCursorId;      // 주민번호 커서
    
	IBOutlet UITextField *txtInSecurity;    // 입력문자 저장용
    IBOutlet UITextField *txtInSecurityLand;// 입력문자 저장용 가로모드
    IBOutlet UITextField *txtInSecurityIdNum1; // 주민번호 텍스트필드
	IBOutlet UITextField *txtInSecurityIdNum2; // 주민번호 텍스트 필드
    IBOutlet UITextField *txtInSecurityId;   // 주민번호 텍스트필드
    
	IBOutlet UIButton *keypad1;             // 키패드
	IBOutlet UIButton *keypad2;             // 키패드
	IBOutlet UIButton *keypad3;             // 키패드
	IBOutlet UIButton *keypad4;             // 키패드
	IBOutlet UIButton *keypad5;             // 키패드
	IBOutlet UIButton *keypad6;             // 키패드
	IBOutlet UIButton *keypad7;             // 키패드
	IBOutlet UIButton *keypad8;             // 키패드
	IBOutlet UIButton *keypad9;             // 키패드
	IBOutlet UIButton *keypad0;             // 키패드
    
	IBOutlet UIButton *keypad1_land;        // 키패드 가로모드
	IBOutlet UIButton *keypad2_land;        // 키패드 가로모드
	IBOutlet UIButton *keypad3_land;        // 키패드 가로모드
	IBOutlet UIButton *keypad4_land;        // 키패드 가로모드
	IBOutlet UIButton *keypad5_land;        // 키패드 가로모드
	IBOutlet UIButton *keypad6_land;        // 키패드 가로모드
	IBOutlet UIButton *keypad7_land;        // 키패드 가로모드
	IBOutlet UIButton *keypad8_land;        // 키패드 가로모드
	IBOutlet UIButton *keypad9_land;        // 키패드 가로모드
	IBOutlet UIButton *keypad0_land;        // 키패드 가로모드
	
	IBOutlet UIButton *btnReload;           // 재배열 버튼
    IBOutlet UIButton *btnReloadLandscape;  // 재배열 버튼 가로모드
    
    IBOutlet UIButton *btnReplacekey;                       // 재배열 버튼
    IBOutlet UIButton *btnReplacekeyLandscape;              // 재배열 버튼 가로모드
    
    IBOutlet UIButton *btnConfirm;                          // 확인 버튼
    IBOutlet UIButton *btnCancel;                           // 취소 버튼
    
    IBOutlet UIButton *btnConfirmLandscape;                 // 확인 버튼 가로모드
    IBOutlet UIButton *btnCancelLandscape;                  // 취소 버튼 가로모드
    
    IBOutlet UIButton *btnToolbarConfirm;                   // 툴바 확인 버튼
    IBOutlet UIButton *btnToolbarPrev;                      // 툴바 이전 버튼
    IBOutlet UIButton *btnToolbarNext;                      // 툴바 다음 버튼
    IBOutlet UIImageView *imgToolbarPrev;                   // 툴바 이전 버튼 이지미
    IBOutlet UIImageView *imgToolbarNext;                   // 툴바 다음 버튼 이지미
    
    IBOutlet UIButton *btnBackGroundClose;                  // 하프 모드 시에 백그라운드 클릭시 엔필터 닫힘
    
    id _pTarget;                    // 타겟
    
    SEL _pMethodOnNext;             // 다음 셀렉터
    SEL _pMethodOnPrev;             // 이전 셀렉터
    SEL _pMethodOnPress;            // 버튼 누름 셀렉터
    SEL _pMethodOnConfirm;          // 확인 셀렉터
	SEL _pMethodOnCancel;           // 취소 셀렉터
	
	NSInteger lengthLimit;          // 텍스트 길이
	NSString *tagName;              // 태그 이름
    NSString *title;                // 타이틀
    NSString *barTitle;             // 바타이틀
    NSTimer *tmrCursor;             // 커서타이머
    UIButton *btnRadnomNum;         // 랜덤버튼
    NSArray *arrGapByEcc;
    
	BOOL isStopCursor;              // 커서멈춤
    BOOL isSuportLandscape;         // 가로모드 지원
    BOOL isLandscapeMode;           // 회전지원
	BOOL ignoreSuffle;              // 재배열 금지
	BOOL isDeepSecMode;             // 강한보안모드
	BOOL isHideLastValue;           // 마지막 입력값 숨김
    BOOL isNonPlainText;            // 평문없음
    BOOL isFullMode;                // 풀모드 옵션
    BOOL isSuportBackgroundEvent;   // 백그라운드이벤트 지원
    BOOL isSerialMode;              // 시리얼 모드
    BOOL isToolbarHidden;           // 툴바
    BOOL isNoSound;                 // 사운드
    BOOL isSuportRotation;          // 회전지원
    BOOL isInputBoxForIdentityNum;  // 주민등록번호 옵션
    BOOL isEngMode;                 // 영문모드
    BOOL isDummyData;               // 평문 사용 안함
    BOOL isInputSecurityId;         // 주민등록번호 옵션
    BOOL isBackGroundClose;         // 백그라운드 클릭시 종료
    BOOL isSupportFullEnc;          // 평문암호화
    BOOL isSupportLinkage;          // 연동모드
    BOOL isSupportRetinaHD;          // 6,6+ xib 지원
    
    float barHeight;                // 바 높이
    
    CGRect screenBound;             // 이하 스크린 사이즈
    CGSize screenSize;
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat nfilterHeight;          //  nfilter 높이
    
    NSString *OKTxt;
    NSString *CancelTxt;
    NSString *RepTxt;
    NSString *PrevTxt;
    NSString *NextTxt;
}

@property (nonatomic, retain) NSTimer* tmrCursor;           // 커서 타이머
@property (nonatomic, strong) NSString* tagName;
@property (nonatomic, assign) float barHeight;                // 바 높이
@property (nonatomic, assign) BOOL isBackGroundClose;       // 백그라운드 클릭시 종료
@property (nonatomic, strong) NSString *OKTxt;
@property (nonatomic, strong) NSString *CancelTxt;
@property (nonatomic, strong) NSString *RepTxt;
@property (nonatomic, strong) NSString *PrevTxt;
@property (nonatomic, strong) NSString *NextTxt;
@property (nonatomic, strong) UIView *backgroundView;

- (IBAction)pressCancel;                    // 취소
- (IBAction)pressConfirm;                   // 확인
- (IBAction)onBtnPrev:(id)sender;           // 이전
- (IBAction)onBtnNext:(id)sender;           // 다음
- (IBAction)pressButton:(id)sender;         // 버튼 누르기
- (IBAction)pressBack;                      // 백버튼
- (IBAction)pressKeypadReload;              // 재배열
- (IBAction)pressBackGround:(id)sender;     // 백그라운드 클릭

// show for trans
+ (NFilterNum*)numPadShared;                //싱글톤
- (void)setRotateToInterfaceOrientation:(UIInterfaceOrientation)tointerfaceOrientation;                                  // 회전지원
- (void)setRotateToInterfaceOrientation:(UIInterfaceOrientation)tointerfaceOrientation parentView:(UIView*)pParentView;  // 회전지원
- (void)clearField;                                         // 필드클리어
- (void)closeNFilter;                                       // nFilter 닫기

// 이하 고객지원 옵션
- (void)setBackgroundDimmedColor;
- (void)hidePrvNxtBtnsOfToolbar;
- (void)setSupportBackgroundEvent:(BOOL)pYesOrNo;           // 백그라운드 이벤트 설정
- (void)setDeepSecMode:(BOOL)pYesOrNo;                      // 강한 보한 모드 설정
- (void)setSupportRotation:(BOOL)pYesOrNo;                  // 회전 설정
- (void)setIgnoreSuffle:(BOOL)pIgnoreSuffle;                // 셔플안함 설정
- (void)setServerPublickey:(NSString *)pServerPublickey;    // 서버공개키 설정
- (void)setServerPublickeyURL:(NSString *)pXmlURL;          // 서버공개키 설정(xml)
- (void)setFullMode:(BOOL)pYesOrNo;                         // 풀모드 설정
- (void)setTitleText:(NSString *)ptitle;                    // 타이틀 텍스트 설정
- (void)setTopBarText:(NSString *)bBarTitle;                // 탑바 텍스트 설정
- (void)setToolBar:(BOOL)pYesOrNo;                          // 툴바 설정
- (void)setLengthWithTagName:(NSString *)pTagName length:(NSInteger)pLength webView:(UIWebView *)pWebView;            // 태그이름,길이 설정
- (void)setNonPlainText:(BOOL)pYesOrNo;                     // 평문없앰 설정
- (void)setNoSound:(BOOL)pYesOrNo;                          // 사운드 없앰
- (void)setSupportIdentityNum:(BOOL)pYesOrNo;
- (void)setSupportIdentityId:(BOOL)pYesOrNo;                // 주민등록번호
- (void)setEngMode:(BOOL)pYesOrNo;                          // 영문모드
- (void)setDummyText:(BOOL)pYesOrNo;                        // 평문 사용 안함
- (void)setSupportBackGroundClose:(BOOL)pYesOrNO;           // 백그라운드 클릭시 종료
- (void)setSupportFullEnc:(BOOL)pYesOrNO;                 // 평문 암호화
- (void)setVerticalFrame:(NSInteger)pYFrame;                // View의 Y축을 조절
- (void)setSupportLinkage:(BOOL)pYesOrNO;                 // 연동모드
- (void)setSupportRetinaHD:(BOOL)pYesOrNO;                  // 6,6+ xib 지원
- (void)setBtnTextWithRepText:(NSString *)pRepText
                       okText:(NSString *)pOkText
                   cancelText:(NSString *)pCancelText
                     prevText:(NSString *)pPrevText
                     nextText:(NSString *)pNextText;

- (void)setCallbackMethod:(id)pTarget
          methodOnConfirm:(SEL)pMethodOnConfirm
             methodOnPrev:(SEL)pMethodOnPrev
             methodOnNext:(SEL)pMethodOnNext
            methodOnPress:(SEL)pMethodOnPress;              // 콜백 메소드 설정
- (void)setCallbackMethod:(id)pTarget
          methodOnConfirm:(SEL)pMethodOnConfirm
            methodOnPress:(SEL)pMethodOnPress;              // 콜백 메소드 설정
- (void)setCallbackMethod:(id)pTarget
          methodOnConfirm:(SEL)pMethodOnConfirm
		   methodOnCancel:(SEL)pMethodOnCancel;             // 콜백 메소드 설정

@end
