//
//  LoginAccountController.h
//  np
//
//  Created by Infobank2 on 10/27/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginAccountController : NSObject

- (void)validateLoginAccount:(NSString *)accountNo password:(NSString *)pw birthday:(NSString *)birthday ofViewController:(UIViewController *)viewController action:(SEL)action;

@end
