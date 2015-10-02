//
//  ArchivedTransItemRemoveActionView.m
//  np
//
//  Created by Infobank2 on 10/2/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ArchivedTransItemRemoveActionView.h"

@interface ArchivedTransItemRemoveActionView()

@property (nonatomic, assign) id removeBtnTarget;
@property (nonatomic, assign) SEL removeBtnAction;

@property (nonatomic, assign) id cancelBtnTarget;
@property (nonatomic, assign) SEL cancelBtnAction;

@end

@implementation ArchivedTransItemRemoveActionView

- (IBAction)removeSelectedItems {
    NSLog(@"%s", __func__);
    if (self.removeBtnTarget) {
        [self.removeBtnTarget performSelector:self.removeBtnAction withObject:nil afterDelay:0];
    }
}

- (IBAction)closeSelectToDeleteView {
    NSLog(@"%s", __func__);
    if (self.cancelBtnTarget) {
        [self.cancelBtnTarget performSelector:self.cancelBtnAction withObject:nil afterDelay:0];
    }
}

- (void)addTargetForRemoveButton:(id)target action:(SEL)action {
    NSLog(@"%s", __func__);
    self.removeBtnTarget = target;
    self.removeBtnAction = action;
}

- (void)addTargetForCancelButton:(id)target action:(SEL)action {
    NSLog(@"%s", __func__);
    self.cancelBtnTarget = target;
    self.cancelBtnAction = action;
}
@end
