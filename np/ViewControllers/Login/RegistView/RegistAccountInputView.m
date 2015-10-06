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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)checkAccount:(id)sender
{
    if(delegate != nil && [delegate respondsToSelector:@selector(checkRegistAccountRequest:)])
    {
        NSMutableDictionary *accountInfo = [[NSMutableDictionary alloc] init];
        [accountInfo setObject:[accountInputField text] forKey:@"AccountNumber"];
        [accountInfo setObject:[accountPassInputField text] forKey:@"AccountPassword"];
        [accountInfo setObject:[birthInputField text] forKey:@"BirthDay"];
        [delegate performSelector:@selector(checkRegistAccountRequest:) withObject:accountInfo];
    }
}
@end
