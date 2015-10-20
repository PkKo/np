//
//  DrawPatternMgmtViewController.h
//  np
//
//  Created by Infobank2 on 10/20/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "DrawPatternLockView.h"

@interface DrawPatternMgmtViewController : CommonViewController <UIAlertViewDelegate> {
    NSMutableArray* _paths;
    
    // after pattern is drawn, call this:
    id _target;
    SEL _action;
}

@property (weak, nonatomic) IBOutlet DrawPatternLockView    * patternView;
@property (weak, nonatomic) IBOutlet UILabel                * guide;
@property (weak, nonatomic) IBOutlet UIButton               * nextBtn;

- (IBAction)clickCancel;
- (IBAction)clickNext;

- (NSString*)getKey;
- (void)setTarget:(id)target withAction:(SEL)action;

@end
