//
//  StorageBoxUtil.m
//  np
//
//  Created by Infobank2 on 9/23/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "StorageBoxUtil.h"
#import "MemoCompositionViewController.h"
#import "SNSViewController.h"


@implementation StorageBoxUtil

- (void)showMemoComposerInViewController:(UIViewController *)viewController withTransationObject:(TransactionObject *)transactionObject {
    
    NSLog(@"showMemoComposerInViewController");
    
    MemoCompositionViewController * memoComposer = [[MemoCompositionViewController alloc] initWithNibName:@"MemoCompositionViewController"
                                                                                                   bundle:nil];
    [memoComposer setTransactionObject:transactionObject];
    [self showViewController:memoComposer inParentViewController:viewController];
}

- (void)showSNSShareInViewController:(UIViewController *)viewController withTransationObject:(TransactionObject *)transactionObject {
    
    NSLog(@"showSNSShareInViewController");
    
    SNSViewController * snsShare = [[SNSViewController alloc] initWithNibName:@"SNSViewController"
                                                                                                   bundle:nil];
    [snsShare setTransactionObject:transactionObject];
    [self showViewController:snsShare inParentViewController:viewController];
}


- (void)showViewController:(UIViewController *)viewController inParentViewController:(UIViewController *)parentViewController {
    
    NSLog(@"showViewController");
    
    viewController.view.frame             = parentViewController.view.bounds;
    viewController.view.autoresizingMask  = parentViewController.view.autoresizingMask;
    
    [parentViewController addChildViewController:viewController];
    [parentViewController.view addSubview:viewController.view];
    
    [viewController didMoveToParentViewController:parentViewController];
}

@end
