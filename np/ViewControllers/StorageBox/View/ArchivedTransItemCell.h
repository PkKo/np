//
//  ArchivedTransItemCell.h
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArchivedTransItemCellDelegate <NSObject>

- (void)markAsDeleted:(BOOL)isMarkedAsDeleted ofItemSection:(NSInteger)section row:(NSInteger)row;

@end

@interface ArchivedTransItemCell : UITableViewCell

@property (weak) id<ArchivedTransItemCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView    * transacTypeImageView;
@property (weak, nonatomic) IBOutlet UIButton       * deleteBtn;
@property (nonatomic) NSInteger                     section;
@property (nonatomic) NSInteger                     row;
- (IBAction)clickDeleteBtn;
@property (weak, nonatomic) IBOutlet UILabel        * transacTime;
@property (weak, nonatomic) IBOutlet UILabel        * transacName;
@property (weak, nonatomic) IBOutlet UILabel        * transacAmount;
@property (weak, nonatomic) IBOutlet UIImageView    * pinImageView;
@property (weak, nonatomic) IBOutlet UILabel        * transacAccountNo;
@property (weak, nonatomic) IBOutlet UILabel        * transacBalance;
@property (weak, nonatomic) IBOutlet UILabel        * transacMemo;
- (IBAction)editMemo;

@end
