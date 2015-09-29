//
//  ChartItemData.m
//  np
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank1. All rights reserved.
//

#import "ChartItemData.h"

@implementation ChartItemData

- (instancetype)initWithColor:(NSString *)color name:(NSString *)name percent:(NSString *)percent value:(NSString *)value type:(NSString *)itemType {
    self = [super init];
    if (self != nil) {
        self.itemColor      = color;
        self.itemName       = name;
        self.itemPercent    = percent;
        self.itemValue      = value;
        self.itemType       = itemType;
    }
    return self;
}

@end
