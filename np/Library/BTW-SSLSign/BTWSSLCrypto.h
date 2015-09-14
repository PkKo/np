//
//  BTWSSLCrypto.h
//  BTW-SSLSign
//
//  Created by bluehoho on 13. 10. 14..
//  Copyright (c) 2013년 BTWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTWSSLCrypto : NSObject

@property (nonatomic, retain) NSData *cert;
@property (nonatomic, retain) NSString *lastError;

+ (id)sharedInstance;
+ (void)killInstance;

- (void)setRecipientInfo:(NSData *)cert;
- (NSData *)envelop:(NSData *)inputData;

- (NSString *)encrypt:(NSString *)plainData sid:(NSString *)sid;
- (NSString *)decrypt:(NSString *)encData sid:(NSString *)sid;

- (NSData *)encrypt:(NSData *)plainData;
- (NSData *)decrypt:(NSData *)encData;

@end
