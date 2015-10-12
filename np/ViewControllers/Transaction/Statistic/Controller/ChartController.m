//
//  ChartController.m
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import "ChartController.h"
#import "ChartItemData.h"
#import "ConstantMaster.h"

@implementation ChartController

- (NSArray *)getChartDataByAccountNo:(NSString *)accountNo {
    return [self getChartData];
}

- (NSArray *)getChartDataFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    return [self getChartData];
}

- (NSArray *)getChartData {
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    int rand = arc4random_uniform(12);
    
    switch (rand) {
        case 0:
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ff00ff" name:@"급여" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"1.35" value:@"1000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#7E57C2" name:@"지원급" percent:@"4.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeff00" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffaaff" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#1976D2" name:@"식비" percent:@"50" value:@"6000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#7E57C2" name:@"담배" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#11ccff" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            
            break;
        case 1:
            [items addObject:[[ChartItemData alloc] initWithColor:@"#D81B60" name:@"급여" percent:@"32.7" value:@"2000000" type:TRANS_TYPE_EXPENSE ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"11.35" value:@"1000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#feefff" name:@"지원급" percent:@"4.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeff00" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#1976D2" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeaaff" name:@"식비" percent:@"10" value:@"6000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#7E57C2" name:@"담배" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#11ccff" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            break;
            
        case 2:
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ff00ff" name:@"급여" percent:@"27.7" value:@"2000000" type:TRANS_TYPE_EXPENSE ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"21.35" value:@"1000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#D81B60" name:@"지원급" percent:@"4.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeff00" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffaaff" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeaaff" name:@"식비" percent:@"10" value:@"6000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eebbff" name:@"담배" percent:@"11.4" value:@"2000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#11ccff" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            break;
        
        case 3:
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ff00ff" name:@"급여" percent:@"27.7" value:@"2000000" type:TRANS_TYPE_EXPENSE ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"21.35" value:@"1000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#D81B60" name:@"지원급" percent:@"4.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeff00" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#F57C00" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeaaff" name:@"식비" percent:@"10" value:@"6000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eebbff" name:@"담배" percent:@"11.4" value:@"2000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#0288D1" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            break;
            
        case 4:
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ff00ff" name:@"급여" percent:@"27.7" value:@"2000000" type:TRANS_TYPE_EXPENSE ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"21.35" value:@"1000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#D81B60" name:@"지원급" percent:@"4.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeff00" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#F57C00" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#0288D1" name:@"식비" percent:@"10" value:@"6000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eebbff" name:@"담배" percent:@"11.4" value:@"2000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#11ccff" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            break;
            
        case 5:
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ff00ff" name:@"급여" percent:@"27.7" value:@"2000000" type:TRANS_TYPE_EXPENSE ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"21.35" value:@"1000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#D81B60" name:@"지원급" percent:@"4.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeff00" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#F57C00" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#0288D1" name:@"식비" percent:@"10" value:@"6000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eebbff" name:@"담배" percent:@"11.4" value:@"2000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#11ccff" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            break;
            
        case 6:
            [items addObject:[[ChartItemData alloc] initWithColor:@"#0288D1" name:@"급여" percent:@"27.7" value:@"2000000" type:TRANS_TYPE_EXPENSE ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"21.35" value:@"1000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#D81B60" name:@"지원급" percent:@"4.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeff00" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffaaff" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeaaff" name:@"식비" percent:@"10" value:@"6000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#F57C00" name:@"담배" percent:@"11.4" value:@"2000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#11ccff" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            break;
            
            
        case 7:
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ff00ff" name:@"급여" percent:@"27.7" value:@"2000000" type:TRANS_TYPE_EXPENSE ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"21.35" value:@"1000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#D81B60" name:@"지원급" percent:@"4.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#0288D1" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffaaff" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeaaff" name:@"식비" percent:@"10" value:@"6000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#AFB42B" name:@"담배" percent:@"11.4" value:@"2000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#11ccff" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            break;
            
            
        case 8:
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ff00ff" name:@"급여" percent:@"27.7" value:@"2000000" type:TRANS_TYPE_EXPENSE ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#AFB42B" name:@"상급" percent:@"21.35" value:@"1000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#D81B60" name:@"지원급" percent:@"4.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeff00" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffaaff" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeaaff" name:@"식비" percent:@"10" value:@"6000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eebbff" name:@"담배" percent:@"11.4" value:@"2000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#11ccff" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            break;
            
            
        case 9:
            [items addObject:[[ChartItemData alloc] initWithColor:@"#283593" name:@"급여" percent:@"27.7" value:@"2000000" type:TRANS_TYPE_EXPENSE ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"21.35" value:@"1000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#D81B60" name:@"지원급" percent:@"4.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#0288D1" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffaaff" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eeaaff" name:@"식비" percent:@"10" value:@"6000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#eebbff" name:@"담배" percent:@"11.4" value:@"2000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#AFB42B" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            break;
            
            
        case 10:
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ff00ff" name:@"급여" percent:@"27.7" value:@"2000000" type:TRANS_TYPE_EXPENSE ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"21.35" value:@"1000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#D81B60" name:@"지원급" percent:@"4.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#283593" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffaaff" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#0288D1" name:@"식비" percent:@"10" value:@"6000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#AFB42B" name:@"담배" percent:@"11.4" value:@"2000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#11ccff" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            break;
            
        default:
            [items addObject:[[ChartItemData alloc] initWithColor:@"#F44336" name:@"급여" percent:@"17.7" value:@"2000000" type:TRANS_TYPE_EXPENSE ]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"21.35" value:@"1000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#0288D1" name:@"지원급" percent:@"14.05" value:@"3000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#7E57C2" name:@"주택제공" percent:@"5.4" value:@"4000000" type:TRANS_TYPE_EXPENSE]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#1976D2" name:@"식지제공" percent:@"2.7" value:@"2000000" type:TRANS_TYPE_INCOME]];
            
            [items addObject:[[ChartItemData alloc] initWithColor:@"#AFB42B" name:@"식비" percent:@"10" value:@"6000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#D81B60" name:@"담배" percent:@"11.4" value:@"2000000" type:TRANS_TYPE_INCOME]];
            [items addObject:[[ChartItemData alloc] initWithColor:@"#283593" name:@"교육비" percent:@"16.4" value:@"2000000" type:TRANS_TYPE_EXPENSE]];
            break;
    }
    
    
    return [items copy];
}

@end
