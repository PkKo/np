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
@end
