//
//  NFIlterChar.m
//  nFilterChar KeyPad
//
//	Ver.5.2.16.ad
//  Created by NSHC on 2013/07/29
//  Copyright (c) 2013 NSHC. ( http://www.nshc.net )
//  All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import "nFilterCharForPad.h"
#import "EccEncryptor.h"
#import "KnmRepUnicode.h"
#include <CommonCrypto/CommonDigest.h>

@implementation nFilterCharForPad {
@private
    EccEncryptor *ec;               // 암복호화 객체
    NSString *stringStore;
    NSInteger yFrame;               // Y 포지션 조절	
}

@synthesize tmrCursor, tmrMasking, stringKeyboardType;
@synthesize tagName;
@synthesize OKTxt = _OKTxt;
@synthesize CancelTxt = _CancelTxt;
@synthesize ENTxt = _ENTxt;
@synthesize RepTxt = _RepTxt;
@synthesize PrevTxt = _PrevTxt;
@synthesize NextTxt = _NextTxt;
@synthesize backgroundView = _backgroundView;

static nFilterCharForPad* instance = nil;

+(nFilterCharForPad*)nFilterCharForiPad {
    if (instance == nil) {
        instance = [[nFilterCharForPad alloc] initWithNibName:@"nFilterCharForPad" bundle:nil];
    }
    
    return instance;
}

-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    
    self = [super initWithNibName:nibName bundle:nibBundle];
    
    // 키패드 높이
    nfilterHeight = 284.0;
    
    // 암복호화 객체 초기화
    ec = [EccEncryptor sharedInstance];
    
    return self;
}

#pragma mark - ---------------------------------------------- IBAction ----------------------------------------------

#pragma mark - 키모드 변경
// 키모드 변경버튼 눌림
- (IBAction)changeKeypadMode:(id)sender {
    
    [self soundPlay:@"click2"];
    NSInteger clickedButtenTag = [(UIButton*)sender tag];
    
    /*
     91 : SHIFT
     92 : 특수기호
     93 : 한영
     */
    
    // SHIFT 키가 눌렸다면
    if (clickedButtenTag == 91) {
        
        // 특수기호상태일때 쉬프트값은 의미가 없다
        if (_keymodeTypeCurr == NKeymodeSpecl) {
            return;
        }
        
        // 눌린상태인지 아닌지를 알 수 있게하자
        NSString *imgName = @"NFPadicon_shift.png";  // 눌렸을때의 이미지파일명
        if (_keymodeTypeCurr == NKeymodeSEng) {
            imgName = @"NFPadicon_shift_pressed.png";
            isReadyFixUppercase = YES;
            isFixUppercase = NO;
        } else {
            imgName = @"NFPadicon_shift.png";
            isReadyFixUppercase = NO;
            isFixUppercase = YES;
        }
        
        UIImage *img = [UIImage imageNamed:imgName ] ;
        [shiftIco setImage:img];
        [shiftIcoLandscape setImage:img];
        
        // 영소에서 쉬프트키라면 영대 모드로 들어간다
        if (_keymodeTypeCurr == NKeymodeSEng) {
            //NSLog(@"영소에서 영대로 변경");
            _keymodeTypeCurr = NKeymodeEng;
            [self setKeypadMode:_keymodeTypeCurr];
            return;
        } else {
            _keymodeTypeCurr = NKeymodeSEng;
            [self setKeypadMode:_keymodeTypeCurr];
            return;
        }
    }
    
    // 특수기호 키가 눌렸다면
    if (clickedButtenTag == 92) {
        _keymodeTypeCurr = NKeymodeSpecl;
        [self setKeypadMode:_keymodeTypeCurr];
        
        // 쉬프트키가 눌려 있다면 기본상태로 돌린다
        UIImage *img = [UIImage imageNamed:@"NFPadicon_shift.png" ];
        [shiftIco setImage:img];
        [shiftIcoLandscape setImage:img];
        
        return;
    }
    
    // 영문키가 눌렸다면
    if (clickedButtenTag == 93) {
        
        _keymodeTypeCurr = NKeymodeSEng;
        [self setKeypadMode:_keymodeTypeCurr];
    }
}

#pragma mark - 버튼 누름

// 키패드 버튼 릴리즈
- (IBAction)pressButton:(id)sender {
    
    [self soundPlay:@"click"];
    // 커서깜빡임 중지
    [self stopCursor];
    
    UIButton *button = (UIButton *)sender;
    
    if ( txtInSecurity.text.length == lengthLimit )
        return;
    
    [tmrMasking invalidate];
    tmrMasking = nil;
    
    
    NSString *newStr = nil;
    if ([[(UIButton *)sender titleLabel].text isEqualToString:@"SPACE"]) {
        [self soundPlay:@"click"];
        newStr = [[NSString alloc] initWithFormat:@"%@ ", stringStore];
    } else {
        NSString *keyValue = [[button titleLabel].text stringByReplacingOccurrencesOfString:@" " withString:@""];
        lblInputValue.hidden = isHideLastValue;
        lblInputValueLandscape.hidden = isHideLastValue;
        newStr = [[NSString alloc] initWithFormat:@"%@%@", stringStore, keyValue];
    }
    
    // 강한보안모드일때 텍스트라벨을 숨긴다.
    lblInputValue.hidden = isDeepSecMode;
    lblInputValueLandscape.hidden = isDeepSecMode;
    
    txtInSecurity.text = [self getDummyData:newStr.length];
    txtInSecurityLandscape.text = [self getDummyData:newStr.length];
    stringStore = newStr;
    
    // 이부분에서 키보드타입어레이에 차례대로 입력시켜주자
    NSString* keyboardType = @"S";
    if ((_keymodeTypeCurr == NKeymodeSHan) || (_keymodeTypeCurr == NKeymodeHan))
        keyboardType = @"K";
    if ((_keymodeTypeCurr == NKeymodeSEng) || (_keymodeTypeCurr == NKeymodeEng))
        keyboardType = @"E";
    [self.stringKeyboardType appendString:keyboardType];
    // 키보드타입 어레이 입력 끝
    
    txtInSecurityLandscape.text = txtInSecurity.text;
    
    // 마지막 입력값 출력
    lblInputValue.text = [self getLastInputValue];
    lblInputValueLandscape.text = lblInputValue.text;
    
    // 2초 후에 변경..
    self.tmrMasking = [NSTimer scheduledTimerWithTimeInterval: 2.0
                                                       target: self
                                                     selector: @selector(changeLastInputValue)
                                                     userInfo: nil
                                                      repeats: NO];
    
    // 키프레스 콜백설정되었다면 지금까지 입력값을 넘겨주자
    // 4. 이벤트발생
    if (_pMethodOnPress != nil) {
        [self returnWithCallBackMethod:_pMethodOnPress];
    }
    
    // 현재 대문자 모드인가? 또한 캡스락 지원모드인가?
    // 그렇다면 소문자모드로 돌아가자
    if ((_keymodeTypeCurr == NKeymodeEng) && (isSuportCapslock) && (!isFixUppercase)) {
        _keymodeTypeCurr = NKeymodeSEng;
        [self setKeypadMode:_keymodeTypeCurr];
        
        UIImage *img = [UIImage imageNamed:@"NFPadicon_shift.png"];
        [btnShiftkey setBackgroundImage:img forState:UIControlStateNormal];
    }
}

#pragma mark - 백스페이스
// 빽버튼 누름
- (IBAction)pressBack {
    //NSLog(@"TOUCH UP");
    isWhileDOWN = FALSE;
}

#pragma mark - 백스페이스 연속
- (IBAction)backRepeat {
    isWhileDOWN = YES;
    [self simulBackButton];
}

#pragma mark - 이전
- (IBAction)onBtnPrev:(id)sender {
    if (_pMethodOnPrev == nil)
        return;
    [self returnWithCallBackMethod:_pMethodOnPrev];
}

#pragma mark - 다음
- (IBAction)onBtnNext:(id)sender {
    if (_pMethodOnNext == nil)
        return;
    [self returnWithCallBackMethod:_pMethodOnNext];
}

#pragma mark - 재배열
- (IBAction)pressKeypadReload {
    [self soundPlay:@"click2"];
    [self clearField];
    [self replaceKeypad];
}

#pragma mark - 취소 버튼 이벤트

- (IBAction)pressCancel {
    if (_pMethodOnCancel == nil)
        return;
    [self returnWithCallBackMethod:_pMethodOnCancel];
    [self closeNFilter];
}

#pragma mark - 확인 버튼 이벤트

// 확인, 완료 버튼 등에 연결되어 있음

- (IBAction)pressConfirm {
    if (_pMethodOnConfirm == nil)
        return;
    [self returnWithCallBackMethod:_pMethodOnConfirm];
    [self closeNFilter];
}

#pragma mark - ---------------------------------------------- 내부 함수 ----------------------------------------------

#pragma mark - 백스페이스 누름효과
// 빽버튼 누름효과
- (void)simulBackButton {
    
    if (!isWhileDOWN)
        return;
    
    [self soundPlay:@"click"];
    
    //NSLog(@"do simulBackButton: %d", isWhileDOWN);
    lblInputValue.hidden = YES;
    lblInputValueLandscape.hidden = YES;
    NSString *newStr = stringStore;
    if (newStr.length == 0)
        return;
    
    NSString *backStr = [[NSString alloc] initWithFormat:@"%@", [newStr substringToIndex:(newStr.length -1)]];
    txtInSecurity.text = [self getDummyData:backStr.length];
    txtInSecurityLandscape.text = [self getDummyData:backStr.length];
    stringStore = backStr;
    
    // 이부분에서 키보드타입어레이를 하나 지워주자
    [self.stringKeyboardType deleteCharactersInRange:NSMakeRange([self.stringKeyboardType length]-1, 1)];
    txtInSecurityLandscape.text = txtInSecurity.text;
    
    if (backStr.length ==0) {
        isStopCursor = NO;
        [self playCursor];
    }
    
    
    // 키프레스 콜백설정되었다면 지금까지 입력값을 넘겨주자
    // 4. 이벤트발생
    if (_pMethodOnPress != nil) {
        [self returnWithCallBackMethod:_pMethodOnPress];
    }
    
    if (isWhileDOWN) {
        //NSLog(@"재실행: %d", isWhileDOWN);
        [NSTimer scheduledTimerWithTimeInterval:0.3
                                         target:self
                                       selector:@selector(simulBackButton)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void)returnWithCallBackMethod:(SEL)callbackMethod{
    
    // 0. 암호화할 데이터
    NSString* plainText = [NSString stringWithFormat:@"%@", stringStore];
    plainText = [plainText stringByReplacingOccurrencesOfString:@"₩" withString:@"\\"];
    
    NSData* textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    // 1. 암호화 수행
    NSString *encText = nil;
    if (isNoPadding) {
        encText = [[NSString alloc] initWithFormat:@"%@", [ec makeEncNoPadding:textData]];
    } else {
        encText = [[NSString alloc] initWithFormat:@"%@", [ec makeEncPadding:textData]];
    }
    
    NSString *dummyText = [self getDummyData:[plainText length]];
    
    // 2. 만약 치환테이블 사용옵션이 켜져있다면 치환시킨 후에 암호화하자
    if (isSuportReplaceTable) {
        NSInteger randNum = ([ec getRandNum] % 100) + 129;
        plainText = [[KnmRepUnicode shared] replaceString:plainText increaseNum:randNum];
    }
    
    if (isSupportLinkage) {
        NSData* plainTextForCallBack = [ec encyptWithAES:textData pubkey:nil];
        void (*funcp)(id, SEL, NSData*, NSString*, NSString*) = (void(*)(id,SEL, NSData*, NSString*, NSString*))[_pTarget methodForSelector:callbackMethod];
        (*funcp)(_pTarget,              // 타겟setSupportLinkage
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
    }
}

/*--------------------------------------------------------------------------------------
 엔필터를 띄울 때 가로세로 지정
 ---------------------------------------------------------------------------------------*/
-(void)setRotateToInterfaceOrientation:(UIInterfaceOrientation)tointerfaceOrientation {
    //	NSLog(@"문자 키패드: 세로-가로 변경");
    
    if ( tointerfaceOrientation == UIInterfaceOrientationPortrait ) {
        self.view = viewPortrait;
        isLandscapeMode = NO;
    } else if ( tointerfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
        self.view = viewLandscape;
        isLandscapeMode = YES;
    } else if ( tointerfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ) {
        self.view = viewPortrait;
        isLandscapeMode = NO;
    } else if ( tointerfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
        self.view = viewLandscape;
        isLandscapeMode = YES;
    }
	
	screenBound = [[UIScreen mainScreen] bounds];
	screenSize = screenBound.size;
	screenWidth = screenSize.width;
	screenHeight = screenSize.height;
	
	if (isLandscapeMode) {
		self.view.frame = CGRectMake(0.0, yFrame, screenWidth > screenHeight ? screenWidth : screenHeight, screenWidth < screenHeight ? screenWidth : screenHeight);
	} else {
		self.view.frame = CGRectMake(0.0, yFrame, screenWidth < screenHeight ? screenWidth : screenHeight, screenWidth > screenHeight ? screenWidth : screenHeight);
	}
	
    // 뷰변경시 텍스트와 탑바 설정
    viwToolbar.hidden = !isToolbarHidden;
    viwToolbarLand.hidden = !isToolbarHidden;
    viwFullMode.hidden = !isFullMode;
    viwFullModeLand.hidden = !isFullMode;
    viwStatusBar.hidden = !isFullMode;
    viwStatusBarLand.hidden = !isFullMode;
    
    // 뷰가 교체되면 재배열시키고
    // 문자셋도 변경한다
    [self replaceKeypad];
    [self setKeypadMode:_keymodeTypeCurr];
}

/*--------------------------------------------------------------------------------------
 엔필터를 띄울 때 가로세로 지정
 ---------------------------------------------------------------------------------------*/
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
        [btnEngkey setTitle:@"EN" forState:UIControlStateNormal];                           // 영문 버튼
        [btnEngkeyLandscape setTitle:@"EN" forState:UIControlStateNormal];
        
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

#pragma mark - 엔필터닫음
-(void)closeNFilter {
    [self clearField];
    [self.view removeFromSuperview];
}

#pragma mark - 텍스트필드 클리어
-(void)clearField {
    stringStore = @"";
    txtInSecurity.text = @"";
    txtInSecurityLandscape.text = @"";
    lblInputValue.text = @"";
    lblInputValueLandscape.text = @"";
}

#pragma mark - 마지막 입력값 가져오기
// 마지막 입력값 가져오기
-(NSString*)getLastInputValue {
    if ([txtInSecurity.text length] == 0) {
        return @"";
    }
    NSString* retValue = [stringStore substringWithRange:NSMakeRange([stringStore length] -1, 1)];
    return retValue;
}

#pragma mark - 소리재생
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

#pragma mark - 커서 정지
- (void)stopCursor {
    lblCursor.hidden = YES;
    lblCursorLand.hidden = YES;
    isStopCursor = YES;
}

#pragma mark - 버튼 위치 배열
// 버튼의 위치를 변경
- (UIButton *)moveButtonWithTag:(NSInteger)pTag plusX:(NSInteger)pPlusX plusY:(NSInteger)pPlusY {
    
    UIView *viewPad = [self view];
    UIButton *button = (UIButton *)[viewPad viewWithTag:pTag];
    
    button.center = CGPointMake(button.center.x + pPlusX + btnRect, button.center.y + pPlusY);
    
    return button;
}


#pragma mark - 키패드 모드
// 키모드로 변경하기 (영문, 한글, 특문등)
- (void)setKeypadMode:(NKeymodeType)pKeyOrder {
    
    NSInteger intKeymode = 0;
    NSInteger intKeymodeSmall = 0;
    
    if (pKeyOrder == NKeymodeEng) {
        intKeymode = 1;
        intKeymodeSmall = 3;
    }
    if (pKeyOrder == NKeymodeSEng) {
        intKeymode = 0;
        intKeymodeSmall = 2;
    }
    if (pKeyOrder == NKeymodeHan) {
        intKeymode = 2;
        intKeymodeSmall = 0;
    }
    if (pKeyOrder == NKeymodeSHan) {
        intKeymode = 3;
        intKeymodeSmall = 1;
    }
    if (pKeyOrder == NKeymodeSpecl) intKeymode = 4;
    
    
    
    UIView *keyview = [self view];
    for (int i = 0; i < [arrKeys count]; i++) {
        
        // 버튼라벨 셋팅
        NSArray *oneKeySet = [dictKeys objectForKey:[arrKeys objectAtIndex:i]];
        UIButton *button = (UIButton *)[keyview viewWithTag: [[arrKeys objectAtIndex:i] intValue] ];
        [button setTitle:[oneKeySet objectAtIndex:intKeymode] forState:UIControlStateNormal];
        
        // 숫자키패드는 변경사항 없다
        if (i < 10)
            continue;
        
        // 특수기호일때 라벨들 숨겨주고 버튼글씨 살린다
        if ( pKeyOrder == NKeymodeSpecl ) {
            UILabel *labelE = (UILabel *)[[self view] viewWithTag:button.tag +200];
            labelE.hidden = YES;
            UILabel *labelH = (UILabel *)[[self view] viewWithTag:button.tag +100];
            labelH.hidden = YES;
            
        } else {
            UILabel *labelE = (UILabel *)[[self view] viewWithTag:button.tag +200];
            labelE.text = button.titleLabel.text;
            labelE.hidden = NO;
            
            UILabel *labelH = (UILabel *)[[self view] viewWithTag:button.tag +100];
            labelH.text = [oneKeySet objectAtIndex:intKeymodeSmall];
            labelH.hidden = NO;
        }
    }
    
}

#pragma mark - 키패드 초기화
// 키패드 초기화
- (void)keypadInit_Landscape {
    //	NSLog(@"가로모드 키패드 초기화");
    NSInteger intPadding = 85 + 5; // 버튼들의 넓이
    NSInteger intButtonStartPosition = (11+44); // 시작위치에서 버튼 넓이의 절반값을 더해준다
    
    NSInteger intPLUS = intButtonStartPosition;
    for (int i = 1 ; i < 11 ; i ++) {
        UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
        button.center = CGPointMake(intPLUS, button.center.y);
        intPLUS = intPLUS + intPadding;
    }
    
    intPLUS = intButtonStartPosition;
    for (int i = 11 ; i < 21 ; i ++) {
        UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
        button.center = CGPointMake(intPLUS, button.center.y);
        intPLUS = intPLUS + intPadding;
        
        UILabel *label = (UILabel*)[[self view] viewWithTag:(button.tag+100)];
        label.center = CGPointMake(button.center.x + label.frame.size.width, label.center.y);
    }
    
    intPLUS = intButtonStartPosition;
    for (int i = 21 ; i < 30 ; i ++) {
        UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
        button.center = CGPointMake(intPLUS, button.center.y);
        intPLUS = intPLUS + intPadding;
        
        UILabel *label = (UILabel*)[[self view] viewWithTag:(button.tag+100)];
        label.center = CGPointMake(button.center.x + label.frame.size.width, label.center.y);
    }
    
    intPLUS = intButtonStartPosition;
    intPLUS = intPLUS + 132; // <-- 'Z' 의 위치잡기
    for (int i = 30 ; i < 37 ; i ++) {
        UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
        button.center = CGPointMake(intPLUS, button.center.y);
        intPLUS = intPLUS + intPadding;
        
        UILabel *label = (UILabel*)[[self view] viewWithTag:(button.tag+100)];
        label.center = CGPointMake(button.center.x + label.frame.size.width, label.center.y);
    }
    
}

// 키패드 초기화
- (void)keypadInit {
    //	NSLog(@"세로모드 키패드 초기화");
    NSInteger intPadding = 66; // 버튼들의 넓이
    NSInteger intButtonStartPosition = 48; // 시작위치에서 버튼 넓이의 절반값을 더해준다
    
    NSInteger intPLUS = intButtonStartPosition;
    for (int i = 1 ; i < 11 ; i ++) {
        UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
        button.center = CGPointMake(intPLUS, button.center.y);
        intPLUS = intPLUS + intPadding;
    }
    
    intPLUS = intButtonStartPosition;
    for (int i = 11 ; i < 21 ; i ++) {
        UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
        button.center = CGPointMake(intPLUS, button.center.y);
        intPLUS = intPLUS + intPadding;
        
        UILabel *label = (UILabel*)[[self view] viewWithTag:(button.tag+100)];
        label.center = CGPointMake(button.center.x + label.frame.size.width, label.center.y);
    }
    
    intPLUS = intButtonStartPosition;
    for (int i = 21 ; i < 30 ; i ++) {
        UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
        button.center = CGPointMake(intPLUS, button.center.y);
        intPLUS = intPLUS + intPadding;
        
        UILabel *label = (UILabel*)[[self view] viewWithTag:(button.tag+100)];
        label.center = CGPointMake(button.center.x + label.frame.size.width, label.center.y);
    }
    
    intPLUS = intButtonStartPosition;
    intPLUS = intPLUS + 100; // <-- 'Z' 의 위치잡기
    for (int i = 30 ; i < 37 ; i ++) {
        UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
        button.center = CGPointMake(intPLUS, button.center.y);
        intPLUS = intPLUS + intPadding;
        
        UILabel *label = (UILabel*)[[self view] viewWithTag:(button.tag+100)];
        label.center = CGPointMake(button.center.x + label.frame.size.width, label.center.y);
    }
    
}


#pragma mark - 키패드 재배열
// 키패드 버튼 재배열
-(void)replaceKeypad {
    if (isLandscapeMode) {
        [self keypadInit_Landscape];
    } else {
        [self keypadInit];
    }
    
//    [self clearField];
    
    NSString * strSeed = [NSString stringWithFormat:@"%lf",CFAbsoluteTimeGetCurrent()];
    NSArray *listItems = [strSeed componentsSeparatedByString:@"."];
    strSeed = listItems[1];
    
    NSInteger intPadding = 40;
    if (isLandscapeMode) {
        intPadding = 53;
    }
    NSInteger intTagCount = 0;
    // 첫번째열
    NSInteger intPLUS = 0;
    NSArray *arrGap = [ec makeGapWithKeypads:([strSeed intValue]+1) gapCount:2 widthPixel:10];
    for (int i = 0; i < [arrGap count]; i++) {
        for (int j = 0; j < ([[arrGap objectAtIndex:i] intValue]); j++) {
            intTagCount = intTagCount +1;
            [self moveButtonWithTag:intTagCount plusX:intPLUS plusY:0];
        }
        intPLUS = intPLUS + intPadding;
    }

    intPLUS = 0;
    arrGap = [ec makeGapWithKeypads:([strSeed intValue]+2) gapCount:2 widthPixel:10];
    for (int i = 0; i < [arrGap count]; i++) {
        for (int j = 0; j < ([[arrGap objectAtIndex:i] intValue]); j++) {
            intTagCount = intTagCount +1;
            UIButton *button = [self moveButtonWithTag:intTagCount plusX:intPLUS plusY:0];
            UILabel *label = (UILabel*)[[self view] viewWithTag:(button.tag+100)];
            label.center = CGPointMake(button.center.x + label.frame.size.width, label.center.y);
        }
        intPLUS = intPLUS + intPadding;
    }
    intPLUS = 0;
    arrGap = [ec makeGapWithKeypads:([strSeed intValue]+3) gapCount:3 widthPixel:9];
    for (int i = 0; i < [arrGap count]; i++) {
        for (int j = 0; j < ([[arrGap objectAtIndex:i] intValue]); j++) {
            intTagCount = intTagCount +1;
            UIButton *button = [self moveButtonWithTag:intTagCount plusX:intPLUS plusY:0];
            UILabel *label = (UILabel*)[[self view] viewWithTag:(button.tag+100)];
            label.center = CGPointMake(button.center.x + label.frame.size.width, label.center.y);
        }
        intPLUS = intPLUS + (intPadding +1);
    }
    intPLUS = 0;
    intTagCount = intTagCount +1;
    arrGap = [ec makeGapWithKeypads:([strSeed intValue]+4) gapCount:2 widthPixel:7];
    for (int i = 0; i < [arrGap count]; i++) {
        for (int j = 0; j < ([[arrGap objectAtIndex:i] intValue]); j++) {
            intTagCount = intTagCount +1;
            UIButton *button = [self moveButtonWithTag:intTagCount plusX:intPLUS plusY:0];
            UILabel *label = (UILabel*)[[self view] viewWithTag:(button.tag+100)];
            label.center = CGPointMake(button.center.x + label.frame.size.width, label.center.y);
        }
        intPLUS = intPLUS + (intPadding +1);
    }
}

#pragma mark - 대소문자 고정

- (void)onTimerToChangeFixUppercase {
    isReadyFixUppercase = NO;
}

#pragma mar - 문자 키패드에서 더미값 구하기

- (NSString*)getDummyData: (NSInteger) max{
    
    NSData* keyData = [stringStore dataUsingEncoding:NSUTF8StringEncoding];
    
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, (int)keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return [hash substringToIndex:max];
}

- (void)changeLastInputValue {
    lblInputValue.text = [self getBullet];
    lblInputValueLandscape.text = [self getBullet];
}

#pragma mark - 마스킹 변경값
-(NSString*)getBullet {
    unichar uni = 0x2022;
    NSString* bullet = [NSString stringWithCharacters: &uni length:1];
    return bullet;
}

#pragma mark - --------------------------------------------- nFilter Option --------------------------------------------

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

#pragma mark - 서버공개키 설정

- (void)setServerPublickey:(NSString *)pServerPublickey {
    ec = [EccEncryptor sharedInstance];
    [ec setServerPublickey:pServerPublickey];
}

- (void)setServerPublickeyURL:(NSString *)pXmlURL {
    ec = [EccEncryptor sharedInstance];
    [ec setServerPublickeyURL:pXmlURL];
}

#pragma mark - 강한보안모드

- (void)setDeepSecMode:(BOOL)pYesOrNo {
    isDeepSecMode = pYesOrNo;
}

#pragma mark - 로테이션 지원설정

- (void)setSupportLandscape:(BOOL)pYesOrNo {
    isSuportLandscape = pYesOrNo;
}

#pragma mark - 마지막 입력값 설정

- (void)setHideLastValue:(BOOL)pYesOrNo {
    isHideLastValue = pYesOrNo;
}

#pragma mark - 백그라운드 이벤트 허용 설정

- (void)setSupportBackgroundEvent:(BOOL)pYesOrNo {
    isSuportBackgroundEvent = pYesOrNo;
}

#pragma mark - 치환테이블

- (void)setSupportReplaceTable:(BOOL)pYesOrNO {
    isSuportReplaceTable = pYesOrNO;
}

#pragma mark - capslock

- (void)setSupportCapslock:(BOOL)pYesOrNO {
    isSuportCapslock = pYesOrNO;
}

#pragma mark - 평문없음

- (void)setNonPlainText:(BOOL)pYesOrNo {
    isNonPlainText = pYesOrNo;
}

#pragma mark - 풀모드 설정

- (void)setFullMode:(BOOL)pYesOrNo {
    isFullMode = pYesOrNo;
}

#pragma mark - 툴바 설정

- (void)setToolBar:(BOOL)pYesOrNo {
    isToolbarHidden = pYesOrNo;
}

#pragma mark - 패딩설정

- (void)setNoPadding:(BOOL)pYesOrNo {
    isNoPadding = pYesOrNo;
}

#pragma mark - 사운드설정

- (void)setNoSound:(BOOL)pYesOrNo {
    isNoSound = pYesOrNo;
}

#pragma mark - 키패드의 텍스트필드 길이제한

- (void)setLengthWithTagName:(NSString *)pTagName length:(NSInteger)pLength webView:(UIWebView *)pWebView {
    lengthLimit = pLength;
    tagName = pTagName;
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
- (void)setBtnTextWithEngText:(NSString *)pEnText
                      repText:(NSString *)pRepText
                       okText:(NSString *)pOkText
                   cancelText:(NSString *)pCancelText
                     prevText:(NSString *)pPrevText
                     nextText:(NSString *)pNextText {
    _ENTxt = pEnText;
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
    
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* plistPath = [bundle pathForResource:@"iPadKeySetting" ofType:@"plist"];
    dictKeys = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    arrKeys = [[NSArray alloc] initWithArray:[[dictKeys allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    // 1. 키패드모드 기본값으로 시작
    _keymodeTypeCurr = NKeymodeSEng;
    [self setKeypadMode:_keymodeTypeCurr];
    
    // 2. 커서깜빡임
    isStopCursor = NO;
    [self playCursor];
    
    // 3. 버튼재배열
    [self replaceKeypad];
    
    // 4. 키입력유형 초기화
    self.stringKeyboardType = [NSMutableString stringWithCapacity:100];
    
    [self clearField];
    
    if(_ENTxt != nil) [btnEngkey setTitle:_ENTxt forState:UIControlStateNormal];                           // 영문 버튼
    if(_ENTxt != nil) [btnEngkeyLandscape setTitle:_ENTxt forState:UIControlStateNormal];
    
    if(_RepTxt != nil) [btnReplacekey setTitle:_RepTxt forState:UIControlStateNormal];
    if(_RepTxt != nil) [btnReplacekeyLandscape setTitle:_RepTxt forState:UIControlStateNormal];
    
    if(_OKTxt != nil) [btnConfirm setTitle:_OKTxt forState:UIControlStateNormal];
    if(_OKTxt != nil) [btnConfirmLandscape setTitle:_OKTxt forState:UIControlStateNormal];
    
    if(_CancelTxt != nil) [btnCancel setTitle:_CancelTxt forState:UIControlStateNormal];
    if(_CancelTxt != nil) [btnCancelLandscape setTitle:_CancelTxt forState:UIControlStateNormal];
    
    if(_PrevTxt != nil) [btnToolbarPrev setTitle:_PrevTxt forState:UIControlStateNormal];
    if(_NextTxt != nil) [btnToolbarNext setTitle:_NextTxt forState:UIControlStateNormal];
	
	CGRect rect = CGRectMake(0, 0,  [[UIScreen mainScreen] bounds].size.width,  [[UIScreen mainScreen] bounds].size.height);
	self.backgroundView = [[UIView alloc] initWithFrame:rect];
	self.backgroundView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.backgroundView];
	self.backgroundView.hidden = YES;
}

-(void) viewDidAppear:(BOOL)animated {
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

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	
	screenBound = [[UIScreen mainScreen] bounds];
	screenSize = screenBound.size;
	screenWidth = screenSize.width;
	screenHeight = screenSize.height;
	
	NSLog(@"screenWidth : %f", screenWidth);

}

#pragma mark - didReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    tmrCursor = nil;
    dictKeys = nil;
    arrKeys = nil;
}
@end