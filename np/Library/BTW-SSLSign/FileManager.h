//
//  FileManager.h
//  SecureBrowser
//
//  Created by bluehoho on 10. 8. 19..
//  Copyright 2010 BTWorks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileManager : NSObject

+ (NSString *)getDocumentDirectoryPath;
+ (NSString *)getNPKIDirectoryPath;

+ (void)saveCertToKeychain:(NSData *)data subjectDN:(NSString *)subjectDN;
+ (void)savePriKeyToKeychain:(NSData *)data subjectDN:(NSString *)subjectDN;
+ (NSData *)loadCertFromKeyChain:(NSString *)subjectDN;
+ (NSData *)loadPriKeyFromKeyChain:(NSString *)subjectDN;

+ (void)deleteCertFile:(NSString *)subjectDN;
+ (int)initCert;

+ (void)saveKmCertToKeychain:(NSData *)data subjectDN:(NSString *)subjectDN;
+ (void)saveKmKeyToKeychain:(NSData *)data subjectDN:(NSString *)subjectDN;
+ (NSData *)loadKmCertFromKeyChain:(NSString *)subjectDN;
+ (NSData *)loadKmKeyFromKeyChain:(NSString *)subjectDN;

/*
 *  Old API
 */
+ (NSString *)getCertDirectoryPath;
+ (NSArray *)getCertDirectoryNameArray;
+ (NSArray *)getSubjectDNArray;

+ (void)saveCert:(NSData *)data subjectDN:(NSString *)subjectDN;
+ (void)savePriKey:(NSData *)data subjectDN:(NSString *)subjectDN;

+ (NSData *)loadCert:(NSString *)subjectDN;
+ (NSData *)loadPriKey:(NSString *)subjectDN;

+ (void)deleteCert:(NSString *)subjectDN;

@end
