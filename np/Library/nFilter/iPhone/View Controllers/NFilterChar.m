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
#include <CommonCrypto/CommonDigest.h>
#import "NFilterChar.h"
#import "EccEncryptor.h"
#import "KnmRepUnicode.h"
#import "NSData+AESCrypt.h"
#import "PublicKeyDownloader.h"

@implementation NFilterChar {
@private
	EccEncryptor *ec;               // 암복호화 객체
	//    NSString *stringStore;
	NSMutableArray *arrayStrore;
    NSString* pubChain;
    NSInteger yFrame;               // Y 포지션 조절
}

@synthesize tmrCursor, stringKeyboardType;
@synthesize tagName;
@synthesize barHeight = _barHeight;
@synthesize isBackGroundClose = _isBackGroundClose;

@synthesize OKTxt = _OKTxt;
@synthesize CancelTxt = _CancelTxt;
@synthesize ENTxt = _ENTxt;
@synthesize RepTxt = _RepTxt;
@synthesize PrevTxt = _PrevTxt;
@synthesize NextTxt = _NextTxt;
@synthesize backgroundView = _backgroundView;

static NFilterChar* instance = nil;

+(NFilterChar*)charPadShared {
    if (instance == nil) {
        instance = [[NFilterChar alloc] initWithNibName:@"NFilterChar" bundle:nil];
    }
    
    return instance;
}

-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    
    self = [super initWithNibName:nibName bundle:nibBundle];
    
    // 키패드 높이
    nfilterHeight = 280.0;
    
    // 암복호화 객체 초기화
	ec = [EccEncryptor sharedInstance];
	arrayStrore = [[NSMutableArray alloc] init];
	
    return self;
}

#pragma mark - ---------------------------------------------- IBAction ----------------------------------------------

#pragma mark - 키모드 변경
// 키모드 변경버튼 눌림
- (IBAction)changeKeypadMode:(id)sender {
    
	[self soundPlay:@"click"];
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
		NSString *imgName = @"nf_ios_btn.png";  // 눌렸을때의 이미지파일명
		if (_keymodeTypeCurr == NKeymodeSEng) {
            imgName = @"nf_ios_icon_shift_pressed.png";
            isReadyFixUppercase = YES;
            isFixUppercase = NO;
		} else {
            imgName = @"nf_ios_icon_shift.png";
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
		UIImage *img = [UIImage imageNamed:@"nf_ios_icon_shift.png" ];
		[shiftIco setImage:img];
        [shiftIcoLandscape setImage:img];
        
        // 숫자패드 변경
        for (int i = 1; i < 11 ; i ++) {
            UIButton *button1 = (UIButton *)[viewPortrait viewWithTag:i];
            [button1 setBackgroundImage:[UIImage imageNamed:@"nf_ios_char.png"] forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            UIButton *button2 = (UIButton *)[viewLandscape viewWithTag:i];
            [button2 setBackgroundImage:[UIImage imageNamed:@"nf_ios_char.png"] forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            imgBigNum.image = [UIImage imageNamed:@"nf_ios_bubble.png"];
            lblBigNum.textColor = [UIColor blackColor];
            imgBigNumLandscape.image = [UIImage imageNamed:@"NFbubble_char_wide.png"];
            lblBigNumLandscape.textColor = [UIColor blackColor];
        }
		return;
	}
	
	// 영문키가 눌렸다면
	if (clickedButtenTag == 93) {
        
        _keymodeTypeCurr = NKeymodeSEng;
        [self setKeypadMode:_keymodeTypeCurr];
        
        // 숫자패드 원복
        for (int i = 1; i < 11 ; i ++) {
            UIButton *button1 = (UIButton *)[viewPortrait viewWithTag:i];
            [button1 setBackgroundImage:[UIImage imageNamed:@"nf_ios_char.png"] forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            UIButton *button2 = (UIButton *)[viewLandscape viewWithTag:i];
            [button2 setBackgroundImage:[UIImage imageNamed:@"nf_ios_char.png"] forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            imgBigNum.image = [UIImage imageNamed:@"nf_ios_bubble.png"];
            lblBigNum.textColor = [UIColor blackColor];
            imgBigNumLandscape.image = [UIImage imageNamed:@"NFbubble_num_wide.png"];
            lblBigNumLandscape.textColor = [UIColor blackColor];
        }
	}
}

#pragma mark - 풍선 띄우기
// 풍선띄우기
- (IBAction)touchDownKepad:(id)sender {
    
	UIButton *button = (UIButton *)sender;
    
    // 사운드효과
    [self soundPlay:@"click"];
    
	// 풍선뜨는 위치조정 Y 값
	NSInteger popupControllX = 0;
	NSInteger popupControllY = 0;
    
    /* 가로,세로 확인 */
    //NSLog(@"[[UIScreen mainScreen] bounds].size.width : %f", [[UIScreen mainScreen] bounds].size.width);
    //NSLog(@"[[UIScreen mainScreen] bounds].size.width : %f", [[UIScreen mainScreen] bounds].size.height);
    //NSLog(@"self.view.frame.size.width : %f", self.view.frame.size.width);
    //NSLog(@"self.view.frame.size.height : %f", self.view.frame.size.height);
    if ([[UIScreen mainScreen] bounds].size.width >= 460)
        isLandscapeMode = YES;
    
	if (isLandscapeMode) {
        //NSLog(@"가로모드 풍선띄우기");
		popupControllX = (viwCharPadLandscape.frame.origin.x);
		popupControllY = (viwCharPadLandscape.frame.origin.y) - 25;
	} else {
        //NSLog(@"세로모드 풍선띄우기");
        //NSLog(@"viwCharPad.frame.origin.x : %f", viwCharPad.frame.origin.x);
        //NSLog(@"viwCharPad.frame.origin.y : %f", viwCharPad.frame.origin.y);
		popupControllX = (viwCharPad.frame.origin.x);
		popupControllY = (viwCharPad.frame.origin.y) - 20;
	}
	
	// 강한보안모드일때 풍선팝업 랜덤하게 하나 더 띄운다
	if (isDeepSecMode) {
		[self popRandom:button];
	}
	
	CGFloat scrnWidth = [[UIScreen mainScreen] bounds].size.width;
	float ratio = 1.0f;
	// 이하 상단의 숫자키들 일 경우 풍선
	if (button.tag < 11) {
        
		// 새로모드일때의 풍선
		if(scrnWidth == 375.0f && isSupportRetinaHD) {
			ratio = 1.171f;
			imgBigNum.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			lblBigNum.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			imgBigNum.center = CGPointMake((button.center.x + popupControllX) * ratio,
										   button.center.y + popupControllY + 5);
			lblBigNum.center = CGPointMake((button.center.x + popupControllX) * ratio,
										   button.center.y + popupControllY - 17 );
		} else if (scrnWidth == 414.0f && isSupportRetinaHD) {
			ratio = 1.3f;
			imgBigNum.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			lblBigNum.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			imgBigNum.center = CGPointMake((button.center.x + popupControllX) * ratio,
										   button.center.y + popupControllY + 12);
			lblBigNum.center = CGPointMake((button.center.x + popupControllX) * ratio,
										   button.center.y + popupControllY - 17 );
		} else {
			imgBigNum.center = CGPointMake(button.center.x + popupControllX,
										   button.center.y + popupControllY);
			lblBigNum.center = CGPointMake(button.center.x + popupControllX,
										   button.center.y + popupControllY - 17 );
		}
		
		lblBigNum.text = [button titleLabel].text;
		imgBigNum.hidden = NO;
		lblBigNum.hidden = NO;
		
		// 가로모드일때의 풍선
		imgBigNumLandscape.center = CGPointMake(button.center.x + popupControllX,
												button.center.y + popupControllY);
		lblBigNumLandscape.center = CGPointMake(button.center.x + popupControllX,
												button.center.y + popupControllY - 17);
		
		lblBigNumLandscape.text = [button titleLabel].text;
		imgBigNumLandscape.hidden = NO;
		lblBigNumLandscape.hidden = NO;
	} // 이하 문자키들 일 경우 풍선
	else if (button.tag != 30 || button.tag != 38) {
		
		if(scrnWidth == 375.0f && isSupportRetinaHD) {
			ratio = 1.171f;
			imgBigChr.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			lblBigChr.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			imgBigChr.center = CGPointMake((button.center.x + popupControllX) * ratio,
										   (button.center.y * ratio) + popupControllY - 6 );
			lblBigChr.center = CGPointMake((button.center.x + popupControllX) * ratio,
										   (button.center.y * ratio) + popupControllY - 30 );
		} else if (scrnWidth == 414.0f && isSupportRetinaHD) {
			ratio = 1.3f;
			imgBigChr.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			lblBigChr.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			imgBigChr.center = CGPointMake((button.center.x + popupControllX) * ratio,
										   (button.center.y * ratio) + popupControllY - 7 );
			lblBigChr.center = CGPointMake((button.center.x + popupControllX) * ratio,
										   (button.center.y * ratio) + popupControllY - 30 );
		} else {
			imgBigChr.center = CGPointMake(button.center.x + popupControllX,
										   button.center.y + popupControllY);
			lblBigChr.center = CGPointMake(button.center.x + popupControllX,
										   button.center.y + popupControllY - 18 );
		}
		
		lblBigChr.text = [button titleLabel].text;
		imgBigChr.hidden = NO;
		lblBigChr.hidden = NO;
		
		// 가로모드일때의 풍선
		imgBigChrLandscape.center = CGPointMake(button.center.x + popupControllX,
												button.center.y + popupControllY);
		lblBigChrLandscape.center = CGPointMake(button.center.x + popupControllX,
												button.center.y + popupControllY - 18);
		
		lblBigChrLandscape.text = [button titleLabel].text;
		imgBigChrLandscape.hidden = NO;
		lblBigChrLandscape.hidden = NO;
	}
}

#pragma mark - 버튼 누름

// 키패드 버튼 릴리즈
- (IBAction)pressButton:(id)sender {
	
	// 커서깜빡임 중지
	[self stopCursor];
	[self checkPubChain];
    // 풍선버튼 숨기자
	[self hideTooltipBtn];
	
	UIButton *button = (UIButton *)sender;
	
	if ( txtInSecurity.text.length == lengthLimit )
		return;
	
	NSString *keyValue = nil;
	//	NSString *newStr;
	if ([[(UIButton *)sender titleLabel].text isEqualToString:@"SPACE"]) {
		[self soundPlay:@"click"];
		//		newStr = [[NSString alloc] initWithFormat:@"%@ ", stringStore];
		//#pragma mark ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆ arrayStrore ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆pubChain
		[arrayStrore addObject:[[@" " dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pubChain iv:[ec getIV:pubChain]]];
		keyValue = @" ";
	} else {
		keyValue = [[button titleLabel].text stringByReplacingOccurrencesOfString:@" " withString:@""];
		if (isHideLastValue == NO) {
			lblInputValue.hidden = NO;
			lblInputValueLandscape.hidden = NO;
		}
		
		//		newStr = [[NSString alloc] initWithFormat:@"%@%@", stringStore, keyValue];
		//#pragma mark ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆ arrayStrore ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
		[arrayStrore addObject:[[keyValue dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:pubChain iv:[ec getIV:pubChain]]];
		
	}
	
	// 강한보안모드일때 텍스트라벨을 숨긴다.
	if (isDeepSecMode) {
		lblInputValue.hidden = YES;
		lblInputValueLandscape.hidden = YES;
	} else {
		if (isHideLastValue == NO) {
			lblInputValue.hidden = NO;
			lblInputValueLandscape.hidden = NO;
		}
	}
	
	//    stringStore = newStr;
	txtInSecurity.text = [self getDummyData:arrayStrore.count];
	txtInSecurityLandscape.text = [self getDummyData:arrayStrore.count];
    
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
    lblInputValue.text = keyValue;
    lblInputValueLandscape.text = lblInputValue.text;
    
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
        
        UIImage *img = [UIImage imageNamed:@"nf_ios_icon_shift.png"];
        [shiftIco setImage:img];
        [shiftIcoLandscape setImage:img];
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
	[self soundPlay:@"click"];
	[self replaceKeypad];
}

#pragma mark - 취소 버튼 이벤트

- (IBAction)pressCancel {

    if (_pMethodOnCancel == nil) {
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

#pragma mark - 백그라운 클릭시 엔필터 종료 이벤트
- (IBAction)pressBackGround:(id)sender{
    [self clearField];
    [self.view removeFromSuperview];

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
	//	NSString *newStr = stringStore;
	if (arrayStrore.count == 0)
		return;
	//#pragma mark ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆ arrayStrore ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆
	//	NSString *backStr = [[NSString alloc] initWithFormat:@"%@", [newStr substringToIndex:(newStr.length -1)]];
	[arrayStrore removeLastObject];
	
	txtInSecurity.text = [self getDummyData:[arrayStrore count]];
	txtInSecurityLandscape.text = [self getDummyData:[arrayStrore count]];
	//    stringStore = backStr;
	
	// 이부분에서 키보드타입어레이를 하나 지워주자
	[self.stringKeyboardType deleteCharactersInRange:NSMakeRange([self.stringKeyboardType length]-1, 1)];
	txtInSecurityLandscape.text = txtInSecurity.text;
	
	if (arrayStrore.count ==0) {
		isStopCursor = NO;
		lblInputValue.hidden = YES;
		lblInputValueLandscape.hidden = YES;
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

#pragma mark - 콜백 메소드 실행

- (void)returnWithCallBackMethod:(SEL)callbackMethod{
    
	// #pragma mark ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆ arrayStrore ☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆☆

	// 1. 암호화 수행
    NSString *encText = nil;
    if (isNoPadding) {
        encText = [[NSString alloc] initWithFormat:@"%@", [ec makeEncNoPadding2:arrayStrore]];
    } else {
        encText = [[NSString alloc] initWithFormat:@"%@", [ec makeEncPadding2:arrayStrore]];
    }
	
    NSString *dummyText = [self getDummyData:arrayStrore.count];
    
    // 2. 만약 치환테이블 사용옵션이 켜져있다면 치환시킨 후에 암호화하자
    //if (isSuportReplaceTable) {
    //    NSInteger randNum = ([ec getRandNum] % 100) + 129;
    //    plainText = [[KnmRepUnicode shared] replaceString:plainText increaseNum:randNum];
    //}
    
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
		NSString *plainText = [ec makeEncNoPadWithSeedkey2:arrayStrore];

        (*funcp)(_pTarget,              // 타겟
                 callbackMethod,        // 콜백메소드
                 plainText,             // 평문
                 encText,               // 암호텍스트
				 dummyText,				// 더미텍스트
                 tagName);              // 태그명
    }
}

#pragma mark - 회전지원
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
    
    viwCharPad.frame = CGRectMake(0.0, 0.0, screenWidth, nfilterHeight);
    viwCharPad.center = CGPointMake(screenWidth * 0.5, self.view.frame.size.height - (nfilterHeight * 0.5));
    [pParentView addSubview:self.view];
}

#pragma mark - 화면초기화

-(void)setRotateToInterfaceOrientation:(UIInterfaceOrientation)tointerfaceOrientation {
    
    // 스크린 사이즈 가져옴
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;
    
    if ( tointerfaceOrientation == UIInterfaceOrientationPortrait || tointerfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		self.view = viewPortrait;
		isLandscapeMode = NO;
        screenHeight = screenSize.height+0.5;
        btnRect = 0;
	} else if ( tointerfaceOrientation == UIInterfaceOrientationLandscapeLeft || tointerfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		self.view = viewLandscape;
		isLandscapeMode = YES;
        btnRect = (screenHeight-480) * 0.6;
	}
	
    // 뷰변경시 텍스트와 탑바 설정
    viwToolbar.hidden = !isToolbarHidden;
    lbltopTitle.text = title;
    lbltopBarTitle.text = barTitle;
    viwFullMode.hidden = !isFullMode;
    
	// 가로세로 모드가 변하면서 뷰가 바뀌기 때문에 키버튼 재배열해줘야 한다
	[self replaceKeypad];
	[self setKeypadMode:_keymodeTypeCurr];
}


#pragma mark - 엔필터닫음
-(void)closeNFilter {
    [self clearField];
    [self dismissViewControllerAnimated:NO completion:nil];
    
 }

#pragma mark - 텍스트필드 클리어
-(void)clearField {
    arrayStrore = [[NSMutableArray alloc] init];
    txtInSecurity.text = @"";
    txtInSecurityLandscape.text = @"";
    lblInputValue.text = @"";
    lblInputValueLandscape.text = @"";
}

//#pragma mark - 마지막 입력값 가져오기
// 마지막 입력값 가져오기
//-(NSString*)getLastInputValue {
//    if ([txtInSecurity.text length] == 0) {
//        return @"";
//    }
//    NSString* retValue = [stringStore substringWithRange:NSMakeRange([stringStore length] -1, 1)];
//    return retValue;
//}

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
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
			
			UILabel *labelE = (UILabel *)[[self view] viewWithTag:button.tag +200];
			labelE.hidden = YES;
			UILabel *labelH = (UILabel *)[[self view] viewWithTag:button.tag +100];
			labelH.hidden = YES;
            
        } else {
			// 특수기호가 아닐때 버튼글씨 죽이고 라벨들 살린다
			[button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
			[button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
			
			UILabel *labelE = (UILabel *)[[self view] viewWithTag:button.tag +200];
			labelE.text = button.titleLabel.text;
			labelE.hidden = NO;
			
			UILabel *labelH = (UILabel *)[[self view] viewWithTag:button.tag +100];
			labelH.text = [oneKeySet objectAtIndex:intKeymodeSmall];
			labelH.hidden = isEngMode;
		}
	}
    
}

#pragma mark - 강한보안모드일경우 버튼 풍선
// 강한보안모드일때 랜덤한 버튼풍선을 띄워준다
- (void)popRandom:(id)sender {
	
	// 풍선뜨는 위치조정 X, Y 값
	NSInteger popupControllY = (viwCharPad.frame.size.height) + 15;
	
	UIButton *button = (UIButton *)sender;
	NSInteger randomNumber =  1 + arc4random() % 27;
	randomNumber = randomNumber +10;
	
	if ( button.tag == randomNumber )
		randomNumber = randomNumber +1;
	if ( randomNumber == 30 )
		randomNumber = randomNumber -1;
	if (randomNumber == 38 )
		randomNumber = randomNumber -1;
    
	//NSLog(@"Random number: %d", randomNumber);
	button = (UIButton*)[[self view] viewWithTag:randomNumber];
	//NSLog(@"Random button: %@", [button titleLabel].text);
	
	imgBigRadom.center = CGPointMake(button.center.x,
									 button.center.y + popupControllY);
	lblBigRandom.center = CGPointMake(button.center.x
									  , button.center.y + popupControllY - 20);
	
	lblBigRandom.text = [button titleLabel].text;
	imgBigRadom.hidden = NO;
	lblBigRandom.hidden = NO;
}


#pragma mark - 풍선숨기기
// 풍선숨기기
- (void)hideTooltipBtn {
    imgBigNum.hidden = YES;
	lblBigNum.hidden = YES;
    
	imgBigChr.hidden = YES;
	lblBigChr.hidden = YES;
	
	imgBigNumLandscape.hidden = YES;
	lblBigNumLandscape.hidden = YES;
    
	imgBigChrLandscape.hidden = YES;
	lblBigChrLandscape.hidden = YES;
	
	imgBigRadom.hidden = YES;
	lblBigRandom.hidden = YES;
}

#pragma mark - 키패드 초기화
// 키패드 초기화 가로모드
- (void)keypadInitLandscape {
    
    //NSLog(@"키패드초기화 가로모드");
    
	NSInteger intPLUS = 27;
    UIButton *button;
    
	for (int i = 1 ; i < 11 ; i ++) {
		button = [self moveButtonWithTag:i plusX:0 plusY:0];
		button.center = CGPointMake(intPLUS, button.center.y);
		intPLUS = intPLUS + 43;
	}
	
	intPLUS = 27;
	for (int i = 11 ; i < 21 ; i ++) {
		UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
		button.center = CGPointMake(intPLUS, button.center.y);
		intPLUS = intPLUS + 43;
	}
	
	intPLUS = 27;
	for (int i = 21 ; i < 30 ; i ++) {
		button = [self moveButtonWithTag:i plusX:0 plusY:0];
		button.center = CGPointMake(intPLUS, button.center.y);
		intPLUS = intPLUS + 43;
	}
    
	intPLUS = 94 + btnRect;   //147
	for (int i = 30; i < 37 ; i ++) {
		UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
		button.center = CGPointMake(intPLUS, button.center.y);
		intPLUS = intPLUS + 43;
        
        // 한글라벨
		UILabel *labelH = (UILabel*)[[self view] viewWithTag:[button tag] + 100];
		labelH.center = CGPointMake(button.center.x, labelH.center.y);
		
		// 영문라벨
		UILabel *labelE = (UILabel*)[[self view] viewWithTag:[button tag] + 200];
		labelE.center = CGPointMake(button.center.x, labelE.center.y);
		labelE.text = button.titleLabel.text;
	}
    
    // 이하 키패드 부속 버튼 위치 조정
    intPLUS = 39 + btnRect; //92
    button = [self moveButtonWithTag:91 plusX:0 plusY:0];
    button.center = CGPointMake(intPLUS, button.center.y);
    
    // 아이콘
    shiftIcoLandscape.center = CGPointMake(intPLUS, shiftIcoLandscape.center.y);
    
    button = [self moveButtonWithTag:92 plusX:0 plusY:0];
    button.center = CGPointMake(intPLUS, button.center.y);
    
    intPLUS = intPLUS + 67; //159
    button = [self moveButtonWithTag:93 plusX:0 plusY:0];
    button.center = CGPointMake(intPLUS, button.center.y);
    
    intPLUS = intPLUS + 157; // 316
    button = [self moveButtonWithTag:300 plusX:0 plusY:0];
    button.center = CGPointMake(intPLUS, button.center.y);
    
    intPLUS = intPLUS + 169; // 485
    button = [self moveButtonWithTag:301 plusX:0 plusY:0];
    button.center = CGPointMake(intPLUS, button.center.y);
    
    intPLUS = intPLUS + 13; // 497
    button = [self moveButtonWithTag:38 plusX:0 plusY:0];
    button.center = CGPointMake(intPLUS, button.center.y);
    
    // 아이콘
    delIcoLandscape.center = CGPointMake(intPLUS, delIcoLandscape.center.y);
    
	return;
}

// 키패드 초기화 세로모드
- (void)keypadInit {
    
    //NSLog(@"키패드 초기화 세로모드");
	float intPLUS = 16;
	for (int i = 1 ; i < 11 ; i ++) {
		UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
		button.center = CGPointMake(intPLUS, button.center.y);
		intPLUS = intPLUS + 29;
	}
	
	intPLUS = 16;
	for (int i = 11 ; i < 21 ; i ++) {
		UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
		button.center = CGPointMake(intPLUS, button.center.y);
		intPLUS = intPLUS + 29;
		
		// 한글라벨
		UILabel *labelH = (UILabel*)[[self view] viewWithTag:[button tag] + 100];
		labelH.center = CGPointMake(button.center.x, labelH.center.y);
		
		// 영문라벨
		UILabel *labelE = (UILabel*)[[self view] viewWithTag:[button tag] + 200];
		labelE.center = CGPointMake(button.center.x, labelE.center.y);
		labelE.text = button.titleLabel.text;
	}
	
	intPLUS = 16;
	for (int i = 21 ; i < 30 ; i ++) {
		UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
		button.center = CGPointMake(intPLUS, button.center.y);
		intPLUS = intPLUS + 29;
		
		// 한글라벨
		UILabel *labelH = (UILabel*)[[self view] viewWithTag:[button tag] + 100];
		labelH.center = CGPointMake(button.center.x, labelH.center.y);
		
		// 영문라벨
		UILabel *labelE = (UILabel*)[[self view] viewWithTag:[button tag] + 200];
		labelE.center = CGPointMake(button.center.x, labelE.center.y);
		labelE.text = button.titleLabel.text;
	}
	
	intPLUS = 20;
	intPLUS = intPLUS + 37;
	for (int i = 30 ; i < 37 ; i ++) {
		UIButton *button = [self moveButtonWithTag:i plusX:0 plusY:0];
		button.center = CGPointMake(intPLUS, button.center.y);
		intPLUS = intPLUS + 29;
		
		// 한글라벨
		UILabel *labelH = (UILabel*)[[self view] viewWithTag:[button tag] + 100];
		labelH.center = CGPointMake(button.center.x, labelH.center.y);
		
		// 영문라벨
		UILabel *labelE = (UILabel*)[[self view] viewWithTag:[button tag] + 200];
		labelE.center = CGPointMake(button.center.x, labelE.center.y);
		labelE.text = button.titleLabel.text;
	}
}

#pragma mark - 키패드 재배열
- (void)replaceKeypad {
	
    [self clearField];
    
    /* 가로모드인지 세로모드인지 확인 */
    if ([[UIScreen mainScreen] bounds].size.width >= 460)
        isLandscapeMode = YES;
    
	NSInteger intInterval = 14;
	if ( isLandscapeMode ) {
		[self keypadInitLandscape];
        		//NSLog(@"replaceKeypad: 가로모드 버튼배열");
		intInterval = 20;
	} else	{
		[self keypadInit];
        		//NSLog(@"replaceKeypad: 세로모드 버튼배열");
	}
	
	
	NSString * strDate = [NSString stringWithFormat:@"%lf",CFAbsoluteTimeGetCurrent()];
    NSArray *listItems = [strDate componentsSeparatedByString:@"."];
    strDate = listItems[1];
	
	NSInteger intTagCount = 0;
	// 첫번째열
	NSInteger intPLUS = 0;
	NSArray *arrGap = [ec makeGapWithKeypads:([strDate intValue]+1) gapCount:2 widthPixel:10];
	for (int i = 0; i < [arrGap count]; i++) {
		for (int j = 0; j < ([[arrGap objectAtIndex:i] intValue]); j++) {
			intTagCount = intTagCount +1;
			[self moveButtonWithTag:intTagCount plusX:intPLUS plusY:0];
		}
		intPLUS = intPLUS + intInterval;
	}
	
	intPLUS = 0;
	arrGap = [ec makeGapWithKeypads:([strDate intValue]+2) gapCount:2 widthPixel:10];
	for (int i = 0; i < [arrGap count]; i++) {
		for (int j = 0; j < ([[arrGap objectAtIndex:i] intValue]); j++) {
			intTagCount = intTagCount +1;
			UIButton *button = [self moveButtonWithTag:intTagCount plusX:intPLUS plusY:0];
			// 한글라벨
			UILabel *labelH = (UILabel*)[[self view] viewWithTag:[button tag] + 100];
			labelH.center = CGPointMake(button.center.x, labelH.center.y);
			
			// 영문라벨
			UILabel *labelE = (UILabel*)[[self view] viewWithTag:[button tag] + 200];
			labelE.center = CGPointMake(button.center.x, labelE.center.y);
		}
		intPLUS = intPLUS + intInterval;
	}
	
	intPLUS = 0;
	arrGap = [ec makeGapWithKeypads:([strDate intValue]+3) gapCount:3 widthPixel:9];
	for (int i = 0; i < [arrGap count]; i++) {
		for (int j = 0; j < ([[arrGap objectAtIndex:i] intValue]); j++) {
			intTagCount = intTagCount +1;
			UIButton *button = [self moveButtonWithTag:intTagCount plusX:intPLUS plusY:0];
			// 한글라벨
			UILabel *labelH = (UILabel*)[[self view] viewWithTag:[button tag] + 100];
			labelH.center = CGPointMake(button.center.x, labelH.center.y);
			
			// 영문라벨
			UILabel *labelE = (UILabel*)[[self view] viewWithTag:[button tag] + 200];
			labelE.center = CGPointMake(button.center.x, labelE.center.y);
		}
		intPLUS = intPLUS + intInterval;
	}
	
	intPLUS = 0;
	intTagCount = intTagCount +1;
	arrGap = [ec makeGapWithKeypads:([strDate intValue]+4) gapCount:2 widthPixel:7];
	for (int i = 0; i < [arrGap count]; i++) {
		for (int j = 0; j < ([[arrGap objectAtIndex:i] intValue]); j++) {
			intTagCount = intTagCount +1;
			UIButton *button = [self moveButtonWithTag:intTagCount plusX:intPLUS-btnRect plusY:0];
			// 한글라벨
			UILabel *labelH = (UILabel*)[[self view] viewWithTag:[button tag] + 100];
			labelH.center = CGPointMake(button.center.x, labelH.center.y);
			
			// 영문라벨
			UILabel *labelE = (UILabel*)[[self view] viewWithTag:[button tag] + 200];
			labelE.center = CGPointMake(button.center.x, labelE.center.y);
		}
		intPLUS = intPLUS + intInterval;
	}
}

#pragma mark - 대소문자 고정

- (void)onTimerToChangeFixUppercase {
    isReadyFixUppercase = NO;
}

#pragma mark - 문자 키패드에서 더미값 구하기

- (NSString*)getDummyData: (int) max{
	
	NSString *dummy = [ec makeEncNoPadWithSeedkey2:arrayStrore];
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
	
	return rtn;
}

#pragma mark - 6,6+ 해상도 맞추기 용
- (void) setFrame {
	if (!isSupportRetinaHD) {
		if (isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			self.view.center = CGPointMake(self.view.center.x, self.view.center.y + screenHeight - nfilterHeight);
			viwCharPad.center = CGPointMake(screenWidth * 0.5, (nfilterHeight * 0.5));
		} else if(!isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			[viewPortrait setBackgroundColor:[UIColor clearColor]];
		}
		return;
	}
	//NSLog(@"setFrame");
	
	CGFloat scrnWidth = [[UIScreen mainScreen] bounds].size.width;
	CGFloat scrnHeight = [[UIScreen mainScreen] bounds].size.height;
	
	float ratio = 1.0f;
	float x = 0.0f;
	float y = 0.0f;
	float centerY = 0.0f;
	
	if(scrnWidth == 375.0f) {
		ratio = 1.172f;
		x = 32.0f;
		y = -62.0f;
		centerY = 505;
		
		
		if (isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			self.view.center = CGPointMake(self.view.center.x,  centerY + (nfilterHeight/1.5) - 20);
			viwCharPad.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			viwCharPad.center = CGPointMake(scrnWidth/2 + x, centerY/3 - 3.5);
		} else {
			viwFullMode.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			viwCharPad.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			viwFullMode.center = CGPointMake(scrnWidth/2, centerY/2 + y);
			viwCharPad.center = CGPointMake(scrnWidth/2 + x, centerY);
		}
		
		if(!isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			[viewPortrait setBackgroundColor:[UIColor clearColor]];
		}
		
	} else if (scrnWidth == 414.0f) {
		ratio = 1.3f;
		x = 61.0f;
		y = 55.0f;
		centerY = 187;
		
		
		if (isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			self.view.center = CGPointMake(self.view.center.x,  (centerY * 2 + nfilterHeight * ratio));
			viwCharPad.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			viwCharPad.center = CGPointMake(scrnWidth/2 + x, centerY - 3);
		} else {
			viwFullMode.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			viwCharPad.transform = CGAffineTransformScale(CGAffineTransformIdentity, ratio, ratio);
			viwFullMode.center = CGPointMake(scrnWidth/2, scrnHeight/2 - y);
			viwCharPad.center = CGPointMake(scrnWidth/2 + x, scrnHeight/2 + centerY);
		}
		
		if(!isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			[viewPortrait setBackgroundColor:[UIColor clearColor]];
		}
	} else {
		if (isSuportBackgroundEvent && !isFullMode && !isLandscapeMode) {
			self.view.center = CGPointMake(self.view.center.x, self.view.center.y + screenHeight - nfilterHeight);
			viwCharPad.center = CGPointMake(screenWidth * 0.5, (nfilterHeight * 0.5));
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
	[ec setServerPublickey:pServerPublickey];
}

- (void)setServerPublickeyURL:(NSString *)pXmlURL {
	[ec setServerPublickeyURL:pXmlURL];
}

#pragma mark - 강한보안모드

- (void)setDeepSecMode:(BOOL)pYesOrNo {
	isDeepSecMode = pYesOrNo;
}

#pragma mark - 로테이션 지원설정

- (void)setSupportRotation:(BOOL)pYesOrNo {
	isSuportRotation = pYesOrNo;
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

#pragma mark - 사운드설정

- (void)setNoSound:(BOOL)pYesOrNo {
    isNoSound = pYesOrNo;
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

#pragma mark - 패딩설정

- (void)setNoPadding:(BOOL)pYesOrNo {
    isNoPadding = pYesOrNo;
}

#pragma mark - 키패드의 텍스트필드 길이제한

- (void)setLengthWithTagName:(NSString *)pTagName length:(NSInteger)pLength webView:(UIWebView *)pWebView {
	lengthLimit = pLength;
	self.tagName = pTagName;
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

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:NO];
    [self.tmrCursor invalidate];
    self.tmrCursor = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationWillResignActiveNotification
												  object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidBecomeActiveNotification
												  object:nil];
}

- (void) viewDidAppear:(BOOL)animated{
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(handleResignActiveNotification)
												 name: UIApplicationWillResignActiveNotification
											   object: nil];
	
	
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(handleBecomeActiveNotification)
												 name: UIApplicationDidBecomeActiveNotification
											   object: nil];
	[super viewDidAppear:YES];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	NSBundle* bundle = [NSBundle mainBundle];
	NSString* plistPath = [bundle pathForResource:@"iPhoneKeySetting" ofType:@"plist"];
	dictKeys = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
	arrKeys = [[NSArray alloc] initWithArray:[[dictKeys allKeys] sortedArrayUsingSelector:@selector(compare:)]];
	
	// 1. 키패드모드 기본값으로 시작
	_keymodeTypeCurr = NKeymodeSEng;
	[self setKeypadMode:_keymodeTypeCurr];
	
    // 2. 커서깜빡임
	isStopCursor = NO;
    self.tmrCursor = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                 target: self
                                               selector: @selector(playCursor)
                                               userInfo: nil
                                                repeats: YES];
    
	// 3. 버튼재배열
	[self replaceKeypad];
    
    // 4. 키입력유형 초기화
    self.stringKeyboardType = [NSMutableString stringWithCapacity:100];
    
    [self clearField];
    

    if (_ENTxt != nil) {
        [btnEngkey setTitle:_ENTxt forState:UIControlStateNormal];                           // 영문 버튼
        [btnEngkeyLandscape setTitle:_ENTxt forState:UIControlStateNormal];
    }

    if (_RepTxt != nil) {
        [btnReplacekey setTitle:_RepTxt forState:UIControlStateNormal];
        [btnReplacekeyLandscape setTitle:_RepTxt forState:UIControlStateNormal];
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

    if (_PrevTxt != nil) {
        [btnToolbarPrev setTitle:_PrevTxt forState:UIControlStateNormal];
        [btnToolbarNext setTitle:_PrevTxt forState:UIControlStateNormal];
    }
	
	CGRect rect = CGRectMake(0, 0,  [[UIScreen mainScreen] bounds].size.width,  [[UIScreen mainScreen] bounds].size.height);
	self.backgroundView = [[UIView alloc] initWithFrame:rect];
	self.backgroundView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.backgroundView];
	self.backgroundView.hidden = YES;
}

#pragma mark viewWillAppear

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
	[self setFrame];
	[self checkPubChain];
}

- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:NO];
	viwFullMode.transform = CGAffineTransformIdentity;
	viwCharPad.transform = CGAffineTransformIdentity;
}
#pragma mark - didReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
	
	self.tmrCursor = nil;
	dictKeys = nil;
	arrKeys = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (isSuportRotation) {
        [self setRotateToInterfaceOrientation:(UIInterfaceOrientation)[UIDevice currentDevice].orientation];
    }
    return YES;
}

- (BOOL)shouldAutorotate {
    if (isSuportRotation) {
        [self setRotateToInterfaceOrientation:(UIInterfaceOrientation)[UIDevice currentDevice].orientation];
    }
    return isSuportRotation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
@end