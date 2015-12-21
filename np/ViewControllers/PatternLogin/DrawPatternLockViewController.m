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
#import "CustomerCenterUtil.h"
#import "BTWCodeguard.h"
#import "ServiceDeactivationController.h"

#define MATRIX_SIZE 3

@interface DrawPatternLockViewController() {
    BOOL _backFromSelfIdentifer;
}
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
    
    self.loginMethod                = LOGIN_BY_PATTERN;
    
    _backFromSelfIdentifer          = NO;
    
    CGFloat screenWidth             = [[UIScreen mainScreen] bounds].size.width;
    CGRect patternViewFrame         = _patternView.frame;
    patternViewFrame.size.width     = (screenWidth - patternViewFrame.origin.x * 2);
    patternViewFrame.size.height    = patternViewFrame.size.width;
    [_patternView setFrame:patternViewFrame];
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
    
    CGFloat spaceBtwPatternAndFooter    = self.footer.frame.origin.y - (_patternView.frame.origin.y + _patternView.frame.size.height);
    CGRect setttingsViewFrame           = self.settingsView.frame;
    setttingsViewFrame.origin.y         = _patternView.frame.origin.y + _patternView.frame.size.height + (spaceBtwPatternAndFooter - setttingsViewFrame.size.height)/2;
    [self.settingsView setFrame:setttingsViewFrame];
    
    int i=0;
    for (UIView *view in _patternView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            int x = w*(i/MATRIX_SIZE) + w/2;
            int y = h*(i%MATRIX_SIZE) + h/2;
            
            view.center = CGPointMake(x, y);
            i++;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_backFromSelfIdentifer) {
        LoginUtil * util = [[LoginUtil alloc] init];
        //NSString * patternPw = [util getPatternPassword];
        if (![util existPatternPassword]) {
            [util gotoPatternLoginMgmt:self.navigationController animated:YES];
        }
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

- (BOOL)hasLoadingPage {
    return (![loadingIndicatorBg isHidden]);
}

#pragma mark - Touches
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self hasLoadingPage]) {
        return;
    }
    
    _paths = [[NSMutableArray alloc] init];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self hasLoadingPage]) {
        return;
    }
    
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
    
    if ([self hasLoadingPage]) {
        return;
    }
    
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

#pragma mark - Refresh UI
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


#pragma mark - Logic
- (void)validatePW:(NSString *)password {
    
    if (!password || [password isEqualToString:@""]) {
        return;
    }
    
    [self redrawCorrectDotConnections];
    [self startIndicator];
    [self validateLoginPasswordAndGetAccountList:[self getKey]];
}

#pragma mark - Alert

- (void)showAlert:(NSString *)alertMessage tag:(int)tag {
    
    NSLog(@"NHI ----- > %s", __func__);
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                    delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"%s", __func__);
    
    switch (alertView.tag) {
        case ALERT_GOTO_SELF_IDENTIFY:
        {
            [self gotoPatternLoginMgmt];
            break;
        }
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
    [self clearDotConnections];
    _backFromSelfIdentifer = YES;
    [[[LoginUtil alloc] init] showSelfIdentifer:LOGIN_BY_PATTERN];
}

-(IBAction)gotoLoginSettings {
    [[[LoginUtil alloc] init] gotoLoginSettings:self.navigationController];
}

@end
