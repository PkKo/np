//
//  RegistPhoneViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 21..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface RegistPhoneViewController : CommonViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    NSArray *carrierListArray;
    NSInteger carrierIndex;
    NSTimer *authNumTimer;
    NSInteger authNumCounter;
    NSString *authNumber;
    NSString *crmPhoneNumber;
    
    NSInteger tempIndex;
    
    CGRect orgBottomRect;
    UIView *pickeBgView;
    
    NSDate *backgroundEnteredTime;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

// 캐리어 선택 버튼
@property (strong, nonatomic) IBOutlet UIButton *carrierSelectButton;
// 휴대폰 번호 입력
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberInput;
// 인증번호 요청 버튼
@property (strong, nonatomic) IBOutlet UIButton *reqAuthNumButton;
// 인증번호 입력
@property (strong, nonatomic) IBOutlet UITextField *phoneAuthNumInput;
// 캐리어 선택 피커 뷰
@property (strong, nonatomic) IBOutlet UIPickerView *carrierPickerView;
@property (strong, nonatomic) IBOutlet UIView *carrierPickerBgView;

@property (strong, nonatomic) IBOutlet UILabel *descLabelOne;
@property (strong, nonatomic) IBOutlet UILabel *descLabelTwo;
@property (strong, nonatomic) IBOutlet UILabel *descLabelThree;
@property (strong, nonatomic) IBOutlet UIView *bottomDescView;

- (IBAction)carrierNumClick:(id)sender;
- (IBAction)requestAuthNumber:(id)sender;
- (IBAction)nextViewClick:(id)sender;

- (IBAction)pickerSelectConfirm:(id)sender;
- (IBAction)pickerViewHide:(id)sender;
@end
