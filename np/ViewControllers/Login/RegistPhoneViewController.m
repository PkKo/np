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
#import "RegistPhoneErrorViewController.h"
#import "RegisterAccountViewController.h"

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

@synthesize isRegisteredUser;

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
    
    crmPhoneNumber = [CommonUtil decrypt3DES:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_CRM_MOBILE] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_ACCOUNT])
    {
        [phoneNumberInput setText:[crmPhoneNumber substringWithRange:NSMakeRange(3, crmPhoneNumber.length - 3)]];
        [phoneNumberInput setEnabled:NO];
    }
    
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
    
    if(orgBottomRect.size.width == 0)
    {
        orgBottomRect = bottomDescView.frame;
        [bottomDescView setFrame:CGRectMake(phoneAuthNumInput.frame.origin.x,
                                            phoneAuthNumInput.frame.origin.y,
                                            bottomDescView.frame.size.width,
                                            bottomDescView.frame.size.height)];
    }
    
    crmPhoneNumber = [CommonUtil decrypt3DES:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_CRM_MOBILE] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_ACCOUNT])
    {
        [phoneNumberInput setText:[crmPhoneNumber substringWithRange:NSMakeRange(3, crmPhoneNumber.length - 3)]];
        [phoneNumberInput setEnabled:NO];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCurrentTime:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentTime:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - UIButtonAction
/**
 @brief 앞 세자리 선택 피커뷰 호출
 */
- (IBAction)carrierNumClick:(id)sender
{
    if(pickeBgView == nil)
    {
        pickeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [pickeBgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    }
    [self.view addSubview:pickeBgView];
    [carrierPickerBgView setHidden:NO];
    [self.view bringSubviewToFront:carrierPickerBgView];
    [carrierPickerView selectRow:carrierIndex inComponent:0 animated:YES];
}

/**
 @brief 휴대폰 인증번호 요청
 */
- (IBAction)requestAuthNumber:(id)sender
{
#if !DEV_MODE
    if([[phoneNumberInput text] length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if([[phoneNumberInput text] length] < 7)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰번호를 정확히 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 휴대폰 번호 유효성 체크(CRM 확인)
    if(![crmPhoneNumber isEqualToString:[NSString stringWithFormat:@"%@%@", carrierSelectButton.titleLabel.text, phoneNumberInput.text]])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"입력한 휴대폰번호가\nNH농협에 미등록되어 있거나\n번호가 다른경우 가입이 불가능합니다." delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:@"자세히보기", nil];
        [alertView setTag:60001];
        [alertView show];
        return;
    }
#endif
    [self authNumberRequest];
}

/**
 @brief 다음화면 이동
 */
- (IBAction)nextViewClick:(id)sender
{
    [self authNumberTimerStop];
#if !DEV_MODE
    // 휴대폰 번호 입력 체크
    if([[phoneNumberInput text] length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if([[phoneNumberInput text] length] < 7)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰번호를 정확히 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // 휴대폰 번호 유효성 체크(CRM 확인)
    if(![crmPhoneNumber isEqualToString:[NSString stringWithFormat:@"%@%@", carrierSelectButton.titleLabel.text, phoneNumberInput.text]])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"입력한 휴대폰번호가\nNH농협에 미등록되어 있거나\n번호가 다른경우 가입이 불가능합니다." delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:@"자세히보기", nil];
        [alertView setTag:60001];
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
    
    // 인증번호 인증유효시간 체크
    if(authNumCounter >= AUTH_NUMBER_TIMER_MAX)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증번호 입력 시간을 초과했습니다.\n인증번호 재요청 후 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
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
    
#endif
    //*
    if(isRegisteredUser)
    {
        RegisterAccountViewController *vc = [[RegisterAccountViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        RegisterTermsViewController *vc = [[RegisterTermsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }//*/
    
//    RegisterTermsViewController *vc = [[RegisterTermsViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    authNumber = nil;
    carrierIndex = 0;
    tempIndex = 0;
    [carrierSelectButton setTitle:[carrierListArray objectAtIndex:carrierIndex] forState:UIControlStateNormal];
    [phoneNumberInput setText:@""];
    [phoneAuthNumInput setText:@""];
    [reqAuthNumButton setTitle:@"인증번호 요청" forState:UIControlStateNormal];
    [reqAuthNumButton setEnabled:YES];
    [reqAuthNumButton setBackgroundColor:[UIColor colorWithRed:62.0/255.0f green:155.0/255.0f blue:233.0/255.0f alpha:1.0f]];
    [phoneAuthNumInput setHidden:YES];
    [bottomDescView setFrame:CGRectMake(phoneAuthNumInput.frame.origin.x,
                                        phoneAuthNumInput.frame.origin.y,
                                        bottomDescView.frame.size.width,
                                        bottomDescView.frame.size.height)];
    
    [scrollView scrollsToTop];
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
    [pickeBgView removeFromSuperview];
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
    [phoneAuthNumInput setText:@""];
    
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
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증번호를 발송하였습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        
        // 인증번호 입력 대기 및 카운터 스타트
        [self authNumberTimerStart];
        [reqAuthNumButton setTitle:[NSString stringWithFormat:@"인증번호 재요청 (남은시간 %d초)", AUTH_NUMBER_TIMER_MAX] forState:UIControlStateNormal];
        [reqAuthNumButton setBackgroundColor:[UIColor colorWithRed:208.0/255.0f green:209.0/255.0f blue:214.0/255.0f alpha:1.0f]];
        [reqAuthNumButton setEnabled:NO];
        
        // 인증 코드 저장
        authNumber = [response objectForKey:RESPONSE_PHONE_AUTH_CODE];
//        [phoneAuthNumInput setText:authNumber];
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
    return 36.0f;
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
            if(textField.text.length == 4)
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
    
    [reqAuthNumButton setEnabled:YES];
    [reqAuthNumButton setBackgroundColor:[UIColor colorWithRed:62.0/255.0f green:155.0/255.0f blue:233.0/255.0f alpha:1.0f]];
}

- (void)authNumberOnTime
{
    authNumCounter++;
    
    if(authNumCounter >= AUTH_NUMBER_TIMER_MAX)
    {
        [self authNumberTimerStop];
    }
    
    // 타이머 숫자 표시
    [reqAuthNumButton setTitle:[NSString stringWithFormat:@"인증번호 재요청 (남은시간 %ld초)", AUTH_NUMBER_TIMER_MAX - authNumCounter] forState:UIControlStateNormal];
}

#pragma mark - UIApplication Notification
- (void)saveCurrentTime:(NSNotification *)noti
{
    if(authNumTimer != nil)
    {
        backgroundEnteredTime = [NSDate date];
    }
}

- (void)loadCurrentTime:(NSNotification *)noti
{
    if(authNumTimer != nil && backgroundEnteredTime != nil)
    {
        NSDate *currentDate = [NSDate date];
        NSTimeInterval timeDiff = [currentDate timeIntervalSinceDate:backgroundEnteredTime];
        authNumCounter += timeDiff;
        
        if(authNumCounter >= AUTH_NUMBER_TIMER_MAX)
        {
            [self authNumberTimerStop];
        }
        
        if(authNumCounter > AUTH_NUMBER_TIMER_MAX)
        {
            // 타이머 숫자 표시
            [reqAuthNumButton setTitle:@"인증번호 재요청 (남은시간 0초)" forState:UIControlStateNormal];
        }
        else
        {
            // 타이머 숫자 표시
            [reqAuthNumButton setTitle:[NSString stringWithFormat:@"인증번호 재요청 (남은시간 %ld초)", AUTH_NUMBER_TIMER_MAX - authNumCounter] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag])
    {
        case 60001: // 휴대폰 오류 자세히 보기 뷰 생성
        {
            if(buttonIndex == BUTTON_INDEX_OK)
            {
                RegistPhoneErrorViewController *vc = [[RegistPhoneErrorViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
            
        default:
            break;
    }
}
@end
