//
//  MenuTableEtcView.m
//  np
//
//  Created by Infobank1 on 2015. 9. 22..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "MenuTableEtcView.h"
#import "CustomerCenterUtil.h"

@implementation MenuTableEtcView

@synthesize nongminButton;
@synthesize nongminLabel;
@synthesize telButton;
@synthesize telLabel;
@synthesize faqButton;
@synthesize faqLabel;
@synthesize noticeButton;
@synthesize noticeLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)gotoFarmerNews
{
    [self closeMenu];
    [[CustomerCenterUtil sharedInstance] gotoFarmerNews];
}

- (IBAction)gotoNotice
{
    [self closeMenu];
    [[CustomerCenterUtil sharedInstance] gotoNotice];
}

- (IBAction)gotoFAQ
{
    [self closeMenu];
    [[CustomerCenterUtil sharedInstance] gotoFAQ];
}

- (IBAction)gotoTelEnquiry
{
    [self closeMenu];
    [[CustomerCenterUtil sharedInstance] gotoTelEnquiry];
}

- (void)closeMenu
{
    if([((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController respondsToSelector:@selector(closeMenuView)])
    {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController performSelector:@selector(closeMenuView) withObject:nil];
    }
}

@end
