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

@implementation LoginUtil

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
