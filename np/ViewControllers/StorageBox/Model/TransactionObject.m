//
//  TransactionObject.m
//  np
//
//  Created by Infobank2 on 9/23/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "TransactionObject.h"

@implementation TransactionObject

- (NSString *)formattedTransactionDate {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    return [dateFormatter stringFromDate:self.transactionDate];
}

- (NSString *)formattedTransactionAmount {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [NSString stringWithFormat:@"%@원", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[self.transactionAmount floatValue]]]];
}

@end
