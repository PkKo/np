//
//  CommonUtil.m
//  httpserver
//
//  Created by Infobank1 on 2015. 9. 7..
//  Copyright (c) 2015년 Infobank. All rights reserved.
//

#import "CommonUtil.h"
#import "KeychainItemWrapper.h"

@implementation CommonUtil

+ (NSString *)getAppVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSString *)getOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)getMaskingNumber:(NSString *)number
{
    NSString *maskingNumber = @"";
    
    if([number containsString:STRING_DASH])
    {
        NSArray *numberArray = [number componentsSeparatedByString:STRING_DASH];
        
        if([numberArray count] > 0 && [numberArray count] == 4)
        {
            // 3-4-4-2 형태의 계좌
            // 111-****-3333-44로 마스킹한다.
            if([[numberArray objectAtIndex:1] length] == 4)
            {
                maskingNumber = [NSString stringWithFormat:@"%@-%@-%@-%@",
                                 [numberArray objectAtIndex:0], STRING_MASKING,
                                 [numberArray objectAtIndex:2], [numberArray objectAtIndex:3]];
            }
        }
        else if([numberArray count] > 0)
        {
            /**
             3-2-6형태의 계좌 : 111-22-****33
             4-2-6형태의 계좌 : 1111-22-****33
             6-2-6형태의 계좌 : 111111-22-****33
             6-3-6형태의 계좌 : 111111-222-****33
             */
            NSString *lastNumber = [numberArray objectAtIndex:[numberArray count] - 1];
            lastNumber = [lastNumber stringByReplacingCharactersInRange:NSMakeRange(0, [STRING_MASKING length]) withString:STRING_MASKING];
            maskingNumber = [NSString stringWithFormat:@"%@-%@-%@",
                             [numberArray objectAtIndex:0], [numberArray objectAtIndex:1], lastNumber];
        }
    }
    
    return maskingNumber;
}

+ (NSString *)getDeviceUUID
{
    KeychainItemWrapper *keyChainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_ID accessGroup:nil];
    NSString *uuidString = [keyChainWrapper objectForKey:(__bridge NSString *)kSecAttrAccount];
    
    // 키체인에 저장된 UUID가 없으면 새로 생성해 키체인에 저장하고 값을 리턴한다
    if(uuidString == nil || uuidString.length <= 0)
    {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        
        uuidString = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
        CFRelease(uuidStringRef);
        
        // 키체인에 UUID 저장
        [keyChainWrapper setObject:uuidString forKey:(__bridge NSString *)kSecAttrAccount];
    }
    
    return uuidString;
}

+ (NSString *)getBodyString:(NSDictionary *)bodyObject
{
    NSString *bodyString = [NSString string];
    NSEnumerator *keys = [bodyObject keyEnumerator];
    for(NSString *key in keys)
    {
        if([bodyString length] == 0)
        {
            bodyString = [NSString stringWithFormat:@"%@=%@", key, [bodyObject objectForKey:key]];
        }
        else
        {
            bodyString = [NSString stringWithFormat:@"%@&%@=%@", bodyString, key, [bodyObject objectForKey:key]];
        }
    }
    
    return bodyString;
}

+ (CGSize)getStringFrameSize:(NSString *)string fontSize:(CGFloat)fontSize bold:(BOOL)isBold
{
    CGSize size = CGSizeMake(0, 0);
    
    if(isBold)
    {
        size = [string sizeWithFont:[UIFont boldSystemFontOfSize:fontSize]];
    }
    else
    {
        size = [string sizeWithFont:[UIFont systemFontOfSize:fontSize]];
    }
    
    return size;
}

+ (void)runSpinAnimationWithDuration:(UIView *)view duration:(CGFloat)duration
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:M_PI * 2.0 * duration];
    rotationAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = INFINITY;
    
    [view.layer addAnimation:rotationAnimation forKey:@"SpinAnimation"];
    
}

+ (void)stopSpinAnimation:(UIView *)view
{
    [view.layer removeAnimationForKey:@"SpinAnimation"];
}

+ (NSString *)getURLEncodedString:(NSString *)unencodeString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)unencodeString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
    return encodedString;
}

+ (UIImage *)getStickerImage:(StickerType)stickerType
{
    NSString *stickerImageName = @"";
    
    switch (stickerType)
    {
        case STICKER_DEPOSIT_NORMAL:
        {
            stickerImageName = @"icon_sticker_01.png";
            break;
        }
        case STICKER_DEPOSIT_SALARY:
        {
            stickerImageName = @"icon_deposit_01_dft.png";
            break;
        }
        case STICKER_DEPOSIT_POCKET:
        {
            stickerImageName = @"icon_deposit_02_dft.png";
            break;
        }
        case STICKER_DEPOSIT_ETC:
        {
            stickerImageName = @"icon_deposit_03_dft.png";
            break;
        }
        case STICKER_WITHDRAW_NORMAL:
        {
            stickerImageName = @"icon_sticker_02.png";
            break;
        }
        case STICKER_WITHDRAW_FOOD:
        {
            stickerImageName = @"icon_withdraw_01_dft.png";
            break;
        }
        case STICKER_WITHDRAW_TELEPHONE:
        {
            stickerImageName = @"icon_withdraw_02_dft.png";
            break;
        }
        case STICKER_WITHDRAW_HOUSING:
        {
            stickerImageName = @"icon_withdraw_03_dft.png";
            break;
        }
        case STICKER_WITHDRAW_SHOPPING:
        {
            stickerImageName = @"icon_withdraw_04_dft.png";
            break;
        }
        case STICKER_WITHDRAW_CULTURE:
        {
            stickerImageName = @"icon_withdraw_05_dft.png";
            break;
        }
        case STICKER_WITHDRAW_EDUCATION:
        {
            stickerImageName = @"icon_withdraw_06_dft.png";
            break;
        }
        case STICKER_WITHDRAW_CREDIT:
        {
            stickerImageName = @"icon_withdraw_07_dft.png";
            break;
        }
        case STICKER_WITHDRAW_SAVING:
        {
            stickerImageName = @"icon_withdraw_08_dft.png";
            break;
        }
        case STICKER_WITHDRAW_ETC:
        {
            stickerImageName = @"icon_withdraw_09_dft.png";
            break;
        }
        default:
            break;
    }
    
    UIImage *stickerImage = [UIImage imageNamed:stickerImageName];
    return stickerImage;
}

+ (NSString *)getTodayDateString
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy.MM.dd"];
    NSString *todayString = [dateFormat stringFromDate:today];
    
    return todayString;
}

+ (NSString *)getDateString:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy.MM.dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

+ (NSString *)getDayString:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

+ (NSString *)getTimeString:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *timeString = [dateFormat stringFromDate:date];
    
    return timeString;
}
@end
