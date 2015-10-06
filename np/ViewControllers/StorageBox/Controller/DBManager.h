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

- (NSString *)findTransactionMemoById:(NSString *)transactionId;
- (void)saveTransaction:(TransactionObject *)transObj;

@end
