//
//  VersionInfoViewController.h
//  np
//
//  Created by Infobank2 on 10/21/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface VersionInfoViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UIButton *checkAppVersionBtn;
- (IBAction)checkAppVersion:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *currentVersionNo;
@property (weak, nonatomic) IBOutlet UILabel *latestVersionNo;

@end
