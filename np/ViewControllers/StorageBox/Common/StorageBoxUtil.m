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
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
}

- (void)addSelectToRemoveViewToParent:(UIView *)parentView
             moveTopViewSeperatorDown:(UILabel *)topViewSeperator
                    moveTableviewDown:(UIView *)tableview
                               target:(id)target
                      selectAllAction:(SEL)selectAllAction
            removeSelectedItemsAction:(SEL)removeSelectedItemsAction
        closeSelectToRemoveViewAction:(SEL)closeSelectToRemoveViewAction {
    
    if ([self hasSelectAllViewInParentView:parentView]) {
        return;
    }
    
    NSArray * nibArr = [[NSBundle mainBundle] loadNibNamed:@"ArchivedTransItemRemoveAllSelectView"
                                                     owner:self options:nil];
    ArchivedTransItemRemoveAllSelectView * selectAllView = (ArchivedTransItemRemoveAllSelectView *)[nibArr objectAtIndex:0];
    
    [selectAllView addTargetForSelectAllBtn:target action:selectAllAction];
    
    CGRect selectToRemoveViewFrame      = selectAllView.frame;
    selectToRemoveViewFrame.origin.y    = topViewSeperator.frame.origin.y;
    selectToRemoveViewFrame.size.width  = parentView.frame.size.width;
    [selectAllView setFrame:selectToRemoveViewFrame];
    
    CGRect topViewSeperatorFrame    = topViewSeperator.frame;
    topViewSeperatorFrame.origin.y += selectToRemoveViewFrame.size.height;
    [topViewSeperator setFrame:topViewSeperatorFrame];
    
    CGRect tableviewFrame           = tableview.frame;
    tableviewFrame.origin.y        += selectToRemoveViewFrame.size.height;
    tableviewFrame.size.height     -= selectToRemoveViewFrame.size.height;
    [tableview setFrame:tableviewFrame];
    
    [parentView addSubview:selectAllView];
    
    // -------
    
    nibArr = [[NSBundle mainBundle] loadNibNamed:@"ArchivedTransItemRemoveActionView"
                                           owner:self options:nil];
    ArchivedTransItemRemoveActionView * removeCancelView = (ArchivedTransItemRemoveActionView *)[nibArr objectAtIndex:0];
    [removeCancelView addTargetForRemoveButton:target action:removeSelectedItemsAction];
    [removeCancelView addTargetForCancelButton:target action:closeSelectToRemoveViewAction];
    [removeCancelView updateHighlightBackgroundColor];
    
    CGRect removeCancelViewFrame        = removeCancelView.frame;
    removeCancelViewFrame.origin.y      = parentView.frame.size.height - removeCancelViewFrame.size.height;
    removeCancelViewFrame.size.width    = parentView.frame.size.width;
    [removeCancelView setFrame:removeCancelViewFrame];
    /*
    tableviewFrame.size.height         -= removeCancelViewFrame.size.height + 18;
    [tableview setFrame:tableviewFrame];
    */
    [parentView addSubview:removeCancelView];
}

- (void)removeSelectToRemoveViewFromParentView:(UIView *)parentView
                      moveTopViewSeperatorBack:(UILabel *)topViewSeperator
                             moveTableviewBack:(UIView *)tableview {
    
    ArchivedTransItemRemoveAllSelectView    * selectAllView     = [self hasSelectAllViewInParentView:parentView];
    ArchivedTransItemRemoveActionView       * removeCancelView  = [self hasRemoveCancelViewInParentView:parentView];
    
    if (selectAllView && removeCancelView) {
        
        CGRect selectToRemoveViewFrame  = selectAllView.frame;
        CGRect topViewSeperatorFrame    = topViewSeperator.frame;
        topViewSeperatorFrame.origin.y -= selectToRemoveViewFrame.size.height;
        [topViewSeperator setFrame:topViewSeperatorFrame];
        
        
        CGRect tableviewFrame           = tableview.frame;
        tableviewFrame.origin.y        -= selectToRemoveViewFrame.size.height;
        tableviewFrame.size.height     += selectToRemoveViewFrame.size.height;
        [tableview setFrame:tableviewFrame];
        /*
        CGRect removeCancelViewFrame    = removeCancelView.frame;
        tableviewFrame.size.height     += removeCancelViewFrame.size.height;
        [tableview setFrame:tableviewFrame];
        */
        [selectAllView removeFromSuperview];
        [removeCancelView removeFromSuperview];
    }
}

- (ArchivedTransItemRemoveAllSelectView *)hasSelectAllViewInParentView:(UIView *)parentView {
    
    NSArray * subviews = [parentView subviews];
    for (UIView * subview in subviews) {
        if ([subview isKindOfClass:[ArchivedTransItemRemoveAllSelectView class]]) {
            return (ArchivedTransItemRemoveAllSelectView *)subview;
        }
    }
    return nil;
}

- (ArchivedTransItemRemoveActionView *)hasRemoveCancelViewInParentView:(UIView *)parentView {
    
    NSArray * subviews = [parentView subviews];
    for (UIView * subview in subviews) {
        if ([subview isKindOfClass:[ArchivedTransItemRemoveActionView class]]) {
            return (ArchivedTransItemRemoveActionView *)subview;
        }
    }
    return nil;
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
    [viewController didMoveToParentViewController:parentViewController];
}

@end
