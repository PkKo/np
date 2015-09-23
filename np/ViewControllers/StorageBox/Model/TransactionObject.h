//
//  TransactionObject.h
//  np
//
//  Created by Infobank2 on 9/23/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionObject : NSObject

@property (nonatomic, weak) NSDate * transactionDate;
@property (nonatomic, weak) NSString * transactionAccountNumber;
@property (nonatomic, weak) NSString * transactionDetails;
@property (nonatomic, weak) NSString * transactionType;
@property (nonatomic, weak) NSNumber * transactionAmount;

@end
