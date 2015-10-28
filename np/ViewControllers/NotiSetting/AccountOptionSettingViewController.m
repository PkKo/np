//
//  AccountOptionSettingViewController.m
//  np
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "AccountOptionSettingViewController.h"

@interface AccountOptionSettingViewController ()

@end

@implementation AccountOptionSettingViewController

@synthesize accountNumber;
@synthesize contentView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:NO];
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"입출금 알림 계좌관리"];
    
    optionView = [RegistAccountOptionSettingView view];
    [optionView setDelegate:self];
    [optionView initDataWithAccountNumber:accountNumber];
    [optionView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [contentView addSubview:optionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButtonAction
/**
 @brief 확인버튼 클릭
 */
- (IBAction)optionSettingConfirm:(id)sender
{
    // 옵션 갑 확인해서 세팅한다.
}

#pragma mark - AccountOption API
- (void)accountOptionSettingRequest
{
    HttpRequest *req = [HttpRequest getInstance];
    
    [req setDelegate:self selector:@selector(accountOptionSettingResponse:)];
}

- (void)accountOptionSettingResponse:(NSDictionary *)response
{
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    [self.keyboardCloseButton setEnabled:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.keyboardCloseButton setEnabled:NO];
    self.currentTextField = nil;
}
@end
