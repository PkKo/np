//
//  LoginUtil.h
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CertInfo.h"

@interface LoginUtil : NSObject

#pragma mark - Login Settings
- (BOOL)isLoggedIn;
- (void)setLogInStatus:(BOOL)isLoggedIn;
- (void)gotoLoginSettings:(UINavigationController *)navController;
- (void)saveLoginMethod:(LoginMethod)loginMethod;
- (LoginMethod)getLoginMethod;
- (void)showMainPage;
- (void)showLoginPage:(UINavigationController *)navController;
- (void)showSelfIdentifer:(LoginMethod)loginMethod;

#pragma mark - Certificate Login
- (void)removeCertToLogin;
- (CertInfo *)getCertToLogin;
- (void)saveCertToLogin:(CertInfo *)cert;
- (void)gotoCertCentre:(UINavigationController *)navController;
- (NSInteger)getCertPasswordFailedTimes;
- (void)saveCertPasswordFailedTimes:(NSInteger)failedTimes;

#pragma mark - Account Login
- (NSInteger)getAccountPasswordFailedTimes;
- (void)saveAccountPasswordFailedTimes:(NSInteger)failedTimes;
- (NSArray *)getAllAccounts;
- (void)saveAllAccounts:(NSArray *)allAccounts;

#pragma mark - Simple Login
- (void)gotoSimpleLoginMgmt:(UINavigationController *)navController;
- (NSString *)getSimplePassword;
- (void)saveSimplePassword:(NSString *)simplePassword;
- (void)removeSimplePassword;
- (NSInteger)getSimplePasswordFailedTimes;
- (void)saveSimplePasswordFailedTimes:(NSInteger)failedTimes;

#pragma mark - Pattern Login
- (void)gotoPatternLoginMgmt:(UINavigationController *)navController;
- (UIViewController *)getPatternLoginMgmt;
- (NSString *)getPatternPassword;
- (void)savePatternPassword:(NSString *)pw;
- (void)removePatternPassword;
- (NSInteger)getPatternPasswordFailedTimes;
- (void)savePatternPasswordFailedTimes:(NSInteger)failedTimes;

#pragma mark - Notice Background Colour
- (UIColor *)getNoticeBackgroundColour;
- (void)saveNoticeBackgroundColour:(UIColor *)colour;

#pragma mark - Using Simple View
- (void)saveUsingSimpleViewFlag:(BOOL)isUsingSimpleView;
- (BOOL)isUsingSimpleView;

#pragma mark - Secure Keyboard
- (void)showSecureKeypadInParent:(UIViewController *)viewController
                          topBar:(NSString *)topBar title:(NSString *)title
                      textLength:(NSInteger)length
                      doneAction:(SEL)doneAction cancelAction:(SEL)cancelAction;

- (void)showSecureNumpadInParent:(UIViewController *)viewController
                          topBar:(NSString *)topBar title:(NSString *)title
                      textLength:(NSInteger)length
                      doneAction:(SEL)doneAction methodOnPress:(SEL)methodOnPress;
@end
