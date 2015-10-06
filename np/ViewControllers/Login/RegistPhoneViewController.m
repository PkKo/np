//
//  RegistPhoneViewController.m
//  회원가입 - 휴대폰인증
//
//  Created by Infobank1 on 2015. 9. 21..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "RegistPhoneViewController.h"
#import "RegistTabView.h"
#import "RegisterTermsViewController.h"

#define AUTH_NUMBER_TIMER_INTERVAL  1.0
#define AUTH_NUMBER_TIMER_MAX       180

@interface RegistPhoneViewController ()

@end

@implementation RegistPhoneViewController

@synthesize carrierSelectButton;
@synthesize phoneNumberInput;
@synthesize reqAuthNumButton;
@synthesize phoneAuthNumInput;
@synthesize carrierPickerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mMenuButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
    NSString *carrierListPath = [[NSBundle mainBundle] pathForResource:@"CarrierList" ofType:@"plist"];
    carrierListArray = [[NSArray alloc] initWithContentsOfFile:carrierListPath];
    
    isAuthNumberConfirm = false;
    isPhoneNumberConfirm = false;
    
    authNumCounter = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButtonAction
/**
 @brief 앞 세자리 선택 피커뷰 호출
 */
- (IBAction)carrierNumClick:(id)sender
{
    [carrierPickerView setHidden:NO];
}

/**
 @brief 휴대폰 인증번호 요청
 */
- (IBAction)requestAuthNumber:(id)sender
{
}

/**
 @brief 다음화면 이동
 */
- (IBAction)nextViewClick:(id)sender
{
    // 휴대폰 번호 입력 체크
    if([[phoneNumberInput text] length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 인증번호 입력 체크
    if([[phoneAuthNumInput text] length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 인증번호 유효성 체크
    if(!isAuthNumberConfirm)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"입력하신 인증번호가 일치하지 않습니다.\n다시 확인해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 휴대폰 번호 유효성 체크(CRM 확인)
    if(!isPhoneNumberConfirm)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"해당 휴대폰 번호는 NH농협에 미등록되어 있는 번호입니다.\n번호가 변경된 경우는 인근 영업점에 고객정보를 변경 후 이용하시기 바랍니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 인증번호 인증유효시간 체크
    
    RegisterTermsViewController *vc = [[RegisterTermsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Network Connect
/**
 @brief 인증번호 Request
 */
- (void)authNumberRequest
{
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(authNumberResponse:)];
    [req requestUrl:@"Server URL" bodyObject:nil];
}
/**
 @brief 인증번호 Response
 */
- (void)authNumberResponse:(NSDictionary *)response
{
    // Connection Success
    if([[response objectForKey:@""] isEqualToString:@"200"])
    {
        // 인증번호 입력 대기 및 카운터 스타트
        [self authNumberTimerStart];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [carrierListArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [carrierListArray objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [carrierSelectButton setTitle:[carrierListArray objectAtIndex:row] forState:UIControlStateNormal];
    [carrierPickerView setHidden:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    [self.keyboardCloseButton setEnabled:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentTextField = nil;
    [self.keyboardCloseButton setEnabled:NO];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(![string isEqualToString:@""])
    {
        if([textField isEqual:phoneNumberInput])
        {
            if(textField.text.length == 8)
            {
                return NO;
            }
        }
        else if ([textField isEqual:phoneAuthNumInput])
        {
            if(textField.text.length == 6)
            {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - AuthNumberTimer
- (void)authNumberTimerStart
{
    if(authNumTimer != nil)
    {
        [authNumTimer invalidate];
        authNumTimer = nil;
    }
    
    authNumTimer = [NSTimer scheduledTimerWithTimeInterval:AUTH_NUMBER_TIMER_INTERVAL target:self selector:@selector(authNumberOnTime) userInfo:nil repeats:YES];
    [authNumTimer fire];
}

- (void)authNumberTimerStop
{
    if(authNumTimer != nil)
    {
        [authNumTimer invalidate];
        authNumTimer = nil;
    }
}

- (void)authNumberOnTime
{
    authNumCounter++;
    
    if(authNumCounter == AUTH_NUMBER_TIMER_MAX)
    {
        [self authNumberTimerStop];
    }
    
    // 타이머 숫자 표시
}

@end
