//
//  StorageBoxUtil.h
//  np
//
//  Created by Infobank2 on 9/23/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionObject.h"

@interface StorageBoxUtil : NSObject

- (void)showMemoComposerInViewController:(UIViewController *)viewController withTransationObject:(TransactionObject *)transactionObject;
- (void)showSNSShareInViewController:(UIViewController *)viewController withTransationObject:(TransactionObject *)transactionObject;

+ (UIColor *)getDimmedBackgroundColor;

@end
