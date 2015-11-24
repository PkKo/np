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
#import "SimplePwMgntChangeViewController.h"
#import "LoginCertController.h"
#import "LoginSettingsViewController.h"
#import "DrawPatternMgmtViewController.h"
#import "StatisticMainUtil.h"
#import "CertificateMenuViewController.h"
#import "MainPageViewController.h"
#import "LoginCertListViewController.h"
#import "LoginAccountVerificationViewController.h"
#import "DrawPatternLockViewController.h"
#import "LoginSimpleVerificationViewController.h"
#import "RegistAccountViewController.h"
#import "ServiceDeactivationController.h"
#import "DBManager.h"

@implementation LoginUtil

#pragma mark - Service Deactivation
- (BOOL)isServiceDeactivated {
    return [(AppDelegate *)[UIApplication sharedApplication].delegate isServiceDeactivated];
}

- (void)deactivateService:(BOOL)isDeactivated {
    [(AppDelegate *)[UIApplication sharedApplication].delegate setIsServiceDeactivated:isDeactivated];
}

- (void)removeAllData {
    // remove all objects
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
    [[DBManager sharedInstance] removeDB];
}

#pragma mark - App Version {
- (NSString *)getLatestAppVersion {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    NSString * latestVersion = [prefs stringForKey:PREF_KEY_LATEST_APP_VERSION];
    if (latestVersion == nil) {
        latestVersion = [CommonUtil getAppVersion];
    }
    
    return latestVersion;
}

- (void)saveLatestAppVersion:(NSString *)latestVersion {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:latestVersion forKey:PREF_KEY_LATEST_APP_VERSION];
    [prefs synchronize];
}

#pragma mark - Login Settings
- (BOOL)isLoggedIn {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs boolForKey:PREF_KEY_LOGIN_STATUS];
}

- (void)setLogInStatus:(BOOL)isLoggedIn {
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:isLoggedIn forKey:PREF_KEY_LOGIN_STATUS];
    [prefs synchronize];
}

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
        return LOGIN_BY_ACCOUNT;
    }
}

- (void)showMainPage {
    
    if ([self isServiceDeactivated]) {
        [[ServiceDeactivationController sharedInstance] deactivateService:IS_REGISTERED_YES];
        return;
    }
    
    [self setLogInStatus:YES];
    
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
    MainPageViewController *vc = [[MainPageViewController alloc] init];
    [vc setStartPageIndex:0];
    slidingViewController.topViewController = vc;
    
    UINavigationController * navController = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController;
    [navController setViewControllers:@[slidingViewController] animated:YES];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;
}

- (void)showLoginPage:(UINavigationController *)navController {
    
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
    UIViewController * vc = nil;
    
    LoginUtil * util = [[LoginUtil alloc] init];
    LoginMethod loginMethod = [util getLoginMethod];
    
    switch (loginMethod) {
        case LOGIN_BY_CERTIFICATE:
            vc = [[LoginCertListViewController alloc] initWithNibName:@"LoginCertListViewController" bundle:nil];
            break;
            
        case LOGIN_BY_ACCOUNT:
            vc = [[LoginAccountVerificationViewController alloc] initWithNibName:@"LoginAccountVerificationViewController" bundle:nil];
            break;
            
        case LOGIN_BY_PATTERN:
            vc = [[DrawPatternLockViewController alloc] initWithNibName:@"DrawPatternLockViewController" bundle:nil];
            break;
            
        case LOGIN_BY_SIMPLEPW:
            vc = [[LoginSimpleVerificationViewController alloc] initWithNibName:@"LoginSimpleVerificationViewController" bundle:nil];
            break;
            
        default:
            break;
    }
    
    slidingViewController.topViewController = vc;
    [navController setViewControllers:@[slidingViewController] animated:YES];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = slidingViewController;
}

- (void)showSelfIdentifer:(LoginMethod)loginMethod {
    
    UINavigationController * navController = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController;
    
    BOOL shouldAnimateSelfIdentifier = YES;
    
    // pin/pattern login view -> 본인인증
    // shows pat/pattern management page right after the self identification process is done.
    if (![self isLoggedIn]) {
        
        if (loginMethod == LOGIN_BY_SIMPLEPW || loginMethod == LOGIN_BY_PATTERN) {
            shouldAnimateSelfIdentifier = NO;
            
            NSArray             * viewControllers   = [navController viewControllers];
            UIViewController    * pinOrPatLoginView = nil;
            int             numberOfViewControllers = (int)[viewControllers count];
            
            if (numberOfViewControllers >= 1) {
                
                pinOrPatLoginView = [viewControllers objectAtIndex:(numberOfViewControllers - 1)];
                
                if (pinOrPatLoginView && [[(ECSlidingViewController *)pinOrPatLoginView topViewController] isKindOfClass:[DrawPatternLockViewController class]]) {
                    
                    [self gotoPatternLoginMgmt:navController animated:shouldAnimateSelfIdentifier];
                    
                } else if (pinOrPatLoginView && [[(ECSlidingViewController *)pinOrPatLoginView topViewController] isKindOfClass:[LoginSimpleVerificationViewController class]]) {
                    
                    [self gotoSimpleLoginMgmt:navController animated:shouldAnimateSelfIdentifier];
                }
            }
        }
    }
    
    // 본인 인증
    RegistAccountViewController *vc = [[RegistAccountViewController alloc] initWithNibName:@"SelfIdentifyViewController" bundle:nil];
    [vc setIsSelfIdentified:YES];
    [vc setLoginMethod:loginMethod];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
    
    [navController pushViewController:eVC animated:shouldAnimateSelfIdentifier];
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
    
    if (!certificateName) {
        return nil;
    }
    
    NSArray * certificates = [[[LoginCertController alloc] init] getCertList];
    
    if (!certificates || [certificates count] == 0) {
        return nil;
    }
    
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

- (NSInteger)getCertPasswordFailedTimes {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    return [[prefs objectForKey:PREF_KEY_CERT_LOGIN_SETT_FAILED_TIMES] integerValue];
}

- (void)saveCertPasswordFailedTimes:(NSInteger)failedTimes {
    
    NSUserDefaults * prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:[NSNumber numberWithInteger:failedTimes] forKey:PREF_KEY_CERT_LOGIN_SETT_FAILED_TIMES];
    [prefs synchronize];
}

#pragma mark - Account Login
- (NSArray *)getAllAccounts {
    
    return [[NSUserDefaults standardUserDefaults] arrayForKey:PREF_KEY_ALL_ACCOUNT];
}

- (void)saveAllAccounts:(NSArray *)allAccounts {
    
    [[NSUserDefaults standardUserDefaults] setObject:allAccounts forKey:PREF_KEY_ALL_ACCOUNT];
}

#pragma mark - Simple Login
- (void)gotoSimpleLoginMgmt:(UINavigationController *)navController animated:(BOOL)animated {
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:[[SimplePwMgntChangeViewController alloc] initWithNibName:@"SimplePwMgntChangeViewController" bundle:nil]];
    [navController pushViewController:eVC animated:animated];
}

- (NSString *)getSimplePassword {
    
    NSUserDefaults * prefs              = [NSUserDefaults standardUserDefaults];
    NSString * encryptedSimplePassword  = [prefs objectForKey:PREF_KEY_SIMPLE_LOGIN_SETT_PW];
    if (!encryptedSimplePassword) {
        return nil;
    }
    NSString * simplePassword           = [CommonUtil decrypt3DES:encryptedSimplePassword decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
    return simplePassword;
}

- (void)saveSimplePassword:(NSString *)simplePassword {
    
    NSUserDefaults *prefs               = [NSUserDefaults standardUserDefaults];
    NSString * encryptedSimplePassword  = [CommonUtil encrypt3DESWithKey:simplePassword key:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
    
    [prefs setObject:encryptedSimplePassword forKey:PREF_KEY_SIMPLE_LOGIN_SETT_PW];
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
- (void)gotoPatternLoginMgmt:(UINavigationController *)navController animated:(BOOL)animated {
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:[self getPatternLoginMgmt]];
    [navController pushViewController:eVC animated:animated];
}

- (UIViewController *)getPatternLoginMgmt {
    UIViewController * vc = [[DrawPatternMgmtViewController alloc] initWithNibName:@"DrawPatternMgmtViewController"
                                                                            bundle:nil];
    return vc;
}

- (NSString *)getPatternPassword {
    
    NSUserDefaults * prefs          = [NSUserDefaults standardUserDefaults];
    NSString * encryptedPassword    = [prefs objectForKey:PREF_KEY_PATTERN_LOGIN_SETT_PW];
    if (!encryptedPassword) {
        return nil;
    }
    NSString * password             = [CommonUtil decrypt3DES:encryptedPassword decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
    return password;
}

- (void)savePatternPassword:(NSString *)pw {
    
    NSUserDefaults *prefs           = [NSUserDefaults standardUserDefaults];
    NSString * encryptedPassword    = [CommonUtil encrypt3DESWithKey:pw key:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
    
    [prefs setObject:encryptedPassword forKey:PREF_KEY_PATTERN_LOGIN_SETT_PW];
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
    [prefs setValue:[NSNumber numberWithBool:isUsingSimpleView] forKey:QUICK_VIEW_SETTING];
}

- (BOOL)isUsingSimpleView {
    NSUserDefaults  * prefs = [NSUserDefaults standardUserDefaults];
    return [prefs boolForKey:QUICK_VIEW_SETTING];
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
        [vc setSupportRetinaHD:YES];
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
                      doneAction:(SEL)doneAction methodOnPress:(SEL)methodOnPress {
    
    [self showSecureNumpadInParent:viewController
                            topBar:topBar title:title textLength:length
                        doneAction:doneAction methodOnPress:methodOnPress
                        isFullMode:NO
               isAutoCloseKeyboard:YES];
}

- (void)showSecureNumpadInParent:(UIViewController *)viewController
                          topBar:(NSString *)topBar title:(NSString *)title
                      textLength:(NSInteger)length
                      doneAction:(SEL)doneAction methodOnPress:(SEL)methodOnPress isFullMode:(BOOL)isFullMode isAutoCloseKeyboard:(BOOL)isAutoCloseKeyboard {
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterNum" bundle:nil];
        //        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterSerialNum" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:@""];
        
        //콜백함수 설정
        [vc setCallbackMethod:viewController methodOnConfirm:doneAction methodOnPress:methodOnPress ];
        [vc setLengthWithTagName:@"PasswordInput" length:length webView:nil isAutoCloseKeyboard:isAutoCloseKeyboard];
        [vc setFullMode:isFullMode];
        [vc setToolBar:NO];
        [vc setSupportRetinaHD:YES];
        [vc setTopBarText:topBar];
        [vc setTitleText:title];
        [vc setRotateToInterfaceOrientation:viewController.interfaceOrientation parentView:viewController.view];
        [vc setBackgroundDimmedColor];
    }
    else
    {
        nFilterNumForPad *vc = [[nFilterNumForPad alloc] initWithNibName:@"nFilterNumForPad" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:@""];
        
        //콜백함수 설정
        [vc setCallbackMethod:viewController methodOnConfirm:doneAction methodOnPress:methodOnPress];
        [vc setLengthWithTagName:@"PasswordInput" length:length webView:nil];
        [vc setRotateToInterfaceOrientation:viewController.interfaceOrientation parentView:viewController.view];
    }
}

@end
