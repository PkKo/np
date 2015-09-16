//
//  NFIlterChar.h
//  nFilterChar KeyPad
//
//  Created by NSHC on 2013/07/29
//  Copyright (c) 2013 NSHC. ( http://www.nshc.net )
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nFilterTypes.h"

@interface NFilterChar : UIViewController {

	IBOutlet UIView *viewPortrait;                          // nFilter 메인뷰
	IBOutlet UIView *viewLandscape;                         // nFilter 메인뷰 가로모드
	
    IBOutlet UIView *viwToolbar;                            // 툴바 뷰
    
    IBOutlet UIView *viwFullMode;                           // 풀모드 상단
    
    IBOutlet UIView *viwCharPad;                            // 키패드뷰
	IBOutlet UIView *viwCharPadLandscape;                   // 키패드뷰 가로모드
    
	IBOutlet UILabel *lblCursor;                            // 커서
	IBOutlet UILabel *lblCursorLand;                        // 커서 가로모드
    
	IBOutlet UILabel *lblInputValue;                        // 입력문자
	IBOutlet UILabel *lblInputValueLandscape;               // 입력문자 가로모드

    IBOutlet UILabel *lblBigNum;                            // 풍선문자 (숫자)
    IBOutlet UILabel *lblBigNumLandscape;                   // 풍선문자 가로모드 (숫자)
    IBOutlet UILabel *lblBigChr;                            // 풍선문자 (문자)
    IBOutlet UILabel *lblBigChrLandscape;                   // 풍선문자 가로모드 (문자)
    IBOutlet UILabel *lblBigRandom;                         // 풍선문자 랜덤
    IBOutlet UILabel *lbltopTitle;                          // 상단 타이틀
    IBOutlet UILabel *lbltopBarTitle;                       // 탑바 타이틀
    
	IBOutlet UITextField *txtInSecurity;                    // 입력문자 저장용
	IBOutlet UITextField *txtInSecurityLandscape;           // 입력문자 저장용 가로모드
    
	IBOutlet UIImageView *imgBigNum;                        // 풍선문자이미지 (숫자)
	IBOutlet UIImageView *imgBigNumLandscape;               // 풍선문자이미지 가로모드 (숫자)
	IBOutlet UIImageView *imgBigChr;                        // 풍선문자이미지 (문자)
	IBOutlet UIImageView *imgBigChrLandscape;               // 풍선문자이미지 (문자)
	IBOutlet UIImageView *imgBigRadom;                      // 풍선문자이미지 (랜덤)
    IBOutlet UIImageView *shiftIco;                         // 쉬프트버튼 아이콘
    IBOutlet UIImageView *shiftIcoLandscape;                // 쉬프트버튼 아이콘 가로모드
    IBOutlet UIImageView *delIcoLandscape;                  // 지우기버튼 아이콘 가로모드
    
	IBOutlet UIButton *_btnKeymode;                         // 키모드버튼
    IBOutlet UIButton *_btnKeymodeLandscape;                // 키모드버튼 가로모드
	
    IBOutlet UIButton *btnShiftkey;                         // shift 버튼
    
    IBOutlet UIButton *btnEngkey;                           // 영문 버튼
    IBOutlet UIButton *btnEngkeyLandscape;                  // 영문 버튼 가로모드
    
    IBOutlet UIButton *btnReplacekey;                       // 재배열 버튼
    IBOutlet UIButton *btnReplacekeyLandscape;              // 재배열 버튼 가로모드
    
    IBOutlet UIButton *btnConfirm;                          // 확인 버튼
    IBOutlet UIButton *btnCancel;                           // 취소 버튼
    
    IBOutlet UIButton *btnConfirmLandscape;                 // 확인 버튼 가로모드
    IBOutlet UIButton *btnCancelLandscape;                  // 취소 버튼 가로모드
    
    IBOutlet UIButton *btnToolbarConfirm;                   // 툴바 확인 버튼
    IBOutlet UIButton *btnToolbarPrev;                      // 툴바 이전 버튼
    IBOutlet UIButton *btnToolbarNext;                      // 툴바 다음 버튼
    
    IBOutlet UIButton *btnBackGroundClose;                  // 하프 모드 시에 백그라운드 클릭시 엔필터 닫힘
    
    id _pTarget;                    // 타겟
    
    SEL _pMethodOnNext;             // 다음 셀렉터
    SEL _pMethodOnPrev;             // 이전 셀렉터
    SEL _pMethodOnPress;            // 버튼 누름 셀렉터
    SEL _pMethodOnConfirm;          // 확인 셀렉터
	SEL _pMethodOnCancel;           // 취소 셀렉터
    
    NSString *tagName;              // 태그이름
    NSString *title;                // 타이틀
    NSString *barTitle;             // 바타이틀
	NSDictionary *dictKeys;         // 버튼라벨
	NSArray *arrKeys;
	NSInteger lengthLimit;          // 길이한정
	UIWebView *webview;             // 웹뷰
	NSTimer *tmrCursor;             // 커서 타이머
	UIButton *btnRadnomNum;         // 빈넘버
    
	NKeymodeType _keymodeTypeCurr;  // 키모드
    
	BOOL isStopCursor;              // 커서정지
	BOOL isDeepSecMode;             // 강한보안모드
	BOOL isSuportLandscape;         // 가로모드지원
	BOOL isHideLastValue;           // 마지막 문자 없앰
	BOOL isLandscapeMode;           // 가로모드
    BOOL isSuportRotation;          // 회전지원
    BOOL isSuportReplaceTable;      // 치환테이블
    BOOL isNonPlainText;            // 빈문자열
    BOOL isSuportCapslock;          // CapsLock 설정
    BOOL isReadyFixUppercase;       // 대문자 고정모드
    BOOL isFixUppercase;            // 대문자 고정모드
    BOOL isSuportBackgroundEvent;   // 백그라운드 이벤트
    BOOL isFullMode;                // 풀모드 옵션
    BOOL isWhileDOWN;               // 누르고 있는동안
    BOOL isToolbarHidden;           // 툴바
    BOOL isNoPadding;
    BOOL isNoSound;                 // 사운드
    BOOL isEngMode;                 // 영문모드
    BOOL isDummyData;               // 평문 사용 안함
    BOOL isBackGroundClose;         // 백그라운드 클릭시 종료
    BOOL isSupportFullEnc;          // 평문암호화
    BOOL isSupportLinkage;          // 연동모드
    BOOL isSupportRetinaHD;          // 6,6+ xib 지원
    
    float btnRect;                  // 가로모드 버튼 공백
    float barHeight;                // 바 높이
    
    NSMutableString* stringKeyboardType;    // 키모드 타입
    
    CGRect screenBound;             // 이하 스크린 사이즈
    CGSize screenSize;
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat nfilterHeight;          //  nfilter 높이
    
    NSString *OKTxt;
    NSString *CancelTxt;
    NSString *ENTxt;
    NSString *RepTxt;
    NSString *PrevTxt;
    NSString *NextTxt;
}

@property (nonatomic, retain) NSTimer* tmrCursor;
@property (nonatomic, retain) NSMutableString* stringKeyboardType;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, strong) NSString *OKTxt;
@property (nonatomic, strong) NSString *CancelTxt;
@property (nonatomic, strong) NSString *ENTxt;
@property (nonatomic, strong) NSString *RepTxt;
@property (nonatomic, strong) NSString *PrevTxt;
@property (nonatomic, strong) NSString *NextTxt;
@property (nonatomic, assign) float barHeight;
@property (nonatomic, assign) BOOL isBackGroundClose;       // 백그라운드 클릭시 종료
@property (nonatomic, strong) UIView *backgroundView;

- (IBAction)pressCancel;                                    // 취소버튼
- (IBAction)pressConfirm;                                   // 확인버튼
- (IBAction)touchDownKepad:(id)sender;                      // 키패드누름상태
- (IBAction)pressButton:(id)sender;                         // 키패드 누름
- (IBAction)pressBack;                                      // 뒤로가기
- (IBAction)backRepeat;                                     // 뒤로가기 반복
- (IBAction)pressKeypadReload;                              // 재배열버튼
- (IBAction)changeKeypadMode:(id)sender;                    // 키패드모드변경
- (IBAction)pressBackGround:(id)sender;     // 백그라운드 클릭

+ (NFilterChar*)charPadShared;
- (void)setRotateToInterfaceOrientation:(UIInterfaceOrientation)tointerfaceOrientation;                                  // 회전지원
- (void)setRotateToInterfaceOrientation:(UIInterfaceOrientation)tointerfaceOrientation parentView:(UIView*)pParentView;  // 회전지원
- (void)clearField;                                          // 키패드 클리어
- (void)closeNFilter;                                        // 키패드 닫기

// 이하 고객지원옵션
- (void)setSupportBackgroundEvent:(BOOL)pYesOrNo;           // 백그라운드 이벤트
- (void)setSupportCapslock:(BOOL)pYesOrNO;                  // Caps Lock 지원모드
- (void)setSupportReplaceTable:(BOOL)pYesOrNO;              // 랜덤넘버
- (void)setHideLastValue:(BOOL)pYesOrNo;                    // 마지막 문자 숨김
- (void)setDeepSecMode:(BOOL)pYesOrNo;                      // 강한보안모드
- (void)setSupportRotation:(BOOL)pYesOrNo;                  // 회전 설정
- (void)setServerPublickey:(NSString *)pServerPublickey;    // 서버공개키설정
- (void)setServerPublickeyURL:(NSString *)pXmlURL;          // 서버공개키 설정(xml)
- (void)setLengthWithTagName:(NSString *)pTagName length:(NSInteger)pLength webView:(UIWebView *)pWebView; // 태그이름 길이 설정
- (void)setFullMode:(BOOL)pYesOrNo;                         // 풀모드 설정
- (void)setTitleText:(NSString *)ptitle;                    // 타이틀 텍스트 설정
- (void)setTopBarText:(NSString *)bBarTitle;                // 탑바 텍스트 설정
- (void)setToolBar:(BOOL)pYesOrNo;                          // 툴바 설정
- (void)setNonPlainText:(BOOL)pYesOrNo;                     // 평문없앰
- (void)setNoPadding:(BOOL)pYesOrNo;                        // 패딩없음
- (void)setNoSound:(BOOL)pYesOrNo;                          // 사운드 없앰
- (void)setEngMode:(BOOL)pYesOrNo;                          // 영문모드
- (void)setDummyText:(BOOL)pYesOrNo;                        // 평문 사용 안함
- (void)setSupportBackGroundClose:(BOOL)pYesOrNO;           // 백그라운드 클릭시 종료
- (void)setSupportFullEnc:(BOOL)pYesOrNO;                 // 평문 암호화
- (void)setVerticalFrame:(NSInteger)pYFrame;                // View의 Y축을 조절
- (void)setSupportLinkage:(BOOL)pYesOrNO;                 // 연동모드
- (void)setSupportRetinaHD:(BOOL)pYesOrNO;                  // 6,6+ xib 지원
- (void)setBtnTextWithEngText:(NSString *)pEnText
                      repText:(NSString *)pRepText
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
