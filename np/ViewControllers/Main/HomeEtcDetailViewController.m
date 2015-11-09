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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mTitleLabel setText:@"상세보기"];
    
    if(inboxData != nil)
    {
        [IBInbox loadWithListener:self];
        [IBInbox requestInboxSingMessage:inboxData.serverMessageKey];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBInboxProtocol Delegate
- (void)loadedContents:(BOOL)success contents:(ContentsData *)contents
{
    NSLog(@"%s, content = %@", __FUNCTION__, contents);
}

- (void)loadedSingleMessage:(BOOL)success message:(InboxMessageData *)message
{
    NSLog(@"%s, message = %@", __FUNCTION__, message);
}
@end
