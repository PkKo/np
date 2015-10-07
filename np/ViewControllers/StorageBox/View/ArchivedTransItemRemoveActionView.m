//
//  ArchivedTransItemRemoveActionView.m
//  np
//
//  Created by Infobank2 on 10/2/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ArchivedTransItemRemoveActionView.h"
#import "UIButton+BackgroundColor.h"

@interface ArchivedTransItemRemoveActionView()

@property (nonatomic, assign) id removeBtnTarget;
@property (nonatomic, assign) SEL removeBtnAction;

@property (nonatomic, assign) id cancelBtnTarget;
@property (nonatomic, assign) SEL cancelBtnAction;

@end

@implementation ArchivedTransItemRemoveActionView

- (IBAction)removeSelectedItems {
    if (self.removeBtnTarget) {
        [self.removeBtnTarget performSelector:self.removeBtnAction withObject:nil afterDelay:0];
    }
}

- (IBAction)closeSelectToDeleteView {
    if (self.cancelBtnTarget) {
        [self.cancelBtnTarget performSelector:self.cancelBtnAction withObject:nil afterDelay:0];
    }
}

- (void)addTargetForRemoveButton:(id)target action:(SEL)action {
    self.removeBtnTarget = target;
    self.removeBtnAction = action;
}

- (void)addTargetForCancelButton:(id)target action:(SEL)action {
    self.cancelBtnTarget = target;
    self.cancelBtnAction = action;
}

- (void)updateHighlightBackgroundColor {
    [self.removeBtn setBackgroundColor:[UIColor colorWithRed:213.0f/255.0f green:42.0f/255.0f blue:58.0f/255.0f alpha:1] forState:UIControlStateHighlighted];
    [self.cancelBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9] forState:UIControlStateHighlighted];
}
@end
