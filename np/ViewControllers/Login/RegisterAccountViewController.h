//
//  RegisterAccountViewController.h
//  np
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "RegistAccountAllListView.h"
#import "RegistAccountInputAccountView.h"
#import "RegistAccountOptionSettingView.h"

@interface RegisterAccountViewController : CommonViewController<UITextFieldDelegate>
{
    BOOL isCertMode;
    RegistAccountAllListView *allListView;
    RegistAccountInputAccountView *inputAccountView;
    RegistAccountOptionSettingView *optionView;
    NSMutableArray *allAccountList;
    NSString *certifiedAccountNumber;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)nextButtonClick:(id)sender;
@end
