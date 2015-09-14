//
//  BTWDeviceInfoManager.h
//  BTW-SSLSign
//
//  Created by bluehoho on 13. 7. 11..
//  Copyright (c) 2013년 BTWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTWDeviceInfoManager : NSObject

@property (nonatomic, retain) NSString *serverUrl;

+ (id)sharedInstance;
+ (void)killInstance;

- (NSString *)getDeviceInfo;
- (void)resetDeviceInfo;

- (NSString *)getD1;
- (NSString *)getD2;

@end