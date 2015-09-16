//
//  NSStreamAdditions.h
//  NetworkForTDD
//
//  Created by 발팀 개 on 10. 1. 14..
//  Copyright 2010 NSHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStream(NSStreamKNAdditions)

+ (void)getStreamsToHostNamed:(NSString *)hostName 
						 port:(NSInteger)port 
				  inputStream:(NSInputStream **)inputStreamPtr 
				 outputStream:(NSOutputStream **)outputStreamPtr;

@end
