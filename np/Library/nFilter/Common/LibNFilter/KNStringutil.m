//
//  KNStringutil.m
//  AllKeypadNFilter
//
//  Created by 발팀 개 on 10. 9. 17..
//  Copyright 2010 NSHC. All rights reserved.
//

#import "KNStringutil.h"

static KNStringutil *instance = nil;
@implementation KNStringutil

+ (KNStringutil*)sharedInstance {

	if (instance == nil) {
		instance = [[KNStringutil alloc] init];
	}
	return instance;
}

- (id)init {
	
	self = [super init];
	return self;
}

- (NSString*)returnDumyWithSameLength:(NSString*)pStr {
	NSMutableString* retStr = [[NSMutableString alloc] initWithCapacity:[pStr length]];
	//NSLog(@"시작값: %@", retStr);
	srandom((unsigned int)time(NULL));
	for (int i = 0; i < [pStr length]; i++) {
		NSInteger rndi = 	arc4random() % 10;
		//NSLog(@"랜덤값: %d", rndi);
		[retStr appendFormat:@"%ld", (long)rndi];
	}
	//NSLog(@"랜던값: %@", retStr);
	return retStr;
}

- (NSArray*)splitBy1Size:(NSData *)pStr {
    NSString *tmpStr = [[NSString alloc] initWithData:pStr encoding:NSUTF8StringEncoding];
	//NSLog(@"넘어온 값: %@", pStr);
	NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity:[tmpStr length]];
	
	for (int i = 0; i < [pStr length]; i ++) {
		//NSLog(@"SPLIT: %@", [pStr substringWithRange:NSMakeRange(i, 1)]);
		[arr addObject: [tmpStr substringWithRange:NSMakeRange(i, 1)] ];
	}
	
	return arr;
}

@end
