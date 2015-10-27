//
//  RegistAccountOptionSettingView.m
//  np
//
//  Created by Infobank1 on 2015. 10. 14..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistAccountOptionSettingView.h"

@implementation RegistAccountOptionSettingView

@synthesize delegate;
@synthesize scrollView;
@synthesize contentView;

@synthesize accountNumberLabel;
@synthesize accountChangeButton;
@synthesize accountNicknameInput;
@synthesize bothSelectImg;
@synthesize bothSelectText;
@synthesize depositSelectImg;
@synthesize depositSelectText;
@synthesize withdrawSelectImg;
@synthesize withdrawSelectText;

@synthesize amountNoLimitImg;
@synthesize amountNoLimitText;
@synthesize amountLimitBgView;
@synthesize amountSelectImg;
@synthesize amountSelectText;
@synthesize amountSelectView;
@synthesize amountSeletPickerView;

@synthesize notiTimeStart;
@synthesize notiTimeEnd;

@synthesize balanceOnImg;
@synthesize balanceOnText;
@synthesize balanceOffImg;
@synthesize balanceOffText;

@synthesize notiAutoText;

@synthesize notiNoTimeImg;
@synthesize notiNoTimeText;
@synthesize notiTimeOnImg;
@synthesize notiTimeOnText;
@synthesize notiTimeOneText;
@synthesize notiTimeTwoText;
@synthesize notiTimeThreeText;

// 입출금 선택(1:입출 2:입금 3:출금)
@synthesize selectedType;
// 통지금액(0:x, 1:천, 2:만, 3:십만, 4:백만, 5:천만, 6:일억, 7:십억)
@synthesize selectedAmount;
// 제한시간 설정(0:미설정, 1:설정)
@synthesize notiTimeFlag;
// 알림제한시간(시작)(-1:미설정, 0~23시)
@synthesize notiStartTime;
// 알림제한시간(종료)(-1:미설정, 0~23시)
@synthesize notiEndTime;
// 잔액표시여부(1:표시, 2:미표시)
@synthesize balanceFlag;
// 자동이체 선택(1:발송, 2:미발송, 3:실시간)
@synthesize notiAutoFlag;
// 알림주기(1:실시간 2:지정)
@synthesize notiPeriodType;
// 지정시간 1(-1:미설정, 0~23시)
@synthesize notiPeriodTime1;
@synthesize notiPeriodTime2;
@synthesize notiPeriodTime3;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    accountChangeButton.layer.cornerRadius = accountChangeButton.frame.size.height / 2;
    accountChangeButton.alpha = 0.9f;
    
    [amountLimitBgView.layer setBorderColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f].CGColor];
    [amountLimitBgView.layer setBorderWidth:1.0f];
}

- (void)initDataWithAccountNumber:(NSString *)accountNum
{
    [scrollView setContentSize:contentView.frame.size];
    
    [accountNumberLabel setText:accountNum];
    if(delegate != nil)
    {
        [accountNicknameInput setDelegate:delegate];
    }
    // 입출금 알림 선택
    selectedType = BOTH;
    [bothSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [bothSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [depositSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    [depositSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
    [withdrawSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    [withdrawSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
    
    // 통지금액 선택
    selectedAmount = 0;
    amountList = [[NSArray alloc] initWithObjects:@"천원 이상", @"만원 이상", @"십만원 이상", @"백만원 이상", @"천만원 이상", @"일억 이상", @"십억 이상", nil];
    [amountNoLimitImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [amountNoLimitText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [amountSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    [amountSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
    
    // 알림 시간 제한 선택
    alarmTimeList = [NSArray arrayWithObjects:@"00:00", @"01:00", @"02:00", @"03:00", @"04:00", @"05:00", @"06:00", @"07:00", @"08:00", @"09:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00", nil];
    
    // 잔액 표시
    [balanceOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [balanceOnText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [balanceOffImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    [balanceOffText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
    
    // 자동이체
    notiAutoList = @[@"제한발송(22시~08시)", @"발송하지 않음", @"제한없음(실시간)"];
    
    // 알림 주기 선택
    [notiNoTimeImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [notiNoTimeText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [notiTimeOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    [notiTimeOnText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
    
    notiTimeFlag = NO;
    notiStartTime = -1;
    notiEndTime = -1;
    balanceFlag = 1;
    notiAutoFlag = 1;
    notiPeriodType = 1;
    notiPeriodTime1 = -1;
    notiPeriodTime2 = -1;
    notiPeriodTime3 = -1;
}

- (void)makePickerSelectResult
{
    switch (currentPickerView)
    {
        case AMOUNT:
        {
            [amountNoLimitImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [amountNoLimitText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            [amountSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [amountSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            selectedAmount = (AmountSettingType)pickerSelectIndex + 1;
            [amountSelectText setText:[amountList objectAtIndex:pickerSelectIndex]];
            pickerSelectIndex = -1;
            break;
        }
        case NOTI_TIME_START:
        {
            [notiTimeStart setTextColor:[UIColor colorWithRed:96.0/255.0f green:97.0/255.0f blue:102.0/255.0f alpha:1.0f]];
            [notiTimeStart setText:[alarmTimeList objectAtIndex:pickerSelectIndex]];
            notiStartTime = pickerSelectIndex;
            break;
        }
        case NOTI_TIME_END:
        {
            [notiTimeEnd setTextColor:[UIColor colorWithRed:96.0/255.0f green:97.0/255.0f blue:102.0/255.0f alpha:1.0f]];
            [notiTimeEnd setText:[alarmTimeList objectAtIndex:pickerSelectIndex]];
            notiEndTime = pickerSelectIndex;
            break;
        }
        case NOTI_PERIOD_ONE:
        {
            [notiNoTimeImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [notiNoTimeText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            [notiTimeOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [notiTimeOneText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [notiTimeOneText setTextColor:[UIColor colorWithRed:96.0/255.0f green:97.0/255.0f blue:102.0/255.0f alpha:1.0f]];
            notiPeriodType = 2;
            notiPeriodTime1 = pickerSelectIndex;
            break;
        }
        case NOTI_PERIOD_TWO:
        {
            [notiNoTimeImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [notiNoTimeText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            [notiTimeOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [notiTimeTwoText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [notiTimeTwoText setTextColor:[UIColor colorWithRed:96.0/255.0f green:97.0/255.0f blue:102.0/255.0f alpha:1.0f]];
            notiPeriodType = 2;
            notiPeriodTime2 = pickerSelectIndex;
            break;
        }
        case NOTI_PERIOD_THREE:
        {
            [notiNoTimeImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [notiNoTimeText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            [notiTimeOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [notiTimeThreeText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [notiTimeThreeText setTextColor:[UIColor colorWithRed:96.0/255.0f green:97.0/255.0f blue:102.0/255.0f alpha:1.0f]];
            notiPeriodType = 2;
            notiPeriodTime3 = pickerSelectIndex;
            break;
        }
        case NOTI_LIMIT_AUTO:
        {
            [notiAutoText setText:[notiAutoList objectAtIndex:pickerSelectIndex]];
            notiAutoFlag = pickerSelectIndex + 1;
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 입출금 알림 옵션 선택
- (NSInteger)getAlarmSettingType
{
    return (NSInteger)selectedType;
}

- (IBAction)selectDepWithType:(id)sender
{
    switch ([sender tag])
    {
        case BOTH:
        {
            [bothSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [bothSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [depositSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [depositSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            [withdrawSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [withdrawSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            selectedType = BOTH;
            break;
        }
        case DEPOSIT:
        {
            [bothSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [bothSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            [depositSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [depositSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [withdrawSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [withdrawSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            selectedType = DEPOSIT;
            break;
        }
        case WITHDRAW:
        {
            [bothSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [bothSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            [depositSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [depositSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            [withdrawSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [withdrawSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            selectedType = WITHDRAW;
            break;
        }
            
        default:
            break;
    }
    
    selectedType = (AlarmSettingType)[sender tag];
}

#pragma mark - 통지금액 옵션 선택
- (NSInteger)getAmountSettingType
{
    return (NSInteger)selectedAmount;
}

- (IBAction)selectAmountLimit:(id)sender
{
    switch ([sender tag])
    {
        case 0:
        {
            [amountNoLimitImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [amountNoLimitText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [amountSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [amountSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            selectedAmount = NOLIMIT;
            break;
        }
        case 1:
        {
            // 옵션 선택할 수 있는 피커 뷰 생성
            currentPickerView = AMOUNT;
            [self showAmountSelectPickerView];
            break;
        }
            
        default:
            break;
    }
}

/**
 @brief 알림제한시간 설정
 */
- (IBAction)selectLimtTime:(id)sender
{
    currentPickerView = (PickerViewType)[sender tag];
    [self showAmountSelectPickerView];
}

- (IBAction)selectAmountPicker:(id)sender
{
    if([sender tag] == 0)
    {
        // 피커뷰 확인 버튼
        [self makePickerSelectResult];
    }
    else if([sender tag] == 1)
    {
        // 피커뷰 취소 버튼
    }
    
    currentPickerView = 0;
    [self hideAmountSelectPickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(currentPickerView == AMOUNT)
    {
        return [amountList count];
    }
    else if(currentPickerView == NOTI_LIMIT_AUTO)
    {
        return [notiAutoList count];
    }
    else
    {
        return [alarmTimeList count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(currentPickerView == AMOUNT)
    {
        return [amountList objectAtIndex:row];
    }
    else if(currentPickerView == NOTI_LIMIT_AUTO)
    {
        return [notiAutoList objectAtIndex:row];
    }
    else
    {
        return [alarmTimeList objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerSelectIndex = row;
}

- (void)showAmountSelectPickerView
{
    [amountSelectView setFrame:CGRectMake(0, ((UIViewController *)delegate).view.frame.size.height - amountSelectView.frame.size.height, ((UIViewController *)delegate).view.frame.size.width, amountSelectView.frame.size.height)];
    [((UIViewController *)delegate).view addSubview:amountSelectView];
    [amountSeletPickerView reloadAllComponents];
    [amountSeletPickerView selectRow:0 inComponent:0 animated:NO];
}

- (void)hideAmountSelectPickerView
{
    [amountSelectView removeFromSuperview];
}

/**
 @brief 잔액 표시 설정
 */
- (IBAction)selectBalanceSetting:(id)sender
{
    if([sender tag] == 1)
    {
        [balanceOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [balanceOnText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [balanceOffImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [balanceOffText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
    }
    else if([sender tag] == 2)
    {
        [balanceOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [balanceOnText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [balanceOffImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [balanceOffText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    }
    balanceFlag = [sender tag];
}

- (IBAction)selectNotiAutoSetting:(id)sender
{
    currentPickerView = NOTI_LIMIT_AUTO;
    [self showAmountSelectPickerView];
}

- (IBAction)selectNotiTime:(id)sender
{
    if([sender tag] == 0)
    {
        [notiNoTimeImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [notiNoTimeText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [notiTimeOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [notiTimeOnText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [notiTimeOneText setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
        [notiTimeTwoText setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
        [notiTimeThreeText setTextColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f]];
        notiPeriodType = 1;
        notiPeriodTime1 = -1;
        notiPeriodTime2 = -1;
        notiPeriodTime3 = -1;
    }
    else
    {
        currentPickerView = (PickerViewType)[sender tag];
        [self showAmountSelectPickerView];
    }
}
@end
