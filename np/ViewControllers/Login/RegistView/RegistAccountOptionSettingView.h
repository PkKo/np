//
//  RegistAccountOptionSettingView.h
//  np
//
//  Created by Infobank1 on 2015. 10. 14..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum AlarmSetting
{
    BOTH = 0,
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

@interface RegistAccountOptionSettingView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>
{
    AlarmSettingType selectedType;
    AmountSettingType selectedAmount;
    NSArray *amountList;
}

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *accountChangeButton;
@property (strong, nonatomic) IBOutlet CircleView *bothSelectImg;
@property (strong, nonatomic) IBOutlet UILabel *bothSelectText;
@property (strong, nonatomic) IBOutlet CircleView *depositSelectImg;
@property (strong, nonatomic) IBOutlet UILabel *depositSelectText;
@property (strong, nonatomic) IBOutlet CircleView *withdrawSelectImg;
@property (strong, nonatomic) IBOutlet UILabel *withdrawSelectText;

@property (strong, nonatomic) IBOutlet CircleView *amountNoLimitImg;
@property (strong, nonatomic) IBOutlet UILabel *amountNoLimitText;
@property (strong, nonatomic) IBOutlet UIView *amountLimitBgView;
@property (strong, nonatomic) IBOutlet CircleView *amountSelectImg;
@property (strong, nonatomic) IBOutlet UILabel *amountSelectText;
@property (weak, nonatomic) IBOutlet UIView *amountSelectView;
@property (weak, nonatomic) IBOutlet UIPickerView *amountSeletPickerView;

- (void)initDataWithAccountNumber:(NSString *)accountNum;
- (NSInteger)getAlarmSettingType;
// 입출금 옵션 선택
- (IBAction)selectDepWithType:(id)sender;

- (NSInteger)getAmountSettingType;
// 통지금액 옵션 선택
- (IBAction)selectAmountLimit:(id)sender;
- (IBAction)selectAmountPicker:(id)sender;

@end
