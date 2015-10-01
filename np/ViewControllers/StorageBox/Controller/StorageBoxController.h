//
//  StorageBoxController.h
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageBoxController : NSObject

- (NSArray *)getArchivedItems; // array of TransactionObject
- (NSDictionary *)getIndexDicOutOfArray:(NSArray *)arr; // array of TransactionObject
@end
