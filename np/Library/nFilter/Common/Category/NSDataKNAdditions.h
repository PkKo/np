/*
 // 사용법
 NSString *sourceString = @"username:password";  
 NSLog(@"Original string: %@", sourceString);  
 NSData *sourceData = [sourceString dataUsingEncoding:NSUTF8StringEncoding];  
 
 NSString *base64EncodedString = [sourceData base64Encoding];  
 NSLog([NSString stringWithFormat:@"Encoded form: %@", base64EncodedString]);  
 
 NSData *decodedData = [NSData dataWithBase64EncodedString:base64EncodedString];  
 NSString *decodedString = [[[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding] autorelease];  
 NSLog([NSString stringWithFormat:@"Decoded again: %@",decodedString]);
 */

#import <Foundation/Foundation.h>

@interface NSData (NSDataKNAdditions)
+ (NSData *) dataWithBase64EncodedString:(NSString *) string;
- (id) initWithBase64EncodedString:(NSString *) string;

- (NSString *) base64Encoding;
- (NSString *) base64EncodingWithLineLength:(NSUInteger) lineLength;

- (BOOL) hasPrefix:(NSData *) prefix;
- (BOOL) hasPrefixBytes:(const void *) prefix length:(NSUInteger) length;

- (BOOL) hasSuffix:(NSData *) suffix;
- (BOOL) hasSuffixBytes:(const void *) suffix length:(NSUInteger) length;

- (NSString *) stringWithHexBytes1;
- (NSString *) stringWithHexBytes2;

- (NSString *)toString;
@end
