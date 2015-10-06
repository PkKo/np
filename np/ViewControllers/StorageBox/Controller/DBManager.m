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

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
        [_sharedObject createDB];
    });
    
    return _sharedObject;
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
    if ([filemgr fileExistsAtPath: _databasePath ] == NO) {
        
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_nhTransactionDB) == SQLITE_OK) {
            
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS transactions (ID INTEGER PRIMARY KEY AUTOINCREMENT, TRANS_ID TEXT, TRANS_DATE TEXT, TRANS_ACCOUNT TEXT, TRANS_NAME TEXT, TRANS_TYPE TEXT, TRANS_AMOUNT TEXT, TRANS_BALANCE TEXT, TRANS_MEMO TEXT)";
            
            if (sqlite3_exec(_nhTransactionDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create table");
            }
            sqlite3_close(_nhTransactionDB);
        } else {
            NSLog(@"Failed to open/create database");
        }
    } else {
        NSLog(@"db exists");
    }
}

- (NSArray *)selectAllTransactions { // array of TransactionObject
    
    NSMutableArray * transactions = [[NSMutableArray alloc] init];
    
    sqlite3_stmt * statement;
    
    BOOL openDB = sqlite3_open([self.databasePath UTF8String], &_nhTransactionDB);
    if (openDB == SQLITE_OK) {
        
        NSString * selectSQL = @"SELECT TRANS_ID,TRANS_DATE, TRANS_ACCOUNT, TRANS_NAME, TRANS_TYPE, TRANS_AMOUNT, TRANS_BALANCE, TRANS_MEMO FROM transactions";
        
        if (sqlite3_prepare(_nhTransactionDB, [selectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                TransactionObject * tranObj = [[TransactionObject alloc] init];
                [tranObj setTransactionId:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [tranObj setTransactionDate:[[StatisticMainUtil getDateFormatterDateHourStyle] dateFromString:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]]];
                [tranObj setTransactionAccountNumber:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]];
                [tranObj setTransactionDetails:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]];
                [tranObj setTransactionType:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]];
                [tranObj setTransactionAmount:[NSNumber numberWithFloat:[[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 5)] floatValue]]];
                [tranObj setTransactionBalance:[NSNumber numberWithFloat:[[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] floatValue]]];
                [tranObj setTransactionMemo:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 7)]];
                
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
    
    const char * encodedDBPath = [self.databasePath UTF8String];
    sqlite3_stmt * statement;
    
    if (sqlite3_open(encodedDBPath, &_nhTransactionDB) == SQLITE_OK) {
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

- (void)updateTransactionMemo:(NSString *)memo byTransId:(NSString *)transId {
    
    sqlite3_stmt * statement;
    
    BOOL openDBResult = sqlite3_open([self.databasePath UTF8String], &_nhTransactionDB);
    
    if (openDBResult == SQLITE_OK) {
        NSLog(@"opened db");
        
        NSString * updateSQL = [NSString stringWithFormat:@"UPDATE transactions SET trans_memo = \"%@\" WHERE trans_id = \"%@\"", memo, transId];
        
        sqlite3_prepare(_nhTransactionDB, [updateSQL UTF8String], -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"updated.");
        } else {
            NSLog(@"failed to update");
        }
    } else {
        NSLog(@"failed to open db.");
    }
}

- (void)deleteAllTransactions {
    sqlite3_stmt * statement;
    
    BOOL openDB = sqlite3_open([self.databasePath UTF8String], &_nhTransactionDB);
    
    if (openDB == SQLITE_OK) {
        
        NSLog(@"opened db.");
        NSString * deleteSQL = @"DELETE FROM transactions";
        
        sqlite3_prepare(_nhTransactionDB, [deleteSQL UTF8String], -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"deleted");
        } else {
            NSLog(@"failed to delete");
        }
    } else {
        NSLog(@"failed to open db");
    }
}

- (void)deleteTransactionById:(NSString *)transId {
    sqlite3_stmt * statement;
    
    BOOL openDB = sqlite3_open([self.databasePath UTF8String], &_nhTransactionDB);
    
    if (openDB == SQLITE_OK) {
        
        NSLog(@"opened db.");
        NSString * deleteSQL = [NSString stringWithFormat:@"DELETE FROM transactions WHERE trans_id = \"%@\"", transId];
        
        sqlite3_prepare(_nhTransactionDB, [deleteSQL UTF8String], -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"deleted");
        } else {
            NSLog(@"failed to delete");
        }
    } else {
        NSLog(@"failed to open db");
    }
}

- (void)saveTransaction:(TransactionObject *)transObj {
    
    sqlite3_stmt * statement;
    
    BOOL openDatabaseResult = sqlite3_open([self.databasePath UTF8String], &_nhTransactionDB);
    if(openDatabaseResult == SQLITE_OK) {
        
        NSString * insertSQL = [NSString stringWithFormat:@"INSERT INTO transactions (TRANS_ID,TRANS_DATE, TRANS_ACCOUNT, TRANS_NAME, TRANS_TYPE, TRANS_AMOUNT, TRANS_BALANCE, TRANS_MEMO) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", transObj.transactionId, transObj.formattedTransactionDateForDB,
                                transObj.transactionAccountNumber, transObj.transactionDetails,
                                transObj.transactionType, [transObj.transactionAmount stringValue],
                                [transObj.transactionBalance stringValue], transObj.transactionMemo];
        
        const char * insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare(_nhTransactionDB, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"added");
        } else {
            NSLog(@"failed to add");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_nhTransactionDB);
        
    } else {
        NSLog(@"failed to open");
    }
}

@end
