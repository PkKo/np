//
//  ArchivedTransItemCell.h
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepositStickerView.h"
#import "WithdrawStickerSettingView.h"

@protocol ArchivedTransItemCellDelegate <NSObject>

- (void)markAsDeleted:(BOOL)isMarkedAsDeleted ofItemSection:(NSInteger)section row:(NSInteger)row;
- (void)markAsPinup:(BOOL)isPinnable ofItemSection:(NSInteger)section row:(NSInteger)row;
- (void)updateMemo:(NSString *)memo ofItemSection:(NSInteger)section row:(NSInteger)row;
- (void)updateSticker:(StickerType)sticker ofItemSection:(NSInteger)section row:(NSInteger)row;

@end

@interface ArchivedTransItemCell : UITableViewCell <StickerSettingDelegate>

@property (weak) id<ArchivedTransItemCellDelegate> delegate;

@property (nonatomic) NSInteger                     section;
@property (nonatomic) NSInteger                     row;
@property (nonatomic) BOOL                          pinnable;

@property (weak, nonatomic) IBOutlet UIButton       * transacTypeBtn;
- (IBAction)stickerButtonClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton       * deleteBtn;
- (IBAction)clickDeleteBtn;
@property (weak, nonatomic) IBOutlet UILabel        * transacTime;
@property (weak, nonatomic) IBOutlet UILabel        * transacName;
@property (weak, nonatomic) IBOutlet UIView         * transacAmountView;
@property (weak, nonatomic) IBOutlet UILabel        * transacAmountType;
@property (weak, nonatomic) IBOutlet UILabel        * transacAmount;
@property (weak, nonatomic) IBOutlet UILabel        * transacAmountUnit;
@property (weak, nonatomic) IBOutlet UIButton       * pinupBtn;
@property (weak, nonatomic) IBOutlet UILabel        * transacAccountNo;
@property (weak, nonatomic) IBOutlet UILabel        * transacBalance;
@property (weak, nonatomic) IBOutlet UILabel        * transacMemo;
@property (weak, nonatomic) IBOutlet UIButton       * editMemoBtn;
- (IBAction)editMemo;
@property (weak, nonatomic) IBOutlet UIView         * editView;
@property (weak, nonatomic) IBOutlet UITextField    * fakeEditTextField;
@property (weak, nonatomic) IBOutlet UITextField    * editTextField;
@property (weak, nonatomic) IBOutlet UIImageView    * textingIcon;

- (IBAction)togglePinup;
- (IBAction)saveNewMemo;
- (IBAction)validateEditingText:(UITextField *)sender;
- (void)updateTransTypeImageBtnByStickerCode:(StickerType)stickerCode;
- (void)updateMemoTextBorder;
@end
