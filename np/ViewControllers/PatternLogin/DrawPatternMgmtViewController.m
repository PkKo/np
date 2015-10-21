//
//  DrawPatternMgmtViewController.m
//  np
//
//  Created by Infobank2 on 10/20/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "DrawPatternMgmtViewController.h"
#import "LoginUtil.h"

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
    NSString  * _pw;
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
    
    [self checkSavedPassword];
    
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
    _paths = [[NSMutableArray alloc] init];
    
    //[self clearDotConnections];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint pt = [[touches anyObject] locationInView:_patternView];
    UIView *touched = [_patternView hitTest:pt withEvent:event];
    
    DrawPatternLockView *v = (DrawPatternLockView*)_patternView;
    [v drawLineFromLastDotTo:pt];
    
    NSLog(@"touched: %d", touched.tag);
    
    if (touched!=_patternView && 1 <= touched.tag && touched.tag <= 9) {
        
        BOOL found = NO;
        for (NSNumber *tag in _paths) {
            found = tag.integerValue==touched.tag;
            if (found)
                break;
        }
        
        if (found) {
            NSLog(@"found touched.tag:%d", touched.tag);
            return;
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
    NSMutableString *key;
    key = [NSMutableString string];
    
    // simple way to generate a key
    for (NSNumber *tag in _paths) {
        [key appendFormat:@"%02d", [tag intValue]];
    }
    
    return key;
}

- (void)setTarget:(id)target withAction:(SEL)action {
    _target = target;
    _action = action;
}

#pragma mark - Logic
- (void)checkSavedPassword {
    
    LoginUtil * util = [[LoginUtil alloc] init];
    NSString * savedPw = [util getPatternPassword];
    
    if (savedPw) {
        _pw             = savedPw;
        _setupStatus    = SETUP_UPDATE;
    } else {
        _pw             = nil;
        _setupStatus    = SETUP_PW;
    }
    
    [self refreshUI:_setupStatus];
}

- (void)validatePW:(NSString *)password {
    
    LoginUtil * util = [[LoginUtil alloc] init];
    
    NSString * alertMessage     = nil;
    NSInteger failedTimes       = [util getPatternPasswordFailedTimes];
    NSString * savedPassword    = [util getPatternPassword];
    NSInteger tag               = ALERT_DO_NOTHING;
    
    if ([password length] < 8) {
        alertMessage = @"4개 이상의 점을 연결해 주세요.";
        
    } else if (_setupStatus == SETUP_UPDATE && ![password isEqualToString:savedPassword]) {
        
        
        failedTimes++;
        if (failedTimes >= 5) {
            
            alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 본인인증이 필요합니다. 본인인증 후 다시 이용해주세요.";
            tag             = ALERT_GOTO_SELF_IDENTIFY;
            [util removePatternPassword];
            
        } else {
            alertMessage = [NSString stringWithFormat:@"패턴이 일치하지 않습니다.\n%d 회 오류입니다. 5회 이상 오류 시 본인 인증이 필요합니다.", (int)failedTimes];
            [util savePatternPasswordFailedTimes:failedTimes];
        }
        
    } else if (_setupStatus == SETUP_PW) {
        
        _pw = password;
        
    } else if (_setupStatus == SETUP_PW_CONFIRM && ![password isEqualToString:_pw]) {
        
        alertMessage = @"패턴이 일치하지 않습니다. 다시 한번 같은 패턴을 그려주세요.";
        
    }
    
    if (alertMessage) {
        //[self drawIncorrectDotConnections];
        [self showAlert:alertMessage tag:tag];
    } else {
        //[self redrawCorrectDotConnections];
    }
}

- (void)refreshUI:(SetupStatus)setupStatus {
    
    switch (setupStatus) {
        case SETUP_UPDATE:
            self.guide.text = @"기존에 설정하신 패턴을 그려주세요.";
            [self.nextBtn setTitle:@"계속" forState:UIControlStateNormal];
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

- (IBAction)clickCancel {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)clickNext {
    
    LoginUtil * util = [[LoginUtil alloc] init];
    
    if (_setupStatus < SETUP_PW_CONFIRM) {
        
        if (_setupStatus == SETUP_UPDATE) { // reset pw failed times
            [util savePatternPasswordFailedTimes:0];
        }
        
        [self clearDotConnections];
        [self refreshUI:++_setupStatus];
        
    } else  if (_setupStatus == SETUP_PW_CONFIRM) {
        
        [util savePatternPassword:_pw];
        [self showAlert:@"패턴이 설정 되었습니다." tag:ALERT_SUCCEED_SAVE];
    }
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
            NSLog(@"본인인증으로 이동");
            [self clickCancel];
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
