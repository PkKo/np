//
//  ChartData.h
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartData : NSObject

@property NSDate *startDate;
@property NSDate *endDate;
@property NSMutableArray *itemArray; // array of ChartItemData

@end
