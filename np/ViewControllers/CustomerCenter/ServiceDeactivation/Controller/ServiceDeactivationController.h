//
//  ServiceDeactivationController.h
//  np
//
//  Created by Infobank2 on 11/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceDeactivationController : NSObject

+ (instancetype)sharedInstance;
- (void)deactivateService;
@end
