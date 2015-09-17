//
//  ChartItemData.h
//  np
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartItemData : NSObject

@property NSString *itemColor;
@property NSString *itemName;
@property NSString *itemValue;
@property BOOL *isIncome; // not income is expense

@end
