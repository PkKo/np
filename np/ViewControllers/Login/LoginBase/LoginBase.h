//
//  LoginBase.h
//  np
//
//  Created by Infobank2 on 11/24/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface LoginBase : CommonViewController
- (void)loginResponse:(NSDictionary *)response;

#pragma mark - Footer
- (IBAction)gotoNotice;
- (IBAction)gotoFAQ;
- (IBAction)gotoTelEnquiry;

@end
