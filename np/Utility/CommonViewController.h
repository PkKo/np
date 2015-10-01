//
//  CommonViewController.h
//  mp
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "NavigationView.h"
#import "MenuViewController.h"

@interface CommonViewController :UIViewController
{
    UIView *loadingIndicatorBg;
    UIImageView *loadingIndicatorImg;
}

@property (strong, nonatomic) NavigationView *mNaviView;
@property (strong, nonatomic) UIButton *mMenuCloseButton;
@property (strong, nonatomic) UIButton *keyboardCloseButton;
@property (strong, nonatomic) UITextField *currentTextField;

- (void)makeNaviAndMenuView;
- (void)closeMenuView;
- (void)keyboardClose;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)startIndicator;
- (void)stopIndicator;
@end
