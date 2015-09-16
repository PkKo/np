//
//  NFIlterNum.m
//  nFilterNum KeyPad
//
//	Ver.5.2.16.ad
//  Created by NSHC on 2013/07/29
//  Copyright (c) 2013 NSHC. ( http://www.nshc.net )
//  All rights reserved.
//

#import "nFilterNumForPad.h"
#import "EccEncryptor.h"
#import "NSStringKNAdditions.h"
#import "KNStringutil.h"
#import <AudioToolbox/AudioServices.h>
#include <CommonCrypto/CommonDigest.h>

@implementation nFilterNumForPad {
@private
    EccEncryptor *ec;               // 암복호화 객체
    NSString *stringStore;
    NSInteger yFrame;               // Y 포지션 조절
}

@synthesize tmrCursor;
@synthesize tmrMasking;
@synthesize tagName;

@synthesize OKTxt = _OKTxt;
@synthesize CancelTxt = _CancelTxt;
@synthesize RepTxt = _RepTxt;
@synthesize PrevTxt = _PrevTxt;
@synthesize NextTxt = _NextTxt;
@synthesize backgroundView = _backgroundView;

static nFilterNumForPad* instance = nil;

#pragma mark - 싱글톤
+ (nFilterNumForPad*)nFilterNumForiPad {
    
    if (instance == nil) {
        instance = [[nFilterNumForPad alloc] initWithNibName:@"nFilterNumForPad" bundle:nil];
    }
    
    return instance;
}


-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    
    self = [super initWithNibName:nibName bundle:nibBundle];
    
    // 암복호화 객체 초기화
    ec = [EccEncryptor sharedInstance];
    
    // 닙이름으로 시리얼모드인지 변수 저장
    if ([nibName isEqualToString:@"NFilterSerialNum"]) {
        isSerialMode = YES;
    }
    return self;
}

#pragma mark - ---------------------------------------------- IBAction ----------------------------------------------

#pragma mark - 버튼 누름 이벤트

- (IBAction)pressButton:(id)sender {
    
    [self soundPlay:@"click"];
    
    if ( txtInSecurity.text.length == lengthLimit )
        return;
    
    [tmrMasking invalidate];
    tmrMasking = nil;
    
    // 커서깜빡임을 없앤다
    [self stopCursor];
    
    UIButton *button = (UIButton *)sender;
    lblInputValue.text = [button titleLabel].text;
    lblInputValueLand.text = [button titleLabel].text;
    
    // 2초 후에 변경..
    self.tmrMasking = [NSTimer scheduledTimerWithTimeInterval: 2.0
                                                       target: self
                                                     selector: @selector(changeLastInputValue)
                                                     userInfo: nil
                                                      repeats: NO];
    
    
    if (isDeepSecMode) {
        [self performSelector:@selector(deepSecurityMode:) withObject:sender];
    } else {
        lblInputValue.hidden = NO;
        lblInputValueLand.hidden = NO;
    }
    
    NSString *newStr = [[NSString alloc] initWithFormat:@"%@%d", stringStore, (int)[(UIButton *)sender tag] -1];
    txtInSecurity.text = [self getDummyData:newStr.length];
    txtInSecurityLand.text = [self getDummyData:newStr.length];
    stringStore = newStr;
    
    if (_pMethodOnPress == nil)
        return;
    
    [self returnWithCallBackMethod:_pMethodOnPress];
}
#pragma mark - 지우기 버튼 이벤트

- (IBAction)pressBack {
    
    [self soundPlay:@"click"];
    
    lblInputValue.hidden = YES;
    lblInputValueLand.hidden = YES;
    
    NSString *newStr = stringStore;
    if (newStr.length == 0) return;
    
    // 하나를 지웁니다
    NSString *backStr = [[NSString alloc] initWithFormat:@"%@", [newStr substringToIndex:(newStr.length -1)]];
    
    txtInSecurity.text = [self getDummyData:backStr.length];
    txtInSecurityLand.text = [self getDummyData:backStr.length];
    stringStore = backStr;
    
    // 커서깜빡임 시작
    if (backStr.length == 0) {
        isStopCursor = NO;
        [self playCursor];
    }
    
    if (_pMethodOnPress == nil)
        return;
    
    [self returnWithCallBackMethod:_pMethodOnPress];
}

#pragma mark - 이전 버튼 이벤트

- (IBAction)onBtnPrev:(id)sender {
    if (_pMethodOnPrev == nil)
        return;
    
    [self returnWithCallBackMethod:_pMethodOnPrev];
}

#pragma mark - 다음 버튼 이벤트

- (IBAction)onBtnNext:(id)sender {
    
    if (_pMethodOnNext == nil)
        return;
    
    [self returnWithCallBackMethod:_pMethodOnNext];
}

#pragma mark - 취소 버튼 이벤트

- (IBAction)pressCancel {
    if (_pMethodOnCancel == nil)
        return;
    [self returnWithCallBackMethod:_pMethodOnCancel];
    [self closeNFilter];
    return;
}

#pragma mark - 확인 버튼 이벤트

// 확인, 완료 버튼 등에 연결되어 있음

- (IBAction)pressConfirm {
    if (_pMethodOnConfirm == nil)
        return;
    [self returnWithCallBackMethod:_pMethodOnConfirm];
    [self closeNFilter];
}

#pragma mark - 재배열 버튼 누름 이벤트

- (IBAction)pressKeypadReload {
    [self soundPlay:@"click2"];
    [self reloadKeypad];
    [self clearField];
}

#pragma mark - ---------------------------------------------- 내부 함수 ----------------------------------------------

#pragma mark - 엔필터 닫기

-(void)closeNFilter {
    [self clearField];
    [self.view removeFromSuperview];
}

#pragma mark - 필드 클리어

-(void)clearField {
    stringStore = @"";
    txtInSecurity.text = @"";
    txtInSecurityLand.text = @"";
    lblInputValue.text = @"";
    lblInputValueLand.text = @"";
}

#pragma mark - 사운드 플레이

- (void)soundPlay:(NSString*)pSoundFile {
    
    if (isNoSound) {
        return;
    }
    
    CFBundleRef mb = CFBundleGetMainBundle ();
    CFURLRef soundFileURLRef = CFBundleCopyResourceURL
    (mb, (__bridge CFStringRef) pSoundFile, CFSTR ("wav"), NULL);
    
    UInt32 soundID;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
    CFRelease(soundFileURLRef);
    AudioServicesPlaySystemSound(soundID);
    
}

#pragma mark - 커서 시작

- (void)playCursor {
    if (isStopCursor)
        return;
    
    lblCursor.hidden = !(lblCursor.hidden);
    lblCursorLand.hidden = !(lblCursorLand.hidden);
    tmrCursor = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                 target: self
                                               selector: @selector(playCursor)
                                               userInfo: nil
                                                repeats: NO];
}

#pragma mark - 커서 멈춤

- (void)stopCursor {
    lblCursor.hidden = YES;
    lblCursorLand.hidden = YES;
    isStopCursor = YES;
}

#pragma mark - 숫자키패드에서 평문구하기

- (NSString*)getPlainText:(NSData*)pUserInput {
    
    NSString* aStr = [[NSString alloc] initWithData:pUserInput encoding:NSUTF8StringEncoding];
    NSMutableString *plainText = [[NSMutableString alloc] initWithCapacity: lengthLimit];
    NSArray *arrText = [[KNStringutil sharedInstance] splitBy1Size:[aStr dataUsingEncoding: NSUTF8StringEncoding]];
    
    for (int i = 0; i < [arrText count]; i++) {
        UIButton *btn = (UIButton *)[[self view] viewWithTag:[[arrText objectAtIndex:i] intValue]+1 ];
        [plainText appendString:[btn titleLabel].text];
    }
    
    NSString* retValue = [NSString stringWithFormat:@"%@",
                          [plainText stringByReplacingOccurrencesOfString:@" " withString:@""]];

    return retValue;
}

#pragma mark - 강한 보안 모드

- (void) deepSecurityMode:(id)sender {
    // 강한암호옵션일때는 화면에 눌린키정보를 보이지 않는다.
    lblInputValue.hidden = isDeepSecMode;
    lblInputValueLand.hidden = isDeepSecMode;
    
    // 강한암호옵션일때 랜덤한 버튼이 눌린것처럼 효과준다.
    // 강한암호옵션일때 백그라운드가 변하게 되면 원래데로 고쳐준다.
    [self randomPressKey:sender];
    //    [btnRadnomNum setBackgroundImage:[UIImage imageNamed:@"emptynum1_NSHC.png"] forState:UIControlStateNormal];
}

#pragma mark - 랜덤키 눌림 효과

- (void)randomPressKey:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSInteger randomNumber =  1 + arc4random() % 9;
    randomNumber = randomNumber +1;
    if (randomNumber == button.tag)
        randomNumber = randomNumber +1;
    if (randomNumber > 9)
        randomNumber = 2;
    
    btnRadnomNum = (UIButton*)[[self view] viewWithTag:randomNumber];
    [btnRadnomNum setBackgroundImage:[UIImage imageNamed:@"pressednumkey.png"]
                            forState:UIControlStateNormal];
}

#pragma mark - 콜백 메소드 실행

- (void)returnWithCallBackMethod:(SEL)callbackMethod{
    
    NSString *plainText = [[self getPlainText:[stringStore dataUsingEncoding: NSUTF8StringEncoding]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSData* textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *dummyText = [self getDummyData:[plainText length]];
    NSString *encText = @"";
    
    encText = [ec makeEncWithPadding:textData];
    
    
    if (isSupportLinkage) {
        NSData* plainTextForCallBack = [ec encyptWithAES:textData pubkey:nil];
        void (*funcp)(id, SEL, NSData*, NSString*, NSString*) = (void(*)(id,SEL, NSData*, NSString*, NSString*))[_pTarget methodForSelector:callbackMethod];
        (*funcp)(_pTarget,              // 타겟
                 callbackMethod,        // 콜백메소드
                 plainTextForCallBack,             // 평문
                 encText,               // 암호텍스트
                 tagName);              // 태그명
        
    } else {
        void (*funcp)(id, SEL, NSString*, NSString*, NSString*) = (void(*)(id,SEL, NSString*, NSString*, NSString*))[_pTarget methodForSelector:callbackMethod];
        if (isSupportFullEnc) plainText = [[NSString alloc] initWithFormat:@"%@", [ec makeEncNoPadWithSeedkey:textData]];
        if (isNonPlainText) plainText = @"";
        (*funcp)(_pTarget,              // 타겟
                 callbackMethod,        // 콜백메소드
                 (isDummyData) ? dummyText : plainText,             // 평문
                 encText,               // 암호텍스트
                 tagName);              // 태그명
    }            // 태그명
}           // 태그명

#pragma mark - 콜백메소드 설정

- (void)setCallbackMethod:(id)pTarget
          methodOnConfirm:(SEL)pMethodOnConfirm
             methodOnPrev:(SEL)pMethodOnPrev
             methodOnNext:(SEL)pMethodOnNext
            methodOnPress:(SEL)pMethodOnPress {
    
    if (pTarget != nil)
        _pTarget = pTarget;
    
    if (pMethodOnConfirm != nil)
        _pMethodOnConfirm = pMethodOnConfirm;
    
    if (pMethodOnPrev != nil)
        _pMethodOnPrev = pMethodOnPrev;
    
    if (pMethodOnNext != nil)
        _pMethodOnNext = pMethodOnNext;
    
    if (pMethodOnPress != nil)
        _pMethodOnPress = pMethodOnPress;
    
}

- (void)setCallbackMethod:(id)pTarget
          methodOnConfirm:(SEL)pMethodOnConfirm
            methodOnPress:(SEL)pMethodOnPress {
    
    if (pTarget != nil)
        _pTarget = pTarget;
    
    if (pMethodOnConfirm != nil)
        _pMethodOnConfirm = pMethodOnConfirm;
    
    if (pMethodOnPress != nil)
        _pMethodOnPress = pMethodOnPress;
}

- (void)setCallbackMethod:(id)pTarget
          methodOnConfirm:(SEL)pMethodOnConfirm
           methodOnCancel:(SEL)pMethodOnCancel {
    
    if (pTarget != nil)
        _pTarget = pTarget;
    
    if (pMethodOnConfirm != nil)
        _pMethodOnConfirm = pMethodOnConfirm;
    
    if (pMethodOnCancel != nil)
        _pMethodOnCancel = pMethodOnCancel;
}


#pragma mark - 키패드 다시 그리기

- (void)reloadKeypad {
    
    NSArray *pArray;
    if (!ignoreSuffle) {
        pArray = [ec getKeypadArray];
    } else {
        pArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    }
    
    [keypad0 setTitle:pArray[0] forState:UIControlStateNormal];
    [keypad1 setTitle:pArray[1] forState:UIControlStateNormal];
    [keypad2 setTitle:pArray[2] forState:UIControlStateNormal];
    [keypad3 setTitle:pArray[3] forState:UIControlStateNormal];
    [keypad4 setTitle:pArray[4] forState:UIControlStateNormal];
    [keypad5 setTitle:pArray[5] forState:UIControlStateNormal];
    [keypad6 setTitle:pArray[6] forState:UIControlStateNormal];
    [keypad7 setTitle:pArray[7] forState:UIControlStateNormal];
    [keypad8 setTitle:pArray[8] forState:UIControlStateNormal];
    [keypad9 setTitle:pArray[9] forState:UIControlStateNormal];
    
    [keypad0_land setTitle:pArray[0] forState:UIControlStateNormal];
    [keypad1_land setTitle:pArray[1] forState:UIControlStateNormal];
    [keypad2_land setTitle:pArray[2] forState:UIControlStateNormal];
    [keypad3_land setTitle:pArray[3] forState:UIControlStateNormal];
    [keypad4_land setTitle:pArray[4] forState:UIControlStateNormal];
    [keypad5_land setTitle:pArray[5] forState:UIControlStateNormal];
    [keypad6_land setTitle:pArray[6] forState:UIControlStateNormal];
    [keypad7_land setTitle:pArray[7] forState:UIControlStateNormal];
    [keypad8_land setTitle:pArray[8] forState:UIControlStateNormal];
    [keypad9_land setTitle:pArray[9] forState:UIControlStateNormal];
    
    // 이하는 시리얼 모드일 경우에만 - 일반방식과 시리얼 방식의 셔플방식이 다르다
    
    if (isSerialMode) {
        NSString * strDate = [NSString stringWithFormat:@"%lf",CFAbsoluteTimeGetCurrent()];
        NSArray *listItems = [strDate componentsSeparatedByString:@"."];
        strDate = listItems[1];
        
        arrGapByEcc = [[NSArray alloc] initWithArray:
                       [ec makeGapWithKeypads:([strDate intValue]+1) gapCount:2 widthPixel:8]];
        
        // 공백추가
        [self replaceButtonWithSpace];
    }
    
}

#pragma mark - 시리얼 모드 버튼 그리기

/* 공백추가 */
-(void)replaceButtonWithSpace {
    
    // 재배열때 발생된 키갭스트링 그대로 이용
    NSArray *arrGap = [NSArray arrayWithArray:arrGapByEcc];
    
    NSInteger start1 = [arrGap [0] integerValue];
    NSInteger start2 = [arrGap [1] integerValue] +1 +start1;
    
    NSInteger btnNumberToReplace = 0;
    for (int i = 0; i < 12; i++) {
        
        if ((i == start1) || (i == start2)) {
            continue;
        }
        
        // 버튼찾기
        btnNumberToReplace = btnNumberToReplace +1;
        NSString* number = [NSString stringWithFormat:@"%d", btnNumberToReplace];
        UIButton* btn = [self getButton:number];
        
        [self setButtonTo:btn number:i+1+100];
        
    }
    
    /* 마지막 0번버튼 처리 */
    UIButton* btn = [self getButton:@"0"];
    [self setButtonTo:btn number:12 + 100];
    
}

#pragma mark - 버튼위치 조정

/* 버튼을 받아서 특정 위치로 이동시킨다 */
-(void)setButtonTo:(UIButton*)pButton number:(NSInteger)pNumber {
    NSString* btnToGet = [NSString stringWithFormat:@"%d", pNumber];
    UIButton* btn = [self getButton:btnToGet];
    pButton.frame = btn.frame;
    pButton.center = btn.center;
}

#pragma mark - 버튼위치 매칭

/* 버튼위의 특정숫자가 쓰인 BUTTON-VIEW 를 가져온다 */
-(UIButton*)getButton:(NSString*)pNumber {
    for (int i = 1; i < 11; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:i];
        NSString* titlevalue = [btn.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([titlevalue isEqualToString:pNumber]) {
            return btn;
        }
    }
    
    for (int i = 9100; i < 9113; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:i];
        NSString* titlevalue = [btn.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([titlevalue isEqualToString:pNumber]) {
            return btn;
        }
    }
    
    for (int i = 9200; i < 9213; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:i];
        NSString* titlevalue = [btn.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([titlevalue isEqualToString:pNumber]) {
            return btn;
        }
    }
    
    return nil;
}

#pragma mark - 뷰 교체 (세로 <-> 가로)

-(void)setRotateToInterfaceOrientation:(UIInterfaceOrientation)tointerfaceOrientation {
    
    if ( tointerfaceOrientation == UIInterfaceOrientationPortrait || tointerfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.view = viewPortrait;
        isLandscapeMode = NO;
    } else if ( tointerfaceOrientation == UIInterfaceOrientationLandscapeLeft || tointerfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view = viewLandscape;
        isLandscapeMode = YES;
    }

	screenBound = [[UIScreen mainScreen] bounds];
	screenSize = screenBound.size;
	screenWidth = screenSize.width;
	screenHeight = screenSize.height;
	
	if (isLandscapeMode) {
		self.view.frame = CGRectMake(0.0, yFrame, screenWidth, screenHeight);
	} else {
		self.view.frame = CGRectMake(0.0, yFrame, screenWidth, screenHeight);
	}
	
    // 뷰변경시 텍스트와 탑바 설정
    viwToolbar.hidden = !isToolbarHidden;
    viwToolbarLand.hidden = !isToolbarHidden;
    viwFullMode.hidden = !isFullMode;
    viwFullModeLand.hidden = !isFullMode;
    viwStatusBar.hidden = !isFullMode;
    viwStatusBarLand.hidden = !isFullMode;
    
    // 가로세로 모드가 변하면서 뷰가 바뀌기 때문에 키버튼 재배열해줘야 한다
    if ([txtInSecurity.text length] == 0)
        [self pressKeypadReload];
}

#pragma mark - 회전관련

-(void)setRotateToInterfaceOrientation:(UIInterfaceOrientation)tointerfaceOrientation parentView:(UIView*)pParentView {
    [self.view removeFromSuperview];
    [self setRotateToInterfaceOrientation:tointerfaceOrientation];
    
    if (self.view.frame.origin.y == 0) {
        self.view.frame = CGRectOffset(self.view.frame, 0, 0);
    }
    
    [pParentView addSubview:self.view];
    
    // 커서깜빡임
    if (([txtInSecurity.text length] == 0) && (isStopCursor == YES)) {
        isStopCursor = NO;
        [self playCursor];
    }
    
    if (isEngMode) {
        [btnReplacekey setTitle:@"Replace" forState:UIControlStateNormal];
        [btnReplacekeyLandscape setTitle:@"Replace" forState:UIControlStateNormal];
        
        [btnConfirm setTitle:@"OK" forState:UIControlStateNormal];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        
        [btnConfirmLandscape setTitle:@"OK" forState:UIControlStateNormal];
        [btnCancelLandscape setTitle:@"Cancel" forState:UIControlStateNormal];
        
        [btnToolbarPrev setTitle:@"PREV" forState:UIControlStateNormal];
        [btnToolbarNext setTitle:@"NEXT" forState:UIControlStateNormal];
        [btnToolbarPrevLandscape setTitle:@"PREV" forState:UIControlStateNormal];
        [btnToolbarNextLandscape setTitle:@"NEXT" forState:UIControlStateNormal];
    }
    
}

#pragma mark - 숫자키패드에서 더미값 구하기

- (NSString*)getDummyData: (NSInteger) max{
    const char *s=[[self getPlainText:[stringStore dataUsingEncoding: NSUTF8StringEncoding]] cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, (int)keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return [hash substringToIndex:max];
}

#pragma mark - 마스킹
- (void)changeLastInputValue {
    lblInputValue.text = [self getBullet];
    lblInputValueLand.text = [self getBullet];
}

#pragma mark - 마스킹 변경값
-(NSString*)getBullet {
    unichar uni = 0x2022;
    NSString* bullet = [NSString stringWithCharacters: &uni length:1];
    return bullet;
}

#pragma mark - --------------------------------------------- nFilter Option --------------------------------------------

#pragma mark - Non-PlainText 옵션

- (void)setNonPlainText:(BOOL)pYesOrNo {
    isNonPlainText = pYesOrNo;
}

#pragma mark - Non-셔플 옵션

- (void)setIgnoreSuffle:(BOOL)pIgnoreSuffle {
    ignoreSuffle = pIgnoreSuffle;
}

#pragma mark - 강한 보안 옵션

/*
 1. 랜덤한 키가 클릭한것처럼 보이게 함
 2. 클릭한 키 내용을 숨김
 3. 키 백그란운드이미지(눌림효과) 안보임
 */

- (void)setDeepSecMode:(BOOL)pYesOrNo {
    isDeepSecMode = pYesOrNo;
}

#pragma mark - 가로모드 사용여부 옵션

- (void)setSupportLandscape:(BOOL)pYesOrNo {
    isSuportLandscape = pYesOrNo;
}

#pragma mark - 길이와 태그 이름 웹뷰 지정

- (void)setLengthWithTagName:(NSString *)pTagName length:(NSInteger)pLength webView:(UIWebView *)pWebView {
    lengthLimit = pLength;
    
    tagName = pTagName;
}

#pragma mark - 백그라운드 이벤트 허용 설정

- (void)setSupportBackgroundEvent:(BOOL)pYesOrNo {
    isSuportBackgroundEvent = pYesOrNo;
}

#pragma mark - 풀모드 설정

- (void)setFullMode:(BOOL)pYesOrNo {
    isFullMode = pYesOrNo;
}

#pragma mark - 툴바 설정

- (void)setToolBar:(BOOL)pYesOrNo {
    isToolbarHidden = pYesOrNo;
}

#pragma mark - 사운드설정

- (void)setNoSound:(BOOL)pYesOrNo {
    isNoSound = pYesOrNo;
}

#pragma mark - 공개키 설정

- (void)setServerPublickey:(NSString *)pServerPublickey {
    ec = [EccEncryptor sharedInstance];
    [ec setServerPublickey:pServerPublickey];
}

- (void)setServerPublickeyURL:(NSString *)pXmlURL {
    ec = [EccEncryptor sharedInstance];
    [ec setServerPublickeyURL:pXmlURL];
}

#pragma mark - 영문모드

- (void)setEngMode:(BOOL)pYesOrNo {
    isEngMode = pYesOrNo;
}

#pragma mark - 평문 사용 안함

- (void)setDummyText:(BOOL)pYesOrNo {
    isDummyData = pYesOrNo;
}

#pragma mark - 모두암호화

- (void)setSupportFullEnc:(BOOL)pYesOrNO {
    isSupportFullEnc = pYesOrNO;
}

#pragma mark - 연동모드
- (void)setSupportLinkage:(BOOL)pYesOrNO {
    isSupportLinkage = pYesOrNO;
}

#pragma mark - 버전정보
- (NSString *)getNFilterVer {
    return @"5.2.16.ad";
}

#pragma mark - 버튼텍스트 설정
- (void)setBtnTextWithRepText:(NSString *)pRepText
                       okText:(NSString *)pOkText
                   cancelText:(NSString *)pCancelText
                     prevText:(NSString *)pPrevText
                     nextText:(NSString *)pNextText {
    
    _RepTxt = pRepText;
    _OKTxt = pOkText;
    _CancelTxt = pCancelText;
    _PrevTxt = pPrevText;
    _NextTxt = pNextText;
}

#pragma mark - YFrame 조절
- (void)setVerticalFrame:(NSInteger)pYFrame {
	yFrame = pYFrame;
}

#pragma mark - ---------------------------------------------- 화면 숨기기 콜백 메서드 ----------------------------------------------
- (void) handleResignActiveNotification {
	self.backgroundView.hidden = NO;
}


- (void) handleBecomeActiveNotification {
	self.backgroundView.hidden = YES;
}

#pragma mark - ---------------------------------------------- 애플 기본 ----------------------------------------------

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1. 키패드 재배열
    [self reloadKeypad];
    
    // 2. 커서깜빡임
    isStopCursor = NO;
    [self playCursor];
    
    [self clearField];
    
  	if( _RepTxt != nil) [btnReplacekey setTitle:_RepTxt forState:UIControlStateNormal];
  	if( _RepTxt != nil) [btnReplacekeyLandscape setTitle:_RepTxt forState:UIControlStateNormal];
    
  	if( _OKTxt != nil) [btnConfirm setTitle:_OKTxt forState:UIControlStateNormal];
  	if( _OKTxt != nil) [btnConfirmLandscape setTitle:_OKTxt forState:UIControlStateNormal];
    
	if( _CancelTxt != nil) [btnCancel setTitle:_CancelTxt forState:UIControlStateNormal];
	if( _CancelTxt != nil) [btnCancelLandscape setTitle:_CancelTxt forState:UIControlStateNormal];
    
	if( _PrevTxt != nil) [btnToolbarPrev setTitle:_PrevTxt forState:UIControlStateNormal];
	if( _NextTxt != nil) [btnToolbarNext setTitle:_NextTxt forState:UIControlStateNormal];
	
	CGRect rect = CGRectMake(0, 0,  [[UIScreen mainScreen] bounds].size.width,  [[UIScreen mainScreen] bounds].size.height);
	self.backgroundView = [[UIView alloc] initWithFrame:rect];
	self.backgroundView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.backgroundView];
	self.backgroundView.hidden = YES;
}

#pragma mark - viewDidAppear

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (isSerialMode) {
        [self replaceButtonWithSpace]; // 시리얼모드일 경우 버튼을 한번더 재배열한다
    }
	[super viewDidAppear:YES];
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(handleResignActiveNotification)
												 name: UIApplicationWillResignActiveNotification
											   object: nil];
	
	
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(handleBecomeActiveNotification)
												 name: UIApplicationDidBecomeActiveNotification
											   object: nil];
}

-(void) viewDidDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationWillResignActiveNotification
												  object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidBecomeActiveNotification
												  object:nil];
	[super viewDidDisappear:YES];
}

#pragma mark - didReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    tagName = nil;
    tmrCursor = nil;
    btnRadnomNum = nil;
    arrGapByEcc = nil;
}

#pragma mark - shouldAutorotateToInterfaceOrientation < 5.0

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) ||
        (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)) {
        isLandscapeMode = YES;
    } else isLandscapeMode = NO;
    
    if (isSuportLandscape == NO)
        isLandscapeMode = NO;
    
    return isSuportLandscape;
}

@end
