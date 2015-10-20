//
//  LoginUtil.h
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantMaster.h"
#import "CertInfo.h"

@interface LoginUtil : NSObject

#pragma mark - Login Settings
- (void)gotoLoginSettings:(UINavigationController *)navController;
- (void)saveLoginMethod:(LoginMethod)loginMethod;
- (LoginMethod)getLoginMethod;

#pragma mark - Certificate Login
- (void)removeCertToLogin;
- (CertInfo *)getCertToLogin;
- (void)saveCertToLogin:(CertInfo *)cert;

#pragma mark - Simple Login
- (void)gotoSimpleLoginMgmt:(UINavigationController *)navController;
- (UIViewController *)getSimpleLoginMgmt;
- (NSString *)getSimplePassword;
- (void)saveSimplePassword:(NSString *)simplePassword;
- (void)removeSimplePassword;
- (NSInteger)getSimplePasswordFailedTimes;
- (void)saveSimplePasswordFailedTimes:(NSInteger)failedTimes;

#pragma mark - Pattern Login
- (NSString *)getPatternLoginPassword;
- (void)savePatternLoginPassword:(NSString *)pw;

#pragma mark - Secure Keyboard
- (void)showSecureKeypadInParent:(UIViewController *)viewController
                          topBar:(NSString *)topBar title:(NSString *)title
                      textLength:(NSInteger)length
                      doneAction:(SEL)doneAction cancelAction:(SEL)cancelAction;

- (void)showSecureNumpadInParent:(UIViewController *)viewController
                          topBar:(NSString *)topBar title:(NSString *)title
                      textLength:(NSInteger)length
                      doneAction:(SEL)doneAction cancelAction:(SEL)cancelAction;
@end
