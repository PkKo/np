//
//  CommonUtil.h
//  httpserver
//
//  Created by Infobank1 on 2015. 9. 7..
//  Copyright (c) 2015년 Infobank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

+ (NSString *)getAppVersion;
+ (NSString *)getOSVersion;
+ (NSString *)getMaskingNumber:(NSString *)number;
+ (NSString *)getDeviceUUID;
+ (NSString *)getBodyString:(NSDictionary *)bodyObject;
+ (CGSize)getStringFrameSize:(NSString *)string fontSize:(CGFloat)fontSize bold:(BOOL)isBold;
+ (void)runSpinAnimationWithDuration:(UIView *)view duration:(CGFloat)duration;
+ (void)stopSpinAnimation:(UIView *)view;
+ (NSString *)getURLEncodedString:(NSString *)unencodeString;
@end
