//
//  FooterView.m
//  np
//
//  Created by Infobank2 on 10/27/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "FooterView.h"
#import "NoticeViewController.h"
#import "FaqViewController.h"
#import "TelInquiryViewController.h"

@implementation FooterView

- (IBAction)gotoNB {
    NoticeViewController * notice = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:notice];
    
    UINavigationController * navController = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController;
    [navController pushViewController:eVC animated:YES];
}

- (IBAction)gotoFAQ {
    FaqViewController * faq = [[FaqViewController alloc] initWithNibName:@"FaqViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:faq];
    
    UINavigationController * navController = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController;
    [navController pushViewController:eVC animated:YES];
}

- (IBAction)gotoTelInquiry {
    TelInquiryViewController * telInquiry = [[TelInquiryViewController alloc] initWithNibName:@"TelInquiryViewController"
                                                                                       bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:telInquiry];
    
    UINavigationController * navController = ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.navigationController;
    [navController pushViewController:eVC animated:YES];
}

@end
