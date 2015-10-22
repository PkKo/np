//
//  NotiSettingMenuViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 24..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface NotiSettingMenuViewController : CommonViewController<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *allNotiButton;

- (IBAction)allNotiOnOff:(id)sender;
- (IBAction)moveAccountSetting:(id)sender;
- (IBAction)moveExchangeSetting:(id)sender;
@end
