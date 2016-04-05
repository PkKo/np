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
#import "Constants.h"
#import <IBNgmService/IBNgmService.h>

#define kOldDeviceToken @"OldDeviceToken"

@interface AppDelegate : UIResponder <UIApplicationDelegate, IBNgmServiceProtocol>

@property (nonatomic) BOOL isServiceDeactivated;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ECSlidingViewController *slidingViewController;
@property (strong, nonatomic) NSString *serverKey;
@property (assign, nonatomic) SIMPLE_VIEW_TYPE simpleViewType;

@property (strong, nonatomic) BannerInfo *bannerInfo;
@property (assign, nonatomic) NSInteger unreadCountBanking;
@property (assign, nonatomic) NSInteger unreadCountEtc;
@property (strong, nonatomic) UIImage *nongminBannerImg;
@property (strong, nonatomic) UIImage *noticeBannerImg;
@property (strong, nonatomic) NSMutableArray *tempAllAccountList;
@property (strong, nonatomic) NSData* currentDeviceToken;

- (void)timeoutError:(NSDictionary *)response;
- (void)restartApplication;
- (void)checkAppUpdate;

@end

