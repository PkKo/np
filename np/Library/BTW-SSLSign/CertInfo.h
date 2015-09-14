//
//  CertInfo.h
//  SecureBrowser
//
//  Created by 양호중 on 10. 8. 19..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CertInfo : NSObject

// 인증서 버전
@property (nonatomic, retain) NSString *version;
// 인증서 주체DN
@property (nonatomic, retain) NSString *subjectDN;
// 인증서 주체CN
@property (nonatomic, retain) NSString *subjectCN;
// 만료일
@property (nonatomic, retain) NSString *notAfter;
// 발급일
@property (nonatomic, retain) NSString *notBefore;
// 발급기관(한글)
@property (nonatomic, retain) NSString *issuer;         // 금융결제원, 한국정보인증, .....
// 발급기관(영문)
@property (nonatomic, retain) NSString *caName;         // yessign, SignKorea, ....
// 발급기관 DN
@property (nonatomic, retain) NSString *issuerDN;
// 발급일, 만료일(NSDate형태)
@property (nonatomic, retain) NSDate *dtNotAfter;
@property (nonatomic, retain) NSDate *dtNotBefore;
// 인증서 정책 OID
@property (nonatomic, retain) NSString *oid;            // policy OID
// 인증서 정책
@property (nonatomic, retain) NSString *policy;         // 개인, 범용, 기업, .....
// 인증서 시리얼번호
@property (nonatomic, retain) NSString *serial;         // Decimal
@property (nonatomic, retain) NSString *serialHex;      // HexDecimal
// 인증서 서명 알고리즘
@property (nonatomic, retain) NSString *signatureAlg;

@property (nonatomic, retain) NSData *signCert;
@property (nonatomic, retain) NSData *signKey;

// 인증서 주체DN (for 농협 SSO)
@property (nonatomic, retain) NSString *subjectDN2;

- (id)initWithSubjectDN:(NSString *)subjectDN;
- (id)initWithSignCert:(NSData *)signCert;

- (void)setB64SignCert:(NSString *)signCert;
- (void)setB64SignKey:(NSString *)signKey;
- (NSString *)getB64SignCert;
- (NSString *)getB64SignKey;


/*
 *  Old API
 */
@property (nonatomic, readonly) unsigned char *value;
@property (nonatomic, readonly) int length;
@property (nonatomic, retain) NSString *path;

+ (int)importCert:(NSData *)data password:(NSString *)pwd;
- (int)changePassword:(NSString *)newPasswd currentPassword:(NSString *)currentPasswd;
- (int)verifyVID:(NSString *)passwd idNumber:(NSString *)idn;

@end
