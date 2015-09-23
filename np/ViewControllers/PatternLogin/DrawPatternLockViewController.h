//
//  DrawPatternLockViewController.h
//  np
//
//  Created by Infobank2 on 9/21/15.
//  Copyright (c) 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "DrawPatternLockView.h"

@interface DrawPatternLockViewController : CommonViewController {
    NSMutableArray* _paths;
    
    // after pattern is drawn, call this:
    id _target;
    SEL _action;
}
@property (weak, nonatomic) IBOutlet DrawPatternLockView *patternView;
// get key from the pattern drawn
- (NSString*)getKey;
- (void)setTarget:(id)target withAction:(SEL)action;

- (IBAction)showMemoComposer;
@end
