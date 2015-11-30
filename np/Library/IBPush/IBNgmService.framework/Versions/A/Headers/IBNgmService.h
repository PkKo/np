//
//  IBNgmService.h
//  IBNgmService
//
//  Created by soulkey on 12. 9. 18..
//  Copyright (c) 2012년 Infobank Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IBPush.h"
#import "IBInbox.h"
#import "IBNgmProtocol.h"

#define REQUEST_MESSAGE_MAXCOUNT	100
#define REQUEST_MESSAGE_ASCENDING	NO
#define DEFAULT_COUNTRY_CODE        82

typedef enum EN_SERVICE_RESPONSE_CODE
{
	ServiceResponseCodeNone							= 0,		// 에러 없음
	ServiceResponseCodeRequestFail					= 10001,	// 서버 요청 실패
	ServiceResponseCodeInternalError,							// 서버 장애 발생이거나 통신이 원활하지 않음
	ServiceResponseCodeServiceRepair,							// 서비스 점검
	ServiceResponseCodeAuthenticateFail,						// 서비스 인증 실패
	ServiceResponseCodeRequiredParameter,						// 기본 App 정보 값이 존재하지 않음
	ServiceResponseCodeInvalidParameter,						// 서버 요청 시 필요 파라미터 값이 존재하지 않음
	ServiceResponseCodeInvalidToken,							// 토큰 오류(Expire 포함)
	ServiceResponseCodeFileUploadFail,							// 파일 업로드 실패
	ServiceResponseCodeFileDownloadFail,						// 파일 다운로드 실패
	ServiceResponseCodeExceedFileUploadCount,					// 업로드 파일 개수 초과
	ServiceResponseCodeNotRegisteredMoRecipientNum,				// 등록되지 않은 번호
} ServiceResponseCode;

typedef enum INBOX_READ_METHOD
{
    ReadMethodByNoti = 1,
    ReadMethodByInbox = 2
} InboxReadMethod;

extern NSString * const IBNgmServiceInfoAppIdKey;
extern NSString * const IBNgmServiceInfoAppSecretKey;
extern NSString * const IBNgmServiceInfoThirdAccountKey;
extern NSString * const IBNgmServiceInfoApnsSoundKey;
extern NSString * const IBNgmServiceInfoNetWorkIndicatorOptKey;
extern NSString * const IBNgmServiceInfoLaunchOptsKey;
extern NSString * const IBNgmServiceInfoAccountId;
extern NSString * const IBNgmServiceInfoVerifyCode;
extern NSString * const IBNgmServiceInfoCountryCode;
extern NSString * const IBNgmServiceInfoPhoneNumber;
extern NSString * const IBNgmServiceInfoAdditionalInfo;

@interface IBNgmService : NSObject
{
	NSString	* appId;
	NSString	* appSecret;
    NSString    * accountId;
    NSData      * verifyCode;
}

@property (nonatomic, readonly)	BOOL		pushEnabled;

@property (nonatomic, readonly)	NSString	* appId;
@property (nonatomic, readonly)	NSString	* appSecret;
@property (nonatomic, readonly) NSString    * accountId;
@property (nonatomic, readonly) NSData      * verifyCode;

@property (nonatomic, readonly) NSString	* apnsDeviceToken;

@property (nonatomic)           BOOL        useCustomAddress;
@property (nonatomic, weak)     NSString    * accountServAddr;
@property (nonatomic)           int         portNum;

//////////////////////////////////////////////////////////////////////////////
//								Singleton									//
//////////////////////////////////////////////////////////////////////////////

+ (IBNgmService *)sharedInstance;

//////////////////////////////////////////////////////////////////////////////
//								Open API									//
//////////////////////////////////////////////////////////////////////////////

+ (BOOL)startServiceWithApplicationInfo:(NSDictionary *)appInfo;
+ (void)stopService;
+ (BOOL)registerUser:(NSDictionary *)userInfo;
+ (BOOL)registerUserWithAccountId:(NSString *)accountId verifyCode:(NSData *)verifyCode;
+ (BOOL)registerUserWithAccountId:(NSString *)accountId verifyCode:(NSData *)verifyCode phoneNumber:(NSString *)phoneNumber;
+ (BOOL)registerUserWithAccountId:(NSString *)accountId verifyCode:(NSData *)verifyCode countryCode:(int)countryCode phoneNumber:(NSString *)phoneNumber;

+ (void)setNgmServiceReceiver:(id)listener;

+ (BOOL)getApnsAllow;
+ (void)setApnsAllow:(BOOL)allow;
+ (void)setAdditionalInfo:(NSDictionary *)additionalInfo;

+ (NSString *)libVersion;

@end
