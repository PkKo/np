//
//  AccountObject.h
//  np
//
//  Created by Infobank1 on 1/13/16.
//  Copyright © 2016 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountObject : NSObject

@property (nonatomic, assign) UIControlState accountCheckState;
@property (nonatomic, copy) NSString * accountNo;
@property (nonatomic, copy) NSString * accountDesc;
@property (nonatomic, copy) NSString * registeredAccount;
@property (nonatomic, assign) AccountType accountType;
@property (nonatomic, copy) NSString * accountTypeDesc;

@end
