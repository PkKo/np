//
//  CertLoader.h
//  HanaBankPBK
//
//  Created by bluehoho on 11. 10. 20..
//  Copyright (c) 2011년 HanaBank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CertLoadOption;

@interface CertLoader : NSObject

+ (NSMutableArray *)getCertInfoArray;
+ (NSMutableArray *)getCertInfoArray:(CertLoadOption *)option;

//Support for HanaBank
+ (NSMutableArray *)getCertControlArray;

@end

@interface CertLoadOption : NSObject

@property (nonatomic) BOOL yessignList;     // 금결원
@property (nonatomic) BOOL signgateList;    // 정보인증
@property (nonatomic) BOOL signkoreaList;   // 코스콤
@property (nonatomic) BOOL crosssignList;   // 전자인증
@property (nonatomic) BOOL tradesignList;   // 무역정보
@property (nonatomic) BOOL ncasignList;     // 구 전산원
@property (nonatomic, retain) NSString *caName;       // 기타 인증서

@property (nonatomic, retain) NSString *certSerials;    // using delimiter "|"

@end