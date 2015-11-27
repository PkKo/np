//
//  RegistAccountOptionSettingView.h
//  np
//
//  Created by Infobank1 on 2015. 10. 14..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum AccountType
{
    // 입출금(요구불)
    NORMAL = 1,
    // 외화(요구불)
    EXCHANGE,
    // 수익증권
    FUND,
    // 신탁
    TRUST
}AccountType;

typedef enum AlarmSetting
{
    BOTH = 1,
    DEPOSIT,
    WITHDRAW
}AlarmSettingType;

typedef enum AmountSetting
{
    NOLIMIT = 0,
    THOUSAND,
    TEN_THOUSAND,
    HUNDRED_THOUSAND,
    MILLION,
    TEN_MILLION,
    HUNDRED_MILLION,
    BILLION
    
}AmountSettingType;

typedef enum PickerViewType
{
    AMOUNT = 1,
    NOTI_TIME_START,
    NOTI_TIME_END,
    NOTI_PERIOD_ONE,
    NOTI_PERIOD_TWO,
    NOTI_PERIOD_THREE,
    NOTI_LIMIT_AUTO
}PickerViewType;

@interface RegistAccountOptionSettingView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *amountList;
    NSArray *alarmTimeList;
    NSArray *notiAutoList;
    NSArray *alarmPeriodList;
    int pickerSelectIndex;
    PickerViewType currentPickerView;
    UIView *pickerBgView;
    BOOL notiAbortFlag;
}

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

// 계좌번호
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLabel;
// 계좌변경
@property (strong, nonatomic) IBOutlet UIButton *accountChangeButton;
//
@property (assign, nonatomic) NSInteger accountType;
// 계좌 별칭
@property (strong, nonatomic) IBOutlet CommonTextField *accountNicknameInput;
- (IBAction)validateNicknameTextEditing:(UITextField *)textField;

/////////////////////////////////////////////////////////////////
// 입출금 선택
@property (strong, nonatomic) IBOutlet CircleView *bothSelectImg;
@property (strong, nonatomic) IBOutlet UILabel *bothSelectText;
@property (strong, nonatomic) IBOutlet CircleView *depositSelectImg;
@property (strong, nonatomic) IBOutlet UILabel *depositSelectText;
@property (strong, nonatomic) IBOutlet CircleView *withdrawSelectImg;
@property (strong, nonatomic) IBOutlet UILabel *withdrawSelectText;
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
// 통지 금액
@property (strong, nonatomic) IBOutlet CircleView *amountNoLimitImg;
@property (strong, nonatomic) IBOutlet UILabel *amountNoLimitText;
@property (strong, nonatomic) IBOutlet UIView *amountLimitBgView;
@property (strong, nonatomic) IBOutlet CircleView *amountSelectImg;
@property (strong, nonatomic) IBOutlet UILabel *amountSelectText;
@property (strong, nonatomic) IBOutlet UIView *amountSelectView;
@property (strong, nonatomic) IBOutlet UIPickerView *amountSeletPickerView;
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
// 알림 시간 제한
@property (strong, nonatomic) IBOutlet CircleView *notiAbortOnImg;
@property (strong, nonatomic) IBOutlet UILabel *notiAbortLabel;
@property (strong, nonatomic) IBOutlet UILabel *notiTimeStartLabel;
@property (strong, nonatomic) IBOutlet UILabel *notiTimeEndLabel;

/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
// 잔액 표시
@property (strong, nonatomic) IBOutlet CircleView *balanceOnImg;
@property (strong, nonatomic) IBOutlet UILabel *balanceOnText;
@property (strong, nonatomic) IBOutlet CircleView *balanceOffImg;
@property (strong, nonatomic) IBOutlet UILabel *balanceOffText;
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
// 제한발송
@property (strong, nonatomic) IBOutlet UILabel *notiAutoText;
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
// 알림 주기
@property (strong, nonatomic) IBOutlet CircleView *notiNoTimeImg;
@property (strong, nonatomic) IBOutlet UILabel *notiNoTimeText;
@property (strong, nonatomic) IBOutlet CircleView *notiTimeOnImg;
@property (strong, nonatomic) IBOutlet UILabel *notiTimeOnText;
@property (strong, nonatomic) IBOutlet UILabel *notiTimeOneText;
@property (strong, nonatomic) IBOutlet UILabel *notiTimeTwoText;
@property (strong, nonatomic) IBOutlet UILabel *notiTimeThreeText;
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
@property (strong, nonatomic) IBOutlet UIButton *accountDeleteButton;
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
// description 부분
@property (strong, nonatomic) IBOutlet UILabel *descLabel1;
@property (strong, nonatomic) IBOutlet UILabel *descDot1;
@property (strong, nonatomic) IBOutlet UIView *descView2;
@property (strong, nonatomic) IBOutlet UILabel *descLabel2;
@property (strong, nonatomic) IBOutlet UILabel *descDot2;
@property (strong, nonatomic) IBOutlet UIView *descView3;
@property (strong, nonatomic) IBOutlet UILabel *descLabel3;
@property (strong, nonatomic) IBOutlet UILabel *descDot3;
@property (strong, nonatomic) IBOutlet UIView *descView4;
@property (strong, nonatomic) IBOutlet UILabel *descLabel4;
@property (strong, nonatomic) IBOutlet UILabel *descDot4;
/////////////////////////////////////////////////////////////////

// 입출금 선택(1:입출 2:입금 3:출금)
@property (assign, nonatomic) AlarmSettingType selectedType;
// 통지금액(0:x, 1:천, 2:만, 3:십만, 4:백만, 5:천만, 6:일억, 7:십억)
@property (assign, nonatomic) AmountSettingType selectedAmount;
// 제한시간 설정(0:미설정, 1:설정)
@property (assign, nonatomic) BOOL notiTimeFlag;
// 알림제한시간(시작)(-1:미설정, 0~23시)
@property (assign, nonatomic) int notiStartTime;
// 알림제한시간(종료)(-1:미설정, 0~23시)
@property (assign, nonatomic) int notiEndTime;
// 잔액표시여부(1:표시, 2:미표시)
@property (assign, nonatomic) int balanceFlag;
// 자동이체 선택(1:발송, 2:미발송, 3:실시간)
@property (assign, nonatomic) int notiAutoFlag;
// 알림주기(1:실시간 2:지정)
@property (assign, nonatomic) int notiPeriodType;
// 지정시간 1(-1:미설정, 0~23시)
@property (assign, nonatomic) int notiPeriodTime1;
@property (assign, nonatomic) int notiPeriodTime2;
@property (assign, nonatomic) int notiPeriodTime3;

- (void)initDataWithAccountNumber:(NSString *)accountNum;
- (void)makeAllOptionDataView;
- (NSInteger)getAlarmSettingType;
// 입출금 옵션 선택
- (IBAction)selectDepWithType:(id)sender;

- (NSInteger)getAmountSettingType;
// 통지금액 옵션 선택
- (IBAction)selectAmountLimit:(id)sender;
- (IBAction)selectAmountPicker:(id)sender;
// 알림 시간 제한 선택
- (IBAction)selectLimtTime:(id)sender;
// 잔액표시 선택
- (IBAction)selectBalanceSetting:(id)sender;
// 제한발송 선택
- (IBAction)selectNotiAutoSetting:(id)sender;
// 알림주기 선택
- (IBAction)selectNotiTime:(id)sender;
// 알림 시간 제한 선택
- (IBAction)selectNotiAbort:(id)sender;


@end
