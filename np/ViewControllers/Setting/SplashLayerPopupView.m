//
//  SplashLayerPopupView.m
//  np
//
//  Created by Infobank1 on 2015. 11. 11..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "SplashLayerPopupView.h"
#import "SplashViewController.h"
#import "NoticeViewController.h"
#import "FarmerNewsViewController.h"

@implementation SplashLayerPopupView

@synthesize delegate;
@synthesize titleLabel;
@synthesize contentScrollView;
@synthesize contentLinkButton;
@synthesize contentLabel;
@synthesize closeDayOptionButton;
@synthesize closeButton;
@synthesize contentImage;
@synthesize linkInUrl;
@synthesize linkOutUrl;
@synthesize linkUrlButton;

- (IBAction)closeWithCloseDayOption:(id)sender
{
    
}

- (IBAction)closeLayerView:(id)sender
{
    [self removeFromSuperview];
    if(delegate != nil && [delegate respondsToSelector:@selector(closeLayerPopup:)])
    {
        [delegate performSelector:@selector(closeLayerPopup:) withObject:(UIButton *)sender];
    }
}

- (IBAction)linkUrlOpen:(id)sender
{
    if(linkOutUrl != nil && [linkOutUrl length] > 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkOutUrl]];
    }
    else if(linkInUrl != nil && [linkInUrl length] > 0)
    {
        if([linkInUrl isEqualToString:@"N"])
        {
            // 공지사항
            NoticeViewController *vc = [[NoticeViewController alloc] init];
            [vc setIsMenuButtonHidden:YES];
            [((SplashViewController *)delegate).navigationController pushViewController:vc animated:YES];
        }
        else if ([linkInUrl isEqualToString:@"F"])
        {
            FarmerNewsViewController *vc = [[FarmerNewsViewController alloc] init];
            [vc setIsMenuButtonHidden:YES];
            [((SplashViewController *)delegate).navigationController pushViewController:vc animated:YES];
        }
    }
}
@end
