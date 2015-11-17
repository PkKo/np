//
//  NFIlterNum.m
//  nFilterNum KeyPad
//
//	Ver.5.2.16.ad
//  Created by NSHC on 2013/07/29
//  Copyright (c) 2013 NSHC. ( http://www.nshc.net )
//  All rights reserved.
//

#import "NFIlterNum.h"
#import "EccEncryptor.h"
#import "NSStringKNAdditions.h"
#import "KNStringutil.h"
#import "NSData+AESCrypt.h"
#import "PublicKeyDownloader.h"
#import <AudioToolbox/AudioServices.h>
#include <CommonCrypto/CommonDigest.h>
#import "StorageBoxUtil.h"

@implementation NFilterNum {
@private
	EccEncryptor *ec;               // 암복호화 객체
	//    NSString *stringStore;
	NSMutableArray *arrayStrore;
	NSMutableArray *arrayStrore2;
	NSString* pubChain;
    NSInteger yFrame;               // Y 포지션 조절
}

@synthesize tmrCursor;
@synthesize tagName;
@synthesize barHeight = _barHeight;
@synthesize isBackGroundClose = _isBackGroundClose;

@synthesize OKTxt = _OKTxt;
@synthesize CancelTxt = _CancelTxt;
@synthesize RepTxt = _RepTxt;
@synthesize PrevTxt = _PrevTxt;
@synthesize NextTxt = _NextTxt;
@synthesize backgroundView = _backgroundView;

static NFilterNum* instance = nil;

#pragma mark - 싱글톤

+(NFilterNum*)numPadShared {
    
    // 시리얼 모드일 경우 공백셔플방식의 키패드 xib호출 아니라면 일반 키패드
    
    if (instance == nil) {
//        instance = [[NFilterNum alloc] initWithNibName:@"NFilterSerialNum" bundle:nil]; // 시리얼넘패드
        instance = [[NFilterNum alloc] initWithNibName:@"NFilterNum" bundle:nil];     // 일반넘패드
    }
    
    return instance;
}

-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    
    self = [super initWithNibName:nibName bundle:nibBundle];
    // 키패드 높이
    nfilterHeight = 260.0;
    
    // 암복호화 객체 초기화
    ec = [EccEncryptor sharedInstance];
	arrayStrore = [[NSMutableArray alloc] init];
	arrayStrore2 = [[NSMutableArray alloc] init];
	
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
    
	// 커서깜빡임을 없앤다
	[self stopCursor];
	[self checkPubChain];
	UIButton *button = (UIButton *)sender;
	lblInputValue.text = [button titleLabel].text;
    lblInputValueLand.text = [button titleLabel].text;
    
	if (isDeepSecMode) {
        [self performSelector:@selector(deepSecurityMode:) withObject:sender];
        // 강한보안모드일때 텍스트라벨을 숨긴다.
        lblInputValue.hidden = YES;
        lblInputValueLand.hidden = YES;
    }  else {
        lblInputValue.hidden = NO;
        lblInputValueLand.hidden = NO;
    }
	
	NSString *keyValue = nil;
	//NSString *newStr = [[NSString alloc] initWithFormat:@"%@%d", stringStore, (int)[(UIButton *)sender tag] -1];
	keyValue = [NSString stringWithFormat:@"%d", (int)[(UIButton*)sender tag] - 1];
	[arrayStrore addObject:[[keyValue dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pubChain iv:[ec getIV:pubChain]]];
	[arrayStrore2 addObject:[[[self findIndexWithKeyValue:[button titleLabel].text] dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pubChain iv:[ec getIV:pubChain]]];
	//stringStore = newStr;
	txtInSecurity.text = [self getDummyData:arrayStrore.count];
	txtInSecurityLand.text = [self getDummyData:arrayStrore.count];

	
    if(isInputBoxForIdentityNum) [self inputTextShare];
    if(isInputSecurityId) [self inputTextShareInSecurityId];
    
    if (_pMethodOnPress == nil)
        return;
    
    [self returnWithCallBackMethod:_pMethodOnPress];
}

- (NSString *)findIndexWithKeyValue:(NSString*)pKeyValue{
	for (int i = 0; i < [[ec getKeypadArray2] count]; i++) {
		if ([[pKeyValue stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[[[ec getKeypadArray2] objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
			return [NSString stringWithFormat:@"%d", i];
		}
	}
	return nil;
}

#pragma mark - 지우기 버튼 이벤트

- (IBAction)pressBack {
    
    [self soundPlay:@"click"];
    
	//NSString *newStr = stringStore;
	if (arrayStrore.count == 0 && arrayStrore2.count == 0) return;
	
	// 하나를 지웁니다
	//NSString *backStr = [[NSString alloc] initWithFormat:@"%@", [newStr substringToIndex:(newStr.length -1)]];
	[arrayStrore removeLastObject];
	[arrayStrore2 removeLastObject];
	
	txtInSecurity.text = [self getDummyData:arrayStrore.count];
	txtInSecurityLand.text = [self getDummyData:arrayStrore.count];
	txtInSecurityId.text = [self getDummyData:arrayStrore.count];
	//stringStore = backStr;

	
    lblInputValue.hidden = YES;
    lblInputValueLand.hidden = YES;
    
	// 커서깜빡임 시작
	if (arrayStrore.count == 0 && arrayStrore2.count == 0) {
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
    if (_pMethodOnCancel == nil){
        [self clearField];
        [self.view removeFromSuperview];
        return;
    }
    
    [self returnWithCallBackMethod:_pMethodOnCancel];
    [self clearField];
    [self.view removeFromSuperview];
}

#pragma mark - 확인 버튼 이벤트

// 확인, 완료 버튼 등에 연결되어 있음

- (IBAction)pressConfirm {
    if (_pMethodOnConfirm == nil)
        return;
    [self returnWithCallBackMethod:_pMethodOnConfirm];
    [self clearField];
    [self.view removeFromSuperview];
}

#pragma mark - 재배열 버튼 누름 이벤트

- (IBAction)pressKeypadReload {
	[self soundPlay:@"click"];
	[self reloadKeypad];
	txtInSecurity.text = @"";
    txtInSecurityLand.text = @"";
    lblInputValue.text = @"";
    lblInputValueLand.text = @"";
}

#pragma mark - 백그라운 클릭시 엔필터 종료 이벤트
- (IBAction)pressBackGround:(id)sender{
    [self clearField];
    [self.view removeFromSuperview];
}

#pragma mark - ---------------------------------------------- 내부 함수 ----------------------------------------------

#pragma mark - 엔필터 닫기

-(void)closeNFilter {
    [self clearField];
    //    if(self.parentViewController)
    //        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    //    else [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
   [self.view removeFromSuperview];
}

#pragma mark - 필드 클리어

-(void)clearField {
    arrayStrore = [[NSMutableArray alloc] init];
	arrayStrore2 = [[NSMutableArray alloc] init];
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
    
    // 주민번호 입력창에서의 커서처리 시작
	if ([txtInSecurity.text length] == 6)
		lblCursorIdNum2.hidden = !(lblCursorIdNum2.hidden);
	if ([txtInSecurity.text length] == 0)
		lblCursorIdNum1.hidden = !(lblCursorIdNum1.hidden);
	// 주민번호 입력창에서의 커서처리 끝
    
    lblCursorId.hidden = !(lblCursorId.hidden);
    
	lblCursor.hidden = !(lblCursor.hidden);
    lblCursorLand.hidden = !(lblCursorLand.hidden);
}

#pragma mark - 커서 멈춤

- (void)stopCursor {
	lblCursor.hidden = YES;
    lblCursorLand.hidden = YES;
    
    // 주민번호 입력창에서의 커서처리 시작
	lblCursorIdNum1.hidden = YES;
	lblCursorIdNum2.hidden = YES;
	// 주민번호 입력창에서의 커서처리 끝
    
    lblCursorId.hidden = YES;
    
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
    [btnRadnomNum setBackgroundImage:[UIImage imageNamed:@"NFnum_num.png"] forState:UIControlStateNormal];
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
	
	NSString *dummyText = [self getDummyData:arrayStrore.count];
	NSString *encText = @"";
	
		encText = isSerialMode ? [ec makeEncWithPadding3:arrayStrore]: [ec makeEncWithPadding2:arrayStrore];

	
    if (isSupportLinkage) {
        NSData* plainTextForCallBack = [ec encyptWithAES2:arrayStrore pubkey:nil];
//		NSData* plainTextForCallBack = [[NSData alloc] init];
        void (*funcp)(id, SEL, NSData*, NSString*, NSString*, NSString*) = (void(*)(id,SEL, NSData*, NSString*, NSString*, NSString*))[_pTarget methodForSelector:callbackMethod];
        (*funcp)(_pTarget,              // 타겟
                 callbackMethod,        // 콜백메소드
                 plainTextForCallBack,             // 평문
                 encText,               // 암호텍스트
				 dummyText,				// 더미텍스트
                 tagName);              // 태그명
    } else {
        void (*funcp)(id, SEL, NSString*, NSString*, NSString*, NSString*) = (void(*)(id,SEL, NSString*, NSString*, NSString*, NSString*))[_pTarget methodForSelector:callbackMethod];
		NSString *plainText = [ec makeEncNoPadWithSeedkey3:arrayStrore2];
//        if (isNonPlainText) plainText = @"";
        (*funcp)(_pTarget,              // 타겟
                 callbackMethod,        // 콜백메소드
                 plainText,             // 평문
                 encText,               // 암호텍스트
				 dummyText,				// 더미텍스트
                 tagName);              // 태그명
    }            // 태그명
}

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
	
    [self clearField];
    
	NSArray *pArray;
    
	if (!ignoreSuffle) {
		pArray = [ec getKeypadArray];
	} else {
		pArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
	}
    
    //    lblInputValueLand.text = @"";
    //    lblInputValue.text = @"";
    //
    //    txtInSecurityLand.text = @"";
    //    txtInSecurity.text = @"";
    
    // 이하는 시리얼 모드일 경우에만 - 일반방식과 시리얼 방식의 셔플방식이 다르다
    
    if (isSerialMode) {
        
        NSString * strDate = [NSString stringWithFormat:@"%lf",CFAbsoluteTimeGetCurrent()];
        NSArray *listItems = [strDate componentsSeparatedByString:@"."];
        strDate = listItems[1];
        
        arrGapByEcc = [[NSArray alloc] initWithArray:
                       [ec makeGapWithKeypads:([strDate intValue]+1) gapCount:2 widthPixel:8]];
        
        // 공백추가
        [self replaceButtonWithSpace];
    } else {
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
    pButton.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
    pButton.center = CGPointMake(btn.center.x, btn.center.y);
}

#pragma mark - 버튼위치 매칭

/* 버튼위의 특정숫자가 쓰인 BUTTON-VIEW 를 가져온다 */
-(UIButton*)getButton:(NSString*)pNumber {
    for (int i = 1; i < 11; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:i];
        NSString* titlevalue = [btn.titleLabel.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
        if ([titlevalue isEqualToString:pNumber]) {
            return btn;
        }
    }
    
    for (int i = 9100; i < 9113; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:i];
        NSString* titlevalue = [btn.titleLabel.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
        if ([titlevalue isEqualToString:pNumber]) {
            return btn;
        }
    }
    
    for (int i = 9200; i < 9213; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:i];
        NSString* titlevalue = [btn.titleLabel.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
        if ([titlevalue isEqualToString:pNumber]) {
            return btn;
        }
    }
    
    return nil;
}

#pragma mark - 뷰 교체 (세로 <-> 가로)

-(void)setRotateToInterfaceOrientation:(UIInterfaceOrientation)tointerfaceOrientation {
    
    // 스크린 사이즈 가져옴
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    
    
	if ( tointerfaceOrientation == UIInterfaceOrientationPortrait || tointerfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.view = viewPortrait;
		isLandscapeMode = NO;
        screenHeight = screenSize.height+0.5;
	} else if ( tointerfaceOrientation == UIInterfaceOrientationLandscapeLeft || tointerfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		self.view = viewLandscape;
		isLandscapeMode = YES;
	}
    
    // 뷰변경시 텍스트와 탑바 설정
    viwToolbar.hidden = !isToolbarHidden;
    lbltopTitle.text = title;
    lbltopBarTitle.text = barTitle;
    lbltopBarTitleLand.text = barTitle;
    viwFullMode.hidden = !isFullMode;
    
	// 가로세로 모드가 변하면서 뷰가 바뀌기 때문에 키버튼 재배열해줘야 한다
    if ([txtInSecurity.text length] == 0)
        [self pressKeypadReload];
}

#pragma mark - 화면초기화

-(void)setRotateToInterfaceOrientation:(UIInterfaceOrientation)tointerfaceOrientation parentView:(UIView*)pParentView {
    
    [self.view removeFromSuperview];
    [self setRotateToInterfaceOrientation:tointerfaceOrientation];
    CGRect rect;
    rect = [[UIApplication sharedApplication] statusBarFrame];
    
    if (isLandscapeMode && rect.size.height > 460) {
        self.view.frame = CGRectMake(0.0, -_barHeight+yFrame, screenHeight, screenWidth);
    } else {
        self.view.frame = CGRectMake(0.0, -_barHeight+yFrame, screenWidth, screenHeight);
    }
    
    viwNumbPad.frame = CGRectMake(0.0, 0.0, screenWidth, nfilterHeight);
    viwNumbPad.center = CGPointMake(screenWidth * 0.5, self.view.frame.size.height - (nfilterHeight * 0.5));
    
    // identity input box
	vwInputIdentityNum.center = vwInputDefalt.center;
    
    // 필드 하나에 주민등록 번호 입력 하는 뷰
    vwInputIdentityId.center = vwInputDefalt.center;
    
    if (!isInputBoxForIdentityNum && !isInputSecurityId) {
        vwInputDefalt.hidden = NO;
        vwInputIdentityId.hidden = YES;
        vwInputIdentityNum.hidden = YES;
    } else if (isInputBoxForIdentityNum) {
        vwInputDefalt.hidden = YES;
        vwInputIdentityId.hidden = YES;
        vwInputIdentityNum.hidden = NO;
    } else if (isInputSecurityId) {
        vwInputDefalt.hidden = YES;
        vwInputIdentityId.hidden = NO;
        vwInputIdentityNum.hidden = YES;
    }
	
	//[self setFrame];
    [pParentView addSubview:self.view];
}

#pragma mark - 주민등록번호 처리
/*--------------------------------------------------------------------------------------
 사용자 입력값을 길이 6과 7로 나눠 주민번호 입력란에 나눈다
 ---------------------------------------------------------------------------------------*/
-(void)inputTextShare {
	txtInSecurityIdNum1.text = @"";
	txtInSecurityIdNum2.text = @"";
	lblInputValueIdNum1.text = lblInputValue.text;
	lblInputValueIdNum2.text = lblInputValue.text;
	
	NSString *strFull = txtInSecurity.text;
	NSString *plainText = @"";
	// 0. 암호화할 데이터
	//    NSString* plainText = [NSString stringWithFormat:@"%@", stringStore];
	for (id test in arrayStrore) {
		NSData *a1 = [test AES256DecryptWithKey:pubChain iv:[ec getIV:pubChain]];
		NSString *a = [[NSString alloc] initWithData:a1 encoding:NSUTF8StringEncoding];
		plainText = [plainText stringByAppendingString:a];
	}
	plainText = [[self getPlainText:[plainText dataUsingEncoding: NSUTF8StringEncoding]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	if ([strFull length] < 7) {
		txtInSecurityIdNum1.text = plainText;
		lblInputValueIdNum1.hidden = NO;
		lblInputValueIdNum2.hidden = YES;
	} else {
		txtInSecurityIdNum1.text = [plainText substringToIndex:6];
		txtInSecurityIdNum2.text = [strFull substringWithRange:NSMakeRange(6, ([strFull length] - 6))];
		lblInputValueIdNum2.hidden = NO;
		lblInputValueIdNum1.hidden = YES;
	}
	
	if (([strFull length] == 6) && (isInputBoxForIdentityNum) && !(isInputSecurityId)) {
		isStopCursor = NO;
		[self playCursor];
	} else {
		isStopCursor = YES;
		[self stopCursor];
	}
}

#pragma mark - 필드 하나로 된 주민등록번호 처리
/*--------------------------------------------------------------------------------------
 사용자 입력값을 길이 6과 7로 나눠 주민번호 입력란에 나눈다
 ---------------------------------------------------------------------------------------*/
-(void)inputTextShareInSecurityId {
	txtInSecurityId.text = @"";
	
	lblInputValueId.text = lblInputValue.text;
	
	NSString *strFull = txtInSecurity.text;
	NSString *plainText = @"";
	// 0. 암호화할 데이터
	//    NSString* plainText = [NSString stringWithFormat:@"%@", stringStore];
	for (id test in arrayStrore) {
		NSData *a1 = [test AES256DecryptWithKey:pubChain iv:[ec getIV:pubChain]];
		NSString *a = [[NSString alloc] initWithData:a1 encoding:NSUTF8StringEncoding];
		plainText = [plainText stringByAppendingString:a];
	}
	plainText = [[self getPlainText:[plainText dataUsingEncoding: NSUTF8StringEncoding]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	lblInputValueId.hidden = NO;


	if ([strFull length] < 7) {
        txtInSecurityId.text = plainText;
	} else {
        NSString* asterisk = @"*******";
        txtInSecurityId.text = [NSString stringWithFormat:@"%@-%@",[plainText substringToIndex:6], [asterisk substringToIndex:([strFull length] - 6)]];
	}
}

#pragma mark - 숫자키패드에서 더미값 구하기

- (NSString*)getDummyData: (int) max{
	// 0. 암호화할 데이터
	//    NSString* plainText = [NSString stringWithFormat:@"%@", stringStore];
	//const char *s=[[self getPlainText:[stringStore dataUsingEncoding: NSUTF8StringEncoding]] cStringUsingEncoding:NSASCIIStringEncoding];
	NSString *dummy = [ec makeEncNoPadWithSeedkey3:arrayStrore2];
	NSData *keyData=[[dummy dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pubChain iv:[ec getIV:pubChain]];

	//NSLog(@"dummy %@", [[dummy dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pubChain]);
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);

	NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
	for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
	{
		[hash appendFormat:@"%02x",digest[i]];
	}

	NSArray* arr = [ec Permutation:(int)lengthLimit];
	NSString *rtn = @"";
	for (int i = 0; i<max; i++) {
		NSString *index = [NSString stringWithFormat:@"%@", [arr objectAtIndex:i]];
		rtn = [rtn stringByAppendingString:[hash substringWithRange:NSMakeRange([index intValue], 1)]];
	}
	//NSLog(@"rtn : %@",rtn);
    return rtn;
}

#pragma mark - 6,6+ 해상도 맞추기 용
- (void) setFrame {
	if (!isSupportRetinaHD) {
		if (isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			self.view.center = CGPointMake(self.view.center.x, self.view.center.y + screenHeight - nfilterHeight);
			viwNumbPad.center = CGPointMake(screenWidth * 0.5, (nfilterHeight * 0.5));
		} else if(!isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			[viewPortrait setBackgroundColor:[UIColor clearColor]];
		}
		return;
	}
	
	//NSLog(@"setFrame");
	
	CGFloat scrnWidth = [[UIScreen mainScreen] bounds].size.width;
	
	float ratio = 1.0f;
	float x = 0.0f;
	float y = 0.0f;
	float centerY = 0.0f;
	
	if(scrnWidth == 375.0f) {
		ratio = 1.171f;
		x = -27.5f;
		y = 25.0f;
		centerY = 489;
		self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
		if (isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			self.view.center = CGPointMake(self.view.center.x, centerY + (nfilterHeight) + (3 * ratio) - 1);
			viwNumbPad.center = CGPointMake(scrnWidth/2 - x, centerY/4 + 9.5);
		} else {
			viwFullMode.center = CGPointMake(scrnWidth/2, centerY/2 + y);
			viwNumbPad.center = CGPointMake(scrnWidth/2 - x, centerY);
		}
		if(!isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			[viewPortrait setBackgroundColor:[UIColor clearColor]];
		}
	} else if (scrnWidth == 414.0f) {
		ratio = 1.3f;
		x = -47.0f;
		y = 67.5f;
		centerY = 521;
		self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
		if (isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			self.view.center = CGPointMake(self.view.center.x, centerY + ((nfilterHeight + 3) * ratio) + 13);
			viwNumbPad.center = CGPointMake(scrnWidth/2 - x, centerY/4);
		}else {
			viwFullMode.center = CGPointMake(scrnWidth/2, centerY/2 + y);
			viwNumbPad.center = CGPointMake(scrnWidth/2 - x, centerY);
		}
		if(!isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			[viewPortrait setBackgroundColor:[UIColor clearColor]];
		}
	} else {
		if (isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			self.view.center = CGPointMake(self.view.center.x, self.view.center.y + screenHeight - nfilterHeight);
			viwNumbPad.center = CGPointMake(screenWidth * 0.5, (nfilterHeight * 0.5));
		} else if(!isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			[viewPortrait setBackgroundColor:[UIColor clearColor]];
		}
	}
}

#pragma mark - 평문을 암호화 해서 보관할 때 사용 할 공개키를 세팅
- (void) checkPubChain {
	if ([pubChain length] == 0) {
		PublicKeyDownloader *pd = [PublicKeyDownloader sharedInstance];
		pubChain = [pd getServerPubkey];
	}
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

- (void)setSupportRotation:(BOOL)pYesOrNo {
	isSuportRotation = pYesOrNo;
}

#pragma mark - 길이와 태그 이름 웹뷰 지정

- (void)setLengthWithTagName:(NSString *)pTagName length:(NSInteger)pLength webView:(UIWebView *)pWebView {
	lengthLimit = pLength;
	self.tagName = pTagName;
}

#pragma mark - 백그라운드 이벤트 허용 설정
- (void)setBackgroundDimmedColor {
    [btnBackGroundClose setHidden:NO];
    [btnBackGroundClose setBackgroundColor:[StorageBoxUtil getDimmedBackgroundColor]];
}

- (void)hidePrvNxtBtnsOfToolbar {
    
    BOOL isHidden = YES;
    
    [btnToolbarNext setHidden:isHidden];
    [btnToolbarPrev setHidden:isHidden];
    [imgToolbarNext setHidden:isHidden];
    [imgToolbarPrev setHidden:isHidden];
}

- (void)setSupportBackgroundEvent:(BOOL)pYesOrNo {
    isSuportBackgroundEvent = pYesOrNo;
}

#pragma mark - 풀모드 설정

- (void)setFullMode:(BOOL)pYesOrNo {
    isFullMode = pYesOrNo;
}

#pragma mark - 타이틀텍스트 설정

- (void)setTitleText:(NSString *)ptitle {
    title = ptitle;
}

#pragma mark - 상단바 텍스트 설정

- (void)setTopBarText:(NSString *)ptitle {
    barTitle = ptitle;
}

#pragma mark - 툴바 설정

- (void)setToolBar:(BOOL)pYesOrNo {
    isToolbarHidden = pYesOrNo;
}

#pragma mark - 사운드설정

- (void)setNoSound:(BOOL)pYesOrNo {
    isNoSound = pYesOrNo;
}

#pragma mark - 서버공개키 설정

- (void)setServerPublickey:(NSString *)pServerPublickey {
	[ec setServerPublickey:pServerPublickey];
}

- (void)setServerPublickeyURL:(NSString *)pXmlURL {
	[ec setServerPublickeyURL:pXmlURL];
}

#pragma mark - 주민등록번호용 분리된 텍스트필드
- (void)setSupportIdentityNum:(BOOL)pYesOrNo {
    isInputBoxForIdentityNum = pYesOrNo;
    if(isInputBoxForIdentityNum) lengthLimit = 13;
}

#pragma mark - 주민등록번호용 원 필드 텍스트필드
- (void)setSupportIdentityId:(BOOL)pYesOrNo {
    isInputSecurityId = pYesOrNo;
    if(isInputSecurityId) lengthLimit = 13;
}

#pragma mark - 영문모드

- (void)setEngMode:(BOOL)pYesOrNo {
    isEngMode = pYesOrNo;
}

#pragma mark - 평문 사용 안함

- (void)setDummyText:(BOOL)pYesOrNo {
    isDummyData = pYesOrNo;
}

#pragma mark - 백그라운드 클릭시 종료

- (void)setSupportBackGroundClose:(BOOL)pYesOrNO{
    _isBackGroundClose = pYesOrNO;
}

#pragma mark - 모두암호화

- (void)setSupportFullEnc:(BOOL)pYesOrNO {
	isSupportFullEnc = pYesOrNO;
}

#pragma mark - YFrame 조절
- (void)setVerticalFrame:(NSInteger)pYFrame {
    yFrame = pYFrame;
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

#pragma mark - 6,6+ xib 지원
- (void) setSupportRetinaHD:(BOOL)pYesOrNO {
    isSupportRetinaHD = pYesOrNO;
}


#pragma mark - ---------------------------------------------- 화면 숨기기 콜백 메서드 ----------------------------------------------
- (void) handleResignActiveNotification {
	self.backgroundView.hidden = NO;
}


- (void) handleBecomeActiveNotification {
	self.backgroundView.hidden = YES;
}

#pragma mark - ---------------------------------------------- 애플 기본 ----------------------------------------------

#pragma mark - viewdidDisappear

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:NO];
    [self.tmrCursor invalidate];
    self.tmrCursor = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationWillResignActiveNotification
												  object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidBecomeActiveNotification
												  object:nil];
	//NSLog(@"viewDidDisappear");
	
}

-(void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:NO];
	self.view.transform = CGAffineTransformIdentity;
	viwNumbPad.transform = CGAffineTransformIdentity;
	viwFullMode.transform = CGAffineTransformIdentity;
	//NSLog(@"viewWillDisappear");
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // 1. 키패드 재배열
	[self reloadKeypad];
	
    // 2. 커서깜빡임
	isStopCursor = NO;
	self.tmrCursor = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                 target: self
                                               selector: @selector(playCursor)
                                               userInfo: nil
                                                repeats: YES];
    
    [self clearField];
    
    if (_RepTxt != nil) {
        [btnReplacekey setTitle:@"" forState:UIControlStateNormal];
        [btnReplacekeyLandscape setTitle:@"" forState:UIControlStateNormal];
    }
    
    if (_OKTxt != nil) {
        [btnConfirm setTitle:_OKTxt forState:UIControlStateNormal];
        [btnConfirmLandscape setTitle:_OKTxt forState:UIControlStateNormal];
        [btnToolbarConfirm setTitle:_OKTxt forState:UIControlStateNormal];
    }
    
    if (_CancelTxt != nil) {
        [btnCancel setTitle:_CancelTxt forState:UIControlStateNormal];
        [btnCancelLandscape setTitle:_CancelTxt forState:UIControlStateNormal];
    }
    
    if (_PrevTxt) {
        [btnToolbarPrev setTitle:@"" forState:UIControlStateNormal];
        [btnToolbarNext setTitle:@"" forState:UIControlStateNormal];
    }
	//NSLog(@"viewDidLoad");
	
	CGRect rect = CGRectMake(0, 0,  [[UIScreen mainScreen] bounds].size.width,  [[UIScreen mainScreen] bounds].size.height);
	self.backgroundView = [[UIView alloc] initWithFrame:rect];
	self.backgroundView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.backgroundView];
	self.backgroundView.hidden = YES;
}

#pragma mark - viewDidAppear

- (void)viewDidAppear:(BOOL)animated {
	
    [super viewDidAppear:YES];
    [self setRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    if (isSerialMode) {
        [self replaceButtonWithSpace]; // 시리얼모드일 경우 버튼을 한번더 재배열한다
    }
	
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(handleResignActiveNotification)
												 name: UIApplicationWillResignActiveNotification
											   object: nil];
	
	
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(handleBecomeActiveNotification)
												 name: UIApplicationDidBecomeActiveNotification
											   object: nil];
	//NSLog(@"viewDidAppear");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (isSerialMode) {
        [self replaceButtonWithSpace]; // 시리얼모드일 경우 버튼을 한번더 재배열한다
    }
}

#pragma mark viewWillAppear

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
	[self checkPubChain];
	[self setFrame];
	//NSLog(@"viewWillAppear");
}

#pragma mark - didReceiveMemoryWarning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    tagName = nil;
    title = nil;
    barTitle = nil;
    tmrCursor = nil;
    btnRadnomNum = nil;
    arrGapByEcc = nil;
}

@end