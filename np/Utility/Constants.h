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
#if DEV_MODE
// 개발서버
//#define SERVER_URL          @"https://218.239.251.103:39190/"
#define SERVER_URL          @"https://smartdev.nonghyup.com:39190/"
// 스테이징
//#define SERVER_URL          @"https://smartdev.nonghyup.com:9190/"
//@"https://"
#define PUSH_APP_ID         @"8e08577a-6041-4b20-90ae-3017f9d4b5b4"
#define PUSH_APP_SECRET     @"8e08577a-6041-4b20-90ae-3017f9d4b5b4"
// cloud server
//#define IPNS_ACCOUNT_HOST   @"133.130.97.64"
//#define IPNS_INBOX_HOST     @"133.130.97.64"
/* 농협 개발서버 주소*/
#define IPNS_ACCOUNT_HOST   @"218.239.251.112"
#define IPNS_INBOX_HOST     @"218.239.251.113"
#else
// 운영서버
#define SERVER_URL          @"https://umspush.nonghyup.com/"
#define PUSH_APP_ID         @"8e08577a-6041-4b20-90ae-3017f9d4b5b4"
#define PUSH_APP_SECRET     @"8e08577a-6041-4b20-90ae-3017f9d4b5b4"
//#define IPNS_ACCOUNT_HOST   @"61.42.212.61"
#define IPNS_ACCOUNT_HOST   @"umspuships.nonghyup.com"
#define IPNS_INBOX_HOST     @""
#endif

#define IPNS_INBOX_IMAGE    [NSString stringWithFormat:@"http://%@:7104/FT_IMG/", IPNS_ACCOUNT_HOST]

// 공인인증서 NH은행 실제 주소
#define NH_BANK_AUTH_URL    @"https://newsmart.nonghyup.com/so/jsp/btworks/roaming/getauth.jsp"
#define NH_BANK_CERT_URL    @"https://newsmart.nonghyup.com/so/jsp/btworks/roaming/getcert.jsp"

#define APP_STORE_APP_URL               @"https://itunes.apple.com/us/app/nh-seumateu-allim/id1084588831?ls=1&mt=8"
#define APP_STORE_APP_VERSION_CHECK_URL @"http://itunes.apple.com/lookup?id=1084588831"
#define NONG_MIN_NEWS_URL               @"http://www.nongmin.com/xml/app_push/ar_xml_all.xml"

/*
*  System Versioning Preprocessor Macros
*/
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#define IS_IPAD             (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA           ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH        ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT       ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH   (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH   (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5         (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6         (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P        (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define NONGMIN_BANNER_IMAGE_URL        @"content/images/front/common/nongmin_banner.jpg"
#define SNS_SHARE_IMAGE_URL             @"content/images/front/common/logo_ios144px.png"

#define STRING_DASH     @"-"
#define STRING_MASKING  @"****"

#define KEYCHAIN_ID     @"NHSMARTPUSH"

#define BUTTON_INDEX_CANCEL     0
#define BUTTON_INDEX_OK         1

#pragma mark Common
#define BUTTON_BGCOLOR_ENABLE       [UIColor colorWithRed:62.0f/255.0f green:155.0f/255.0f blue:233.0f/255.0f alpha:1.0f]
#define BUTTON_BGCOLOR_DISABLE      [UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1.0f]
#define CIRCLE_BACKGROUND_COLOR_SELECTED    [UIColor colorWithRed:48.0f/255.0f green:158.0f/255.0f blue:251.0f/255.0f alpha:1.0f]
#define CIRCLE_BACKGROUND_COLOR_UNSELECTED  [UIColor colorWithRed:224.0f/255.0f green:225.0f/255.0f blue:230.0f/255.0f alpha:1.0f]
#define CIRCLE_TEXT_COLOR_UNSELECTED        [UIColor colorWithRed:144.0f/255.0f green:145.0f/255.0f blue:150.0f/255.0f alpha:1.0f]
#define REFRESH_HEADER_HEIGHT   76.0f
#define SECTION_HEADER_HEIGHT   31.0f
#define SECTION_FOOTER_HEIGHT   93.0f
#define TIMELINE_BANKING_HEIGHT 117.0f
#define TIMELINE_ETC_HEIGHT     115.0f
#define TIMELINE_ETC_NOTICE_HEIGHT  80.0f
#define TIMELINE_BANNER_HEIGHT  93.0f
#define AMOUNT_FONT_SIZE        20.0f
#define IPHONE_FIVE_FRAME_HEIGHT    568

#define TIMELINE_LOAD_COUNT     20
#define TIMELINE_EVENT_TYPE     @"event_type"
#define TIMELINE_ACCOUNT_NUMBER @"account_number"
#define TIMELINE_TRN_AMT        @"trn_amt"
#define TIMELINE_TRN_AF_AMT     @"trn_af_amt"
#define TIMELINE_TXT_MSG        @"txt_msg"
#define TIMELINE_ACCOUNT_GB     @"account_gb"

// timeline에서 고정핀을 사용한 메시지 id
#define TIMELINE_PIN_MESSAGE_ID @"pinnedServerMessageId"
// 계좌별칭
#define ACCOUNT_NICKNAME_DICTIONARY     @"accountNicknameDictionary"
// 레이어 팝업 seq
#define LAYER_POPUP_SEQ_ENDDATE         @"layerPopupEndDate"
#define FIRST_LOGIN_FLAG_FOR_TIMELINE   @"firstTimeline"
#define FIRST_LOGIN_FLAG_FOR_STORAGE    @"firstStorage"

#pragma mark 입출금 내역 스트링
#define INCOME_STRING_COLOR     [UIColor colorWithRed:36.0f/255.0f green:132.0f/255.0f blue:199.0f/255.0f alpha:1.0f]
#define WITHDRAW_STRING_COLOR   [UIColor colorWithRed:222.0f/255.0f green:69.0f/255.0f blue:98.0f/255.0f alpha:1.0f]
#define STROKE_LINE_COLOR       [UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1.0f]

// 가입완료된 사용자 설정
#define IS_USER                 @"isUser"
// 간편보기 설정값
#define QUICK_VIEW_SETTING      @"quickViewSetting"

#pragma mark - API
// 통신 결과 값
#define RESULT                      @"result"
#define RESULT_SUCCESS              @"00000"
#define RESULT_SUCCESS_ZERO         @"0"
#define RESULT_PIN_EXCEED_5_TIMES   @"EFPU99205"
#define RESULT_PAT_EXCEED_5_TIMES   @"EFPU99305"

// 결과 메시지
#define RESULT_MESSAGE          @"resultMessage"
#define RESULT_MESSAGE2          @"resultMessage2"

#pragma mark 앱버전 체크
// 앱 버전 체크
#define REQUEST_APP_VERSION         @"servlet/EFPU0000R.cmd"
#define REQUEST_APP_SESSION_REFRESH @"servlet/EFPU0001R.cmd"
#define REQUEST_APP_VERSION_UUID    @"uuid"
#define REQUEST_APP_VERSION_APPVER  @"appVer"

#pragma mark 공인인증서 인증
// 공인인증서 인증
#define REQUEST_CERT                    @"servlet/EFPU1001R.cmd"
#define REQUEST_CERT_LOGIN_TYPE         @"REQ_LOGINTYPE"
#define REQUEST_CERT_SSLSIGN_TBS        @"SSLSIGN_TBS_DATA"
#define REQUEST_CERT_SSLSIGN_SIGNATURE  @"SSLSIGN_SIGNATURE"
// crm 휴대폰 번호
#define REQUEST_CERT_CRM_MOBILE     @"mobile_number"
#define RESPONSE_CERT_CRM_MOBILE    @"crmMobile"
// ums id
#define RESPONSE_CERT_UMS_USER_ID   @"umsUserId"
// 인터넷뱅킹 id
#define RESPONSE_CERT_IB_USER_ID    @"ibUserId"
// 주민등록번호
#define RESPONSE_CERT_RLNO          @"resident_no"
// 전체 계좌번호
#define RESPONSE_CERT_ACCOUNT_LIST  @"list"
// 고객명
#define RESPONSE_CERT_USER_NAME     @"user_name"

#pragma mark 계좌 인증
// 계좌 인증
#define REQUEST_ACCOUNT             @"servlet/EFPU1002R.cmd"
// 계좌번호
#define REQUEST_ACCOUNT_NUMBER      @"account_number"
// 계좌 비밀번호
#define REQUEST_ACCOUNT_PASSWORD    @"account_password"
// 생년월일
#define REQUEST_ACCOUNT_BIRTHDAY    @"user_birthday"
// 계좌번호 검증
#define REQUEST_ACCOUNT_CHECK       @"servlet/EFPU1032R.cmd"

#pragma mark 휴대폰 인증번호 발송
#define REQUEST_PHONE_AUTH          @"servlet/EFPUW031001.cmd"
#define REQUEST_PHONE_AUTH_NUMBER   @"receiver"
#define RESPONSE_PHONE_AUTH_CODE    @"randomCode"

#pragma mark 가입된 계좌 목록 조회
#define REQUEST_REGIST_ACCOUNT_LIST         @"servlet/EFPUD060101.cmd"

#pragma mark 계좌 알림 옵션 조회
#define REQUEST_NOTI_OPTION_SEARCH          @"servlet/EFPUW022001.cmd"
// 주민등록번호
#define REQUEST_NOTI_OPTION_SEARCH_RLNO     @"resident_number"
// 계좌번호
#define REQUEST_NOTI_OPTION_SEARCH_ACNO     @"account_number"

#define RESPONSE_NOTI_OPTION_SEARCH_ACNO    @"UMSW022001_OUT_SUB.account_number"
#define RESPONSE_NOTI_OPTION_SEARCH_RPID    @"UMSW022001_OUT_SUB.receipts_payment_id"
#define RESPONSE_NOTI_OPTION_SEARCH_EVENT_TYPE  @"UMSW022001_OUT_SUB.noti_event_type"
#define RESPONSE_NOTI_OPTION_SEARCH_PRICE       @"UMSW022001_OUT_SUB.noti_price"
#define RESPONSE_NOTI_OPTION_SEARCH_TIME_FLAG   @"UMSW022001_OUT_SUB.noti_time_flag"
#define RESPONSE_NOTI_OPTION_SEARCH_UNNOTI_ST   @"UMSW022001_OUT_SUB.unnoti_starttime"
#define RESPONSE_NOTI_OPTION_SEARCH_UNNOTI_ET   @"UMSW022001_OUT_SUB.unnoti_endtime"
#define RESPONSE_NOTI_OPTION_SEARCH_BALANCE_FLAG    @"UMSW022001_OUT_SUB.moneyview_flag"
#define RESPONSE_NOTI_OPTION_SEARCH_AUTO_FLAG       @"UMSW022001_OUT_SUB.noti_auto_flag"
#define RESPONSE_NOTI_OPTION_SEARCH_PERIOD_TYPE     @"UMSW022001_OUT_SUB.noti_period_type"
#define RESPONSE_NOTI_OPTION_SEARCH_NOTI_TIME_ONE   @"UMSW022001_OUT_SUB.noti_time1"
#define RESPONSE_NOTI_OPTION_SEARCH_NOTI_TIME_TWO   @"UMSW022001_OUT_SUB.noti_time2"
#define RESPONSE_NOTI_OPTION_SEARCH_NOTI_TIME_THREE @"UMSW022001_OUT_SUB.noti_time3"

#pragma mark 계좌 알림 옵션 설정
// 가입시
#define REQUEST_NOTI_OPTION                 @"servlet/EFPU1009R.cmd"
// 기존 계좌 알림 수정
#define REQUEST_NOTI_OPTION_SET             @"servlet/EFPUW022004.cmd"
// 신규 계좌 추가 알림 설정
#define REQUEST_NOTI_OPTION_NEW_SET         @"servlet/EFPUD020001.cmd"
//////////////////////////////////////////////////////////////////

#define MAX_NUM_OF_SELECTED_ACCOUNT         3
#define REQUEST_NOTI_OPTION_ACCOUNT_NUMBER  @"account_number"
#define REQUEST_NOTI_OPTION_RECEIPTS_ID     @"receipts_payment_id"
#define REQUEST_NOTI_OPTION_EVENT_TYPE      @"noti_event_type"
#define REQUEST_NOTI_OPTION_PRICE           @"noti_price"
#define REQUEST_NOTI_OPTION_TIME_FLAG       @"noti_time_flag"
#define REQUEST_NOTI_OPTION_UNNOTI_ST       @"unnoti_st"
#define REQUEST_NOTI_OPTION_UNNOTI_ET       @"unnoti_et"
#define REQUEST_NOTI_OPTION_BALANCE_FLAG    @"moneyview_flag"
#define REQUEST_NOTI_OPTION_AUTO_FLAG       @"noti_auto_flag"
#define REQUEST_NOTI_OPTION_PERIOD_TYPE     @"noti_period_type"
#define REQUEST_NOTI_OPTION_NOTI_TIME_ONE   @"noti_time1"
#define REQUEST_NOTI_OPTION_NOTI_TIME_TWO   @"noti_time2"
#define REQUEST_NOTI_OPTION_NOTI_TIME_THREE @"noti_time3"
///////////////////////////////////////////////////////////////////
// 계좌 삭제 요청
#define REQUEST_NOTI_ACCOUNT_DELETE         @"servlet/EFPUD030001.cmd"

#pragma mark 환율 설정
// 환율 국가 목록
#define REQUEST_EXCHANGE_CURRENCY_ALL_COUNTRY           @"servlet/EFPUW023004L.cmd"
// 푸시서비스 가입한 환율 서비스 목록
#define REQUEST_EXCHANGE_CURRENCY_REG_COUNTRY           @"servlet/EFPUW023001L.cmd"
// 대상 국가 옵션 조회
#define REQUEST_EXCHANGE_CURRENCY_COUNTRY_OPION         @"servlet/EFPUW023001S.cmd"
#define REQUEST_EXCHANGE_CURRENCY_NATION_ID             @"nation_id"
#define RESPONSE_EXCHANGE_CURRENCY_EXCHANGE_RATE_ID     @"exchange_rate_id"
// 대상 국가 추가
#define REQUEST_EXCHANGE_CURRENCY_ADD_COUNTRY           @"servlet/EFPUW023005A.cmd"
// 대상 국가 옵션 변경
#define REQUEST_EXCHANGE_CURRENCY_CHANGE_OPTION         @"servlet/EFPUW023006E.cmd"
// 유료 알림 무료 전환
#define REQUEST_EXCHANGE_CHARGE_COUNTRY                 @"servlet/EFPUW023006E.cmd"
// 환율 알림 취소
#define REQEUST_EXCHANGE_CURRENCY_COUNTRY_DELETE        @"servlet/EFPUW023003S.cmd"

#pragma mark 최근 공지사항 1건
#define REQUEST_RECENT_NOTICE       @"servlet/EFPU2013R.cmd"
#pragma mark 배너정보 조회
#define REQUEST_BANNER_INFO         @"servlet/EFPU3011R.cmd"

#pragma mark - 가입 플로우 관련
// 인증방식 저장(공인인증서 or 계좌)
#define REGIST_TYPE                     @"RegistType"
#define REGIST_TYPE_CERT                @"RegistCert"
#define REGIST_TYPE_ACCOUNT             @"RegistAccount"


#define TEXT_FIELD_BORDER_COLOR                     [[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1] CGColor]
#define TEXT_FIELD_BORDER_COLOR_FOR_LOGIN_NOTICE    [[UIColor colorWithRed:51.0f/255.0f green:132.0f/255.0f blue:194.0f/255.0f alpha:1] CGColor]


#define TRANS_ALL_ACCOUNT  @"전체계좌"

#define TRANS_TYPE_GENERAL          @"입출금"
#define TRANS_TYPE_INCOME           @"입금"
#define TRANS_TYPE_INCOME_MODIFY    @"입금정정"
#define TRANS_TYPE_INCOME_CANCEL    @"입금취소"
#define TRANS_TYPE_EXPENSE          @"출금"
#define TRANS_TYPE_EXPENSE_MODIFY   @"출금정정"
#define TRANS_TYPE_EXPENSE_CANCEL   @"출금취소"
#define TRANS_TYPE_ETC              @""


//@"최신순", @"과거순"
#define TIME_ACSENDING_ORDER    @"과거순"
#define TIME_DECSENDING_ORDER   @"최신순"

#define REQUEST_LATEST_TERMS_OF_USE                 @"servlet/EFPU1017U.cmd"
#define REQUEST_LOGIN_CERT                          @"servlet/EFPU1011R.cmd"
#define REQUEST_LOGIN_CERT_VERIFY                   @"servlet/EFPU1021R.cmd"
#define REQUEST_LOGIN_ACCOUNT                       @"servlet/EFPU1012R.cmd"
#define REQUEST_LOGIN_ACCOUNT_VERIFY                @"servlet/EFPU1022R.cmd"
#define REQUEST_LOGIN_PINPAT                        @"servlet/EFPU1013R.cmd"
#define REQUEST_LOGIN_PINPAT_RESET                  @"servlet/EFPU1013E.cmd"
#define REQUEST_SERVICE_DEACTIVATION                @"servlet/EFPUD040001.cmd"
#define REQUEST_RESET_DATA                          @"servlet/EFPU1099E.cmd"

#define NOTIFICATION_REFRESH_BADGES                 @"notificationRefreshBadges"

#define PREF_KEY_SIMPLE_LOGIN_PW_EXIST              @"hasSimpleLoginSettingsKeyPW"
#define PREF_KEY_SIMPLE_LOGIN_SETT_PW               @"simpleLoginSettingsKeyPW"
#define PREF_KEY_SIMPLE_LOGIN_SETT_FAILED_TIMES     @"simpleLoginSettingsKeyFailedTimes"

#define PREF_KEY_PATTERN_LOGIN_PW_EXIST             @"hasPatternLoginSettingsKeyPW"
#define PREF_KEY_PATTERN_LOGIN_SETT_PW              @"patternLoginSettingsKeyPW"
#define PREF_KEY_PATTERN_LOGIN_SETT_FAILED_TIMES    @"patternLoginSettingsKeyFailedTimes"

#define PREF_KEY_ACCOUNT_LOGIN_SETT_FAILED_TIMES    @"accountLoginSettingsKeyFailedTimes"

#define PREF_KEY_ALL_ACCOUNT                        @"AllAccounts"
#define PREF_KEY_ALL_TRANS_ACCOUNT                  @"AllTransAccounts"

#define PREF_KEY_CERT_TO_LOGIN                      @"certificateToLogin"
#define PREF_KEY_CERT_LOGIN_SETT_FAILED_TIMES       @"certLoginSettingsKeyFailedTimes"

#define PREF_KEY_LATEST_APP_VERSION                 @"latestAppVersion"
#define PREF_KEY_LOGIN_STATUS                       @"loginStatus"
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

typedef enum SIMPLE_VIEW_TYPE {
    SIMPLE_VIEW_TYPE_PUSH = 1,
    SIMPLE_VIEW_TYPE_NOTI = 2
} SIMPLE_VIEW_TYPE;


typedef enum AccountType
{
    REGISTERED = 0,
    // 입출금(요구불)
    NORMAL = 1,
    // 외화(요구불)
    EXCHANGE,
    // 수익증권
    FUND,
    // 신탁
    TRUST
}AccountType;

#define ACCOUNT_TYPE_DESCRIPTION [NSArray arrayWithObjects:@"입출금알림(PUSH) 기등록 계좌", @"입출식 계좌", @"외화 입출식 계좌", @"수입증권 계좌", @"신탁 계좌", nil]



#endif
