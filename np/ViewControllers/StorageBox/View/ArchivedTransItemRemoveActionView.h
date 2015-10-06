//
//  ArchivedTransItemRemoveActionView.h
//  np
//
//  Created by Infobank2 on 10/2/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchivedTransItemRemoveActionView : UIView

@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

- (IBAction)removeSelectedItems;
- (IBAction)closeSelectToDeleteView;

- (void)addTargetForRemoveButton:(id)target action:(SEL)action;
- (void)addTargetForCancelButton:(id)target action:(SEL)action;

- (void)updateHighlightBackgroundColor;
@end
