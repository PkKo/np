//
//  AppDelegate.h
//  np
//
//  Created by Infobank1 on 2015. 9. 9..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "BannerInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ECSlidingViewController *slidingViewController;
@property (strong, nonatomic) NSString *serverKey;
@property (strong, nonatomic) BannerInfo *bannerInfo;
@end

