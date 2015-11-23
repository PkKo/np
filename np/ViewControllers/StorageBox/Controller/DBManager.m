//
//  DBManager.m
//  np
//
//  Created by Infobank2 on 10/5/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>
#import "StatisticMainUtil.h"

@interface DBManager()

@property (strong, nonatomic) NSString * databasePath;
@property (nonatomic) sqlite3 *nhTransactionDB;

@end

@implementation DBManager


static dispatch_once_t onceToken    = 0;
static id _sharedObject             = nil;

+ (instancetype)sharedInstance {
    
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject createDB];
    });
    
    return _sharedObject;
}

+(void)resetSharedInstance {
    onceToken       = 0; // resets the once_token so dispatch_once will run again
    _sharedObject   = nil;
}

- (void)removeDB {
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:_databasePath] == YES) {
        NSError * error;
        [filemgr removeItemAtPath:_databasePath error:&error];
    }
    [DBManager resetSharedInstance];
}

- (void)createDB {
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"nhtransactions.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:_databasePath] == NO) {
        
        BOOL openDB = [self openDB];
        if (openDB == SQLITE_OK) {
            
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS transactions (ID INTEGER PRIMARY KEY AUTOINCREMENT, TRANS_ID TEXT, TRANS_DATE TEXT, TRANS_ACCOUNT TEXT, TRANS_ACCOUNT_TYPE TEXT, TRANS_NAME TEXT, TRANS_TYPE TEXT, TRANS_AMOUNT TEXT, TRANS_BALANCE TEXT, TRANS_MEMO TEXT, TRANS_PINNABLE TEXT)";
            
            if (sqlite3_exec(_nhTransactionDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create table");
            } else {
                NSLog(@"created db.");
            }
            sqlite3_close(_nhTransactionDB);
        } else {
            NSLog(@"Failed to open/create database");
        }
    } else {
        NSLog(@"db exists");
    }
}

- (void)deleteTableTransactions {
    
    BOOL openDB = [self openDB];
    
    if (openDB == SQLITE_OK) {
        char * error;
        const char * drop_table_stmt = "DROP TABLE transactions";
        
        if (sqlite3_exec(_nhTransactionDB, drop_table_stmt, NULL, NULL, &error) != SQLITE_OK) {
            NSLog(@"failed to remove table.");
        } else {
            NSLog(@"removed table.");
        }
    } else {
        NSLog(@"Failed to open db");
    }
}


- (NSArray *)selectAllTransactions { // array of TransactionObject
    NSString * selectSQL = @"SELECT TRANS_ID,TRANS_DATE, TRANS_ACCOUNT, TRANS_NAME, TRANS_TYPE, TRANS_AMOUNT, TRANS_BALANCE, TRANS_MEMO, TRANS_PINNABLE, TRANS_ACCOUNT_TYPE FROM transactions";
    return [self selectAllTransactionsWithQuery:selectSQL];
}

- (NSArray *)selectByTransactionsStartDate:(NSString *)startDate endDate:(NSString *)endDate
                                 accountNo:(NSString *)accountNo transType:(NSString *)transType memo:(NSString *)memo {
    
    NSString * selectSQL = [NSString stringWithFormat:@"SELECT TRANS_ID,TRANS_DATE, TRANS_ACCOUNT, TRANS_NAME, TRANS_TYPE, TRANS_AMOUNT, TRANS_BALANCE, TRANS_MEMO, TRANS_PINNABLE, TRANS_ACCOUNT_TYPE FROM transactions WHERE (trans_date BETWEEN \"%@\" AND \"%@\")", startDate, endDate];
    
    if (accountNo) {
        selectSQL = [NSString stringWithFormat:@"%@ AND (trans_account = \"%@\")", selectSQL, accountNo];
    }
    
    if (transType) {
        selectSQL = [NSString stringWithFormat:@"%@ AND (trans_type LIKE \"%@%%\")", selectSQL, transType];
    }
    
    if (memo) {
        selectSQL = [NSString stringWithFormat:@"%@ AND (trans_memo LIKE \"%%%@%%\")", selectSQL, memo];
    }
    return [self selectAllTransactionsWithQuery:selectSQL];
}


- (NSArray *)selectByTransactionsStartDate:(NSString *)startDate endDate:(NSString *)endDate { // array of TransactionObject
    NSString * selectSQL = [NSString stringWithFormat:@"SELECT TRANS_ID,TRANS_DATE, TRANS_ACCOUNT, TRANS_NAME, TRANS_TYPE, TRANS_AMOUNT, TRANS_BALANCE, TRANS_MEMO, TRANS_PINNABLE, TRANS_ACCOUNT_TYPE FROM transactions WHERE trans_date BETWEEN \"%@\" AND \"%@\"", startDate, endDate];
    return [self selectAllTransactionsWithQuery:selectSQL];
}

- (NSArray *)selectAllTransactionsWithQuery:(NSString *)query { // array of TransactionObject
    
    NSMutableArray * transactions = [[NSMutableArray alloc] init];
    
    sqlite3_stmt * statement;
    
    BOOL openDB = [self openDB];
    if (openDB == SQLITE_OK) {
        
        if (sqlite3_prepare(_nhTransactionDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString * transId          = [NSString stringWithUTF8String:
                                                                        (const char *)sqlite3_column_text(statement, 0)];
                
                NSDate   * transDate        = [[StatisticMainUtil getDateFormatterDateHourStyle] dateFromString:[NSString stringWithUTF8String:
                                                                        (const char *)sqlite3_column_text(statement, 1)]];
                
                NSString * transAccount     = [NSString stringWithUTF8String:
                                                                        (const char *)sqlite3_column_text(statement, 2)];
                
                NSString * transName        = [NSString stringWithUTF8String:
                                                                        (const char *)sqlite3_column_text(statement, 3)];
                
                NSString * transType        = [NSString stringWithUTF8String:
                                                                        (const char *)sqlite3_column_text(statement, 4)];
                
                NSNumber * transAmount      = [NSNumber numberWithFloat:[[NSString stringWithUTF8String:
                                                                        (const char *)sqlite3_column_text(statement, 5)] floatValue]];
                
                NSNumber * transBalance     = [NSNumber numberWithFloat:[[NSString stringWithUTF8String:
                                                                        (const char *)sqlite3_column_text(statement, 6)] floatValue]];
                
                NSString * transMemo        = [NSString stringWithUTF8String:
                                                                        (const char *)sqlite3_column_text(statement, 7)];
                
                NSNumber * transPinnable    = [NSNumber numberWithFloat:[[NSString stringWithUTF8String:
                                                                        (const char *)sqlite3_column_text(statement, 8)] floatValue]];
                NSString * transAccountType = [NSString stringWithUTF8String:
                                                                        (const char *)sqlite3_column_text(statement, 9)];
                
                TransactionObject * tranObj = [[TransactionObject alloc] init];
                [tranObj setTransactionId           :transId];
                [tranObj setTransactionDate         :transDate];
                [tranObj setTransactionAccountNumber:transAccount];
                [tranObj setTransactionDetails      :transName];
                [tranObj setTransactionType         :transType];
                [tranObj setTransactionAmount       :transAmount];
                [tranObj setTransactionBalance      :transBalance];
                [tranObj setTransactionMemo         :transMemo];
                [tranObj setTransactionActivePin    :transPinnable];
                [tranObj setTransactionAccountType  :transAccountType];
                
                [transactions addObject:tranObj];
            }
            
        } else {
            NSLog(@"Failed to select data");
        }
        
    } else {
        NSLog(@"Failed to open db");
    }
    
    return [transactions copy];
}

- (NSString *)findTransactionMemoById:(NSString *)transactionId {
    
    NSString * memo = nil;
    
    sqlite3_stmt * statement;
    
    BOOL openDB = [self openDB];
    if (openDB == SQLITE_OK) {
        NSString * querySQL = [NSString stringWithFormat:@"SELECT trans_memo FROM transactions WHERE trans_id = \"%@\"", transactionId];
        const char * encodedQuerySQL = [querySQL UTF8String];
        
        if (sqlite3_prepare(_nhTransactionDB, encodedQuerySQL, -1, &statement, NULL) == SQLITE_OK) {
            
            if (sqlite3_step(statement) == SQLITE_ROW) {
                memo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_nhTransactionDB);
    }
    
    return memo;
}

- (BOOL)updateTransactionType:(NSString *)transType byTransId:(NSString *)transId {
    
    sqlite3_stmt * statement;
    
    BOOL updated = NO;
    
    BOOL openDB = [self openDB];
    
    if (openDB == SQLITE_OK) {
        NSLog(@"opened db");
        
        NSString * updateSQL = [NSString stringWithFormat:@"UPDATE transactions SET trans_type = \"%@\" WHERE trans_id = \"%@\"", transType, transId];
        
        sqlite3_prepare(_nhTransactionDB, [updateSQL UTF8String], -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"updated.");
            updated = YES;
        } else {
            NSLog(@"failed to update");
            updated = NO;
        }
    } else {
        NSLog(@"failed to open db.");
        updated = NO;
    }
    return updated;
}

- (BOOL)updateTransactionMemo:(NSString *)memo byTransId:(NSString *)transId {
    
    sqlite3_stmt * statement;
    
    BOOL updated = NO;
    
    BOOL openDB = [self openDB];
    
    if (openDB == SQLITE_OK) {
        NSLog(@"opened db");
        
        NSString * updateSQL = [NSString stringWithFormat:@"UPDATE transactions SET trans_memo = \"%@\" WHERE trans_id = \"%@\"", memo, transId];
        
        sqlite3_prepare(_nhTransactionDB, [updateSQL UTF8String], -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"updated.");
            updated = YES;
        } else {
            NSLog(@"failed to update");
            updated = NO;
        }
    } else {
        NSLog(@"failed to open db.");
        updated = NO;
    }
    return updated;
}

- (BOOL)updateTransactionPinnable:(BOOL)isPinnedUp byTransId:(NSString *)transId {
    
    sqlite3_stmt * statement;
    
    BOOL updated = NO;
    
    BOOL openDB = [self openDB];
    
    if (openDB == SQLITE_OK) {
        NSLog(@"opened db");
        
        NSString * updateSQL = [NSString stringWithFormat:@"UPDATE transactions SET trans_pinnable = \"%@\" WHERE trans_id = \"%@\"", [[NSNumber numberWithBool:isPinnedUp] stringValue], transId];
        
        sqlite3_prepare(_nhTransactionDB, [updateSQL UTF8String], -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"updated.");
            updated = YES;
        } else {
            NSLog(@"failed to update");
            updated = NO;
        }
    } else {
        NSLog(@"failed to open db.");
        updated = NO;
    }
    return updated;
}

- (BOOL)updateTransaction:(TransactionObject *)transObj {
    
    sqlite3_stmt * statement;
    
    BOOL updated = NO;
    
    BOOL openDB = [self openDB];
    
    if (openDB == SQLITE_OK) {
        NSLog(@"opened db");
        
        NSString * updateSQL = [NSString stringWithFormat:@"UPDATE transactions SET trans_memo = \"%@\", trans_type = \"%@\", trans_pinnable = \"%@\" WHERE trans_id = \"%@\"", transObj.transactionMemo, transObj.transactionType, [transObj.transactionActivePin stringValue], transObj.transactionId];
        
        sqlite3_prepare(_nhTransactionDB, [updateSQL UTF8String], -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"updated.");
            updated = YES;
        } else {
            NSLog(@"failed to update");
            updated = NO;
        }
    } else {
        NSLog(@"failed to open db.");
        updated = NO;
    }
    return updated;
}

- (BOOL)deleteAllTransactions {
    
    sqlite3_stmt * statement;
    
    BOOL deleted = NO;
    
    BOOL openDB = [self openDB];
    if (openDB == SQLITE_OK) {
        
        NSLog(@"opened db.");
        NSString * deleteSQL = @"DELETE FROM transactions";
        
        sqlite3_prepare(_nhTransactionDB, [deleteSQL UTF8String], -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"delete all transactions.");
            deleted = YES;
        } else {
            NSLog(@"failed to delete");
        }
    } else {
        NSLog(@"failed to open db");
    }
    return deleted;
}

- (BOOL)deleteTransactionById:(NSString *)transId {
    sqlite3_stmt * statement;
    
    BOOL deleted = NO;
    
    BOOL openDB = [self openDB];
    if (openDB == SQLITE_OK) {
        
        NSLog(@"opened db.");
        NSString * deleteSQL = [NSString stringWithFormat:@"DELETE FROM transactions WHERE trans_id = \"%@\"", transId];
        
        sqlite3_prepare(_nhTransactionDB, [deleteSQL UTF8String], -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"deleted");
            deleted = YES;
        } else {
            NSLog(@"failed to delete");
        }
    } else {
        NSLog(@"failed to open db");
    }
    return deleted;
}

- (BOOL)saveTransaction:(TransactionObject *)transObj {
    
    sqlite3_stmt * statement;
    
    BOOL saved = NO;
    
    BOOL openDB = [self openDB];
    if(openDB == SQLITE_OK) {
        
        NSString * insertSQL = [NSString stringWithFormat:@"INSERT INTO transactions (TRANS_ID,TRANS_DATE, TRANS_ACCOUNT, TRANS_NAME, TRANS_TYPE, TRANS_AMOUNT, TRANS_BALANCE, TRANS_MEMO, TRANS_PINNABLE, TRANS_ACCOUNT_TYPE) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", transObj.transactionId, transObj.formattedTransactionDateForDB,
                                transObj.transactionAccountNumber, transObj.transactionDetails,
                                transObj.transactionType, [transObj.transactionAmount stringValue],
                                [transObj.transactionBalance stringValue], transObj.transactionMemo, [transObj.transactionActivePin stringValue], transObj.transactionAccountType];
        
        const char * insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare(_nhTransactionDB, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"added");
            saved = YES;
        } else {
            NSLog(@"failed to add");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_nhTransactionDB);
        
    } else {
        NSLog(@"failed to open");
    }
    return saved;
}

-(BOOL)openDB {
     BOOL succeedToOpenDB = sqlite3_open_v2([self.databasePath UTF8String], &_nhTransactionDB, SQLITE_OPEN_FILEPROTECTION_COMPLETE | SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE, NULL);
    return succeedToOpenDB;
}

@end
