//
//  NoticeBackgroundSettingsViewController.h
//  np
//
//  Created by Infobank2 on 10/19/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface NoticeBackgroundSettingsViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;


- (IBAction)selectBackgroundColor:(UITapGestureRecognizer *)sender;
- (IBAction)clickCancel;
- (IBAction)clickDone;
@end
