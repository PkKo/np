//
//  ArchivedTransactionItemsViewController.h
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "StorageBoxDateSearchView.h"

@interface ArchivedTransactionItemsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, StorageBoxDateSearchViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton       * sortByDateBtn;
- (IBAction)clickSortByDate;
- (IBAction)toggleRemovalView:(id)sender;
- (IBAction)toggleSearchView;
@property (weak, nonatomic) IBOutlet UILabel        * topViewSeperator;
@property (weak, nonatomic) IBOutlet UITableView    * tableview;
@property (weak, nonatomic) IBOutlet UIView *keyboardBgView;
- (IBAction)tapToHideKeyboard:(UITapGestureRecognizer *)sender;

#pragma mark - goto Top button
@property (strong, nonatomic) IBOutlet UIButton     * scrollMoveTopButton;
- (IBAction)scrollToTopOfTableView;

#pragma mark - no data
@property (weak, nonatomic) IBOutlet UIView         * noDataView;
@property (weak, nonatomic) IBOutlet UIImageView    * noDataImageView;
@property (weak, nonatomic) IBOutlet UILabel        * noDataNotice;

@end
