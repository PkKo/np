//
//  RegistPhoneViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 21..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface RegistPhoneViewController : CommonViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    NSArray *carrierListArray;
    BOOL isAuthNumberConfirm;
    BOOL isPhoneNumberConfirm;
    NSTimer *authNumTimer;
    NSInteger authNumCounter;
}

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

- (IBAction)carrierNumClick:(id)sender;
- (IBAction)requestAuthNumber:(id)sender;
- (IBAction)nextViewClick:(id)sender;
@end
