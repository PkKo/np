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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_backFromSelfIdentifer) {
        LoginUtil * util = [[LoginUtil alloc] init];
        NSString * patternPw = [util getPatternPassword];
        if (!patternPw) {
            [util gotoPatternLoginMgmt:self.navigationController];
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
    
    LoginUtil * util = [[LoginUtil alloc] init];
    
    NSString * alertMessage     = nil;
    NSInteger failedTimes       = [util getPatternPasswordFailedTimes];
    NSString * savedPassword    = [util getPatternPassword];
    NSInteger tag               = ALERT_DO_NOTHING;
    
    if (failedTimes >= 5) {
        
        alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 본인인증이 필요합니다. 본인인증 후 다시 이용해주세요.";
        tag             = ALERT_GOTO_SELF_IDENTIFY;
        
    } else {
        
        if ([password length] < 8) {
            alertMessage = @"4개 이상의 점을 연결해 주세요.";
            
        } else if (![password isEqualToString:savedPassword]) {
            
            failedTimes++;
            [util savePatternPasswordFailedTimes:failedTimes];
            if (failedTimes >= 5) {
                
                alertMessage    = @"비밀번호 오류가 5회 이상 발생하여 본인인증이 필요합니다. 본인인증 후 다시 이용해주세요.";
                tag             = ALERT_GOTO_SELF_IDENTIFY;
                
            } else {
                alertMessage = [NSString stringWithFormat:@"패턴이 일치하지 않습니다.\n%d 회 오류입니다. 5회 이상 오류 시 본인 인증이 필요합니다.", (int)failedTimes];
            }
        }
    }
    
    if (alertMessage) {
        [self showAlert:alertMessage tag:(int)tag];
    } else {
        [self startIndicator];
        [self validateLoginPattern];
        
    }
}

- (void)showMainView {
    
    [self stopIndicator];
    
    LoginUtil * util = [[LoginUtil alloc] init];
    [util savePatternPasswordFailedTimes:0];
    [util setLogInStatus:YES];
    [util showMainPage];
}

#pragma mark - Alert
- (void)showAlert:(NSString *)alertMessage tag:(int)tag {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:alertMessage
                                                    delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self clearDotConnections];
    
    switch (alertView.tag) {
        case ALERT_GOTO_SELF_IDENTIFY:
        {
            _backFromSelfIdentifer = YES;
            [[[LoginUtil alloc] init] showSelfIdentifer:LOGIN_BY_PATTERN];
            break;
        }
        default:
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

#pragma mark - Server Connection

- (void)validateLoginPattern {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    
    NSString * loginType        = @"PAT";
    NSString * user_id      = [prefs stringForKey:RESPONSE_CERT_UMS_USER_ID]; //@"150324104128890";
    NSString * crmMobile    = [prefs stringForKey:RESPONSE_CERT_CRM_MOBILE]; //@"01540051434";
    
    NSLog(@"user_id: %@", user_id);
    NSLog(@"crmMobile: %@", crmMobile);
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_LOGIN_PINPAT];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setObject:user_id forKey:@"user_id"];
    [requestBody setObject:crmMobile forKey:@"crmMobile"];
    [requestBody setObject:loginType forKey:@"loginType"];
    
    NSString *bodyString = [CommonUtil getBodyString:requestBody];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(loginPatternResponse:)];
    [req requestUrl:url bodyString:bodyString];
    
}

- (void)loginPatternResponse:(NSDictionary *)response {
    
    NSLog(@"response: %@", response);
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        NSDictionary * list     = (NSDictionary *)(response[@"list"]);
        NSArray * accounts      = (NSArray *)(list[@"sub"]);
        int numberOfAccounts    = (int)[accounts count];
        
        NSLog(@"accounts: %@", accounts);
        
        if (numberOfAccounts > 0) {
            
            NSMutableArray * accountNumbers = [NSMutableArray arrayWithCapacity:numberOfAccounts];
            for (NSDictionary * account in accounts) {
                [accountNumbers addObject:(NSString *)account[@"UMSD060101_OUT_SUB.account_number"]];
            }
            
            if ([accountNumbers count] > 0) {
                [[[LoginUtil alloc] init] saveAllAccounts:[accountNumbers copy]];
            }
        }
        
        [self showMainView];
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Footer
- (IBAction)gotoNotice {
    [[CustomerCenterUtil sharedInstance] gotoNotice];
}
- (IBAction)gotoFAQ {
    [[CustomerCenterUtil sharedInstance] gotoFAQ];
}

- (IBAction)gotoTelEnquiry {
    [[CustomerCenterUtil sharedInstance] gotoTelEnquiry];
}

@end
