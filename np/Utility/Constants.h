//
//  Constants.h
//  httpserver
//
//  Created by Ko on 2015. 8. 18..
//  Copyright (c) 2015년 Infobank. All rights reserved.
//

#ifndef httpserver_Constants_h
#define httpserver_Constants_h

#define DEV_MODE        1

// server url 정보
#ifdef DEV_MODE
// 개발서버
#define SERVER_URL          @"https://218.239.251.103:39190/servlet/"
#define PUSH_APP_ID         @"8e08577a-6041-4b20-90ae-3017f9d4b5b4"
#define PUSH_APP_SECRET     @"8e08577a-6041-4b20-90ae-3017f9d4b5b4"
// cloud server
#define IPNS_ACCOUNT_HOST   @"133.130.97.64"
#define IPNS_INBOX_HOST     @"133.130.97.64"
/* 농협 개발서버 주소*/
//#define IPNS_ACCOUNT_HOST   @"218.239.251.112"
//#define IPNS_INBOX_HOST     @"218.239.251.113"
#else
// 운영서버
#define SERVER_URL          @""
#define PUSH_APP_ID         @""
#define PUSH_APP_SECRET     @""
#define IPNS_ACCOUNT_HOST   @""
#define IPNS_INBOX_HOST     @""
#endif

// 공인인증서 NH은행 실제 주소
#define NH_BANK_AUTH_URL    @"https://newsmart.nonghyup.com/so/jsp/btworks/roaming/getauth.jsp"
#define NH_BANK_CERT_URL    @"https://newsmart.nonghyup.com/so/jsp/btworks/roaming/getcert.jsp"

/*
*  System Versioning Preprocessor Macros
*/
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define STRING_DASH     @"-"
#define STRING_MASKING  @"****"

#define KEYCHAIN_ID     @"NHSMARTPUSH"

#define BUTTON_INDEX_CANCEL     0
#define BUTTON_INDEX_OK         1

#pragma mark Common
#define BUTTON_BGCOLOR_ENABLE       [UIColor colorWithRed:62.0f/255.0f green:155.0f/255.0f blue:233.0f/255.0f alpha:1.0f]
#define BUTTON_BGCOLOR_DISABLE      [UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1.0f]
#define CIRCLE_BACKGROUND_COLOR_SELECTED   [UIColor colorWithRed:48.0f/255.0f green:158.0f/255.0f blue:251.0f/255.0f alpha:1.0f]
#define CIRCLE_BACKGROUND_COLOR_UNSELECTED [UIColor colorWithRed:224.0f/255.0f green:225.0f/255.0f blue:230.0f/255.0f alpha:1.0f]
#define REFRESH_HEADER_HEIGHT   76.0f
#define SECTION_HEADER_HEIGHT   31.0f
#define SECTION_FOOTER_HEIGHT   93.0f
#define TIMELINE_BANKING_HEIGHT 117.0f
#define TIMELINE_ETC_HEIGHT     103.0f
#define TIMELINE_BANNER_HEIGHT  93.0f
#define AMOUNT_FONT_SIZE        20.0f
#define IPHONE_FIVE_FRAME_HEIGHT    568

#define TIMELINE_EVENT_TYPE     @"event_type"
#define TIMELINE_ACCOUNT_NUMBER @"account_number"
#define TIMELINE_TRN_AMT        @"trn_amt"
#define TIMELINE_TRN_AF_AMT     @"trn_af_amt"
#define TIMELINE_TXT_MSG        @"txt_msg"
#define TIMELINE_ACCOUNT_GB     @"account_gb"

// timeline에서 고정핀을 사용한 메시지 id
#define TIMELINE_PIN_MESSAGE_ID @"pinnedServerMessageId"

#pragma mark 입출금 내역 스트링
#define INCOME_TYPE_STRING             @"입금"
#define WITHDRAW_TYPE_STRING           @"출금"
#define INCOME_STRING_COLOR     [UIColor colorWithRed:29.0f/255.0f green:149.0f/255.0f blue:240.0f/255.0f alpha:1.0f]
#define WITHDRAW_STRING_COLOR   [UIColor colorWithRed:244.0f/255.0f green:96.0f/255.0f blue:124.0f/255.0f alpha:1.0f]

// 가입완료된 사용자 설정
#define IS_USER                 @"isUser"
// 간편보기 설정값
#define QUICK_VIEW_SETTING      @"quickViewSetting"

#pragma mark - API
// 통신 결과 값
#define RESULT                  @"result"
#define RESULT_SUCCESS          @"00000"
// 결과 메시지
#define RESULT_MESSAGE          @"resultMessage"

#pragma mark 앱버전 체크
// 앱 버전 체크
#define REQUEST_APP_VERSION         @"EFPU_INITAPP.cmd"
#define REQUEST_APP_VERSION_UUID    @"uuid"
#define REQUEST_APP_VERSION_APPVER  @"appVer"

#pragma mark 공인인증서 인증
// 공인인증서 인증
#define REQUEST_CERT                @"PMCNA100R.cmd"
#define REQUEST_CERT_LOGIN_TYPE     @"REQ_LOGINTYPE"
#define REQUEST_CERT_SSLSIGN_TBS    @"SSLSIGN_TBS_DATA"
#define REQUEST_CERT_SSLSIGN_SIGNATURE  @"SSLSIGN_SIGNATURE"
// crm 휴대폰 번호
#define RESPONSE_CERT_CRM_MOBILE    @"crmMobile"
// ums id
#define RESPONSE_CERT_UMS_USER_ID   @"umsUserId"
// 인터넷뱅킹 id
#define RESPONSE_CERT_IB_USER_ID    @"ibUserId"
// 주민등록번호
#define RESPONSE_CERT_RLNO          @"rlno"
// 전체 계좌번호
#define RESPONSE_CERT_ACCOUNT_LIST  @"accountAllRecords"

#pragma mark 휴대폰 인증번호 발송
#define REQUEST_PHONE_AUTH          @"EFPUW031001.cmd"
#define REQUEST_PHONE_AUTH_NUMBER   @"receiver"
#define RESPONSE_PHONE_AUTH_CODE    @"randomCode"

#pragma mark 최근 공지사항 1건
#define REQUEST_RECENT_NOTICE       @"SBAB1010First.cmd"

#pragma mark 가입 플로우 관련
// 인증방식 저장(공인인증서 or 계좌)
#define REGIST_TYPE                     @"RegistType"
#define REGIST_TYPE_CERT                @"RegistCert"
#define REGIST_TYPE_ACCOUNT             @"RegistAccount"


#define TEXT_FIELD_BORDER_COLOR [[UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1] CGColor]

#define TRANS_ALL_ACCOUNT  @"전체계좌"

#define TRANS_TYPE_GENERAL @"입출금"
#define TRANS_TYPE_INCOME  @"입금"
#define TRANS_TYPE_EXPENSE @"출금"

//@"최신순", @"과거순"
#define TIME_ACSENDING_ORDER    @"과거순"
#define TIME_DECSENDING_ORDER   @"최신순"

#define REQUEST_LOGIN_CERT                               @"EFPU1011R.cmd"
#define REQUEST_LOGIN_ACCOUNT                            @"EFPU1012R.cmd"
#define REQUEST_LOGIN_PINPAT                             @"EFPU1013R.cmd"

#define PREF_KEY_SIMPLE_LOGIN_SETT_PW               @"simpleLoginSettingsKeyPW"
#define PREF_KEY_SIMPLE_LOGIN_SETT_FAILED_TIMES     @"simpleLoginSettingsKeyFailedTimes"

#define PREF_KEY_PATTERN_LOGIN_SETT_PW              @"patternLoginSettingsKeyPW"
#define PREF_KEY_PATTERN_LOGIN_SETT_FAILED_TIMES    @"patternLoginSettingsKeyFailedTimes"

#define PREF_KEY_ACCOUNT_LOGIN_SETT_FAILED_TIMES    @"accountLoginSettingsKeyFailedTimes"

#define PREF_KEY_ALL_ACCOUNT                        @"AllAccounts"
#define PREF_KEY_CERT_TO_LOGIN                      @"certificateToLogin"
#define PREF_KEY_CERT_LOGIN_SETT_FAILED_TIMES       @"certLoginSettingsKeyFailedTimes"

#define PREF_KEY_LOGIN_METHOD                       @"loginMethodKey"
typedef enum LoginMethod {
    LOGIN_BY_NONE,
    LOGIN_BY_ACCOUNT,
    LOGIN_BY_CERTIFICATE,
    LOGIN_BY_SIMPLEPW,
    LOGIN_BY_PATTERN
} LoginMethod;

#define PREF_KEY_NOTICE_BACKGROUND_COLOUR        @"noticeBackgroundColour"

#define ALERT_GOTO_SELF_IDENTIFY    100
#define ALERT_DO_NOTHING            0
#define ALERT_SUCCEED_SAVE          1


#endif
