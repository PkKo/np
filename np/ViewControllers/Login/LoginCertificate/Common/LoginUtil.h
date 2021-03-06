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

#pragma mark - Service Deactivation
- (BOOL)isServiceDeactivated;
- (void)deactivateService:(BOOL)isDeactivated;
- (void)removeAllData;

#pragma mark - App Version {
+ (NSString *)getDecryptedCrmMobile;
- (NSString *)getLatestAppVersion;
- (void)saveLatestAppVersion:(NSString *)latestVersion;

#pragma mark - Login Settings
- (BOOL)isLoggedIn;
- (void)setLogInStatus:(BOOL)isLoggedIn;
- (void)gotoLoginSettings:(UINavigationController *)navController;
- (void)saveLoginMethod:(LoginMethod)loginMethod;
- (LoginMethod)getLoginMethod;
- (NSString *)getEncryptedPassword:(NSString *)pw;
- (void)showMainPage;
- (void)showLoginPage:(UINavigationController *)navController;
- (void)showSelfIdentifer:(LoginMethod)loginMethod;
- (void)showSelfIdentifer:(LoginMethod)loginMethod accountNumber:(NSString *)accountNumber;

#pragma mark - Certificate Login
- (void)removeCertToLogin;
- (CertInfo *)getCertToLogin;
- (void)saveCertToLogin:(CertInfo *)cert;
- (void)gotoCertCentre:(UINavigationController *)navController;
- (NSInteger)getCertPasswordFailedTimes;
- (void)saveCertPasswordFailedTimes:(NSInteger)failedTimes;

#pragma mark - Accounts
- (void)saveAllAccountsAndAllTransAccounts:(NSDictionary *)response;
- (NSArray *)getAllAccounts;
- (void)saveAllAccounts:(NSArray *)allAccounts;
- (NSArray *)getAllTransAccounts;
- (void)saveAllTransAccounts:(NSArray *)allAccounts;

#pragma mark - Simple Login
- (void)gotoSimpleLoginMgmt:(UINavigationController *)navController animated:(BOOL)animated;


/*
 - (NSString *)getSimplePassword;
 - (void)saveSimplePassword:(NSString *)simplePassword;
 - (void)removeSimplePassword;
 - (NSInteger)getSimplePasswordFailedTimes;
 - (void)saveSimplePasswordFailedTimes:(NSInteger)failedTimes;
 */





- (void)setSimplePasswordExist:(BOOL)isExisted;
- (BOOL)existSimplePassword;

#pragma mark - Pattern Login
- (void)gotoPatternLoginMgmt:(UINavigationController *)navController animated:(BOOL)animated;
- (UIViewController *)getPatternLoginMgmt;

/*
 - (NSString *)getPatternPassword;
 - (void)savePatternPassword:(NSString *)pw;
 - (void)removePatternPassword;
 - (NSInteger)getPatternPasswordFailedTimes;
 - (void)savePatternPasswordFailedTimes:(NSInteger)failedTimes;
 */








- (void)setPatternPasswordExist:(BOOL)isExisted;
- (BOOL)existPatternPassword;

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

- (void)showSecureNumpadInParent:(UIViewController *)viewController
                          topBar:(NSString *)topBar title:(NSString *)title
                      textLength:(NSInteger)length
                      doneAction:(SEL)doneAction methodOnPress:(SEL)methodOnPress
                      isFullMode:(BOOL)isFullMode
             isAutoCloseKeyboard:(BOOL)isAutoCloseKeyboard;
@end
