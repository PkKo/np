//
//  DBManager.h
//  np
//
//  Created by Infobank2 on 10/5/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionObject.h"

@interface DBManager : NSObject

+ (instancetype)sharedInstance;

- (NSArray *)selectAllTransactions; // array of TransactionObject
- (NSArray *)selectByTransactionsStartDate:(NSString *)startDate endDate:(NSString *)endDate;
- (NSArray *)selectByTransactionsStartDate:(NSString *)startDate endDate:(NSString *)endDate
                                 accountNo:(NSString *)accountNo transType:(NSString *)transType memo:(NSString *)memo;

- (void)removeDB;
- (NSString *)findTransactionMemoById:(NSString *)transactionId;
- (BOOL)saveTransaction:(TransactionObject *)transObj;
- (BOOL)updateTransactionMemo:(NSString *)memo byTransId:(NSString *)transId;
- (BOOL)updateTransactionPinnable:(BOOL)isPinnedUp byTransId:(NSString *)transId;
- (BOOL)updateTransactionType:(NSString *)transType byTransId:(NSString *)transId;
- (BOOL)updateTransaction:(TransactionObject *)transObj;
- (BOOL)deleteAllTransactions;
- (BOOL)deleteTransactionById:(NSString *)transId;

@end
