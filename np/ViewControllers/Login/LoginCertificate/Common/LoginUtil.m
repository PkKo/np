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

@implementation LoginUtil

#pragma mark - Login Settings 
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

#pragma mark - Simple Login
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
