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
    STICKER_DEPOSIT_NORMAL      = 0,
    STICKER_DEPOSIT_SALARY      = 200,
    STICKER_DEPOSIT_POCKET,
    STICKER_DEPOSIT_ETC,
    
    STICKER_WITHDRAW_NORMAL     = 1,
    STICKER_WITHDRAW_FOOD       = 300,
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
@end
