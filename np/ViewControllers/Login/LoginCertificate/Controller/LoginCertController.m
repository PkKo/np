//
//  LoginCertController.m
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginCertController.h"
#import "CertLoader.h"

@implementation LoginCertController

- (CertInfo *)getCert {
    
    NSMutableArray * certArr = [CertLoader getCertControlArray];
    if (certArr != nil && [certArr count] > 0) {
        [certArr objectAtIndex:0];
    }
    
    return nil;
}

- (BOOL)checkPasswordOfCert:(NSString *)password {
    return YES;
}

@end
