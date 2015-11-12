//
//  ExchangeCountryAddViewController.m
//  np
//
//  Created by Infobank1 on 2015. 10. 21..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "ExchangeCountryAddViewController.h"

@interface ExchangeCountryAddViewController ()

@end

@implementation ExchangeCountryAddViewController

@synthesize scrollView;
@synthesize contentView;

@synthesize isNewCoutry;
@synthesize countryCode;
@synthesize countryName;
@synthesize countryAllList;
@synthesize countryNameLabel;
@synthesize countrySelectButton;
@synthesize countryDeleteButton;

@synthesize optionOneImg;
@synthesize optionOneText;
@synthesize optionTwoImg;
@synthesize optionTwoText;
@synthesize periodTimeOneLabel;
@synthesize periodTimeTwoLabel;
@synthesize periodTimeThreeLabel;

@synthesize pickerView;
@synthesize pickerSelectView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:NO];
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"통화국가 추가/편집"];
    
    alarmPeriodList = [NSArray arrayWithObjects:@"선택", @"00시", @"01시", @"02시", @"03시", @"04시", @"05시", @"06시", @"07시", @"08시", @"09시", @"10시", @"11시", @"12시", @"13시", @"14시", @"15시", @"16시", @"17시", @"18시", @"19시", @"20시", @"21시", @"22시", @"23시", nil];

    [scrollView setContentSize:contentView.frame.size];
    
    [countryDeleteButton setHidden:isNewCoutry];
    
    pickerList = [[NSMutableArray alloc] init];
    countrySelectIndex = 0;
    periodFlag = 1;
    periodOneIndex = 0;
    periodTwoIndex = 0;
    periodThreeIndex = 0;
    
    if(!isNewCoutry)
    {
        // 기존 옵션 정보를 가져온다
        [countrySelectButton setEnabled:NO];
        [countryNameLabel setText:countryName];
        [countryNameLabel setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [self registedCurrencyOptionRequest];
    }
    else
    {
        [self makeOptionSettingView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Option View 구성
- (void)makeOptionSettingView
{
    if(periodFlag == 1)
    {
        [optionOneImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [optionOneText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [optionTwoImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [optionTwoText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        
        [periodTimeOneLabel setTextColor:[UIColor colorWithRed:176.0/255.0f green:177.0/255.0f blue:182.0/255.0f alpha:1.0f]];
        [periodTimeTwoLabel setTextColor:[UIColor colorWithRed:176.0/255.0f green:177.0/255.0f blue:182.0/255.0f alpha:1.0f]];
        [periodTimeThreeLabel setTextColor:[UIColor colorWithRed:176.0/255.0f green:177.0/255.0f blue:182.0/255.0f alpha:1.0f]];
    }
    else if(periodFlag == 2)
    {
        [optionOneImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [optionOneText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [optionTwoImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [optionTwoText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        
        if(periodOneIndex == 0)
        {
            [periodTimeOneLabel setTextColor:[UIColor colorWithRed:176.0/255.0f green:177.0/255.0f blue:182.0/255.0f alpha:1.0f]];
        }
        else
        {
            [periodTimeOneLabel setTextColor:[UIColor colorWithRed:96.0/255.0f green:97.0/255.0f blue:102.0/255.0f alpha:1.0f]];
        }
        
        if(periodTwoIndex == 0)
        {
            [periodTimeTwoLabel setTextColor:[UIColor colorWithRed:176.0/255.0f green:177.0/255.0f blue:182.0/255.0f alpha:1.0f]];
        }
        else
        {
            [periodTimeTwoLabel setTextColor:[UIColor colorWithRed:96.0/255.0f green:97.0/255.0f blue:102.0/255.0f alpha:1.0f]];
        }
        
        if(periodThreeIndex == 0)
        {
            [periodTimeThreeLabel setTextColor:[UIColor colorWithRed:176.0/255.0f green:177.0/255.0f blue:182.0/255.0f alpha:1.0f]];
        }
        else
        {
            [periodTimeThreeLabel setTextColor:[UIColor colorWithRed:96.0/255.0f green:97.0/255.0f blue:102.0/255.0f alpha:1.0f]];
        }
    }
    
    [periodTimeOneLabel setText:[alarmPeriodList objectAtIndex:periodOneIndex]];
    [periodTimeTwoLabel setText:[alarmPeriodList objectAtIndex:periodTwoIndex]];
    [periodTimeThreeLabel setText:[alarmPeriodList objectAtIndex:periodThreeIndex]];
}

#pragma mark - 환율 옵션 요청
- (void)registedCurrencyOptionRequest
{
    [self startIndicator];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_UMS_USER_ID] forKey:@"user_id"];
    [reqBody setObject:countryCode forKey:REQUEST_EXCHANGE_CURRENCY_NATION_ID];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_EXCHANGE_CURRENCY_COUNTRY_OPION];
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(registedCurrencyOptionResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)registedCurrencyOptionResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        exchangeRateId = [response objectForKey:@"UMSW023001_OUT_SUB.exchange_rate_id"];
        periodFlag = [[response objectForKey:@"UMSW023001_OUT_SUB.noti_period_type"] integerValue];
        periodOneIndex = [[response objectForKey:@"UMSW023001_OUT_SUB.noti_time1"] integerValue] + 1;
        periodTwoIndex = [[response objectForKey:@"UMSW023001_OUT_SUB.noti_time2"] integerValue] + 1;
        periodThreeIndex = [[response objectForKey:@"UMSW023001_OUT_SUB.noti_time3"] integerValue] + 1;
        
        [self makeOptionSettingView];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - 환율 옵션 수정 저장
- (void)currencyOptionSaveRequest
{
    [self startIndicator];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_UMS_USER_ID] forKey:@"user_id"];
    [reqBody setObject:countryCode forKey:REQUEST_EXCHANGE_CURRENCY_NATION_ID];
    [reqBody setObject:exchangeRateId forKey:RESPONSE_EXCHANGE_CURRENCY_EXCHANGE_RATE_ID];
    [reqBody setObject:[NSNumber numberWithInt:(int)periodFlag] forKey:REQUEST_NOTI_OPTION_PERIOD_TYPE];
    [reqBody setObject:[NSNumber numberWithInt:(int)periodOneIndex - 1] forKey:REQUEST_NOTI_OPTION_NOTI_TIME_ONE];
    [reqBody setObject:[NSNumber numberWithInt:(int)periodTwoIndex - 1] forKey:REQUEST_NOTI_OPTION_NOTI_TIME_TWO];
    [reqBody setObject:[NSNumber numberWithInt:(int)periodThreeIndex - 1] forKey:REQUEST_NOTI_OPTION_NOTI_TIME_THREE];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_EXCHANGE_CURRENCY_CHANGE_OPTION];
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(currencyOptionSaveResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)currencyOptionSaveResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ExchangeCurrencyCountryUpdateNotification" object:self];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - 환율 옵션 추가
- (void)currencyOptionMakeRequest
{
    [self startIndicator];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_UMS_USER_ID] forKey:@"user_id"];
    [reqBody setObject:countryCode forKey:REQUEST_EXCHANGE_CURRENCY_NATION_ID];
    [reqBody setObject:[NSNumber numberWithInt:(int)periodFlag] forKey:REQUEST_NOTI_OPTION_PERIOD_TYPE];
    [reqBody setObject:[NSNumber numberWithInt:(int)periodOneIndex - 1] forKey:REQUEST_NOTI_OPTION_NOTI_TIME_ONE];
    [reqBody setObject:[NSNumber numberWithInt:(int)periodTwoIndex - 1] forKey:REQUEST_NOTI_OPTION_NOTI_TIME_TWO];
    [reqBody setObject:[NSNumber numberWithInt:(int)periodThreeIndex - 1] forKey:REQUEST_NOTI_OPTION_NOTI_TIME_THREE];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_EXCHANGE_CURRENCY_ADD_COUNTRY];
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(currencyOptionMakeResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)currencyOptionMakeResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ExchangeCurrencyCountryUpdateNotification" object:self];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - 환율 국가 삭제
- (void)currencyCountryDeleteRequest
{
    [self startIndicator];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_UMS_USER_ID] forKey:@"user_id"];
    [reqBody setObject:countryCode forKey:REQUEST_EXCHANGE_CURRENCY_NATION_ID];
    [reqBody setObject:exchangeRateId forKey:RESPONSE_EXCHANGE_CURRENCY_EXCHANGE_RATE_ID];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQEUST_EXCHANGE_CURRENCY_COUNTRY_DELETE];
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(currencyCountryDeleteResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)currencyCountryDeleteResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ExchangeCurrencyCountryUpdateNotification" object:self];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - UIButtonAction
- (IBAction)confirmButtonClick:(id)sender
{
    if(isNewCoutry)
    {
        if(countrySelectIndex == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"대상국가를 선택해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        else
        {
            [self currencyOptionMakeRequest];
        }
    }
    else
    {
        [self currencyOptionSaveRequest];
    }
}

- (IBAction)cancelButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)currencyCountrySelect:(id)sender
{
    isCountrySelectMode = YES;
    [pickerView setHidden:NO];
    pickerList = (NSMutableArray *)countryAllList;
    [pickerSelectView reloadAllComponents];
    [pickerSelectView selectRow:countrySelectIndex inComponent:0 animated:YES];
}

- (IBAction)nonPeriodOptionSelect:(id)sender
{
    periodFlag = 1;
    [self makeOptionSettingView];
}

- (IBAction)periodOptionSelect:(id)sender
{
    isCountrySelectMode = NO;
    [pickerView setHidden:NO];
    pickerList = (NSMutableArray *)alarmPeriodList;
    [pickerSelectView reloadAllComponents];
    [pickerSelectView setTag:[sender tag]];
    if([sender tag] == 1)
    {
        [pickerSelectView selectRow:periodOneIndex inComponent:0 animated:YES];
    }
    else if([sender tag] == 2)
    {
        [pickerSelectView selectRow:periodTwoIndex inComponent:0 animated:YES];
    }
    else if([sender tag] == 3)
    {
        [pickerSelectView selectRow:periodThreeIndex inComponent:0 animated:YES];
    }
}

- (IBAction)countryDeleteSelect:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"선택한 국가의 환율정보 알림을 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alertView setTag:80001];
    [alertView show];
}

- (IBAction)pickerSelectConfirm:(id)sender
{
    [self pickerViewHide:nil];

    if(isCountrySelectMode)
    {
        countrySelectIndex = tempIndex;
        [countryNameLabel setText:[[countryAllList objectAtIndex:countrySelectIndex] objectForKey:@"UMSW023004_OUT_SUB.nation_name"]];
        countryCode = [[countryAllList objectAtIndex:countrySelectIndex] objectForKey:@"UMSW023004_OUT_SUB.nation_id"];
        if(countrySelectIndex == 0)
        {
            [countryNameLabel setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        }
        else
        {
            [countryNameLabel setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        }
    }
    else
    {
        periodFlag = 2;
        if([pickerSelectView tag] == 1)
        {
            periodOneIndex = tempIndex;
        }
        else if([pickerSelectView tag] == 2)
        {
            periodTwoIndex = tempIndex;
        }
        else if([pickerSelectView tag] == 3)
        {
            periodThreeIndex = tempIndex;
        }
        [self makeOptionSettingView];
    }
}

- (IBAction)pickerViewHide:(id)sender
{
    [pickerView setHidden:YES];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    
    if(isCountrySelectMode)
    {
        title = [[pickerList objectAtIndex:row] objectForKey:@"UMSW023004_OUT_SUB.nation_name"];
    }
    else
    {
        title = [pickerList objectAtIndex:row];
    }
    
    return title;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    tempIndex = row;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == BUTTON_INDEX_OK)
    {
        switch ([alertView tag])
        {
            case 80001:
            {
                // 계좌 삭제
                [self currencyCountryDeleteRequest];
                break;
            }
                
            default:
                break;
        }
    }
}
@end
