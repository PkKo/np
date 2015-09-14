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

@property (strong, nonatomic) NavigationView *mNaviView;
@property (strong, nonatomic) UIButton *mMenuCloseButton;

- (void)makeNaviAndMenuView;
@end
