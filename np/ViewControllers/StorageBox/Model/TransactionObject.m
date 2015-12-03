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
        self.transactionActivePin       = [NSNumber numberWithBool:TRANS_ACTIVE_PIN_YES];
        self.transactionMarkAsDeleted   = TRANS_MARK_AS_DELETED_NO;
    }
    
    return self;
}

- (instancetype)initTransactionObjectWithTransactionId:(NSString *)transactionId
                                       transactionDate:(NSDate *)transactionDate
                              transactionAccountNumber:(NSString *)transactionAccountNumber
                                transactionAccountType:(NSString *)transactionAccountType
                                    transactionDetails:(NSString *)transactionDetails
                                       transactionType:(NSString *)transactionType
                                     transactionAmount:(NSNumber *)transactionAmount
                                    transactionBalance:(NSNumber *)transactionBalance
                                          currencyUnit:(NSString *)currencyUnit
                                       transactionMemo:(NSString *)transactionMemo
                                  transactionActivePin:(NSNumber *)transactionActivePin {
    self = [super init];
    if (self != nil) {
        self.transactionId              = transactionId;
        self.transactionDate            = transactionDate;
        self.transactionAccountNumber   = transactionAccountNumber;
        self.transactionAccountType     = transactionAccountType;
        self.transactionDetails         = transactionDetails;
        self.transactionType            = transactionType;
        self.transactionAmount          = transactionAmount;
        self.transactionBalance         = transactionBalance;
        self.currencyUnit               = currencyUnit;
        self.transactionMemo            = transactionMemo;
        self.transactionActivePin       = transactionActivePin;
        self.transactionMarkAsDeleted   = TRANS_MARK_AS_DELETED_NO;
    }
    return self;
}

- (NSString *)getMaskingTransactionAccountNumber {
    return [CommonUtil getMaskingNumber:self.transactionAccountNumber];
}

- (NSString *)formattedTransactionDate {
    return [[StatisticMainUtil getDateFormatterDateHourMinuteStyle] stringFromDate:self.transactionDate];
}

- (NSString *)formattedTransactionDateForDB {
    return [[StatisticMainUtil getDateFormatterDateHourStyle] stringFromDate:self.transactionDate];
}


- (NSString *)formattedTransactionAmount {
    return [[StatisticMainUtil getNumberFormatter] stringFromNumber:[NSNumber numberWithDouble:[self.transactionAmount doubleValue]]];
}

- (NSString *)formattedTransactionBalance {
    return [NSString stringWithFormat:@"잔액 %@%@", [[StatisticMainUtil getNumberFormatter] stringFromNumber:[NSNumber numberWithDouble:[self.transactionBalance doubleValue]]], self.currencyUnit];
}

- (NSString *)getTransactionHourMinute {
    return [[StatisticMainUtil getDateFormatterHourMinuteStyle] stringFromDate:self.transactionDate];
}

- (NSString *)transactionTypeDesc {
    
    int sticker = (StickerType)[self.transactionType intValue];
    switch (sticker) {
        case STICKER_DEPOSIT_NORMAL:
        case STICKER_DEPOSIT_SALARY:
        case STICKER_DEPOSIT_POCKET:
        case STICKER_DEPOSIT_ETC:
            return TRANS_TYPE_INCOME;
            
        case STICKER_DEPOSIT_MODIFY:
            return TRANS_TYPE_INCOME_MODIFY;
            
        case STICKER_DEPOSIT_CANCEL:
            return TRANS_TYPE_INCOME_CANCEL;
            
            
        case STICKER_WITHDRAW_NORMAL:
        case STICKER_WITHDRAW_FOOD:
        case STICKER_WITHDRAW_TELEPHONE:
        case STICKER_WITHDRAW_HOUSING:
        case STICKER_WITHDRAW_SHOPPING:
        case STICKER_WITHDRAW_CULTURE:
        case STICKER_WITHDRAW_EDUCATION:
        case STICKER_WITHDRAW_CREDIT:
        case STICKER_WITHDRAW_SAVING:
        case STICKER_WITHDRAW_ETC:
            return TRANS_TYPE_EXPENSE;
            
        case STICKER_WITHDRAW_MODIFY:
            return TRANS_TYPE_EXPENSE_MODIFY;
        
        case STICKER_WITHDRAW_CANCEL:
            return TRANS_TYPE_EXPENSE_CANCEL;
            
        default:
            return TRANS_TYPE_ETC;
    }
}


@end
