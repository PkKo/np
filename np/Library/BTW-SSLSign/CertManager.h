//
//  CertManager.h
//  NavBrowser
//
//  Created by 양호중 on 10. 8. 27..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CERT_SIGN_MODE      0
#define CERT_EXPORT_MODE    1
#define CERT_ISSUE_MODE     2
#define CERT_UPDATE_MODE    3

@class CertInfo;

@interface CertManager : NSObject
{
@private
    NSString *_password;
}

@property (nonatomic, retain) CertInfo *certInfo;
@property (nonatomic, retain) CertInfo *loginedCertInfo;
@property (nonatomic, retain, setter = setSignRequestUrl:) NSString *signRequestUrl;
@property (nonatomic, retain) NSString *lastError;
@property (nonatomic, retain) NSString *authNumber;
@property (nonatomic, retain) NSString *tbs;
@property (nonatomic, retain) NSString *randomNonce;

@property (nonatomic, retain) NSString *caip;       // server ip
@property (nonatomic, retain) NSString *caport;     // server port
@property (nonatomic, retain) NSString *refcode;    // 참조번호
@property (nonatomic, retain) NSString *passcode;   // 인가번호
@property (nonatomic, retain) NSString *regnum;     // 주민번호

+ (id)sharedInstance;
+ (void)killInstance;

- (void)clearLoginedCertInfo;
- (int)getCertMode;

- (int)checkPassword:(NSString *)password;
- (NSString *)startSign;
- (NSString *)getSignature;
- (int)p12Import:(NSData *)p12Data password:(NSString *)password;
- (NSString *)startExportP12;
- (NSString *)getP12;

/*
 *	QR 인증서 복사 또는 b64로된 p12 import
 *	b64P12 : partail p12 base64 스트링 (QR) 또는 p12 base64 스트링 (non-QR) 
 *	strIdx : QR Code에서 얻은 스트링 (QR) 또는 nil (non-QR)
 *	password : 인증서 비밀번호
 *	return : 0 성공, 그외 비밀번호 다름
 */
- (int)p12ImportForQR:(NSString *)b64P12 strIdx:(NSString *)strIdx password:(NSString *)password;

- (NSString *)getAuthNumber:(NSString *)url;
- (int)verifyP12Uploaded:(NSString *)url;
- (int)p12ImportWithUrl:(NSString *)url password:(NSString *)password;
- (int)p12ExportWithUrl:(NSString *)url;

- (int)importSignCertAndPriKey:(NSData *)signCert priKey:(NSData *)priKey;
- (int)importSignCert:(NSData *)signCert priKey:(NSData *)priKey kmCert:(NSData *)kmCert kmKey:(NSData *)kmKey;

- (int)startIssueCert:(NSString *)password;
- (int)startReIssueCert:(NSString *)password;
- (int)startUpdateCert;

- (int)changePassword:(NSString *)newPasswd currentPassword:(NSString *)currentPasswd;
- (int)verifyVID:(NSString *)passwd idNumber:(NSString *)idn;
- (int)deleteCertWithSerial:(NSString *)serial issuer:(NSString *)issuer;

/*
 *  Old API
 */
+ (void)clear;
+ (void)setCertManager:(CertInfo *)certInfo;
+ (void)setSignRequestUrl:(NSString *)url;
+ (int)getCertMode;
+ (CertInfo *)getLoginedCertInfo;
+ (NSString *)getCertPath;
+ (NSString *)getSubjectDN;
+ (NSString *)getSubjectCN;
+ (NSString *)getPolicy;
+ (NSString *)getNotAfter;
+ (NSString *)getNotBefore;
+ (NSString *)getIssuer;
+ (unsigned char *)getCertValue;
+ (int)getCertLength;
+ (int)checkPassword:(char *)pPassword;
+ (NSString *)getSignature;
+ (NSString *)startSign;
+ (NSString *)startExportP12;
+ (int)startIssueCert:(NSString *)password;
+ (int)startUpdateCert;
+ (NSString *)getLastError;

@end