//
//  DrawPatternLockViewController.h
//  np
//
//  Created by Infobank2 on 9/21/15.
//  Copyright (c) 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginBase.h"
#import "DrawPatternLockView.h"

@interface DrawPatternLockViewController : LoginBase {
    NSMutableArray* _paths;
}

@property (weak, nonatomic) IBOutlet UIView * footer;
@property (weak, nonatomic) IBOutlet UIView * settingsView;
@property (weak, nonatomic) IBOutlet DrawPatternLockView * patternView;

- (NSString*)getKey;
- (IBAction)gotoPatternLoginMgmt;
- (IBAction)gotoLoginSettings;

@end
