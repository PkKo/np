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

@synthesize scrollView;
@synthesize contentView;

@synthesize carrierSelectButton;
@synthesize phoneNumberInput;
@synthesize reqAuthNumButton;
@synthesize phoneAuthNumInput;
@synthesize carrierPickerView;
@synthesize carrierPickerBgView;

@synthesize descLabelOne;
@synthesize descLabelTwo;
@synthesize descLabelThree;
@synthesize bottomDescView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mMenuButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
    if(scrollView.frame.size.height < contentView.frame.size.height)
    {
        [scrollView setContentSize:contentView.frame.size];
    }
    
    carrierSelectButton.layer.borderWidth = 1.0f;
    carrierSelectButton.layer.borderColor = [UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f].CGColor;
    
    NSString *carrierListPath = [[NSBundle mainBundle] pathForResource:@"CarrierList" ofType:@"plist"];
    carrierListArray = [[NSArray alloc] initWithContentsOfFile:carrierListPath];
    
    crmPhoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_CRM_MOBILE];
    authNumCounter = 0;
    
    NSMutableAttributedString *textOne = [[NSMutableAttributedString alloc] initWithString:descLabelOne.text];
    [textOne addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:48.0/255.0f green:158.0/255.0f blue:251.0/255.0f alpha:1.0f] range:NSMakeRange(0, 11)];
    [textOne addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(11, 40)];
    [descLabelOne setAttributedText:textOne];
    
    NSMutableAttributedString *textTwo = [[NSMutableAttributedString alloc] initWithString:descLabelTwo.text];
    [textTwo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:48.0/255.0f green:158.0/255.0f blue:251.0/255.0f alpha:1.0f] range:NSMakeRange(0, 13)];
    [textTwo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(13, textTwo.length - 13)];
    [descLabelTwo setAttributedText:textTwo];
    
    NSMutableAttributedString *textThree = [[NSMutableAttributedString alloc] initWithString:descLabelThree.text];
    [textThree addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:48.0/255.0f green:158.0/255.0f blue:251.0/255.0f alpha:1.0f] range:NSMakeRange(0, 19)];
    [textThree addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(19, textThree.length - 19)];
    [descLabelThree setAttributedText:textThree];
    
    carrierIndex = 0;
    tempIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    orgBottomRect = bottomDescView.frame;
    [bottomDescView setFrame:CGRectMake(phoneAuthNumInput.frame.origin.x,
                                        phoneAuthNumInput.frame.origin.y,
                                        bottomDescView.frame.size.width,
                                        bottomDescView.frame.size.height)];
}

#pragma mark - UIButtonAction
/**
 @brief 앞 세자리 선택 피커뷰 호출
 */
- (IBAction)carrierNumClick:(id)sender
{
    [carrierPickerBgView setHidden:NO];
    [carrierPickerView selectRow:carrierIndex inComponent:0 animated:YES];
}

/**
 @brief 휴대폰 인증번호 요청
 */
- (IBAction)requestAuthNumber:(id)sender
{
    if([[phoneNumberInput text] length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 휴대폰 번호 유효성 체크(CRM 확인)
    if(![crmPhoneNumber isEqualToString:[NSString stringWithFormat:@"%@%@", carrierSelectButton.titleLabel.text, phoneNumberInput.text]])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"해당 휴대폰 번호는 NH농협에 미등록되어 있는 번호입니다.\n번호가 변경된 경우는 인근 영업점에 고객정보를 변경 후 이용하시기 바랍니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [self authNumberRequest];
}

/**
 @brief 다음화면 이동
 */
- (IBAction)nextViewClick:(id)sender
{
#if 0
    RegisterTermsViewController *vc = [[RegisterTermsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
#else
    
    [self authNumberTimerStop];
    
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
    
    // 휴대폰 번호 유효성 체크(CRM 확인)
    if(![crmPhoneNumber isEqualToString:[NSString stringWithFormat:@"%@%@", carrierSelectButton.titleLabel.text, phoneNumberInput.text]])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"해당 휴대폰 번호는 NH농협에 미등록되어 있는 번호입니다.\n번호가 변경된 경우는 인근 영업점에 고객정보를 변경 후 이용하시기 바랍니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 인증번호 유효성 체크
    if(![authNumber isEqualToString:phoneAuthNumInput.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"입력하신 인증번호가 일치하지 않습니다.\n다시 확인해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 인증번호 인증유효시간 체크
    if(authNumCounter == AUTH_NUMBER_TIMER_MAX)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증번호 입력 시간을 초과했습니다.\n인증번호 재요청 후 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    RegisterTermsViewController *vc = [[RegisterTermsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
#endif
}

#pragma mark - PickerView Action
- (IBAction)pickerSelectConfirm:(id)sender
{
    carrierIndex = tempIndex;
    [carrierSelectButton setTitle:[carrierListArray objectAtIndex:carrierIndex] forState:UIControlStateNormal];
    [self pickerViewHide:nil];
}

- (IBAction)pickerViewHide:(id)sender
{
    [carrierPickerBgView setHidden:YES];
}

#pragma mark - Network Connect
/**
 @brief 인증번호 Request
 */
- (void)authNumberRequest
{
    [self startIndicator];
    
    [phoneAuthNumInput setHidden:NO];
    [bottomDescView setFrame:CGRectMake(orgBottomRect.origin.x, orgBottomRect.origin.y, bottomDescView.frame.size.width, bottomDescView.frame.size.height)];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_PHONE_AUTH];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[NSString stringWithFormat:@"%@%@", carrierSelectButton.titleLabel.text, phoneNumberInput.text] forKey:REQUEST_PHONE_AUTH_NUMBER];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(authNumberResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}
/**
 @brief 인증번호 Response
 */
- (void)authNumberResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    // Connection Success
    if([[response objectForKey:RESULT] isEqualToString:@"0"])
    {
        // 인증번호 입력 대기 및 카운터 스타트
        [self authNumberTimerStart];
        [reqAuthNumButton setTitle:[NSString stringWithFormat:@"인증번호 재요청 (남은시간 %d초)", AUTH_NUMBER_TIMER_MAX] forState:UIControlStateNormal];
        
        // 임시 코드
        authNumber = [response objectForKey:RESPONSE_PHONE_AUTH_CODE];
        [phoneAuthNumInput setText:authNumber];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - UIPickerViewDataSource
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
}

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
    tempIndex = row;
    /*
    [carrierSelectButton setTitle:[carrierListArray objectAtIndex:row] forState:UIControlStateNormal];
    [carrierPickerView setHidden:YES];*/
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
    [self.keyboardCloseButton setHidden:NO];
    [self.keyboardCloseButton setEnabled:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentTextField = nil;
    [self.keyboardCloseButton setEnabled:NO];
    [self.keyboardCloseButton setHidden:YES];
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
    authNumCounter = 0;
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
    [reqAuthNumButton setTitle:[NSString stringWithFormat:@"인증번호 재요청 (남은시간 %ld초)", AUTH_NUMBER_TIMER_MAX - authNumCounter] forState:UIControlStateNormal];
}

@end
