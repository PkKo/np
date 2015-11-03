//
//  CustomerCenterUtil.m
//  np
//
//  Created by Infobank2 on 11/3/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "CustomerCenterUtil.h"
#import "NoticeViewController.h"
#import "FaqViewController.h"
#import "TelInquiryViewController.h"

@implementation CustomerCenterUtil


+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (void)gotoNotice {
    NoticeViewController * notice = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
    [self gotoViewController:notice];
}

- (void)gotoFAQ {
    
    FaqViewController * faq = [[FaqViewController alloc] initWithNibName:@"FaqViewController" bundle:nil];
    [self gotoViewController:faq];
}

- (void)gotoTelEnquiry {
    
    TelInquiryViewController * telInquiry = [[TelInquiryViewController alloc] initWithNibName:@"TelInquiryViewController"
                                                                                       bundle:nil];
    [self gotoViewController:telInquiry];
}

- (void)gotoViewController:(UIViewController *)vc {
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
    
    UINavigationController * navController = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController;
    [navController pushViewController:eVC animated:YES];
}


@end
