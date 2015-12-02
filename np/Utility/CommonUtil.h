//
//  CommonUtil.h
//  httpserver
//
//  Created by Infobank1 on 2015. 9. 7..
//  Copyright (c) 2015년 Infobank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StickerInfo.h"
#import "Reachability.h"

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
    STICKER_WITHDRAW_ETC,
    
    STICKER_DEPOSIT_MODIFY      = 3,
    STICKER_DEPOSIT_CANCEL,
    STICKER_WITHDRAW_MODIFY,
    STICKER_WITHDRAW_CANCEL,
    STICKER_EXCHANGE_RATE       = 300,
    STICKER_NOTICE_NORMAL,
    STICKER_ETC
} StickerType;

// 환율 300
// 기타 301
@interface CommonUtil : NSObject

+ (NSString *)getAppVersion;
+ (NSString *)getOSVersion;
+ (NSString *)getMaskingNumber:(NSString *)number;
+ (NSString *)getAccountNumberAddDash:(NSString *)number;
+ (NSString *)getDeviceUUID;
+ (NSString *)getBodyString:(NSDictionary *)bodyObject;
+ (CGSize)getStringFrameSize:(NSString *)string fontSize:(CGFloat)fontSize bold:(BOOL)isBold;
+ (void)runSpinAnimationWithDuration:(UIView *)view duration:(CGFloat)duration;
+ (void)stopSpinAnimation:(UIView *)view;
+ (NSString *)getURLEncodedString:(NSString *)unencodeString;
+ (UIImage *)getStickerImage:(StickerType)stickerType;
+ (StickerInfo *)getStickerInfo:(StickerType)stickerType;
+ (NSString *)getTransactionTypeByStickerType:(StickerType)stickerType;
+ (NSString *)getTodayDateString;
+ (NSString *)getDateString:(NSDate *)date;
+ (NSString *)getDayString:(NSDate *)date;
+ (NSString *)getTimeString:(NSDate *)date;
+ (NSString *)getQuickViewDateString:(NSDate *)date;
+ (NSString *)encrypt3DES:(NSString *)str;
+ (NSString *)encrypt3DESWithKey:(NSString *)str key:(NSString *)key;
+ (NSString *)decrypt3DES:(NSString *)str decodingKey:(NSString *)decodingKey;
+ (NSString *)hashSHA256EncryptString:(NSString *)value withKey:(NSString *)key;
+ (NSString *)getFormattedTodayString:(NSString *)format;
+ (NSString *)getFormattedDateStringWithIndex:(NSString *)format indexDay:(NSInteger)indexDay;
+ (NSString *)getFormattedDateStringWithDate:(NSString *)format date:(NSDate *)date;
+ (void)setUnreadCountForBanking:(NSInteger)count;
+ (NSInteger)getUnreadCountForBanking;
+ (void)setUnreadCountForEtc:(NSInteger)count;
+ (NSInteger)getUnreadCountForEtc;
+ (NetworkStatus)getNetworkStatus;
+ (NSComparisonResult)compareDateString:(NSString *)fromDateString toDate:(NSString *)toDateString;
@end
