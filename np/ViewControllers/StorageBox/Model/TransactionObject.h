//
//  TransactionObject.h
//  np
//
//  Created by Infobank2 on 9/23/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TRANS_MARK_AS_DELETED_NO    0
#define TRANS_MARK_AS_DELETED_YES   1

#define TRANS_ACTIVE_PIN_NO         0
#define TRANS_ACTIVE_PIN_YES        1

@interface TransactionObject : NSObject

@property (nonatomic, copy) NSString * transactionId;
@property (nonatomic, copy) NSDate * transactionDate;
@property (nonatomic, copy) NSString * transactionAccountNumber;
@property (nonatomic, copy) NSString * transactionAccountType;
@property (nonatomic, copy) NSString * transactionDetails;
@property (nonatomic, copy) NSString * transactionType;
@property (nonatomic, copy) NSNumber * transactionAmount;
@property (nonatomic, copy) NSNumber * transactionBalance;
@property (nonatomic, copy) NSString * transactionMemo;
@property (nonatomic, copy) NSNumber * transactionActivePin;
@property (nonatomic, copy) NSNumber * transactionMarkAsDeleted;

- (instancetype)initTransactionObjectWithTransactionId:(NSString *)transactionId
                                       transactionDate:(NSDate *)transactionDate
                              transactionAccountNumber:(NSString *)transactionAccountNumber
                                    transactionDetails:(NSString *)transactionDetails
                                       transactionType:(NSString *)transactionType
                                     transactionAmount:(NSNumber *)transactionAmount
                                    transactionBalance:(NSNumber *)transactionBalance
                                       transactionMemo:(NSString *)transactionMemo
                                  transactionActivePin:(NSNumber *)transactionActivePin;

- (instancetype)initTransactionObjectWithTransactionDate:(NSDate *)transactionDate
                                transactionAccountNumber:(NSString *)transactionAccountNumber
                                      transactionDetails:(NSString *)transactionDetails
                                         transactionType:(NSString *)transactionType
                                       transactionAmount:(NSNumber *)transactionAmount
                                       transactionBalance:(NSNumber *)transactionBalance
                                         transactionMemo:(NSString *)transactionMemo;

- (NSString *)formattedTransactionDate;
- (NSString *)formattedTransactionDateForDB;
- (NSString *)formattedTransactionAmount;
- (NSString *)formattedTransactionBalance;
- (NSString *)getTransactionHourMinute;

@end
