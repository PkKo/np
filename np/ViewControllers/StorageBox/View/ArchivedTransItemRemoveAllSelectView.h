//
//  ArchivedTransItemRemoveAllSelectView.h
//  np
//
//  Created by Infobank2 on 10/2/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchivedTransItemRemoveAllSelectView : UIView

@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
- (IBAction)selectAll;

- (void)addTargetForSelectAllBtn:(id)target action:(SEL)action;

@end
