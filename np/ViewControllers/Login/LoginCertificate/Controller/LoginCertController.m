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

- (NSArray *)getCertList {
    return [CertLoader getCertControlArray];
}

- (BOOL)checkPasswordOfCert:(NSString *)password {
    return YES;
}

@end
