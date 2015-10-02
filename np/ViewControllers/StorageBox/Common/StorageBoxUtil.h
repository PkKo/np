//
//  StorageBoxUtil.h
//  np
//
//  Created by Infobank2 on 9/23/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionObject.h"
#import "ArchivedTransItemRemoveAllSelectView.h"
#import "ArchivedTransItemRemoveActionView.h"

@interface StorageBoxUtil : NSObject

- (void)showMemoComposerInViewController:(UIViewController *)viewController withTransationObject:(TransactionObject *)transactionObject;
- (void)showSNSShareInViewController:(UIViewController *)viewController withTransationObject:(TransactionObject *)transactionObject;

- (ArchivedTransItemRemoveAllSelectView *)hasSelectAllViewInParentView:(UIView *)parentView;
- (void)addSelectToRemoveViewToParent:(UIView *)parentView
             moveTopViewSeperatorDown:(UILabel *)topViewSeperator
                    moveTableviewDown:(UITableView *)tableview
                               target:(id)target
                      selectAllAction:(SEL)selectAllAction
            removeSelectedItemsAction:(SEL)removeSelectedItemsAction
        closeSelectToRemoveViewAction:(SEL)closeSelectToRemoveViewAction;

- (void)removeSelectToRemoveViewFromParentView:(UIView *)parentView
                      moveTopViewSeperatorBack:(UILabel *)topViewSeperator
                             moveTableviewBack:(UITableView *)tableview;

+ (UIColor *)getDimmedBackgroundColor;

@end
