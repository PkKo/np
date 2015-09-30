//
//  TransactionObject.h
//  np
//
//  Created by Infobank2 on 9/23/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionObject : NSObject

@property (nonatomic, copy) NSDate * transactionDate;
@property (nonatomic, copy) NSString * transactionAccountNumber;
@property (nonatomic, copy) NSString * transactionDetails;
@property (nonatomic, copy) NSString * transactionType;
@property (nonatomic, copy) NSNumber * transactionAmount;
@property (nonatomic, copy) NSNumber * transactionBalance;
@property (nonatomic, copy) NSString * transactionMemo;

- (instancetype)initTransactionObjectWithTransactionDate:(NSDate *)transactionDate
                                transactionAccountNumber:(NSString *)transactionAccountNumber
                                      transactionDetails:(NSString *)transactionDetails
                                         transactionType:(NSString *)transactionType
                                       transactionAmount:(NSNumber *)transactionAmount
                                       transactionBalance:(NSNumber *)transactionBalance
                                         transactionMemo:(NSString *)transactionMemo;

- (NSString *)formattedTransactionDate;
- (NSString *)formattedTransactionAmount;
- (NSString *)formattedTransactionBalance;
- (NSString *)getTransactionHourMinute;

@end
