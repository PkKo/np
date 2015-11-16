//
//  CommonUtil.m
//  httpserver
//
//  Created by Infobank1 on 2015. 9. 7..
//  Copyright (c) 2015년 Infobank. All rights reserved.
//

#import "CommonUtil.h"
#import "KeychainItemWrapper.h"
#import <CommonCrypto/CommonCryptor.h>
#import "nsdataadditions.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

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
        size.width = size.width + 2;
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
            stickerImageName = @"icon_sticker_01_sel_01.png";
            break;
        }
        case STICKER_DEPOSIT_POCKET:
        {
            stickerImageName = @"icon_sticker_01_sel_02.png";
            break;
        }
        case STICKER_DEPOSIT_ETC:
        {
            stickerImageName = @"icon_sticker_01.png";
            break;
        }
        case STICKER_WITHDRAW_NORMAL:
        {
            stickerImageName = @"icon_sticker_02.png";
            break;
        }
        case STICKER_WITHDRAW_FOOD:
        {
            stickerImageName = @"icon_sticker_02_sel_01.png";
            break;
        }
        case STICKER_WITHDRAW_TELEPHONE:
        {
            stickerImageName = @"icon_sticker_02_sel_02.png";
            break;
        }
        case STICKER_WITHDRAW_HOUSING:
        {
            stickerImageName = @"icon_sticker_02_sel_03.png";
            break;
        }
        case STICKER_WITHDRAW_SHOPPING:
        {
            stickerImageName = @"icon_sticker_02_sel_04.png";
            break;
        }
        case STICKER_WITHDRAW_CULTURE:
        {
            stickerImageName = @"icon_sticker_02_sel_05.png";
            break;
        }
        case STICKER_WITHDRAW_EDUCATION:
        {
            stickerImageName = @"icon_sticker_02_sel_06.png";
            break;
        }
        case STICKER_WITHDRAW_CREDIT:
        {
            stickerImageName = @"icon_sticker_02_sel_07.png";
            break;
        }
        case STICKER_WITHDRAW_SAVING:
        {
            stickerImageName = @"icon_sticker_02_sel_08.png";
            break;
        }
        case STICKER_WITHDRAW_ETC:
        {
            stickerImageName = @"icon_sticker_02.png";
            break;
        }
        case STICKER_EXCHANGE_RATE:
        {
            stickerImageName = @"icon_sticker_03.png";
            break;
        }
        case STICKER_NOTICE_NORMAL:
        {
            stickerImageName = @"icon_sticker_04.png";
            break;
        }
        default:
            break;
    }
    
    UIImage *stickerImage = [UIImage imageNamed:stickerImageName];
    return stickerImage;
}

+ (StickerInfo *)getStickerInfo:(StickerType)stickerType
{
    NSString *stickerImageName = @"";
    NSString * stickerName = @"기타";
    NSString * stickerColorHexStr = @"#3E9BE9";
    
    switch (stickerType)
    {
        case STICKER_DEPOSIT_NORMAL:
        {
            stickerImageName    = @"icon_sticker_01.png";
            stickerName         = @"입금기타";
            stickerColorHexStr  = @"#3E9BE9";
            break;
        }
        case STICKER_DEPOSIT_SALARY:
        {
            stickerImageName    = @"icon_deposit_01_dft.png";
            stickerName         = @"급여";
            stickerColorHexStr  = @"#77A8FD";
            break;
        }
        case STICKER_DEPOSIT_POCKET:
        {
            stickerImageName    = @"icon_deposit_02_dft.png";
            stickerName         = @"용돈";
            stickerColorHexStr  = @"#71C6F2";
            break;
        }
        case STICKER_DEPOSIT_ETC:
        {
            stickerImageName    = @"icon_deposit_03_dft.png";
            stickerName         = @"기타";
            stickerColorHexStr  = @"#3E9BE9";
            break;
        }
        case STICKER_WITHDRAW_NORMAL:
        {
            stickerImageName    = @"icon_sticker_02.png";
            stickerName         = @"지출기타";
            stickerColorHexStr  = @"#F4607C";
            break;
        }
        case STICKER_WITHDRAW_FOOD:
        {
            stickerImageName    = @"icon_withdraw_01_dft.png";
            stickerName         = @"식비";
            stickerColorHexStr  = @"#F97BB6";
            break;
        }
        case STICKER_WITHDRAW_TELEPHONE:
        {
            stickerImageName    = @"icon_withdraw_02_dft.png";
            stickerName         = @"통신";
            stickerColorHexStr  = @"#FF9FEE";
            break;
        }
        case STICKER_WITHDRAW_HOUSING:
        {
            stickerImageName    = @"icon_withdraw_03_dft.png";
            stickerName         = @"주거";
            stickerColorHexStr  = @"#E276F8";
            break;
        }
        case STICKER_WITHDRAW_SHOPPING:
        {
            stickerImageName    = @"icon_withdraw_04_dft.png";
            stickerName         = @"쇼핑";
            stickerColorHexStr  = @"#EB84E7";
            break;
        }
        case STICKER_WITHDRAW_CULTURE:
        {
            stickerImageName    = @"icon_withdraw_05_dft.png";
            stickerName         = @"문화";
            stickerColorHexStr  = @"#FE86B1";
            break;
        }
        case STICKER_WITHDRAW_EDUCATION:
        {
            stickerImageName    = @"icon_withdraw_06_dft.png";
            stickerName         = @"교육";
            stickerColorHexStr  = @"#FF9ADA";
            break;
        }
        case STICKER_WITHDRAW_CREDIT:
        {
            stickerImageName    = @"icon_withdraw_07_dft.png";
            stickerName         = @"카드";
            stickerColorHexStr  = @"#F8986F";
            break;
        }
        case STICKER_WITHDRAW_SAVING:
        {
            stickerImageName    = @"icon_withdraw_08_dft.png";
            stickerName         = @"저축";
            stickerColorHexStr  = @"#FA7575";
            break;
        }
        case STICKER_WITHDRAW_ETC:
        {
            stickerImageName    = @"icon_withdraw_09_dft.png";
            stickerName         = @"기타";
            stickerColorHexStr  = @"#F4607C";
            break;
        }
        case STICKER_EXCHANGE_RATE:
        {
            stickerImageName    = @"icon_sticker_03.png";
            stickerName         = @"기타";
            stickerColorHexStr  = @"#3E9BE9";
            break;
        }
        case STICKER_NOTICE_NORMAL:
        {
            stickerImageName    = @"icon_sticekr_04.png";
            stickerName         = @"기타";
            stickerColorHexStr  = @"#3E9BE9";
            
            break;
        }
        default:
            break;
    }
    
    return [[StickerInfo alloc] initStickerInfoWithStickerName:stickerName
                                            stickerColorHexStr:stickerColorHexStr
                                                  stickerImage:[UIImage imageNamed:stickerImageName]];
}

+ (NSString *)getTransactionTypeByStickerType:(StickerType)stickerType {
    
    switch (stickerType) {
        case STICKER_DEPOSIT_NORMAL:
        case STICKER_DEPOSIT_SALARY:
        case STICKER_DEPOSIT_POCKET:
        case STICKER_DEPOSIT_ETC:
            return INCOME_TYPE_STRING;
        default:
            return WITHDRAW_TYPE_STRING;
    }
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

+ (NSString *)getQuickViewDateString:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM.dd HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

// 3DES 암호화
+ (NSString *)encrypt3DES:(NSString *)str
{
    //NSLog(@"encrypt input string : %@", str);
    //NSLog(@"input length : %d", [str length]);
    NSData *data = [str dataUsingEncoding: NSUTF8StringEncoding];
    //NSLog(@"data : %@", data);
    unsigned char *input = (unsigned char*)[data bytes];
    NSUInteger inLength = [data length];
    NSInteger outLength = ((inLength + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1));
    unsigned char *output =(unsigned char *)calloc(outLength, sizeof(unsigned char));
    bzero(output, outLength*sizeof(unsigned char));
    size_t additionalNeeded = 0;
    
    unsigned char *iv = (unsigned char *)calloc(kCCBlockSize3DES, sizeof(unsigned char));
    bzero(iv, kCCBlockSize3DES * sizeof(unsigned char));
    
    NSString *key = @"abcdefg123123123";
    const void *vkey = (const void *) [key UTF8String];
    
    
    CCCryptorStatus err = CCCrypt(kCCEncrypt,
                                  kCCAlgorithm3DES,
                                  kCCOptionPKCS7Padding | kCCOptionECBMode,
                                  vkey,
                                  kCCKeySize3DES,
                                  iv,
                                  input,
                                  inLength,
                                  output,
                                  outLength,
                                  &additionalNeeded);
    //NSLog(@"encrypt err: %d", err);
    
    if(0);
    else if (err == kCCParamError) NSLog(@"PARAM ERROR");
    else if (err == kCCBufferTooSmall) NSLog(@"BUFFER TOO SMALL");
    else if (err == kCCMemoryFailure) NSLog(@"MEMORY FAILURE");
    else if (err == kCCAlignmentError) NSLog(@"ALIGNMENT");
    else if (err == kCCDecodeError) NSLog(@"DECODE ERROR");
    else if (err == kCCUnimplemented) NSLog(@"UNIMPLEMENTED");
    
    free(iv);
    
    NSString *result;
    //NSData *myData = [NSData dataWithBytesNoCopy:output length:outLength freeWhenDone:YES];
    NSData *myData = [NSData dataWithBytesNoCopy:output length:(NSUInteger)additionalNeeded freeWhenDone:YES];
    //NSLog(@"data : %@", myData);
    //NSLog(@"encrypted string : %s", [myData bytes]);
    //NSLog(@"encrypted length : %d", [myData length]);
    result = [myData base64Encoding];
    
    //NSLog(@"base64encoded : %@", result);
    
    return result;
}

//키를 입력받아 암호화한다
+ (NSString *)encrypt3DESWithKey:(NSString *)str key:(NSString *)key
{
    //NSLog(@"encrypt input string : %@", str);
    //NSLog(@"input length : %d", [str length]);
    NSData *data = [str dataUsingEncoding: NSUTF8StringEncoding];
    //NSLog(@"data : %@", data);
    unsigned char *input = (unsigned char*)[data bytes];
    NSUInteger inLength = [data length];
    NSInteger outLength = ((inLength + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1));
    unsigned char *output =(unsigned char *)calloc(outLength, sizeof(unsigned char));
    bzero(output, outLength*sizeof(unsigned char));
    size_t additionalNeeded = 0;
    
    unsigned char *iv = (unsigned char *)calloc(kCCBlockSize3DES, sizeof(unsigned char));
    bzero(iv, kCCBlockSize3DES * sizeof(unsigned char));
    
    const void *vkey = (const void *) [key UTF8String];
    
    
    CCCryptorStatus err = CCCrypt(kCCEncrypt,
                                  kCCAlgorithm3DES,
                                  kCCOptionPKCS7Padding | kCCOptionECBMode,
                                  vkey,
                                  kCCKeySize3DES,
                                  iv,
                                  input,
                                  inLength,
                                  output,
                                  outLength,
                                  &additionalNeeded);
    //NSLog(@"encrypt err: %d", err);
    
    if(0);
    else if (err == kCCParamError) NSLog(@"PARAM ERROR");
    else if (err == kCCBufferTooSmall) NSLog(@"BUFFER TOO SMALL");
    else if (err == kCCMemoryFailure) NSLog(@"MEMORY FAILURE");
    else if (err == kCCAlignmentError) NSLog(@"ALIGNMENT");
    else if (err == kCCDecodeError) NSLog(@"DECODE ERROR");
    else if (err == kCCUnimplemented) NSLog(@"UNIMPLEMENTED");
    
    free(iv);
    
    NSString *result;
    //NSData *myData = [NSData dataWithBytesNoCopy:output length:outLength freeWhenDone:YES];
    NSData *myData = [NSData dataWithBytesNoCopy:output length:(NSUInteger)additionalNeeded freeWhenDone:YES];
    //NSLog(@"data : %@", myData);
    //NSLog(@"encrypted string : %s", [myData bytes]);
    //NSLog(@"encrypted length : %d", [myData length]);
    result = [myData base64Encoding];
    
    //NSLog(@"base64encoded : %@", result);
    
    return result;
}

// 3DES 복호화
+ (NSString *)decrypt3DES:(NSString *)str decodingKey:(NSString *)decodingKey
{
    //NSLog(@"decrypt input string : %@", str);
    NSData *decodedData = [NSData dataWithBase64EncodedString:str];
    //NSLog(@"data : %@", decodedData);
    //NSLog(@"base64decoded : %s", [decodedData bytes]);
    
    unsigned char *input = (unsigned char*)[decodedData bytes];
    NSUInteger inLength = [decodedData length];
    NSInteger outLength = ((inLength + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1));
    unsigned char *output =(unsigned char *)calloc(outLength, sizeof(unsigned char));
    bzero(output, outLength*sizeof(unsigned char));
    size_t additionalNeeded = 0;
    
    
    unsigned char *iv = (unsigned char *)calloc(kCCBlockSize3DES, sizeof(unsigned char));
    bzero(iv, kCCBlockSize3DES * sizeof(unsigned char));
    
    NSString *key = decodingKey;
    const void *vkey = (const void *) [key UTF8String];
    
    
    CCCryptorStatus err = CCCrypt(kCCDecrypt,
                                  kCCAlgorithm3DES,
                                  kCCOptionPKCS7Padding | kCCOptionECBMode,
                                  vkey,
                                  kCCKeySize3DES,
                                  iv,
                                  input,
                                  inLength,
                                  output,
                                  outLength,
                                  &additionalNeeded);
    //NSLog(@"encrypt err: %d", err);
    
    if(0);
    else if (err == kCCParamError) NSLog(@"PARAM ERROR");
    else if (err == kCCBufferTooSmall) NSLog(@"BUFFER TOO SMALL");
    else if (err == kCCMemoryFailure) NSLog(@"MEMORY FAILURE");
    else if (err == kCCAlignmentError) NSLog(@"ALIGNMENT");
    else if (err == kCCDecodeError) NSLog(@"DECODE ERROR");
    else if (err == kCCUnimplemented) NSLog(@"UNIMPLEMENTED");
    
    free(iv);
    
    NSString *result;
    //NSData *myData = [NSData dataWithBytes:(const void *)output length:(NSUInteger)additionalNeeded];
    //NSData *myData = [NSData dataWithBytesNoCopy:output length:outLength freeWhenDone:YES];
    NSData *myData = [NSData dataWithBytesNoCopy:output length:(NSUInteger)additionalNeeded freeWhenDone:YES];
    //NSLog(@"data : %@", myData);
    //NSLog(@"decrypted string : %s", [myData bytes]);
    //NSLog(@"decrypted length : %d", [myData length]);
    
    result = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    //result = [NSString stringWithFormat:@"%.*s",[myData length], [myData bytes]];
    //result = [NSString stringWithUTF8String:[myData bytes]];
    
    //NSLog(@"output length : %d", [result length]);
    //NSLog(@"result : %@", result);
    
    return result;
}

+ (NSString *)getFormattedTodayString:(NSString *)format
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *todayString = [dateFormat stringFromDate:today];
    
    return todayString;
}

+ (NSString *)getFormattedDateStringWithIndex:(NSString *)format indexDay:(NSInteger)indexDay
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60 * indexDay;
    NSDate *toDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *todayString = [dateFormat stringFromDate:toDate];
    
    return todayString;
}

+ (NSString *)getFormattedDateStringWithDate:(NSString *)format date:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *todayString = [dateFormat stringFromDate:date];
    
    return todayString;
}

+ (void)setUnreadCountForBanking:(NSInteger)count
{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).unreadCountBanking = count;
}

+ (NSInteger)getUnreadCountForBanking
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).unreadCountBanking;
}

+ (void)setUnreadCountForEtc:(NSInteger)count
{
    ((AppDelegate *)[UIApplication sharedApplication].delegate).unreadCountEtc = count;
}

+ (NSInteger)getUnreadCountForEtc
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).unreadCountEtc;
}
@end
