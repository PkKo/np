//
//  StickerSettingView.m
//  np
//
//  Created by Infobank1 on 2015. 10. 19..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "WithdrawStickerSettingView.h"

@implementation WithdrawStickerSettingView

@synthesize delegate;


- (IBAction)closeView:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)stickerSelect:(id)sender
{
    if(delegate != nil && [delegate respondsToSelector:@selector(selectedStickerIndex:)])
    {
        [delegate performSelector:@selector(selectedStickerIndex:) withObject:[NSNumber numberWithInteger:[sender tag]]];
    }
    
    [self removeFromSuperview];
}
@end
