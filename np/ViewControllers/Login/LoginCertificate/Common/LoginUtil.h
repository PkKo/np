//
//  LoginUtil.h
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUtil : NSObject

- (void)showSecureKeypadInParent:(UIViewController *)viewController
                          topBar:(NSString *)topBar title:(NSString *)title
                      textLength:(NSInteger)length
                      doneAction:(SEL)doneAction cancelAction:(SEL)cancelAction;

- (void)showSecureNumpadInParent:(UIViewController *)viewController
                          topBar:(NSString *)topBar title:(NSString *)title
                      textLength:(NSInteger)length
                      doneAction:(SEL)doneAction cancelAction:(SEL)cancelAction;
@end
