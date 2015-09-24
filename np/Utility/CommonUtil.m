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
@end
