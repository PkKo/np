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

#define USE_SQLITE 1

@implementation StorageBoxController

- (NSArray *)getArchivedItems { // array of TransactionObject
    
#if USE_SQLITE
    return [[DBManager sharedInstance] selectAllTransactions];
#endif
    
#if !USE_SQLITE
    
    NSMutableArray * mutableArr = [[NSMutableArray alloc] init];
    
    //2015/9/29
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:29 hour:11 minute:20]
                                                                     transactionAccountNumber:@"111-2343-11**-**"
                                                                           transactionDetails:@"당풍니"
                                                                              transactionType:EXPENSE
                                                                            transactionAmount:@50000
                                                                           transactionBalance:@1000000
                                                                              transactionMemo:@"당풍니가 쓴 돈"]];
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:29 hour:7 minute:40]
                                                                     transactionAccountNumber:@"221-2343-11**-**"
                                                                           transactionDetails:@"이정호"
                                                                              transactionType:INCOME
                                                                            transactionAmount:@10000
                                                                           transactionBalance:@2000000
                                                                              transactionMemo:@"매드포라릭에서 쓴 돈"]];
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:29 hour:8 minute:30]
                                                                     transactionAccountNumber:@"131-2343-11**-**"
                                                                           transactionDetails:@"이정호"
                                                                              transactionType:INCOME
                                                                            transactionAmount:@30000
                                                                           transactionBalance:@3000000
                                                                              transactionMemo:@"이정호가 입금해준 돈"]];
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:29 hour:10 minute:10]
                                                                     transactionAccountNumber:@"141-2343-11**-**"
                                                                           transactionDetails:@"홍지연"
                                                                              transactionType:EXPENSE
                                                                            transactionAmount:@40000
                                                                           transactionBalance:@1500000
                                                                              transactionMemo:@"홍지연가 입금해준 돈"]];
    
    
    //2015/9/27
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:27 hour:11 minute:20]
                                                                     transactionAccountNumber:@"811-2343-11**-**"
                                                                           transactionDetails:@"권기현"
                                                                              transactionType:INCOME
                                                                            transactionAmount:@50000
                                                                           transactionBalance:@1000000
                                                                              transactionMemo:@"당풍니가 입금해준 돈"]];
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:27 hour:7 minute:40]
                                                                     transactionAccountNumber:@"221-2343-11**-**"
                                                                           transactionDetails:@"이정호"
                                                                              transactionType:INCOME
                                                                            transactionAmount:@10000
                                                                           transactionBalance:@2000000
                                                                              transactionMemo:@"매드포라릭에서 쓴 돈"]];
    
    //2015/9/26
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:26 hour:11 minute:20]
                                                                     transactionAccountNumber:@"711-2343-11**-**"
                                                                           transactionDetails:@"최은선"
                                                                              transactionType:EXPENSE
                                                                            transactionAmount:@50000
                                                                           transactionBalance:@1000000
                                                                              transactionMemo:@"당풍니가 입금해준 돈"]];
    
    //2015/9/24
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:24 hour:11 minute:20]
                                                                     transactionAccountNumber:@"111-2343-11**-**"
                                                                           transactionDetails:@"당풍니"
                                                                              transactionType:EXPENSE
                                                                            transactionAmount:@50000
                                                                           transactionBalance:@1000000
                                                                              transactionMemo:@"당풍니가 쓴 돈"]];
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:24 hour:7 minute:40]
                                                                     transactionAccountNumber:@"221-2343-11**-**"
                                                                           transactionDetails:@"이정호"
                                                                              transactionType:INCOME
                                                                            transactionAmount:@10000
                                                                           transactionBalance:@2000000
                                                                              transactionMemo:@"매드포라릭에서 쓴 돈"]];
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:24 hour:8 minute:30]
                                                                     transactionAccountNumber:@"131-2343-11**-**"
                                                                           transactionDetails:@"이정호"
                                                                              transactionType:INCOME
                                                                            transactionAmount:@30000
                                                                           transactionBalance:@3000000
                                                                              transactionMemo:@"이정호가 입금해준 돈"]];
    
    //2015/9/21
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:21 hour:11 minute:20]
                                                                     transactionAccountNumber:@"111-2343-11**-**"
                                                                           transactionDetails:@"당풍니"
                                                                              transactionType:EXPENSE
                                                                            transactionAmount:@50000
                                                                           transactionBalance:@1000000
                                                                              transactionMemo:@"당풍니가 쓴 돈"]];
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:21 hour:7 minute:40]
                                                                     transactionAccountNumber:@"221-2343-11**-**"
                                                                           transactionDetails:@"이정호"
                                                                              transactionType:INCOME
                                                                            transactionAmount:@10000
                                                                           transactionBalance:@2000000
                                                                              transactionMemo:@"매드포라릭에서 쓴 돈"]];
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:21 hour:8 minute:30]
                                                                     transactionAccountNumber:@"131-2343-11**-**"
                                                                           transactionDetails:@"이정호"
                                                                              transactionType:INCOME
                                                                            transactionAmount:@30000
                                                                           transactionBalance:@3000000
                                                                              transactionMemo:@"이정호가 입금해준 돈"]];
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:21 hour:12 minute:20]
                                                                     transactionAccountNumber:@"111-2343-11**-**"
                                                                           transactionDetails:@"당풍니"
                                                                              transactionType:EXPENSE
                                                                            transactionAmount:@50000
                                                                           transactionBalance:@1000000
                                                                              transactionMemo:@"당풍니가 쓴 돈"]];
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:21 hour:8 minute:40]
                                                                     transactionAccountNumber:@"221-2343-11**-**"
                                                                           transactionDetails:@"이정호"
                                                                              transactionType:EXPENSE
                                                                            transactionAmount:@10000
                                                                           transactionBalance:@2000000
                                                                              transactionMemo:@"매드포라릭에서 쓴 돈"]];
    [mutableArr addObject:[[TransactionObject alloc] initTransactionObjectWithTransactionDate:[self createDateWithYear:2015 month:9 day:21 hour:2 minute:30]
                                                                     transactionAccountNumber:@"131-2343-11**-**"
                                                                           transactionDetails:@"이정호"
                                                                              transactionType:INCOME
                                                                            transactionAmount:@30000
                                                                           transactionBalance:@3000000
                                                                              transactionMemo:@"이정호가 입금해준 돈"]];
    return [mutableArr copy];
#endif
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

@end
