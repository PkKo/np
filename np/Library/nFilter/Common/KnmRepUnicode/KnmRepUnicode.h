//
//  KnmRepUnicode.h
//  SmpReplaceUnicode
//
//  Created by Kinamee on 11. 5. 11..
//  Copyright 2011 NSHC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KnmRepUnicode : NSObject {
    
}

+(KnmRepUnicode*)shared;

-(NSString*)replaceString:(NSString*)pSrc increaseNum:(NSInteger)pNum;
-(NSString*)replaceString:(NSString*)pSrc minusNum:(NSInteger)pNum;
-(NSArray*)stringToArray:(NSString*)pSrc;

@end
