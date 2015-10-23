//
//  CommonUtil.h
//  httpserver
//
//  Created by Infobank1 on 2015. 9. 7..
//  Copyright (c) 2015년 Infobank. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum StickerType
{
    STICKER_DEPOSIT_NORMAL      = 1,
    STICKER_DEPOSIT_SALARY      = 100,
    STICKER_DEPOSIT_POCKET,
    STICKER_DEPOSIT_ETC,
    
    STICKER_WITHDRAW_NORMAL     = 2,
    STICKER_WITHDRAW_FOOD       = 200,
    STICKER_WITHDRAW_TELEPHONE,
    STICKER_WITHDRAW_HOUSING,
    STICKER_WITHDRAW_SHOPPING,
    STICKER_WITHDRAW_CULTURE,
    STICKER_WITHDRAW_EDUCATION,
    STICKER_WITHDRAW_CREDIT,
    STICKER_WITHDRAW_SAVING,
    STICKER_WITHDRAW_ETC
} StickerType;

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
+ (UIImage *)getStickerImage:(StickerType)stickerType;
+ (NSString *)getTodayDateString;
+ (NSString *)getDateString:(NSDate *)date;
+ (NSString *)getDayString:(NSDate *)date;
+ (NSString *)getTimeString:(NSDate *)date;
@end
