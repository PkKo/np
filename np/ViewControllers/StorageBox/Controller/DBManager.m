//
//  DBManager.m
//  np
//
//  Created by Infobank2 on 10/5/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

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
    
    NSLog(@"%s", __func__);
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"nhtransactions.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_nhTransactionDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS transactions (ID INTEGER PRIMARY KEY AUTOINCREMENT, TRANS_ID TEXT, TRANS_DATE TEXT, TRANS_ACCOUNT TEXT, TRANS_NAME TEXT, TRANS_TYPE TEXT, TRANS_AMOUNT TEXT, TRANS_BALANCE TEXT, TRANS_MEMO TEXT)";
            
            if (sqlite3_exec(_nhTransactionDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
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

- (NSString *)findTransactionMemoById:(NSString *)transactionId {
    
    NSLog(@"%s", __func__);
    
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

- (void)saveTransaction:(TransactionObject *)transObj {
    
    NSLog(@"%s", __func__);
    
    sqlite3_stmt * statement;
    const char * encodedDBPath = [self.databasePath UTF8String];
    
    NSLog(@"self.databasePath: %@", self.databasePath);
    
    if (sqlite3_open(encodedDBPath, &_nhTransactionDB)) {
        NSString * insertSQL = [NSString stringWithFormat:@"INSERT INTO transactions (trans_id, trans_memo) VALUES (\"%@\", \"%@\")", transObj.transactionId, transObj.transactionMemo];
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
        NSLog(@"faied to open");
    }
}


@end
