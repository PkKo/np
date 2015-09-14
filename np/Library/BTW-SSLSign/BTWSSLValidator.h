//
//  BTWSSLValidator.h
//  BTW-SSLSign
//
//  Created by btworks on 2014. 10. 8..
//  Copyright (c) 2014년 BTWorks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTWSSLValidatorDelegate <NSObject>

/*
 * verifySSLConnection에 대한 callback, 검증실패시 호출
 * return : 에러코드
 * 2101 : hostname 불일치
 * 2102 : 서버인증서 불일치
 * 2103 : 서버 연결 실패
 * 2104 : 타임아웃
 */
- (void)onValidateSSLConnectionFailed:(NSUInteger)errorCode;

@end

@interface BTWSSLValidator : NSObject

/*
 *  serverURL : 서버주소 (예 : "https://banking.example.com")
 */
@property (nonatomic, retain) NSString *serverURL;
@property (nonatomic, assign) id<BTWSSLValidatorDelegate> delegate;
@property (nonatomic, assign) NSUInteger statusCode;
@property (nonatomic, assign) BOOL noti_Flag;

/*
 * SSL 검증
 */
- (void)validateSSLConnection;


+ (id)sharedInstance;
+ (void)killInstance;

@end
