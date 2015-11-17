//
//  HomeEtcDetailViewController.m
//  np
//
//  Created by Infobank1 on 2015. 11. 9..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "HomeEtcDetailViewController.h"

@interface HomeEtcDetailViewController ()

@end

@implementation HomeEtcDetailViewController

@synthesize inboxData;
@synthesize scrollView;
@synthesize contentView;
@synthesize contentImg;
@synthesize contentDate;
@synthesize contentTitle;
@synthesize contentText;
@synthesize contentLinkButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mTitleLabel setText:@"상세보기"];
    
    if(inboxData != nil)
    {
        [self startIndicator];
        [IBInbox loadWithListener:self];
        [IBInbox requestInboxSingMessage:inboxData.serverMessageKey];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setImageView:(NSString *)imageUrl
{
    if(imageUrl == nil)
    {
        [contentImg setHidden:YES];
        [contentView setFrame:CGRectMake(contentView.frame.origin.x, contentImg.frame.origin.y,
                                         contentView.frame.size.width,
                                         contentView.frame.size.height)];
    }
    else
    {
        [contentImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]]];
    }
    
    [contentDate setText:[CommonUtil getDateString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate / 1000)]]];
    [contentTitle setText:inboxData.title];
    [contentText setText:inboxData.text];
    [contentText sizeToFit];
    
    CGSize contentSize = CGSizeMake(contentView.frame.size.width, contentView.frame.origin.y + contentText.frame.origin.y + contentText.frame.size.height);
    [scrollView setContentSize:contentSize];
    [scrollView setContentInset:UIEdgeInsetsZero];
}

#pragma mark - IBInboxProtocol Delegate
- (void)loadingInboxList
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)loadedContents:(BOOL)success contents:(ContentsData *)contents
{
    NSLog(@"%s, content = %@", __FUNCTION__, contents);
    [self stopIndicator];
    if(contents == nil)
    {
        [self setImageView:nil];
    }
    else
    {
        // 이미지 세팅
        [self setImageView:nil];
    }
}

- (void)loadedInboxList:(BOOL)success messageList:(NSArray *)messageList
{
    NSLog(@"%s, message = %@", __FUNCTION__, messageList);
}

- (void)loadedSingleMessage:(BOOL)success message:(InboxMessageData *)message
{
    NSLog(@"%s, message = %@", __FUNCTION__, message);
    if(success)
    {
        for (ContentsPayload *payload in message.payloadList)
        {
            if([payload.key isEqualToString:@"ck"])
            {
                contentKey = payload.value;
                break;
            }
        }
        
        if(contentKey != nil && [contentKey length] > 0)
        {
            [IBInbox requestContents:contentKey];
        }
        else
        {
            [self stopIndicator];
            [self setImageView:nil];
        }
    }
    else
    {
        [self stopIndicator];
    }
}
@end
