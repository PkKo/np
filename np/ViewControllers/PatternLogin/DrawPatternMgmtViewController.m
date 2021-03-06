//
//  DrawPatternMgmtViewController.m
//  np
//
//  Created by Infobank2 on 10/20/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "DrawPatternMgmtViewController.h"
#import "LoginUtil.h"
#import "RegistAccountViewController.h"

#define MATRIX_SIZE 3

typedef enum SetupStatus {
    SETUP_UPDATE = 0,
    SETUP_PW,
    SETUP_PW_CONFIRM
    
} SetupStatus;

#define STROKE_COLOR_BLUE [UIColor colorWithRed:62.0f/255.0f green:155.0f/255.0f blue:233.0f/255.0f alpha:1]
#define STROKE_COLOR_RED [UIColor colorWithRed:248.0f/255.0f green:76.0f/255.0f blue:116.0f/255.0f alpha:1]
@interface DrawPatternMgmtViewController () {
    int         _setupStatus;
    NSString  * _savedPw;
    NSString  * _pw;
    NSString  * _pwConfirm;
}

@end

@implementation DrawPatternMgmtViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"패턴 관리"];
    
    self.loginMethod                = LOGIN_BY_PATTERN;
    
    CGFloat screenWidth             = [[UIScreen mainScreen] bounds].size.width;
    CGRect patternViewFrame         = _patternView.frame;
    patternViewFrame.size.width     = (screenWidth - patternViewFrame.origin.x * 2);
    patternViewFrame.size.height    = patternViewFrame.size.width;
    [_patternView setFrame:patternViewFrame];
    [_patternView setStrokeColor:STROKE_COLOR_BLUE];
    
    for (int i=0; i<MATRIX_SIZE; i++) {
        for (int j=0; j<MATRIX_SIZE; j++) {
            UIImage *dotImage = [UIImage imageNamed:@"pattern_02_dft"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:dotImage
                                                       highlightedImage:[UIImage imageNamed:@"pattern_02_sel"]];
            
            imageView.frame = CGRectMake(0, 0, dotImage.size.width, dotImage.size.height);
            imageView.userInteractionEnabled = YES;
            imageView.tag = j*MATRIX_SIZE + i + 1;
            [_patternView addSubview:imageView];
        }
    }
    
    CGFloat screenHeight        = [[UIScreen mainScreen] bounds].size.height;
    CGRect initialBtnFrame      = [self.initialBtn frame];
    CGFloat initialBtnY         = patternViewFrame.origin.y + patternViewFrame.size.height + (screenHeight == 480 ? 0 : 45); // GAP
    initialBtnFrame.origin.y    = initialBtnY;
    [self.initialBtn setFrame:initialBtnFrame];
}


- (void)viewWillLayoutSubviews {
    
    int w = _patternView.frame.size.width/MATRIX_SIZE;
    int h = _patternView.frame.size.height/MATRIX_SIZE;
    
    int i=0;
    for (UIView *view in _patternView.subviews)
        if ([view isKindOfClass:[UIImageView class]]) {
            int x = w*(i/MATRIX_SIZE) + w/2;
            int y = h*(i%MATRIX_SIZE) + h/2;
            
            view.center = CGPointMake(x, y);
            i++;
        }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkSavedPassword];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_paths && [_paths count] > 0) {
        [self clearDotConnections];
    }
    
    _paths = [[NSMutableArray alloc] init];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint pt = [[touches anyObject] locationInView:_patternView];
    UIView *touched = [_patternView hitTest:pt withEvent:event];
    
    DrawPatternLockView *v = (DrawPatternLockView*)_patternView;
    if ([_paths count] > 0) {
        [v drawLineFromLastDotTo:pt];
    }
    
    if (touched!=_patternView && 1 <= touched.tag && touched.tag <= 9) {
        
        BOOL found = NO;
        for (NSNumber *tag in _paths) {
            found = tag.integerValue==touched.tag;
            if (found)
                break;
        }
        
        if (found) {
            return;
        }
        
        if ([_paths count] > 0) {
            int missedDot = [self findMissedDotBetweenFirstDot:[(NSNumber *)[_paths lastObject] intValue] lastDot:(int)touched.tag];
            [self forceTohighlightTheMissedDot:missedDot];
        }
        
        [_paths addObject:[NSNumber numberWithInteger:touched.tag]];
        [v addDotView:touched];
        
        UIImageView* iv = (UIImageView*)touched;
        iv.highlighted = YES;
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self validatePW:[self getKey]];
}

- (void)clearDotConnections {
    DrawPatternLockView *v = (DrawPatternLockView*)_patternView;
    [v clearDotViews];
    [v setIsIncorrectPattern:NO];
    [v setStrokeColor:STROKE_COLOR_BLUE];
    
    for (UIView *view in _patternView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [(UIImageView*)view setHighlighted:NO];
            [(UIImageView*)view setImage:[UIImage imageNamed:@"pattern_02_dft"]];
        }
    }
    
    [_patternView setNeedsDisplay];
}

- (void)drawIncorrectDotConnections {
    
    DrawPatternLockView *v = (DrawPatternLockView*)_patternView;
    [v setIsIncorrectPattern:YES];
    [v setStrokeColor:STROKE_COLOR_RED];
    
    for (UIView *view in _patternView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            if ([(UIImageView*)view isHighlighted]) {
                [(UIImageView*)view setHighlighted:NO];
                [(UIImageView*)view setImage:[UIImage imageNamed:@"pattern_03_sel"]];
            }
        }
    }
    [_patternView setNeedsDisplay];
}

- (void)redrawCorrectDotConnections {
    
    DrawPatternLockView *v = (DrawPatternLockView*)_patternView;
    [v setIsIncorrectPattern:YES];
    [v setStrokeColor:STROKE_COLOR_BLUE];
    [_patternView setNeedsDisplay];
}


// get key from the pattern drawn
// replace this method with your own key-generation algorithm
- (NSString*)getKey {
    
    if (!_paths || [_paths count] == 0) {
        return nil;
    }
    
    NSMutableString *key;
    key = [NSMutableString string];
    
    // simple way to generate a key
    for (NSNumber *tag in _paths) {
        [key appendFormat:@"%02d", [tag intValue]];
    }
    
    return key;
}

#pragma mark - Logic
- (void)checkSavedPassword {
    
    LoginUtil * util    = [[LoginUtil alloc] init];
    BOOL savedPw        = [util existPatternPassword];
    
    _setupStatus    = savedPw ? SETUP_UPDATE : SETUP_PW;
    [self refreshUI:_setupStatus];
}

- (void)validatePW:(NSString *)password {
    
    if (!password || [password isEqualToString:@""]) {
        return;
    }
    
    NSString * alertMessage     = nil;
    NSInteger tag               = ALERT_DO_NOTHING;
    
    if ([password length] < 8) {
        alertMessage = @"4개 이상의 점을 연결해 주세요.";
        
    } else if (_setupStatus == SETUP_UPDATE) {
        
        [self startIndicator];
        [self validateLoginPassword:password checkPasswordSEL:@selector(checkLoginPassword:)];
        
    } else if (_setupStatus == SETUP_PW) {
        
        if ([password isEqualToString:_savedPw]) {
            alertMessage = @"현재 패턴과 동일한 패턴 입니다.";
        } else {
            _pw = password;
        }
        
    } else if (_setupStatus == SETUP_PW_CONFIRM) {
        
        if (![password isEqualToString:_pw]) {
            alertMessage    = @"패턴이 일치하지 않습니다. 다시 한번 같은 패턴을 그려주세요.";
            _pwConfirm      = nil;
        } else {
            _pwConfirm      = password;
        }
    }
    
    if (alertMessage) {
        
        if (_setupStatus == SETUP_PW_CONFIRM) {
            _pwConfirm  = nil;
        } else if (_setupStatus == SETUP_PW) {
            _pw         = nil;
        }
        
        [self drawIncorrectDotConnections];
        [self showAlert:alertMessage tag:tag];
    } else {
        [self redrawCorrectDotConnections];
    }
}

- (void)checkLoginPassword:(NSDictionary *)response {
    
    NSLog(@"%s", __func__);
    
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        if (_setupStatus == SETUP_UPDATE) {
            _savedPw = [self getKey];
        }
        [self redrawCorrectDotConnections];
        
    } else {
        
        if (_setupStatus == SETUP_UPDATE) {
            _savedPw = nil;
        }
        
        if (_setupStatus == SETUP_PW_CONFIRM) {
            _pwConfirm  = nil;
        } else if (_setupStatus == SETUP_PW) {
            _pw         = nil;
        }
        
        [self drawIncorrectDotConnections];
        
        NSInteger tag = ALERT_DO_NOTHING;
        
        if([[response objectForKey:RESULT] isEqualToString:RESULT_PAT_EXCEED_5_TIMES]) {
            tag = ALERT_GOTO_SELF_IDENTIFY;
        }
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alertView.tag = tag;//test
        [alertView show];
    }
}

#pragma mark - UI
- (void)refreshUI:(SetupStatus)setupStatus {
    
    [self.initialBtn setHidden:YES];
    
    switch (setupStatus) {
        case SETUP_UPDATE:
            self.guide.text = @"기존에 설정하신 패턴을 그려주세요.";
            [self.nextBtn setTitle:@"계속" forState:UIControlStateNormal];
            [self.initialBtn setHidden:NO];
            break;
            
        case SETUP_PW:
            self.guide.text = @"4개 이상의 점을 연결하여 패턴을 그려주세요.";
            [self.nextBtn setTitle:@"계속" forState:UIControlStateNormal];
            break;
            
        case SETUP_PW_CONFIRM:
            self.guide.text = @"확인 위해 다시 패턴을 그려주세요.";
            [self.nextBtn setTitle:@"확인" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (int)findMissedDotBetweenFirstDot:(int)firstDot lastDot:(int)lastDot {
    
    NSArray * dots = @[
                       @[@1, @2, @3],
                       @[@4, @5, @6],
                       @[@7, @8, @9]
                       ];
    
    // find first dot position
    int firstDotRow = 0;
    int firstDotCol = 0;
    BOOL found = NO;
    NSArray * dotsOnRow;
    
    for (firstDotRow = 0; firstDotRow < [dots count]; firstDotRow++) {
        
        dotsOnRow = [dots objectAtIndex:firstDotRow];
        
        for (firstDotCol = 0; firstDotCol < [dotsOnRow count]; firstDotCol++) {
            
            int dot = [[dotsOnRow objectAtIndex:firstDotCol] intValue];
            
            if (dot == firstDot) {
                found = YES;
                break;
            }
        }
        if (found) {
            break;
        }
    }
    
    // check the dot on the same row
    if (firstDotCol != 1) {
        int sameRowDot = [[[dots objectAtIndex:firstDotRow] objectAtIndex:firstDotCol == 0 ? 2 : 0] intValue];
        if (sameRowDot == lastDot) {
            int sameRowMidDot = [[[dots objectAtIndex:firstDotRow] objectAtIndex:1] intValue];
            return sameRowMidDot;
        }
    }
    
    // check the dot across
    
    if (!(firstDotRow == 1 || firstDotCol == 1)) {
        
        int crossLineDot = [[[dots objectAtIndex:firstDotRow == 0 ? 2 : 0] objectAtIndex:firstDotCol == 0 ? 2 : 0] intValue];
        
        if (crossLineDot == lastDot) {
            
            int crossLineMidDot = [[[dots objectAtIndex:1] objectAtIndex:1] intValue];
            return crossLineMidDot;
        }
    }
    
    
    // check the dot on the same col
    if (firstDotRow != 1) {
        int sameColDot = [[[dots objectAtIndex:firstDotRow == 0 ? 2 : 0] objectAtIndex:firstDotCol] intValue];
        if (sameColDot == lastDot) {
            int sameColMidDot = [[[dots objectAtIndex:1] objectAtIndex:firstDotCol] intValue];
            return sameColMidDot;
        }
    }
    return 0;
}

- (void)forceTohighlightTheMissedDot:(int)dot {
    
    if (dot < 0 || dot > 9) {
        return;
    }
    
    for (UIView *view in _patternView.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]]) {
            
            if ((int)view.tag == dot) {
                [_paths addObject:[NSNumber numberWithInteger:dot]];
                [(UIImageView*)view setHighlighted:YES];
            }
        }
    }
}

#pragma mark - Action
- (IBAction)clickCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickNext {
    
    if (_setupStatus < SETUP_PW_CONFIRM) {
        
        BOOL clickNextWithoutEnteringPattern = (_setupStatus == SETUP_PW && _pw == nil) || (_setupStatus == SETUP_UPDATE && _savedPw == nil);
        
        if (clickNextWithoutEnteringPattern) {
            
            [self showAlert:@"4개 이상의 점을 연결하여 패턴을 그려주세요." tag:ALERT_DO_NOTHING];
            
        } else {
            
            [self clearDotConnections];
            [self refreshUI:++_setupStatus];
        }
        
    } else  if (_setupStatus == SETUP_PW_CONFIRM) {
        if (!_pwConfirm) {
            [self showAlert:@"패턴이 일치하지 않습니다. 다시 한번 같은 패턴을 그려주세요." tag:ALERT_DO_NOTHING];
        } else if ([_pw isEqualToString:_pwConfirm]) {
            
            [self startIndicator];
            [self resetPasswordOnServer:_pw];
            
            //[util savePatternPassword:_pw];
            //[self showAlert:@"패턴이 설정 되었습니다." tag:ALERT_SUCCEED_SAVE];
        }
    }
}

- (BOOL)resetPassword:(NSDictionary *)response {
    
    NSLog(@"%s", __func__);
    
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        LoginUtil * util = [[LoginUtil alloc] init];
		[util setPatternPasswordExist:YES];
		[util saveLoginMethod:LOGIN_BY_PATTERN];
		
        [self showAlert:@"패턴이 설정 되었습니다." tag:ALERT_SUCCEED_SAVE];
        return YES;
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
    
    return NO;
}



- (IBAction)clickToShowSelfIdentifier {
    [self clearDotConnections];
    [[[LoginUtil alloc] init] showSelfIdentifer:LOGIN_BY_PATTERN];
}

#pragma mark - Alert
- (void)showAlert:(NSString *)alertMessage tag:(NSInteger)tag {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                    delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_GOTO_SELF_IDENTIFY:
        {
            [self clickToShowSelfIdentifier];
            break;
        }
            break;
        case ALERT_SUCCEED_SAVE:
            [self clickCancel];
            break;
        default:
            [self clearDotConnections];
            break;
    }
}

@end
