//
//  RegistCompleteViewController.h
//  np
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface RegistCompleteViewController : CommonViewController<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *registCompleteTextLabel;
@property (strong, nonatomic) IBOutlet UIButton *addAccountButton;


- (IBAction)quickViewSettingClick:(id)sender;
- (IBAction)currentNotiSettingClick:(id)sender;
- (IBAction)addAccountClick:(id)sender;
- (IBAction)moveMainPage:(id)sender;
@end
