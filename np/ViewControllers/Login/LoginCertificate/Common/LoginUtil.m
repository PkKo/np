//
//  LoginUtil.m
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginUtil.h"
#import "NFilterChar.h"
#import "nFilterCharForPad.h"
#import "NFilterNum.h"
#import "nFilterNumForPad.h"
#import "SimplePwMgntNewViewController.h"
#import "SimplePwMgntChangeViewController.h"
#import "LoginCertController.h"
#import "LoginSettingsViewController.h"
#import "DrawPatternMgmtViewController.h"
#import "StatisticMainUtil.h"
#import "CertificateMenuViewController.h"

@implementation LoginUtil

#pragma mark - Login Settings
- (void)gotoLoginSettings:(UINavigationController *)navController {
    LoginSettingsViewController * loginSettings = [[LoginSettingsViewController alloc] initWithNibName:@"LoginSettingsViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:loginSettings];
    [navController pushViewController:eVC animated:YES];
}

- (void)saveLoginMethod:(LoginMethod)loginMethod {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithInt:loginMethod] forKey:PREF_KEY_LOGIN_METHOD];
    [prefs synchronize];
}

- (LoginMethod)getLoginMethod {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs objectForKey:PREF_KEY_LOGIN_METHOD]) {
        return (LoginMethod)[[prefs objectForKey:PREF_KEY_LOGIN_METHOD] intValue];
    } else {
        return LOGIN_BY_NONE;
    }
}

#pragma mark - Certificate Login
- (void)removeCertToLogin {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:PREF_KEY_CERT_TO_LOGIN];
    [prefs synchronize];
}

- (CertInfo *)getCertToLogin {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSString * certificateName = [prefs objectForKey:PREF_KEY_CERT_TO_LOGIN];
    
    NSArray * certificates = [[[LoginCertController alloc] init] getCertList];
    for (CertInfo * cert in certificates) {
        if ([cert.subjectDN2 isEqualToString:certificateName]) {
            return cert;
        }
    }
    return nil;
}

- (void)saveCertToLogin:(CertInfo *)cert {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:cert.subjectDN2 forKey:PREF_KEY_CERT_TO_LOGIN];
    [prefs synchronize];
}

- (void)gotoCertCentre:(UINavigationController *)navController {
    CertificateMenuViewController * certCentre = [[CertificateMenuViewController alloc] init];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:certCentre];
    [navController pushViewController:eVC animated:YES];
}

#pragma mark - Simple Login
- (void)gotoSimpleLoginMgmt:(UINavigationController *)navController {
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:[self getSimpleLoginMgmt]];
    [navController pushViewController:eVC animated:YES];
}

- (UIViewController *)getSimpleLoginMgmt {
    UIViewController * vc = [self getSimplePassword] ?
        [[SimplePwMgntChangeViewController alloc] initWithNibName:@"SimplePwMgntChangeViewController" bundle:nil] :
        [[SimplePwMgntNewViewController alloc] initWithNibName:@"SimplePwMgntNewViewController" bundle:nil];
    
    return vc;
}

- (NSString *)getSimplePassword {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:PREF_KEY_SIMPLE_LOGIN_SETT_PW];
}

- (void)saveSimplePassword:(NSString *)simplePassword {
    
    NSUserDefaults *prefs   = [NSUserDefaults standardUserDefaults];
    [prefs setObject:simplePassword forKey:PREF_KEY_SIMPLE_LOGIN_SETT_PW];
    [prefs setObject:[NSNumber numberWithInt:0] forKey:PREF_KEY_SIMPLE_LOGIN_SETT_FAILED_TIMES];
    [prefs synchronize];
}

- (void)removeSimplePassword {
    
    NSUserDefaults *prefs   = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:PREF_KEY_SIMPLE_LOGIN_SETT_PW];
    [prefs removeObjectForKey:PREF_KEY_SIMPLE_LOGIN_SETT_FAILED_TIMES];
    [prefs synchronize];
}

- (NSInteger)getSimplePasswordFailedTimes {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [[prefs objectForKey:PREF_KEY_SIMPLE_LOGIN_SETT_FAILED_TIMES] integerValue];
}

- (void)saveSimplePasswordFailedTimes:(NSInteger)failedTimes {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:[NSNumber numberWithInteger:failedTimes] forKey:PREF_KEY_SIMPLE_LOGIN_SETT_FAILED_TIMES];
    [prefs synchronize];
}

#pragma mark - Pattern Login
- (void)gotoPatternLoginMgmt:(UINavigationController *)navController {
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:[self getPatternLoginMgmt]];
    [navController pushViewController:eVC animated:YES];
}

- (UIViewController *)getPatternLoginMgmt {
    UIViewController * vc = [[DrawPatternMgmtViewController alloc] initWithNibName:@"DrawPatternMgmtViewController"
                                                                            bundle:nil];
    return vc;
}

- (NSString *)getPatternPassword {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:PREF_KEY_PATTERN_LOGIN_SETT_PW];
}

- (void)savePatternPassword:(NSString *)pw {
    
    NSUserDefaults *prefs   = [NSUserDefaults standardUserDefaults];
    [prefs setObject:pw forKey:PREF_KEY_PATTERN_LOGIN_SETT_PW];
    [prefs setObject:[NSNumber numberWithInt:0] forKey:PREF_KEY_PATTERN_LOGIN_SETT_FAILED_TIMES];
    [prefs synchronize];
}

- (void)removePatternPassword {
    
    NSUserDefaults *prefs   = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:PREF_KEY_PATTERN_LOGIN_SETT_PW];
    [prefs removeObjectForKey:PREF_KEY_PATTERN_LOGIN_SETT_FAILED_TIMES];
    [prefs synchronize];
}

- (NSInteger)getPatternPasswordFailedTimes {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [[prefs objectForKey:PREF_KEY_PATTERN_LOGIN_SETT_FAILED_TIMES] integerValue];
}

- (void)savePatternPasswordFailedTimes:(NSInteger)failedTimes {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:[NSNumber numberWithInteger:failedTimes] forKey:PREF_KEY_PATTERN_LOGIN_SETT_FAILED_TIMES];
    [prefs synchronize];
}

#pragma mark - Notice Background Colour
- (UIColor *)getNoticeBackgroundColour {
    
    NSUserDefaults  * prefs             = [NSUserDefaults standardUserDefaults];
    NSString        * colourAsHexString = [prefs stringForKey:PREF_KEY_NOTICE_BACKGROUND_COLOUR];
    
    if (!colourAsHexString) {
        UIColor * whiteColour = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        [self saveNoticeBackgroundColour:whiteColour];
        return whiteColour;
    } else {
        return [StatisticMainUtil colorFromHexString:colourAsHexString];
    }
}

- (void)saveNoticeBackgroundColour:(UIColor *)colour {
    NSUserDefaults  * prefs             = [NSUserDefaults standardUserDefaults];
    NSString        * colourAsHexString = [StatisticMainUtil hexStringFromColor:colour];
    [prefs setValue:colourAsHexString forKey:PREF_KEY_NOTICE_BACKGROUND_COLOUR];
}

#pragma mark - Using Simple View
- (void)saveUsingSimpleViewFlag:(BOOL)isUsingSimpleView {
    NSUserDefaults  * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:[NSNumber numberWithBool:isUsingSimpleView] forKey:PREF_KEY_USING_SIMPLE_VIEW];
}

- (BOOL)isUsingSimpleView {
    NSUserDefaults  * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs boolForKey:PREF_KEY_USING_SIMPLE_VIEW];
}

#pragma mark - Secure Keyboard
- (void)showSecureKeypadInParent:(UIViewController *)viewController
                          topBar:(NSString *)topBar title:(NSString *)title
                      textLength:(NSInteger)length
                      doneAction:(SEL)doneAction cancelAction:(SEL)cancelAction {
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        NFilterChar *vc = [[NFilterChar alloc] initWithNibName:@"NFilterChar" bundle:nil];
        //        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterSerialNum" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:@""];
        
        //콜백함수 설정
        [vc setCallbackMethod:viewController methodOnConfirm:doneAction methodOnCancel:cancelAction];
        [vc setLengthWithTagName:@"PasswordInput" length:length webView:nil];
        [vc setFullMode:YES];
        [vc setTopBarText:topBar];
        [vc setTitleText:title];
        [vc setRotateToInterfaceOrientation:viewController.interfaceOrientation parentView:viewController.view];
    }
    else
    {
        nFilterCharForPad *vc = [[nFilterCharForPad alloc] initWithNibName:@"nFilterCharForPad" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:@""];
        
        //콜백함수 설정
        [vc setCallbackMethod:viewController methodOnConfirm:doneAction methodOnCancel:cancelAction];
        [vc setLengthWithTagName:@"PasswordInput" length:length webView:nil];
        [vc setRotateToInterfaceOrientation:viewController.interfaceOrientation parentView:viewController.view];
    }
}

- (void)showSecureNumpadInParent:(UIViewController *)viewController
                          topBar:(NSString *)topBar title:(NSString *)title
                      textLength:(NSInteger)length
                      doneAction:(SEL)doneAction cancelAction:(SEL)cancelAction {
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterNum" bundle:nil];
        //        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterSerialNum" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:@""];
        
        //콜백함수 설정
        [vc setCallbackMethod:viewController methodOnConfirm:doneAction methodOnCancel:cancelAction];
        [vc setLengthWithTagName:@"PasswordInput" length:length webView:nil];
        [vc setFullMode:YES];
        [vc setTopBarText:topBar];
        [vc setTitleText:title];
        [vc setRotateToInterfaceOrientation:viewController.interfaceOrientation parentView:viewController.view];
    }
    else
    {
        nFilterNumForPad *vc = [[nFilterNumForPad alloc] initWithNibName:@"nFilterNumForPad" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:@""];
        
        //콜백함수 설정
        [vc setCallbackMethod:viewController methodOnConfirm:doneAction methodOnCancel:cancelAction];
        [vc setLengthWithTagName:@"PasswordInput" length:length webView:nil];
        [vc setRotateToInterfaceOrientation:viewController.interfaceOrientation parentView:viewController.view];
    }
}

@end
