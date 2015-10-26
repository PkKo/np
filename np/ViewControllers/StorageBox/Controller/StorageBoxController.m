//
//  StorageBoxController.m
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "StorageBoxController.h"
#import "TransactionObject.h"
#import "ConstantMaster.h"
#import "StatisticMainUtil.h"
#import "DBManager.h"

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
    return @[TRANS_ALL_ACCOUNT, @"111-33-3433", @"333-66-2343", @"442-83-3535"];
}

@end
