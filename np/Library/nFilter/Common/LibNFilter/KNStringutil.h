//
//  KNStringutil.h
//  AllKeypadNFilter
//
//  Created by 발팀 개 on 10. 9. 17..
//  Copyright 2010 NSHC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KNStringutil : NSObject {

}

+ (KNStringutil*)sharedInstance;

- (NSArray*)splitBy1Size:(NSData*)pStr;
- (NSString*)returnDumyWithSameLength:(NSString*)pStr;

@end
