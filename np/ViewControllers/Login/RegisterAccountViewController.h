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
#import <IBNgmService/IBNgmService.h>

@interface RegisterAccountViewController : CommonViewController<UITextFieldDelegate, UIAlertViewDelegate, IBNgmServiceProtocol>
{
    BOOL isCertMode;
    RegistAccountAllListView *allListView;
    RegistAccountInputAccountView *inputAccountView;
    RegistAccountOptionSettingView *optionView;
    NSMutableArray *allAccountList;
    NSString *certifiedAccountNumber;
    NSString *receiptsPaymentId;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)nextButtonClick:(id)sender;
@end
