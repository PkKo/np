//
//  CustomerCenterUtil.h
//  np
//
//  Created by Infobank2 on 11/3/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerCenterUtil : NSObject
+ (instancetype)sharedInstance;
- (void)gotoFarmerNews;
- (void)gotoNotice;
- (void)gotoFAQ;
- (void)gotoTelEnquiry;

@end
