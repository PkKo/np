//
//  EnvMgmtViewController.h
//  np
//
//  Created by Infobank2 on 10/19/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface EnvMgmtViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UIButton *usingSimpleViewBtn;
-(IBAction)toggleUsingSimpleView:(UIButton *)simpleViewSwitch;
-(IBAction)gotoLoginSettings;
-(IBAction)gotoSimpleLoginMgmt;
-(IBAction)gotoPatternLoginMgmt;
-(IBAction)gotoNoticeBgColorSettings;









- (IBAction)gotoPatternLogin:(id)sender;
- (IBAction)gotoCertLogin:(id)sender;
- (IBAction)gotoAccountLogin:(id)sender;
- (IBAction)gotoSimpleLogin:(id)sender;
    
@end
