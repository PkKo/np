//
//  ArchivedTransItemCell.m
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ArchivedTransItemCell.h"
#import "StorageBoxUtil.h"
#import "DepositStickerView.h"
#import "MainPageViewController.h"

@implementation ArchivedTransItemCell

- (IBAction)clickDeleteBtn {
    if (self.pinnable) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"고정핀 적용된 아이템은 삭제되지 않습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
    } else {
        [self.deleteBtn setSelected:!self.deleteBtn.selected];
        [self.delegate markAsDeleted:self.deleteBtn.isSelected ofItemSection:self.section row:self.row];
    }
}

- (IBAction)togglePinup {
    
    // do nothing in edit mode
    if (![self.editView isHidden]) {
        return;
    }
    
    if (!self.deleteBtn.isHidden) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"삭제 상태에서 고정핀 해제할 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        [self.pinupBtn setSelected:!self.pinupBtn.isSelected];
        [self.delegate markAsPinup:self.pinupBtn.isSelected ofItemSection:self.section row:self.row];
    }
}

- (IBAction)editMemo {
    [self.editView setHidden:NO];
    [self.textingIcon setHidden:YES];
    [self.transacMemo setHidden:YES];
    [self.editTextField setText:self.transacMemo.text];
    [self.editTextField becomeFirstResponder];
    
}
- (IBAction)saveNewMemo {
    
    [self.editTextField resignFirstResponder];
    
    [self.editView setHidden:YES];
    [self.textingIcon setHidden:NO];
    [self.transacMemo setHidden:NO];
    [self.transacMemo setText:self.editTextField.text];
    
    [self.delegate updateMemo:self.transacMemo.text ofItemSection:self.section row:self.row];
}

- (void)updateMemoTextBorder {
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeEditTextField];
}

#pragma mark - Keyboard
- (IBAction)validateEditingText:(UITextField *)sender {
    if ([[sender text] length] > 10) {
        [sender setText:[[sender text] substringToIndex:10]];
    }
}

#pragma mark - Sticker
- (IBAction)stickerButtonClick:(UIButton *)sender
{
    
    // do nothing in edit mode
    if (![self.editView isHidden]) {
        return;
    }
    
    switch ([sender tag])
    {
        case STICKER_DEPOSIT_NORMAL:
        case STICKER_DEPOSIT_SALARY:
        case STICKER_DEPOSIT_POCKET:
        case STICKER_DEPOSIT_ETC:
        {
            // 입금 스티커
            DepositStickerView * depositStickerView = [DepositStickerView view];
            [depositStickerView setFrame:CGRectMake(0, 0, self.frame.size.width, ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame.size.height)];
            [depositStickerView setDelegate:self];
            
            [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view addSubview:depositStickerView];
            break;
        }
        case STICKER_WITHDRAW_NORMAL:
        case STICKER_WITHDRAW_FOOD:
        case STICKER_WITHDRAW_TELEPHONE:
        case STICKER_WITHDRAW_HOUSING:
        case STICKER_WITHDRAW_SHOPPING:
        case STICKER_WITHDRAW_CULTURE:
        case STICKER_WITHDRAW_EDUCATION:
        case STICKER_WITHDRAW_CREDIT:
        case STICKER_WITHDRAW_SAVING:
        case STICKER_WITHDRAW_ETC:
        {
            // 출금 스티커
            WithdrawStickerSettingView * withdrawStickerView = [WithdrawStickerSettingView view];
            [withdrawStickerView setFrame:CGRectMake(0, 0, self.frame.size.width, ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view.frame.size.height)];
            [withdrawStickerView setDelegate:self];
            
            [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController.view addSubview:withdrawStickerView];
            break;
        }
            
        default:
            break;
    }
}

- (void)selectedStickerIndex:(NSNumber *)index {
    StickerType selectedStickerCode = (StickerType)index.integerValue;
    NSLog(@"%s, %d", __FUNCTION__, (int)selectedStickerCode);
    
    [self updateTransTypeImageBtnByStickerCode:selectedStickerCode];
    [self.delegate updateSticker:selectedStickerCode ofItemSection:self.section row:self.row];
}

- (void)updateTransTypeImageBtnByStickerCode:(StickerType)stickerCode {
    [self.transacTypeBtn setImage:[CommonUtil getStickerImage:stickerCode] forState:UIControlStateNormal];
    [self.transacTypeBtn setTag:stickerCode];
}


@end
