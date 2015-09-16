//
//  NSStreamAdditions.m
//  NetworkForTDD
//
//  Created by 발팀 개 on 10. 1. 14..
//  Copyright 2010 NSHC. All rights reserved.
//

#import "NSStreamKNAdditions.h"

@implementation NSStream(NSStreamKNAdditions)

+ (void)getStreamsToHostNamed:(NSString *)hostName 
                         port:(NSInteger)port 
                  inputStream:(NSInputStream **)inputStreamPtr 
                 outputStream:(NSOutputStream **)outputStreamPtr
{
    CFReadStreamRef     readStream;
    CFWriteStreamRef    writeStream;
    
    assert(hostName != nil);
    assert( (port > 0) && (port < 65536) );
    assert( (inputStreamPtr != NULL) || (outputStreamPtr != NULL) );
    
    readStream = NULL;
    writeStream = NULL;
    
    CFStreamCreatePairWithSocketToHost(
                                       NULL, 
                                       (__bridge CFStringRef) hostName,
                                       (int)port,
                                       ((inputStreamPtr  != nil) ? &readStream : NULL),
                                       ((outputStreamPtr != nil) ? &writeStream : NULL)
                                       );
    
    if (inputStreamPtr != NULL) {
        *inputStreamPtr  = CFBridgingRelease(readStream);
    }
    if (outputStreamPtr != NULL) {
        *outputStreamPtr  = CFBridgingRelease(readStream);
    }
}

@end
