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
#define SERVER_URL      @"https://218.239.251.103:39190/servlet/"
#else
// 운영서버
#define SERVER_URL      @""
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

#pragma mark - 입출금 내역 스트링
#define INCOME_TYPE_STRING             @"입금"
#define WITHDRAW_TYPE_STRING           @"출금"

#endif
