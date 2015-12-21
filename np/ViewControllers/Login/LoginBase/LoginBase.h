//
//  LoginBase.h
//  np
//
//  Created by Infobank2 on 11/24/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface LoginBase : CommonViewController

@property (nonatomic, assign) LoginMethod loginMethod;

#pragma mark - CERT, ACCOUNT, PIN, PAT Login
- (void)loginResponse:(NSDictionary *)response;

#pragma mark - PIN/PAT Server Connection
#pragma mark - Password Reset
- (void)resetPasswordOnServer:(NSString *)pw;

#pragma mark - Password Validation & Account List
- (void)validateLoginPassword:(NSString *)pw checkPasswordSEL:(SEL)checkPasswordSEL;
- (void)validateLoginPasswordAndGetAccountList:(NSString *)pw;

- (void)showAlert:(NSString *)alertMessage tag:(int)tag;

#pragma mark - Footer
- (IBAction)gotoNotice;
- (IBAction)gotoFAQ;
- (IBAction)gotoTelEnquiry;

@end
