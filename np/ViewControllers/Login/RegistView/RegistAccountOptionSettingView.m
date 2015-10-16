//
//  RegistAccountOptionSettingView.m
//  np
//
//  Created by Infobank1 on 2015. 10. 14..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistAccountOptionSettingView.h"

@implementation RegistAccountOptionSettingView

@synthesize scrollView;
@synthesize contentView;

@synthesize accountChangeButton;
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

- (void)initData
{
    [scrollView setContentSize:contentView.frame.size];
    
    // 입출금 알림 선택
    selectedType = BOTH;
    [bothSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [bothSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [depositSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    [depositSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    [withdrawSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    [withdrawSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    
    // 통지금액 선택
    selectedAmount = 0;
    amountList = [[NSArray alloc] initWithObjects:@"천원 이상", @"만원 이상", @"십만원 이상", @"백만원 이상", @"천만원 이상", @"일억 이상", @"십억 이상", nil];
    [amountNoLimitImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [amountNoLimitText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
    [amountSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
    [amountSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
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
            [depositSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [withdrawSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [withdrawSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            break;
        }
        case DEPOSIT:
        {
            [bothSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [bothSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [depositSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [depositSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [withdrawSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [withdrawSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            break;
        }
        case WITHDRAW:
        {
            [bothSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [bothSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [depositSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [depositSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [withdrawSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [withdrawSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
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
            [amountNoLimitText setBackgroundColor:CIRCLE_BACKGROUND_COLOR_SELECTED];
            [amountSelectImg setBackgroundColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            [amountSelectText setTextColor:CIRCLE_BACKGROUND_COLOR_UNSELECTED];
            selectedAmount = NOLIMIT;
            break;
        }
        case 1:
        {
            // 옵션 선택할 수 있는 피커 뷰 생성
            [self showAmountSelectPickerView];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)selectAmountPicker:(id)sender
{
    if([sender tag] == 0)
    {
        // 피커뷰 확인 버튼
    }
    else if([sender tag] == 1)
    {
        // 피커뷰 취소 버튼
    }
    
    [self hideAmountSelectPickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [amountList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [amountList objectAtIndex:row];
}

- (void)showAmountSelectPickerView
{
    
}

- (void)hideAmountSelectPickerView
{
    
}
@end
