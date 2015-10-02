//
//  ArchivedTransItemRemoveActionView.h
//  np
//
//  Created by Infobank2 on 10/2/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchivedTransItemRemoveActionView : UIView

- (IBAction)removeSelectedItems;
- (IBAction)closeSelectToDeleteView;

- (void)addTargetForRemoveButton:(id)target action:(SEL)action;
- (void)addTargetForCancelButton:(id)target action:(SEL)action;
@end
