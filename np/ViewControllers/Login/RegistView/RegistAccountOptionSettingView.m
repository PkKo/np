//
//  RegistAccountOptionSettingView.m
//  np
//
//  Created by Infobank1 on 2015. 10. 14..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistAccountOptionSettingView.h"
#import "StorageBoxUtil.h"

#define DESCRIPTION_THREE_LINE_HEIGHT   48


@implementation RegistAccountOptionSettingView

@synthesize delegate;
@synthesize scrollView;
@synthesize contentView;
@synthesize accountType;

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

@synthesize notiAbortOnImg;
@synthesize notiAbortLabel;
@synthesize notiTimeStartLabel;
@synthesize notiTimeEndLabel;

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

// 계좌삭제버튼
@synthesize accountDeleteButton;

// description views
@synthesize descLabel1;
@synthesize descDot1;
@synthesize descView2;
@synthesize descLabel2;
@synthesize descDot2;
@synthesize descView3;
@synthesize descLabel3;
@synthesize descDot3;
@synthesize descView4;
@synthesize descLabel4;
@synthesize descDot4;
@synthesize descView5;
@synthesize descLabel5;
@synthesize descView6;
@synthesize descLabel6;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    accountChangeButton.layer.cornerRadius = accountChangeButton.frame.size.height / 2;
    accountChangeButton.alpha = 0.9f;
    
    [amountLimitBgView.layer setBorderColor:[UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f].CGColor];
    [amountLimitBgView.layer setBorderWidth:1.0f];
    
    
    [descDot1 setFrame:CGRectMake(descDot1.frame.origin.x,
                                  descLabel1.frame.origin.y + 4,
                                  descDot1.frame.size.width,
                                  descDot1.frame.size.height)];
    [descView2 setFrame:CGRectMake(descView2.frame.origin.x,
                                   descLabel1.frame.origin.y + descLabel1.frame.size.height + 4,
                                   descView2.frame.size.width,
                                   descLabel2.frame.size.height)];
    [descView3 setFrame:CGRectMake(descView3.frame.origin.x,
                                   descView2.frame.origin.y + descView2.frame.size.height + 4,
                                   descView3.frame.size.width,
                                   descLabel3.frame.size.height)];
    [descView4 setFrame:CGRectMake(descView4.frame.origin.x,
                                   descView3.frame.origin.y + descView3.frame.size.height + 4,
                                   descView4.frame.size.width,
                                   descLabel4.frame.size.height)];
    [descView5 setFrame:CGRectMake(descView5.frame.origin.x,
                                   descView4.frame.origin.y + descView4.frame.size.height + 4,
                                   descView5.frame.size.width,
                                   descLabel5.frame.size.height)];
    [descView6 setFrame:CGRectMake(descView6.frame.origin.x,
                                   descView5.frame.origin.y + descView5.frame.size.height + 4,
                                   descView6.frame.size.width,
                                   descLabel5.frame.size.height)];
    [accountDeleteButton setFrame:CGRectMake(accountDeleteButton.frame.origin.x,
                                             descView6.frame.origin.y + descView6.frame.size.height + 15,
                                             accountDeleteButton.frame.size.width,
                                             accountDeleteButton.frame.size.height)];
    
    [contentView setFrame:CGRectMake(0, 0, scrollView.frame.size.width, accountDeleteButton.frame.origin.y + accountDeleteButton.frame.size.height + 15)];
    [scrollView setContentSize:contentView.frame.size];
    [scrollView setContentInset:UIEdgeInsetsZero];
}

- (void)initDataWithAccountNumber:(NSString *)accountNum numberOfAccounts:(NSInteger)numberOfAccounts
{
    
    [scrollView setContentSize:contentView.frame.size];
    
    [accountNumberLabel setText:[CommonUtil getAccountNumberAddDash:accountNum]];
    
    
    if (numberOfAccounts > 0) {
        [self.numberOfAccountsLabel setHidden:NO];
        
        CGRect accountNumberLabelRect       = accountNumberLabel.frame;
        CGSize transacAmountTypeSize        = [StorageBoxUtil contentSizeOfLabel:accountNumberLabel];
        accountNumberLabelRect.size.width   = transacAmountTypeSize.width;
        [accountNumberLabel setFrame:accountNumberLabelRect];
        
        [self.numberOfAccountsLabel setText:[NSString stringWithFormat:@"외 %d건", numberOfAccounts]];
        CGRect numberOfAccountsLabelRect    = self.numberOfAccountsLabel.frame;
        CGSize numberOfAccountsLabelSize    = [StorageBoxUtil contentSizeOfLabel:self.numberOfAccountsLabel];
        numberOfAccountsLabelRect.origin.x  = accountNumberLabelRect.origin.x + accountNumberLabelRect.size.width;
        numberOfAccountsLabelRect.size.width= numberOfAccountsLabelSize.width;
        [self.numberOfAccountsLabel setFrame:numberOfAccountsLabelRect];
        
    } else {
        [self.numberOfAccountsLabel setHidden:YES];
    }
    
    
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
    notiAbortFlag = NO;
    [notiAbortOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    [notiAbortLabel setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
    alarmTimeList = [NSArray arrayWithObjects:@"선택", @"00:00", @"01:00", @"02:00", @"03:00", @"04:00", @"05:00", @"06:00", @"07:00", @"08:00", @"09:00", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00", @"20:00", @"21:00", @"22:00", @"23:00", nil];
    
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
    alarmPeriodList = [NSArray arrayWithObjects:@"선택", @"00시", @"01시", @"02시", @"03시", @"04시", @"05시", @"06시", @"07시", @"08시", @"09시", @"10시", @"11시", @"12시", @"13시", @"14시", @"15시", @"16시", @"17시", @"18시", @"19시", @"20시", @"21시", @"22시", @"23시", nil];
    
    notiTimeFlag = NO;
    notiStartTime = -1;
    notiEndTime = -1;
    balanceFlag = 1;
    notiAutoFlag = 1;
    notiPeriodType = 1;
    notiPeriodTime1 = -1;
    notiPeriodTime2 = -1;
    notiPeriodTime3 = -1;
    
    [descLabel1 sizeToFit];
    [descLabel2 sizeToFit];
    [descLabel3 sizeToFit];
    [descLabel4 sizeToFit];
}

- (void)makeAllOptionDataView
{
    // 입출금 알림 선택
    [self notiEventViewSetting];
    // 통지금액 뷰
    [self notiAmountViewSetting];
    // 알림제한시간 뷰
    [self notiUnnotiTimeViewSetting];
    // 잔액 표시 뷰
    [self notiBalanceViewSetting];
    // 자동이체 선택
    [self notiAutoSelectViewSetting];
    // 알림주기
    [self notiPeriodSelectViewSetting];
}

/**
 @brief 입출금 알림 뷰
 */
- (void)notiEventViewSetting
{
    switch (selectedType)
    {
        case BOTH:
        {
            [bothSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [bothSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [depositSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [depositSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            [withdrawSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [withdrawSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
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
            break;
        }
        default:
            break;
    }
}

/**
 @brief 통지금액 뷰 설정
 */
- (void)notiAmountViewSetting
{
    if(selectedAmount == 0)
    {
        [amountNoLimitImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [amountNoLimitText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [amountSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [amountSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [amountSelectText setText:[amountList objectAtIndex:selectedAmount]];
    }
    else
    {
        [amountNoLimitImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [amountNoLimitText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [amountSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [amountSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [amountSelectText setText:[amountList objectAtIndex:selectedAmount - 1]];
    }
    
    if(accountType == EXCHANGE)
    {
        [amountNoLimitImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [amountNoLimitText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [amountSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [amountSelectText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [amountSelectText setText:[amountList objectAtIndex:selectedAmount]];
    }
}

/**
 @brief 알림시간 제한 뷰 설정
 */
- (void)notiUnnotiTimeViewSetting
{
    if(notiStartTime < 0 && notiEndTime < 0)
    {
        notiTimeFlag = NO;
    }
    else
    {
        notiAbortFlag = YES;
        notiTimeFlag = YES;
    }
    
    if(notiTimeFlag)
    {
        if(notiStartTime < 0)
        {
            [notiTimeStartLabel setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            [notiTimeStartLabel setText:[alarmTimeList objectAtIndex:notiStartTime + 1]];
        }
        else
        {
            [notiTimeStartLabel setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [notiTimeStartLabel setText:[[alarmTimeList objectAtIndex:notiStartTime + 1] stringByReplacingCharactersInRange:NSMakeRange(2, 3) withString:@""]];
        }
        
        if(notiEndTime < 0)
        {
            [notiTimeEndLabel setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
            [notiTimeEndLabel setText:[alarmTimeList objectAtIndex:notiEndTime + 1]];
        }
        else
        {
            [notiTimeEndLabel setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [notiTimeEndLabel setText:[[alarmTimeList objectAtIndex:notiEndTime + 1] stringByReplacingCharactersInRange:NSMakeRange(2, 3) withString:@""]];
        }
    }
    else
    {
        [notiTimeStartLabel setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [notiTimeStartLabel setText:[alarmTimeList objectAtIndex:notiStartTime + 1]];
        [notiTimeEndLabel setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [notiTimeEndLabel setText:[alarmTimeList objectAtIndex:notiEndTime + 1]];
    }
    
    if(notiAbortFlag)
    {
        [notiAbortOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [notiAbortLabel setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    }
    else
    {
        [notiAbortOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [notiAbortLabel setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
    }
}

/**
 @brief 잔액표시 뷰 설정
 */
- (void)notiBalanceViewSetting
{
    if(balanceFlag == 1)
    {
        // 잔액 표시
        [balanceOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [balanceOnText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [balanceOffImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [balanceOffText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
    }
    else if(balanceFlag == 2)
    {
        // 잔액 미표시
        [balanceOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [balanceOnText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [balanceOffImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [balanceOffText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    }
}

/**
 @brief 자동이체 선택 뷰 설정
 */
- (void)notiAutoSelectViewSetting
{
    [notiAutoText setText:[notiAutoList objectAtIndex:notiAutoFlag - 1]];
    [notiAutoText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    
    if(accountType == FUND || accountType == TRUST)
    {
        [notiAutoText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
    }
}

/**
 @brief 알림 주기 뷰 설정
 */
- (void)notiPeriodSelectViewSetting
{
    if(notiPeriodTime1 < 0 && notiPeriodTime2 < 0 && notiPeriodTime3 < 0)
    {
        notiPeriodType = 1;
    }
    else
    {
        notiPeriodType = 2;
    }
    
    if(notiPeriodType == 1)
    {
        [notiNoTimeImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [notiNoTimeText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [notiTimeOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [notiTimeOnText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [notiTimeOneText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [notiTimeTwoText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [notiTimeThreeText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
    }
    else if (notiPeriodType == 2)
    {
        [notiNoTimeImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [notiNoTimeText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [notiTimeOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [notiTimeOnText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        
        if(notiPeriodTime1 < 0)
        {
            [notiTimeOneText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        }
        else
        {
            [notiTimeOneText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        }
        
        if(notiPeriodTime2 < 0)
        {
            [notiTimeTwoText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        }
        else
        {
            [notiTimeTwoText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        }
        
        if(notiPeriodTime3 < 0)
        {
            [notiTimeThreeText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        }
        else
        {
            [notiTimeThreeText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        }
    }
    
    [notiTimeOneText setText:[alarmPeriodList objectAtIndex:notiPeriodTime1 + 1]];
    [notiTimeTwoText setText:[alarmPeriodList objectAtIndex:notiPeriodTime2 + 1]];
    [notiTimeThreeText setText:[alarmPeriodList objectAtIndex:notiPeriodTime3 + 1]];
}

#pragma mark - 피커뷰 선택
- (void)makePickerSelectResult
{
    switch (currentPickerView)
    {
        case AMOUNT:
        {
            selectedAmount = (AmountSettingType)pickerSelectIndex + 1;
            [self notiAmountViewSetting];
            break;
        }
        case NOTI_TIME_START:
        {
            notiStartTime = pickerSelectIndex - 1;
            [self notiUnnotiTimeViewSetting];
            if(notiStartTime > -1 && (notiStartTime >= notiEndTime) && notiEndTime > -1)
            {
                NSString *message = [NSString stringWithFormat:@"선택하신 알림 시간제한은 %@시 00분 부터 \n익일 %@시 59분까지입니다.", [[alarmTimeList objectAtIndex:notiStartTime + 1] stringByReplacingCharactersInRange:NSMakeRange(2, 3) withString:@""], [[alarmTimeList objectAtIndex:notiEndTime + 1] stringByReplacingCharactersInRange:NSMakeRange(2, 3) withString:@""]];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
            }
            
            if(notiStartTime >= 0)
            {
                notiPeriodSelectFlag = NO;
                notiPeriodTime1 = -1;
                notiPeriodTime2 = -1;
                notiPeriodTime3 = -1;
                [self notiPeriodSelectViewSetting];
            }
            break;
        }
        case NOTI_TIME_END:
        {
            notiEndTime = pickerSelectIndex - 1;
            [self notiUnnotiTimeViewSetting];
            if(notiStartTime > -1 && (notiStartTime >= notiEndTime) && notiEndTime > -1)
            {
                NSString *message = [NSString stringWithFormat:@"선택하신 알림 시간제한은 %@시 00분 부터 \n익일 %@시 59분까지입니다.", [[alarmTimeList objectAtIndex:notiStartTime + 1] stringByReplacingCharactersInRange:NSMakeRange(2, 3) withString:@""], [[alarmTimeList objectAtIndex:notiEndTime + 1] stringByReplacingCharactersInRange:NSMakeRange(2, 3) withString:@""]];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
            }
            
            if(notiEndTime >= 0)
            {
                notiPeriodSelectFlag = NO;
                notiPeriodTime1 = -1;
                notiPeriodTime2 = -1;
                notiPeriodTime3 = -1;
                [self notiPeriodSelectViewSetting];
            }
            break;
        }
        case NOTI_PERIOD_ONE:
        {
            if((pickerSelectIndex > 0 && ((pickerSelectIndex - 1) == notiPeriodTime2 || (pickerSelectIndex - 1) == notiPeriodTime3)))
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"같은 시간으로 알림설정 할 수 없습니다.\n다시 선택해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
                return;
            }
            notiPeriodTime1 = pickerSelectIndex - 1;
            [self notiPeriodSelectViewSetting];
            
            if(notiPeriodTime1 >= 0)
            {
                notiAbortFlag = NO;
                notiStartTime = -1;
                notiEndTime = -1;
                [self notiUnnotiTimeViewSetting];
            }
            break;
        }
        case NOTI_PERIOD_TWO:
        {
            if((pickerSelectIndex > 0 && ((pickerSelectIndex - 1) == notiPeriodTime1 || (pickerSelectIndex - 1) == notiPeriodTime3)))
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"같은 시간으로 알림설정 할 수 없습니다.\n다시 선택해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
                return;
            }
            notiPeriodTime2 = pickerSelectIndex - 1;
            [self notiPeriodSelectViewSetting];
            
            if(notiPeriodTime2 >= 0)
            {
                notiAbortFlag = NO;
                notiStartTime = -1;
                notiEndTime = -1;
                [self notiUnnotiTimeViewSetting];
            }
            break;
        }
        case NOTI_PERIOD_THREE:
        {
            if((pickerSelectIndex > 0 && ((pickerSelectIndex - 1) == notiPeriodTime1 || (pickerSelectIndex - 1) == notiPeriodTime2)))
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"같은 시간으로 알림설정 할 수 없습니다.\n다시 선택해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
                return;
            }
            notiPeriodTime3 = pickerSelectIndex - 1;
            [self notiPeriodSelectViewSetting];
            
            if(notiPeriodTime3 >= 0)
            {
                notiAbortFlag = NO;
                notiStartTime = -1;
                notiEndTime = -1;
                [self notiUnnotiTimeViewSetting];
            }
            break;
        }
        case NOTI_LIMIT_AUTO:
        {
            notiAutoFlag = pickerSelectIndex + 1;
            [self notiAutoSelectViewSetting];
            break;
        }
            
        default:
            break;
    }
    
    pickerSelectIndex = -1;
}

#pragma mark - 입출금 알림 옵션 선택
- (NSInteger)getAlarmSettingType
{
    return (NSInteger)selectedType;
}

- (IBAction)selectDepWithType:(id)sender
{
    selectedType = (AlarmSettingType)[sender tag];
    [self notiEventViewSetting];
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
            selectedAmount = NOLIMIT;
            [self notiAmountViewSetting];
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

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 36;
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
    else if (currentPickerView == NOTI_PERIOD_ONE || currentPickerView == NOTI_PERIOD_TWO || currentPickerView == NOTI_PERIOD_THREE)
    {
        return [alarmPeriodList count];
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
    else if (currentPickerView == NOTI_PERIOD_ONE || currentPickerView == NOTI_PERIOD_TWO || currentPickerView == NOTI_PERIOD_THREE)
    {
        return [alarmPeriodList objectAtIndex:row];
    }
    else
    {
        return [alarmTimeList objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    pickerSelectIndex = (int)row;
}

- (void)showAmountSelectPickerView
{
    [amountSelectView setFrame:CGRectMake(0, ((UIViewController *)delegate).view.frame.size.height - amountSelectView.frame.size.height, ((UIViewController *)delegate).view.frame.size.width, amountSelectView.frame.size.height)];
    
    if(pickerBgView == nil)
    {
        pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ((UIViewController *)delegate).view.frame.size.width, ((UIViewController *)delegate).view.frame.size.height - amountSelectView.frame.size.height)];
        [pickerBgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    }
    
    switch (currentPickerView)
    {
        case AMOUNT:
        {
            // 외환계좌인 경우 통지금액 옵션 선택할 수 없음
            if(accountType == EXCHANGE)
            {
                return;
            }
            if(selectedAmount > 0)
            {
                pickerSelectIndex = selectedAmount - 1;
            }
            else
            {
                pickerSelectIndex = 0;
            }
            break;
        }
        case NOTI_TIME_START:
        {
            if(!notiAbortFlag)
            {
                return;
            }
            pickerSelectIndex = notiStartTime + 1;
            break;
        }
        case NOTI_TIME_END:
        {
            if(!notiAbortFlag)
            {
                return;
            }
            pickerSelectIndex = notiEndTime + 1;
            break;
        }
        case NOTI_PERIOD_ONE:
        {
            if(!notiPeriodSelectFlag)
            {
                return;
            }
            
//            if(notiStartTime > -1 || notiEndTime > -1)
//            {
//                return;
//            }
            pickerSelectIndex = notiPeriodTime1 + 1;
            break;
        }
        case NOTI_PERIOD_TWO:
        {
            if(!notiPeriodSelectFlag)
            {
                return;
            }
            
//            if(notiStartTime > -1 || notiEndTime > -1)
//            {
//                return;
//            }
            pickerSelectIndex = notiPeriodTime2 + 1;
            break;
        }
        case NOTI_PERIOD_THREE:
        {
            if(!notiPeriodSelectFlag)
            {
                return;
            }
            
//            if(notiStartTime > -1 || notiEndTime > -1)
//            {
//                return;
//            }
            pickerSelectIndex = notiPeriodTime3 + 1;
            break;
        }
        case NOTI_LIMIT_AUTO:
        {
            // 펀드계좌인 경우 자동이체 옵션 선택할 수 없음
            if(accountType == FUND || accountType == TRUST)
            {
                return;
            }
            pickerSelectIndex = notiAutoFlag - 1;
            break;
        }
            
        default:
            break;
    }
    
    [((UIViewController *)delegate).view addSubview:pickerBgView];
    [((UIViewController *)delegate).view addSubview:amountSelectView];
    [amountSeletPickerView reloadAllComponents];
    [amountSeletPickerView selectRow:pickerSelectIndex inComponent:0 animated:YES];
}

- (void)hideAmountSelectPickerView
{
    [pickerBgView removeFromSuperview];
    [amountSelectView removeFromSuperview];
}

/**
 @brief 잔액 표시 설정
 */
- (IBAction)selectBalanceSetting:(id)sender
{
    balanceFlag = (int)[sender tag];
    [self notiBalanceViewSetting];
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
        [self notiPeriodSelectViewSetting];
    }
    else
    {
        currentPickerView = (PickerViewType)[sender tag];
        [self showAmountSelectPickerView];
    }
}

- (IBAction)selectNotiAbort:(id)sender
{
    /*
    if(notiPeriodTime1 >= 0 || notiPeriodTime2 >= 0 || notiPeriodTime3 >= 0)
    {
        notiAbortFlag = NO;
    }
    else
    {
        notiAbortFlag = !notiAbortFlag;
    }*/
    
    notiAbortFlag = !notiAbortFlag;
    
    if(notiAbortFlag)
    {
        [notiAbortOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [notiAbortLabel setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    }
    else
    {
        notiStartTime = -1;
        notiEndTime = -1;
        [self notiUnnotiTimeViewSetting];
    }
}

- (IBAction)selectNotiPeriodFlag:(id)sender
{
    notiPeriodSelectFlag = !notiPeriodSelectFlag;
    
    if(notiPeriodSelectFlag)
    {
        [notiNoTimeImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
        [notiNoTimeText setTextColor:CIRCLE_TEXT_COLOR_UNSELECTED];
        [notiTimeOnImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
        [notiTimeOnText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    }
    else
    {
        notiPeriodTime1 = -1;
        notiPeriodTime2 = -1;
        notiPeriodTime3 = -1;
        
        [self notiPeriodSelectViewSetting];
    }
}

#pragma mark - TextField
- (IBAction)validateNicknameTextEditing:(UITextField *)textField
{
    NSLog(@"%s, text = %@, %d", __FUNCTION__, textField.text, (int)textField.text.length);
    NSLog(@"%s, text = %@, %d", __FUNCTION__, [textField.text precomposedStringWithCanonicalMapping], (int)[textField.text precomposedStringWithCanonicalMapping].length);
    int maxLength = 5;
    if ([[textField text] length] > maxLength)
    {
        [textField setText:[[textField text] substringToIndex:maxLength]];
    }
}
@end
