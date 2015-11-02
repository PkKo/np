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
             moveTopViewSeperatorDown:(UILabel *)topViewSeperator
                    moveTableviewDown:(UIView *)tableview
                   moveNoDataViewDown:(UIView *)noDataView
                               target:(id)target
                      selectAllAction:(SEL)selectAllAction
            removeSelectedItemsAction:(SEL)removeSelectedItemsAction
        closeSelectToRemoveViewAction:(SEL)closeSelectToRemoveViewAction;

- (void)removeSelectToRemoveViewFromParentView:(UIView *)parentView
                      moveTopViewSeperatorBack:(UILabel *)topViewSeperator
                             moveTableviewBack:(UIView *)tableview
                            moveNoDataViewBack:(UIView *)noDataView;

#pragma mark - Date Search
- (StorageBoxDateSearchView *)hasStorageDateSearchViewInParentView:(UIView *)parentView;

- (StorageBoxDateSearchView *)addStorageDateSearchViewToParent:(UIView *)parentView
                                      moveTopViewSeperatorDown:(UILabel *)topViewSeperator
                                             moveTableviewDown:(UIView *)tableview
                                            moveNoDataViewDown:(UIView *)noDataView;

- (void)removeStorageDateSearchViewFromParentView:(UIView *)parentView
                         moveTopViewSeperatorBack:(UILabel *)topViewSeperator
                                moveTableviewBack:(UIView *)tableview
                               moveNoDataViewBack:(UIView *)noDataView;

#pragma mark - UI Customization
+ (UIColor *)getDimmedBackgroundColor;
+ (CGSize)contentSizeOfLabel:(UILabel *)label;
- (void)updateTextFieldBorder:(UITextField *)textField;
@end
