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

+ (UIColor *)getDimmedBackgroundColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)showMemoComposerInViewController:(UIViewController *)viewController withTransationObject:(TransactionObject *)transactionObject {
    
    MemoCompositionViewController * memoComposer = [[MemoCompositionViewController alloc] initWithNibName:@"MemoCompositionViewController"
                                                                                                   bundle:nil];
    [memoComposer setTransactionObject:transactionObject];
    [self showViewController:memoComposer inParentViewController:viewController];
}

- (void)showSNSShareInViewController:(UIViewController *)viewController withTransationObject:(TransactionObject *)transactionObject {
    
    SNSViewController * snsShare = [[SNSViewController alloc] initWithNibName:@"SNSViewController"
                                                                                                   bundle:nil];
    [snsShare setTransactionObject:transactionObject];
    [self showViewController:snsShare inParentViewController:viewController];
}


- (void)showViewController:(UIViewController *)viewController inParentViewController:(UIViewController *)parentViewController {
    
    viewController.view.frame             = parentViewController.view.bounds;
    viewController.view.autoresizingMask  = parentViewController.view.autoresizingMask;
    
    [parentViewController addChildViewController:viewController];
    [parentViewController.view addSubview:viewController.view];
    /*
    [parentViewController transitionFromViewController:parentViewController
                                      toViewController:viewController
                                              duration:0.3f
                                               options:UIViewAnimationOptionLayoutSubviews
                                            animations:^{
                                                viewController.view.frame             = parentViewController.view.bounds;
                                            }
                                            completion:^(BOOL finished) {
                                                [viewController didMoveToParentViewController:parentViewController];
                                            }];
    */
    [viewController didMoveToParentViewController:parentViewController];
}

@end
