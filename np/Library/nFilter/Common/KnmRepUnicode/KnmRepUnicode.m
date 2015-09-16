//
//  KnmRepUnicode.m
//  SmpReplaceUnicode
//
//  Created by Kinamee on 11. 5. 11..
//  Copyright 2011 NSHC. All rights reserved.
//

#import "KnmRepUnicode.h"

@implementation KnmRepUnicode

static KnmRepUnicode* instance = nil;

+(KnmRepUnicode*)shared {
    
    if (instance == nil) {
        instance = [[KnmRepUnicode alloc] init];
    }
    return instance;
}

-(NSString*)replaceString:(NSString*)pSrc increaseNum:(NSInteger)pNum {
    
    NSMutableString* retValue = [NSMutableString stringWithCapacity:254];
    
    // 1. 문자열을 배열로 바꾼다.
    NSArray* arrSrc = [self stringToArray:pSrc];
    
    // 2. 각 배열의 한문자를 뽑아서 유니코드로 변경한다
    NSString* tmpStr;
    unichar unicode;
    for (int i = 0; i < arrSrc.count; i++) {
        
        tmpStr = [arrSrc objectAtIndex:i];
        [tmpStr getCharacters:&unicode];
        
        // 해당유니코드에 대응하는 문자표시
        // NSLog(@"%d - %@", unicode, [NSString stringWithFormat:@"%C", unicode] );
        
        // 3. 유니코드에 특정숫자만큼을 플러스 시킨다
        unicode = unicode + pNum + i;
        
        // 해당유니코드에 대응하는 문자표시
        // NSLog(@"%d - %@", unicode, [NSString stringWithFormat:@"%C", unicode] );
        
        // 플러스된 유니코드를 문자화하여 더해간다
        [retValue appendFormat:@"%C", unicode];
    }
    return retValue;
}

-(NSString*)replaceString:(NSString*)pSrc minusNum:(NSInteger)pNum {
    
    NSMutableString* retValue = [NSMutableString stringWithCapacity:254];
    
    // 1. 문자열을 배열로 바꾼다.
    NSArray* arrSrc = [self stringToArray:pSrc];
    
    // 2. 각 배열의 한문자를 뽑아서 유니코드로 변경한다
    NSString* tmpStr;
    unichar unicode;
    for (int i = 0; i < arrSrc.count; i++) {
        tmpStr = [arrSrc objectAtIndex:i];
        [tmpStr getCharacters:&unicode];
        
        // 해당유니코드에 대응하는 문자표시
        // NSLog(@"%d - %@", unicode, [NSString stringWithFormat:@"%C", unicode] );
        
        // 3. 유니코드에 특정숫자만큼을 플러스 시킨다
        unicode = unicode - pNum - i;
        
        // 해당유니코드에 대응하는 문자표시
        // NSLog(@"%d - %@", unicode, [NSString stringWithFormat:@"%C", unicode] );
        
        // 플러스된 유니코드를 문자화하여 더해간다
        [retValue appendFormat:@"%C", unicode];
    }
    return retValue;
}

-(NSArray*)stringToArray:(NSString*)pSrc {
    
    NSMutableArray* arrRet = [NSMutableArray arrayWithCapacity:[pSrc length]];
    
    for (int i = 0; i < [pSrc length]; i++) {
        [arrRet addObject:[pSrc substringWithRange:NSMakeRange(i, 1)]];
    }
    
    return arrRet;
}

@end
