//
//  VersionInfoViewController.m
//  np
//
//  Created by Infobank2 on 10/21/15.eww
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "VersionInfoViewController.h"

@interface VersionInfoViewController () {
    NSString * _currentVersion;
    NSString * _latestVersion;
}

@end

@implementation VersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"버전정보"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BOOL isReady = NO;
    
    if (!isReady) {
        [self.checkAppVersionBtn setEnabled:NO];
        _currentVersion = @"1.02";
        _latestVersion = _currentVersion;
        [self.currentVersionNo setText:[NSString stringWithFormat:@"현재 버전 %@", _currentVersion]];
        [self.latestVersionNo setText:[NSString stringWithFormat:@"최신 버전 %@", _latestVersion]];
        
    } else {
        [self refreshVersionInfo];
        [self getAppVersionFromAppStore];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Version Check
- (void)refreshVersionInfo {
    
    NSString * updateVersionBtnTitle    = @"현재 최신 버전입니다.";
    BOOL       shouldUpdate             = NO;
    UIColor  * bgColour                 = [UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1];
    
    _currentVersion                     = [CommonUtil getAppVersion];
    _latestVersion                      = [[[LoginUtil alloc] init] getLatestAppVersion];
    
    [self.currentVersionNo setText:[NSString stringWithFormat:@"현재 버전 %@", _currentVersion]];
    [self.latestVersionNo setText:[NSString stringWithFormat:@"최신 버전 %@", _latestVersion]];
    
    NSComparisonResult compareResult = [_currentVersion compare:_latestVersion];
    if (compareResult == NSOrderedAscending) {
        updateVersionBtnTitle   = @"최신 버전으로 업데이트 하시겠습니까?";
        shouldUpdate            = YES;
        bgColour                = [UIColor colorWithRed:62.0f/255.0f green:155.0f/255.0f blue:251.0f/255.0f alpha:1];
    }
    
    [self.checkAppVersionBtn setTitle:updateVersionBtnTitle forState:UIControlStateNormal];
    [self.checkAppVersionBtn setEnabled:shouldUpdate];
    [self.checkAppVersionBtn setBackgroundColor:bgColour];
}

- (IBAction)checkAppVersion:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_APP_URL]];
}

- (void)getAppVersionFromAppStore {
    
    [self startIndicator];
    
    NSURL           * url       = [NSURL URLWithString:APP_STORE_APP_VERSION_CHECK_URL];
    NSURLRequest    * request   = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (!connectionError) {
            
            NSError         * parseError;
            NSDictionary    * appMetadataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
            NSArray         * resultsArray          = appMetadataDictionary ? [appMetadataDictionary objectForKey:@"results"] : nil;
            NSDictionary    * resultsDic            = [resultsArray firstObject];
            
            if (resultsDic) {
                NSString * latestVersionInAppStore = [resultsDic objectForKey:@"version"];
                
                LoginUtil * util = [[LoginUtil alloc] init];
                
                NSComparisonResult compareResult = [_latestVersion compare:latestVersionInAppStore];
                if (compareResult == NSOrderedAscending) {
                    [util saveLatestAppVersion:latestVersionInAppStore];
                    [self refreshVersionInfo];
                }
            }
            
        } else {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"알림" message:connectionError.description delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
        }
        
        [self stopIndicator];
        
    }];
}

@end
