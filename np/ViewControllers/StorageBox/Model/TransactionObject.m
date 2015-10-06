//
//  TransactionObject.m
//  np
//
//  Created by Infobank2 on 9/23/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "TransactionObject.h"
#import "StatisticMainUtil.h"

@implementation TransactionObject

- (instancetype)init {
    
    self = [super init];
    
    if (self != nil) {
        self.transactionMarkAsDeleted   = TRANS_MARK_AS_DELETED_NO;
    }
    
    return self;
}

- (instancetype)initTransactionObjectWithTransactionId:(NSDate *)transactionId
                                       transactionDate:(NSDate *)transactionDate
                              transactionAccountNumber:(NSString *)transactionAccountNumber
                                    transactionDetails:(NSString *)transactionDetails
                                       transactionType:(NSString *)transactionType
                                     transactionAmount:(NSNumber *)transactionAmount
                                    transactionBalance:(NSNumber *)transactionBalance
                                       transactionMemo:(NSString *)transactionMemo {
    self = [super init];
    if (self != nil) {
        self.transactionId              = transactionId;
        self.transactionDate            = transactionDate;
        self.transactionAccountNumber   = transactionAccountNumber;
        self.transactionDetails         = transactionDetails;
        self.transactionType            = transactionType;
        self.transactionAmount          = transactionAmount;
        self.transactionBalance         = transactionBalance;
        self.transactionMemo            = transactionMemo;
        self.transactionMarkAsDeleted   = TRANS_MARK_AS_DELETED_NO;
    }
    return self;
}

- (instancetype)initTransactionObjectWithTransactionDate:(NSDate *)transactionDate
                                transactionAccountNumber:(NSString *)transactionAccountNumber
                                      transactionDetails:(NSString *)transactionDetails
                                         transactionType:(NSString *)transactionType
                                       transactionAmount:(NSNumber *)transactionAmount
                                      transactionBalance:(NSNumber *)transactionBalance
                                         transactionMemo:(NSString *)transactionMemo {
    self = [super init];
    if (self != nil) {
        self.transactionDate            = transactionDate;
        self.transactionAccountNumber   = transactionAccountNumber;
        self.transactionDetails         = transactionDetails;
        self.transactionType            = transactionType;
        self.transactionAmount          = transactionAmount;
        self.transactionBalance         = transactionBalance;
        self.transactionMemo            = transactionMemo;
        self.transactionMarkAsDeleted   = TRANS_MARK_AS_DELETED_NO;
    }
    return self;
}

- (NSString *)formattedTransactionDate {
    return [[StatisticMainUtil getDateFormatterDateHourMinuteStyle] stringFromDate:self.transactionDate];
}

- (NSString *)formattedTransactionAmount {
    return [NSString stringWithFormat:@"%@원", [[StatisticMainUtil getNumberFormatter] stringFromNumber:[NSNumber numberWithFloat:[self.transactionAmount floatValue]]]];
}

- (NSString *)formattedTransactionBalance {
    return [NSString stringWithFormat:@"%@원", [[StatisticMainUtil getNumberFormatter] stringFromNumber:[NSNumber numberWithFloat:[self.transactionBalance floatValue]]]];
}

- (NSString *)getTransactionHourMinute {
    return [[StatisticMainUtil getDateFormatterHourMinuteStyle] stringFromDate:self.transactionDate];
}



@end
