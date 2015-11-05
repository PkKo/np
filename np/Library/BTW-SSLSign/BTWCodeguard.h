//
//  BTWCodeguard.h
//  Codeguard
//
//  Created by bluehoho on 11. 12. 7..
//  Copyright (c) 2011년 BTWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CODEGUARD_OK                0
#define CODEGUARD_ERROR             -1
#define CODEGUARD_INVALID_URL       1111
#define CODEGUARD_FINAL             2222

// statusCode
#define CG_STATUS_OK                0
#define CG_STATUS_UNKNOWN           -1
#define CG_STATUS_CONNECT_FAIL      101
#define CG_STATUS_TIMEOUT           102
#define CG_STATUS_SERVER_FAIL       110

@protocol CodeguardDelegate

/*
 * startCodeguard, requestAndGetToken에 대한 callback, 토큰발급이 완료되면 호출
 * return : 토큰
 */
- (void)onCompleteCodeguard:(NSString *)token;

/*
 * checkDeviceInfo에 대한 callback, 부정단말 검출시 호출
 * return : 차단여부 (YES : 차단, NO : 통과)
 */
- (void)onCompleteCheckDeviceInfo:(BOOL)isBloking;

@end

@interface Codeguard : NSObject

@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) NSString *appVer;
@property (nonatomic, retain) NSString *challengeRequestUrl;
@property (nonatomic, retain) NSString *deviceGuardUrl;
@property (nonatomic, assign) id<CodeguardDelegate> delegate;
@property (nonatomic, assign) BOOL encOption;                       /* default : NO */
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, assign) float timeOut;                        /* default : 10.0f */
@property (nonatomic, retain) NSString *etcData;
@property (nonatomic, assign) BOOL rootingCheck;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *rootingInfo;                /* @"0" : normal, other : jailbreak */
@property (nonatomic, assign) BOOL dnsLookupEnabled;                /* default : NO */

/*
 * 위변조 검사시 추가 검사할 파일 세팅
 */
@property (nonatomic, retain) NSArray *fileList;


+ (id)sharedInstance;
- (void)initialize;

//for web
- (int)parseURL:(NSString *)url;
- (NSString *)saveMyAppJobs;

//for cs
- (NSString *)saveMyAppJobs:(NSString *)strChallange;

//for token
- (void)startCodeguard;
- (void)cancelCodeguard;
- (NSString *)requestAndGetToken;

// check jailbreak;
+ (BOOL)isJailBroken;
+ (NSString *)checkRooting;

/*  works for Only TEST_MODE */
+ (BOOL)isSimulated;
+ (BOOL)checkSignerIdentity;
+ (BOOL)isDebugged;
- (NSString *)getSvrCertInfo;


/* 부정거래단말차단 API */

/*
 * 단말정보수집시 업무주소 세팅
 */
@property (nonatomic, retain) NSString *TranURL;

/*
 * 단말정보수집시 업무코드 세팅
 */
@property (nonatomic, retain) NSString *TranCODE;

/*
 * 단말정보수집시 ID 세팅
 */
@property (nonatomic, retain) NSString *userID;

/*
 * 부정단말차단 여부 리턴
 */
@property (nonatomic, assign) BOOL isBloking;

/*
 * 부정단말차단시 에러메시지 리턴
 */
@property (nonatomic, retain) NSString *errorMsg;

/*
 * 단말정보수집 리포트 인코딩 설정
 * default : kCFStringEncodingDOSKorean(cp949)
 * NSUTF8StringEncoding 등등 선택
 */
@property (nonatomic, assign) NSStringEncoding CHARSET;

/*
 * PID 세팅
 */
@property (nonatomic, retain) NSString *pid;

/*
 * 리포트 성공횟수 리턴
 */
@property (nonatomic, assign) int reportCount;

- (void)initDeviceInfo;
- (void)checkDeviceInfo;
- (void)requestTaskList;
- (void)resetDeviceInfo;

/*
 * FDS 수집 데이터 리턴 (JSON)
 */
- (NSString *)getFDSData;

@end

@interface  NSString(NSStringUtil)

- (NSString *)stringByUrlEncoding;
- (NSString *)stringByUrlDecoding;

@end
