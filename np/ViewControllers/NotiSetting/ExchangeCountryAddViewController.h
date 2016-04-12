//
//  ExchangeCountryAddViewController.h
//  np
//
//  Created by Infobank1 on 2015. 10. 21..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface ExchangeCountryAddViewController : CommonViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
{
    NSArray * alarmPeriodList;
    NSString *exchangeRateId;
    
    NSInteger countrySelectIndex;
    NSInteger periodFlag;
    NSInteger periodOneIndex;
    NSInteger periodTwoIndex;
    NSInteger periodThreeIndex;
    NSInteger periodOneHour;
    NSInteger periodTwoHour;
    NSInteger periodThreeHour;
    NSInteger tempIndex;
    
    NSMutableArray *pickerList;
    
    BOOL isCountrySelectMode;
    NSInteger totlalNotiCount;
    
    UIView *pickerBgView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (assign, nonatomic) BOOL isNewCoutry;
@property (assign, nonatomic) BOOL isChargeCountry;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSArray *countryAllList;
@property (strong, nonatomic) NSDictionary* responseDictionary;
@property (strong, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *countrySelectButton;
@property (strong, nonatomic) IBOutlet UIButton *countryDeleteButton;
@property (strong, nonatomic) IBOutlet UIImageView *countrySelectDropImg;

@property (strong, nonatomic) IBOutlet CircleView *optionOneImg;
@property (strong, nonatomic) IBOutlet UILabel *optionOneText;
@property (strong, nonatomic) IBOutlet CircleView *optionTwoImg;
@property (strong, nonatomic) IBOutlet UILabel *optionTwoText;
@property (strong, nonatomic) IBOutlet UILabel *periodTimeOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *periodTimeTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *periodTimeThreeLabel;

@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerSelectView;

- (IBAction)confirmButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;

- (IBAction)currencyCountrySelect:(id)sender;
- (IBAction)nonPeriodOptionSelect:(id)sender;
- (IBAction)periodOptionSelect:(id)sender;
- (IBAction)countryDeleteSelect:(id)sender;

- (IBAction)pickerSelectConfirm:(id)sender;
- (IBAction)pickerViewHide:(id)sender;
@end
