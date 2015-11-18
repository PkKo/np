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
#import "StorageBoxDateSearchView.h"

@interface StorageBoxUtil : NSObject

#pragma mark - Memo Composer & SNS & Cert List
- (void)showCertListInViewController:(UIViewController *)viewController dataSource:(NSArray *)certificates
                     updateSltedCert:(SEL)updateSltedCert;
- (void)showMemoComposerInViewController:(UIViewController *)viewController withTransationObject:(TransactionObject *)transactionObject;
- (void)showSNSShareInViewController:(UIViewController *)viewController withTransationObject:(TransactionObject *)transactionObject;

#pragma mark - Select items to remove
- (ArchivedTransItemRemoveAllSelectView *)hasSelectAllViewInParentView:(UIView *)parentView;

- (void)addSelectToRemoveViewToParent:(UIView *)parentView
                               target:(id)target
                      selectAllAction:(SEL)selectAllAction
            removeSelectedItemsAction:(SEL)removeSelectedItemsAction
        closeSelectToRemoveViewAction:(SEL)closeSelectToRemoveViewAction;

- (void)removeSelectToRemoveViewFromParentView:(UIView *)parentView;

#pragma mark - Date Search
- (StorageBoxDateSearchView *)hasStorageDateSearchViewInParentView:(UIView *)parentView;

- (StorageBoxDateSearchView *)addStorageDateSearchViewToParent:(UIView *)parentView
                                      moveTopViewSeperatorDown:(UILabel *)topViewSeperator
                                         outsideOfKeyboardView:(UIView *)outsideOfKeyboardView;

- (void)removeStorageDateSearchViewFromParentView:(UIView *)parentView;

#pragma mark - UI Customization
+ (UIColor *)getDimmedBackgroundColor;
+ (CGSize)contentSizeOfLabel:(UILabel *)label;
- (void)updateTextFieldBorder:(UITextField *)textField;
- (void)updateTextFieldBorder:(UITextField *)textField color:(CGColorRef)color;
@end
