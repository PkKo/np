//
//  RegistAccountInputView.m
//  계좌번호 인증 뷰
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistAccountInputView.h"

@implementation RegistAccountInputView

@synthesize delegate;
@synthesize accountInputField;
@synthesize accountPassInputField;
@synthesize birthInputField;
@synthesize accountCheck;
@synthesize carrierSelectBtn;
@synthesize phoneNumInputField;

@synthesize scrollView;
@synthesize contentView;

@synthesize carrierPickerView;
@synthesize carrierPickerBgView;

- (void)initData
{
    NSString *carrierListPath = [[NSBundle mainBundle] pathForResource:@"CarrierList" ofType:@"plist"];
    carrierListArray = [[NSArray alloc] initWithContentsOfFile:carrierListPath];
    
    tempIndex = 0;
    carrierIndex = 0;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    carrierSelectBtn.layer.borderWidth = 1.0f;
    carrierSelectBtn.layer.borderColor = [UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f].CGColor;
    
    if(scrollView.frame.size.height < contentView.frame.size.height)
    {
        [scrollView setContentSize:contentView.frame.size];
    }
}

- (IBAction)checkAccount:(id)sender
{
    if(delegate != nil && [delegate respondsToSelector:@selector(checkRegistAccountRequest:)])
    {
        NSMutableDictionary *accountInfo = [[NSMutableDictionary alloc] init];
        [accountInfo setObject:[accountInputField text] forKey:REQUEST_ACCOUNT_NUMBER];
        [accountInfo setObject:[accountPassInputField text] forKey:REQUEST_ACCOUNT_PASSWORD];
        [accountInfo setObject:[birthInputField text] forKey:REQUEST_ACCOUNT_BIRTHDAY];
        [delegate performSelector:@selector(checkRegistAccountRequest:) withObject:accountInfo];
    }
}

#pragma mark - UIPickerViewDataSource
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0f;
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
}

- (IBAction)carrierSelectConfirm:(id)sender
{
    carrierIndex = tempIndex;
    [carrierSelectBtn setTitle:[carrierListArray objectAtIndex:carrierIndex] forState:UIControlStateNormal];
    [self carrierPickerViewHide:nil];
}

- (IBAction)carrierPickerViewHide:(id)sender
{
    [pickerBgView removeFromSuperview];
    [carrierPickerBgView setHidden:YES];
}

- (IBAction)carrierPickerViewShow:(id)sender
{
    if(pickerBgView == nil)
    {
        CGSize frame = ((UIViewController *)delegate).view.bounds.size;
        pickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.width, frame.height - carrierPickerBgView.frame.size.height)];
        [pickerBgView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    }
    [((UIViewController *)delegate).view addSubview:pickerBgView];
    [carrierPickerBgView setHidden:NO];
    [self bringSubviewToFront:carrierPickerBgView];
    [carrierPickerView selectRow:carrierIndex inComponent:0 animated:YES];
}

@end
