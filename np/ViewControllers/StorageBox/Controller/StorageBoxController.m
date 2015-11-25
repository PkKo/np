//
//  StorageBoxController.m
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "StorageBoxController.h"
#import "TransactionObject.h"
#import "StatisticMainUtil.h"
#import "DBManager.h"
#import "LoginUtil.h"

@implementation StorageBoxController

- (NSArray *)getAllTransactions { // array of TransactionObject
    
    return [[DBManager sharedInstance] selectAllTransactions];
}

- (NSDictionary *)getIndexDicOutOfArray:(NSArray *)arr { // array of TransactionObject
    
    NSMutableDictionary * indexDic = [NSMutableDictionary dictionary];
    
    for (TransactionObject * trans in arr) {
        
        NSString * dateStr = [[StatisticMainUtil getDateFormatterDateStyle] stringFromDate:trans.transactionDate];
        
        NSMutableArray * sameDateArr = [indexDic objectForKey:dateStr];
        if (!sameDateArr) {
            sameDateArr = [[NSMutableArray alloc] init];
            [indexDic setValue:sameDateArr forKey:dateStr];
        }
        [sameDateArr addObject:trans];
    }
    
    return indexDic;
}

- (NSDate *)createDateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    
    NSCalendar          * calendar          = [NSCalendar currentCalendar];
    NSDateComponents    * newDateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                          fromDate:[NSDate date]];
    [newDateComponents setMonth:month];
    [newDateComponents setYear:year];
    [newDateComponents setDay:day];
    [newDateComponents setHour:hour];
    [newDateComponents setMinute:minute];
    
    return [calendar dateFromComponents:newDateComponents];
}

- (NSArray *)getAllAccounts {
    
    LoginUtil   * util          = [[LoginUtil alloc] init];
    NSArray     * allAccounts   = [util getAllAccounts];
    
    return [self getAllAccounts:allAccounts];
}

- (NSArray *)getAllTransAccounts {
    
    LoginUtil   * util        = [[LoginUtil alloc] init];
    NSArray     * allAccounts = [util getAllTransAccounts];
    
    return [self getAllAccounts:allAccounts];
}

- (NSArray *)getAllAccounts:(NSArray *)allAccounts {
    
    if (allAccounts && [allAccounts count] > 0) {
        
        NSMutableArray * accountsWithAll = [NSMutableArray arrayWithCapacity:[allAccounts count]];
        [accountsWithAll insertObject:TRANS_ALL_ACCOUNT atIndex:0];
        
        for (NSString * account in allAccounts) {
            [accountsWithAll addObject:[CommonUtil getAccountNumberAddDash:account]];
        }
        
        return [accountsWithAll copy];
    }
    
    return @[TRANS_ALL_ACCOUNT];
}

@end
