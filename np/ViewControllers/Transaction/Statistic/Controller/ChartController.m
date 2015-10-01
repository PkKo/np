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

- (NSArray *)getChartData {
    
    NSLog(@"[%s %d]", __func__, __LINE__);
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    [items addObject:[[ChartItemData alloc] initWithColor:@"#ff00ff" name:@"급여" percent:@"2.7" value:@"2000000" type:INCOME ]];
    [items addObject:[[ChartItemData alloc] initWithColor:@"#ffff00" name:@"상급" percent:@"1.35" value:@"1000000" type:INCOME]];
    [items addObject:[[ChartItemData alloc] initWithColor:@"#feefff" name:@"지원급" percent:@"4.05" value:@"3000000" type:INCOME]];
    [items addObject:[[ChartItemData alloc] initWithColor:@"#eeff00" name:@"주택제공" percent:@"5.4" value:@"4000000" type:INCOME]];
    [items addObject:[[ChartItemData alloc] initWithColor:@"#ffaaff" name:@"식지제공" percent:@"2.7" value:@"2000000" type:INCOME]];
    
    [items addObject:[[ChartItemData alloc] initWithColor:@"#eeaaff" name:@"식비" percent:@"50" value:@"6000000" type:EXPENSE]];
    [items addObject:[[ChartItemData alloc] initWithColor:@"#eebbff" name:@"담배" percent:@"16.4" value:@"2000000" type:EXPENSE]];
    [items addObject:[[ChartItemData alloc] initWithColor:@"#11ccff" name:@"교육비" percent:@"16.4" value:@"2000000" type:EXPENSE]];
    
    
    return [items copy];
}

@end
