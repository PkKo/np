//
//  AccountObject.m
//  np
//
//  Created by Infobank1 on 1/13/16.
//  Copyright © 2016 Infobank1. All rights reserved.
//

#import "AccountObject.h"

@implementation AccountObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.accountCheckState = UIControlStateNormal;
    }
    return self;
}

@end
