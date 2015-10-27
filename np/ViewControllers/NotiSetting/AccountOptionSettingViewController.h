//
//  AccountOptionSettingViewController.h
//  np
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "RegistAccountOptionSettingView.h"

@interface AccountOptionSettingViewController : CommonViewController<UITextFieldDelegate>
{
    RegistAccountOptionSettingView *optionView;
}

@property (strong, nonatomic) NSString *accountNumber;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (IBAction)optionSettingConfirm:(id)sender;
@end
