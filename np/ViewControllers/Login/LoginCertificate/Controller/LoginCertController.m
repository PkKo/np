//
//  LoginCertController.m
//  np
//
//  Created by Infobank2 on 10/13/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginCertController.h"
#import "CertLoader.h"
#import "CertManager.h"
#import "LoginUtil.h"

@interface LoginCertController()

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL loginAction;

@end

@implementation LoginCertController

- (NSArray *)getCertList {
    return [CertLoader getCertControlArray];
}

- (BOOL)checkPasswordOfCert:(NSString *)password {
    
    CertInfo * certInfo = [[[LoginUtil alloc] init] getCertToLogin];
    [[CertManager sharedInstance] setCertInfo:certInfo];
    
    int rc = [[CertManager sharedInstance] checkPassword:password];
    
    if(rc == 0) {
        
        NSString * strTbs       = @"abc"; //서명할 원문
        NSString * user_id      = @"150324104128890";
        NSString * crmMobile    = @"01540051434";
        
        [[CertManager sharedInstance] setTbs:strTbs];
        NSString *sig = [CommonUtil getURLEncodedString:[[CertManager sharedInstance] getSignature]];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_LOGIN_CERT];
        
        NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
        [requestBody setObject:strTbs forKey:REQUEST_CERT_SSLSIGN_TBS];
        [requestBody setObject:sig forKey:REQUEST_CERT_SSLSIGN_SIGNATURE];
        [requestBody setObject:@"1" forKey:REQUEST_CERT_LOGIN_TYPE];
        
        [requestBody setObject:user_id forKey:@"user_id"];
        [requestBody setObject:crmMobile forKey:@"crmMobile"];
        
        NSString *bodyString = [CommonUtil getBodyString:requestBody];
        
        HttpRequest *req = [HttpRequest getInstance];
        [req setDelegate:self selector:@selector(certInfoResponse:)];
        [req requestUrl:url bodyString:bodyString];
        
        return YES;
    }
        
    return NO;
}

- (void)certInfoResponse:(NSDictionary *)response {
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        NSDictionary * list     = (NSDictionary *)(response[@"list"]);
        NSArray * accounts      = (NSArray *)(list[@"sub"]);
        
        NSLog(@"accounts: %@", accounts);
        
        int numberOfAccounts    = [accounts count];
        
        if (numberOfAccounts > 0) {
            
            NSMutableArray * accountNumbers = [NSMutableArray arrayWithCapacity:numberOfAccounts];
            for (NSDictionary * accountDic in accounts) {
                
                NSString * account = (NSString *)(accountDic[@"EAAPAL00R0_OUT_SUB.acno"]);
                
                if (account && ![account isEqualToString:@""]) {
                    [accountNumbers addObject:account];
                }
            }
            
            if ([accountNumbers count] > 0) {
                [[[LoginUtil alloc] init] saveAllAccounts:[accountNumbers copy]];
            }
        }
        
        if (self.target) {
            [self.target performSelector:self.loginAction withObject:[NSNumber numberWithBool:YES] afterDelay:0];
        }
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)addTargetForLoginResponse:(id)target action:(SEL)action {
    self.target         = target;
    self.loginAction    = action;
}
@end
