//
//  ChartController.h
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartController : NSObject

- (NSArray *)getChartDataByAccountNo:(NSString *)accountNo;

- (NSArray *)getChartDataFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
@end
