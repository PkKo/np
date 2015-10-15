//
//  LoginCertController.h
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CertInfo.h"

@interface LoginCertController : NSObject

- (CertInfo *)getCert;
- (BOOL)checkPasswordOfCert:(NSString *)password;
@end