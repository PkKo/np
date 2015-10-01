//
//  CommonUtil.h
//  httpserver
//
//  Created by Infobank1 on 2015. 9. 7..
//  Copyright (c) 2015년 Infobank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

+ (NSString *)getMaskingNumber:(NSString *)number;
+ (NSString *)getDeviceUUID;
+ (NSString *)getBodyString:(NSDictionary *)bodyObject;
+ (CGSize)getStringFrameSize:(NSString *)string fontSize:(CGFloat)fontSize bold:(BOOL)isBold;
@end
