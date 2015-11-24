//
//  LoginBase.m
//  np
//
//  Created by Infobank2 on 11/24/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginBase.h"
#import "ServiceDeactivationController.h"
#import "NewTermsOfUseViewController.h"
#import "StatisticMainUtil.h"
#import "CustomerCenterUtil.h"

@interface LoginBase ()

@end

@implementation LoginBase

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginResponse:(NSDictionary *)response {
    
    NSLog(@"response: %@", response);
    
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS]) {
        
        NSString * isRegistered = (NSString *)response[@"reg_yn"];
        
        if ([isRegistered isEqualToString:IS_REGISTERED_NO]) {
            [[ServiceDeactivationController sharedInstance] showForceToDeactivateAlert];
            return;
        }
        
        NSDictionary * list     = (NSDictionary *)(response[@"list"]);
        NSArray * accounts      = (NSArray *)(list[@"sub"]);
        
        int numberOfAccounts    = (int)[accounts count];
        NSMutableArray * accountNumbers = [NSMutableArray array];
        
        if (numberOfAccounts > 0) {
            
            for (NSDictionary * accountDic in accounts) {
                
                NSString * account = (NSString *)(accountDic[@"UMSA360101_OUT_SUB.account_number"]);
                if (account && ![account isEqualToString:@""]) {
                    [accountNumbers addObject:[[StatisticMainUtil sharedInstance] getAccountNumberWithoutDash:account]];
                }
            }
        }
        
        [[[LoginUtil alloc] init] saveAllAccounts:[accountNumbers copy]];
        
        NSString * isLatestTermsOfUse = (NSString *)response[@"provision_check"];
        
        if ([isLatestTermsOfUse isEqualToString:IS_LATEST_TERMS_OF_USE_YES]) {
            
            [[[LoginUtil alloc] init] showMainPage];
            
        } else {
            NewTermsOfUseViewController *termsOfUseView = [[NewTermsOfUseViewController alloc] initWithNibName:@"NewTermsOfUseViewController" bundle:nil];
            ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:termsOfUseView];
            [self.navigationController pushViewController:eVC animated:YES];
        }
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Footer
- (IBAction)gotoNotice {
    [[CustomerCenterUtil sharedInstance] gotoNotice];
}
- (IBAction)gotoFAQ {
    [[CustomerCenterUtil sharedInstance] gotoFAQ];
}

- (IBAction)gotoTelEnquiry {
    [[CustomerCenterUtil sharedInstance] gotoTelEnquiry];
}

@end
