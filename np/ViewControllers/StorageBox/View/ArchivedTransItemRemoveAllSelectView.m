//
//  ArchivedTransItemRemoveAllSelectView.m
//  np
//
//  Created by Infobank2 on 10/2/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ArchivedTransItemRemoveAllSelectView.h"

@interface ArchivedTransItemRemoveAllSelectView()

@property (nonatomic, assign) id selectAllTarget;
@property (nonatomic, assign) SEL selectAllAction;

@end

@implementation ArchivedTransItemRemoveAllSelectView

- (IBAction)selectAll {
    
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    
    if (self.selectAllTarget) {
        [self.selectAllTarget performSelector:self.selectAllAction
                                   withObject:[NSNumber numberWithBool:self.selectAllBtn.selected]
                                   afterDelay:0];
    }
}

- (void)addTargetForSelectAllBtn:(id)target action:(SEL)action {
    self.selectAllTarget = target;
    self.selectAllAction = action;
}
@end
