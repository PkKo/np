//
//  VersionInfoViewController.m
//  np
//
//  Created by Infobank2 on 10/21/15.
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
    [self refreshVersionInfo];
    [self getAppVersionFromAppStore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Version Check
- (void)refreshVersionInfo {
    
    NSString * updateVersionBtnTitle    = @"현재 최신 버전입니다.";
    BOOL       shouldUpdate             = NO;
    
    _currentVersion                     = [CommonUtil getAppVersion];
    _latestVersion                      = [[[LoginUtil alloc] init] getLatestAppVersion];
    
    [self.currentVersionNo setText:[NSString stringWithFormat:@"현재 버전 %@", _currentVersion]];
    [self.latestVersionNo setText:[NSString stringWithFormat:@"최신 버전 %@", _latestVersion]];
    
    NSComparisonResult compareResult = [_currentVersion compare:_latestVersion];
    if (compareResult == NSOrderedAscending) {
        updateVersionBtnTitle   = @"최신 버전으로 업데이트 하시겠습니까?";
        shouldUpdate            = YES;
    }
    
    [self.checkAppVersionBtn setTitle:updateVersionBtnTitle forState:UIControlStateNormal];
    [self.checkAppVersionBtn setEnabled:shouldUpdate];
}

- (IBAction)checkAppVersion:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/seumateunhnonghyeobkadeu/id406473666?l=en&mt=8"]];
}

- (void)getAppVersionFromAppStore {
    
    [self startIndicator];
    
    NSURL           * url       = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=406473666"];
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
