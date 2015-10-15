//
//  RegistAccountInputAccountView.m
//  np
//
//  Created by Infobank1 on 2015. 10. 13..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistAccountInputAccountView.h"

@implementation RegistAccountInputAccountView

@synthesize delegate;
@synthesize scrollView;
@synthesize certifiedAccountView;
@synthesize addNewAccountView;
@synthesize addNewAccountInput;
@synthesize addNewAccountPassInput;
@synthesize addNewAccountBirthInput;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)changeAccountView:(id)sender
{
    switch ([sender tag])
    {
        case 600:
        {
            [certifiedAccountView setHidden:YES];
            [addNewAccountView setHidden:NO];
            [scrollView setContentSize:addNewAccountView.frame.size];
            if(delegate != nil && [delegate respondsToSelector:@selector(changeAccountInputView:)])
            {
                [delegate performSelector:@selector(changeAccountInputView:) withObject:[NSNumber numberWithBool:YES]];
            }
            break;
        }
        case 601:
        {
            [certifiedAccountView setHidden:NO];
            [addNewAccountView setHidden:YES];
            [scrollView setContentSize:certifiedAccountView.frame.size];
            if(delegate != nil && [delegate respondsToSelector:@selector(changeAccountInputView:)])
            {
                [delegate performSelector:@selector(changeAccountInputView:) withObject:[NSNumber numberWithBool:NO]];
            }
            break;
        }
            
        default:
            break;
    }
        
}
@end
