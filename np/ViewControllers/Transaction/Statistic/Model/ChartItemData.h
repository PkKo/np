//
//  ChartItemData.h
//  np
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartItemData : NSObject

@property (nonatomic, copy) NSString * itemColor;
@property (nonatomic, copy) NSString * itemName;
@property (nonatomic, copy) NSString * itemPercent;
@property (nonatomic, copy) NSString * itemValue;
@property (nonatomic, copy) NSString * itemType; // income or expense

- (instancetype)initWithColor:(NSString *)color name:(NSString *)name percent:(NSString *)percent value:(NSString *)value type:(NSString *)itemType;

@end
