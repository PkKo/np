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
}

@property (weak, nonatomic) IBOutlet DrawPatternLockView    * patternView;
@property (weak, nonatomic) IBOutlet UILabel                * guide;
@property (weak, nonatomic) IBOutlet UIButton               * nextBtn;
@property (weak, nonatomic) IBOutlet UIButton               * initialBtn;

- (IBAction)clickToShowSelfIdentifier;
- (IBAction)clickCancel;
- (IBAction)clickNext;

@end
