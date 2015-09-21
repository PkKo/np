//
//  ChartController.m
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import "ChartController.h"
#import "ChartData.h"
#import "ChartItemData.h"

@implementation ChartController

- (ChartData *)getChartData {
    
    ChartData * data = [[ChartData alloc] init];
    data.itemArray = [[NSMutableArray alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DummyChartData" ofType:@"plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSLog(@"dict: %@", dict);
    
    id aKey = nil;
    NSEnumerator *keyEnumerator = [dict keyEnumerator];
    NSEnumerator *objectEnumerator = [dict objectEnumerator];
    
    while ((aKey = [keyEnumerator nextObject]) != nil) {
        
        NSDictionary * value = [objectEnumerator nextObject];
        
        keyEnumerator = [value keyEnumerator];
        objectEnumerator = [value objectEnumerator];
        
        while (aKey = [keyEnumerator nextObject]) {
            
            value = [objectEnumerator nextObject];
            
            if ([(NSString *)aKey isEqualToString:@"startDate"]) {
                
                [data setStartDate:(NSDate *)value];
                
            } else if ([(NSString *)aKey isEqualToString:@"endDate"]) {
                
                [data setEndDate:(NSDate *)value];
                
            } else if ([(NSString *)aKey isEqualToString:@"dataArray"]) {
                
                NSArray * itemDic = (NSArray *)value;
                NSLog(@"itemDic: %@", itemDic);
            }
        }
    }
    
    return nil;
}

@end
