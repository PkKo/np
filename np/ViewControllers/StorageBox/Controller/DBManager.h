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
- (NSString *)findTransactionMemoById:(NSString *)transactionId;
- (BOOL)saveTransaction:(TransactionObject *)transObj;
- (BOOL)updateTransactionMemo:(NSString *)memo byTransId:(NSString *)transId;
- (BOOL)deleteAllTransactions;
- (BOOL)deleteTransactionById:(NSString *)transId;

@end
