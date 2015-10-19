//
//  ArchivedTransItemCell.m
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ArchivedTransItemCell.h"
#import "StorageBoxUtil.h"

@implementation ArchivedTransItemCell

- (IBAction)clickDeleteBtn {
    [self.deleteBtn setSelected:!self.deleteBtn.selected];
    [self.delegate markAsDeleted:self.deleteBtn.isSelected ofItemSection:self.section row:self.row];
    
}

- (IBAction)editMemo {
    [self.editView setHidden:NO];
    [self.editTextField setText:self.transacMemo.text];
    [self.editTextField becomeFirstResponder];
    
}
- (IBAction)saveNewMemo {
    
    [self.editTextField resignFirstResponder];
    
    [self.editView setHidden:YES];
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

@end
