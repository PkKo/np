//
//  SNSViewController.h
//  np
//
//  Created by Infobank2 on 9/17/15.
//  Copyright (c) 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "CommonViewController.h"
#import "TransactionObject.h"

@interface SNSViewController : UIViewController

@property (weak, nonatomic) TransactionObject *transactionObject;

@property (weak, nonatomic) IBOutlet UITextView *snsContent;

- (IBAction)shareOnKakaoStory:(id)sender;
- (IBAction)shareOnFacebook:(id)sender;
- (IBAction)shareOnTwitter:(id)sender;

- (IBAction)shareOnKakaoTalk:(id)sender;
- (IBAction)shareViaSMS:(id)sender;
- (IBAction)shareViaCalendar:(id)sender;
- (IBAction)closeSNSView;

@end
