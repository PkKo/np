//
//  DrawPatternLockViewController.m
//  np
//
//  Created by Infobank2 on 9/21/15.
//  Copyright (c) 2015 Infobank1. All rights reserved.
//

#import "DrawPatternLockViewController.h"
#import "DrawPatternLockView.h"
#import "LoginUtil.h"


#define MATRIX_SIZE 3

@interface DrawPatternLockViewController()
@end

@implementation DrawPatternLockViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@""];
    
    [_patternView setStrokeColor:[UIColor colorWithWhite:1 alpha:0.5]];
    
    for (int i=0; i<MATRIX_SIZE; i++) {
        for (int j=0; j<MATRIX_SIZE; j++) {
            UIImage *dotImage = [UIImage imageNamed:@"pattern_01_dft"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:dotImage
                                                       highlightedImage:[UIImage imageNamed:@"pattern_01_01_sel"]];
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

#pragma mark - Touches
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
        
        if (found)
            return;
        
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
    [v setIsIncorrectPattern:NO];
    [v clearDotViews];
    
    for (UIView *view in _patternView.subviews)
        if ([view isKindOfClass:[UIImageView class]])
            [(UIImageView*)view setHighlighted:NO];
    
    [_patternView setNeedsDisplay];
}

- (void)redrawCorrectDotConnections {
    DrawPatternLockView *v = (DrawPatternLockView*)_patternView;
    [v setIsIncorrectPattern:YES];
    [_patternView setNeedsDisplay];
}

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
- (void)validatePW:(NSString *)password {
    
    NSLog(@"%s, password: %@", __func__, password);
    
    if (!password || [password isEqualToString:@""]) {
        return;
    }
    
    [self redrawCorrectDotConnections];
    
    LoginUtil * util = [[LoginUtil alloc] init];
    
    NSString * alertMessage     = nil;
    NSInteger failedTimes       = [util getPatternPasswordFailedTimes];
    NSString * savedPassword    = [util getPatternPassword];
    NSInteger tag               = ALERT_DO_NOTHING;
    
    if ([password length] < 8) {
        alertMessage = @"4개 이상의 점을 연결해 주세요.";
        
    } else if (![password isEqualToString:savedPassword]) {
        
        
        failedTimes++;
        if (failedTimes >= 5) {
            
            alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 본인인증이 필요합니다. 본인인증 후 다시 이용해주세요.";
            tag             = ALERT_GOTO_SELF_IDENTIFY;
            [util removePatternPassword];
            
        } else {
            alertMessage = [NSString stringWithFormat:@"패턴이 일치하지 않습니다.\n%d 회 오류입니다. 5회 이상 오류 시 본인 인증이 필요합니다.", (int)failedTimes];
            [util savePatternPasswordFailedTimes:failedTimes];
        }
    }
    
    if (alertMessage) {
        [self showAlert:alertMessage tag:tag];
    } else {
        [util savePatternPasswordFailedTimes:0];
        [self closeView];
    }
}

#pragma mark - Alert
- (void)showAlert:(NSString *)alertMessage tag:(int)tag {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                    delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_GOTO_SELF_IDENTIFY:
            NSLog(@"본인인증으로 이동");
            [self closeView];
            break;
        default:
            [self clearDotConnections];
            break;
    }
}

- (void)closeView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Settings
- (IBAction)gotoPatternLoginMgmt {
    [[[LoginUtil alloc] init] gotoPatternLoginMgmt:self.navigationController];
}

-(IBAction)gotoLoginSettings {
    [[[LoginUtil alloc] init] gotoLoginSettings:self.navigationController];
}

@end
