//
//  SNSViewController.m
//  np
//
//  Created by Infobank2 on 9/17/15.
//  Copyright (c) 2015 Infobank1. All rights reserved.
//

#import "SNSViewController.h"
#import <MessageUI/MessageUI.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "StoryLinkHelper.h"
#import "StorageBoxUtil.h"
#import "UIButton+BackgroundColor.h"

@interface SNSViewController () <MFMessageComposeViewControllerDelegate, EKEventEditViewDelegate>

@property (nonatomic, strong) EKEventStore *eventStore;

@end

@implementation SNSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[StorageBoxUtil getDimmedBackgroundColor]];
    self.eventStore = [[EKEventStore alloc] init];
    
    [self composeSNSContent];
    
    [self.cancelBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9] forState:UIControlStateHighlighted];
}

/*
 2015/09/17 12:30
 111-22-***33
 당풍니 입금 100,000원
 */
- (void)composeSNSContent {
    
    NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@ %@ %@",
                         [self.transactionObject formattedTransactionDate],
                         [self.transactionObject transactionAccountNumber],
                         [self.transactionObject transactionDetails],
                         [self.transactionObject transactionTypeDesc],
                         [self.transactionObject formattedTransactionAmount]];
    [_snsContent setText:content];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareOnKakaoTalk:(id)sender {
    if ([KOAppCall canOpenKakaoTalkAppLink]) {
        
        [KOAppCall openKakaoTalkAppLink:[self kakaotalkMessage]];
        
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kakaotalk.com"]];
    }
}

- (NSArray *)kakaotalkMessage {
    KakaoTalkLinkObject *label = [KakaoTalkLinkObject createLabel:[NSString stringWithFormat:@"[%@]\n%@",
                                                                   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"], _snsContent.text]];
    
    KakaoTalkLinkAction *androidAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformAndroid devicetype:KakaoTalkLinkActionDeviceTypePhone execparam:@{@"test1" : @"test1", @"test2" : @"test2"}];
    
    KakaoTalkLinkAction *iphoneAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS
                                                                     devicetype:KakaoTalkLinkActionDeviceTypePhone
                                                                      execparam:@{@"test1" : @"test1", @"test2" : @"test2"}];
    
    KakaoTalkLinkAction *ipadAppAction = [KakaoTalkLinkAction createAppAction:KakaoTalkLinkActionOSPlatformIOS
                                                                   devicetype:KakaoTalkLinkActionDeviceTypePad
                                                                    execparam:nil];
    
    
    KakaoTalkLinkObject *appLink = [KakaoTalkLinkObject createAppButton:@"앱으로 연결"
                                                                actions:@[androidAppAction, iphoneAppAction, ipadAppAction]];
    
    return @[label];
}

- (IBAction)shareOnKakaoStory:(id)sender {
    
    if (![StoryLinkHelper canOpenStoryLink]) {
        NSLog(@"Cannot open kakao story.");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://story.kakao.com/s/login"]];
        return;
    }
    
    [StoryLinkHelper openStoryLinkWithURLString:[self kakaoStoryContent]];
}




- (NSString *)dummyStoryLinkURLString {
    
    NSLog(@"[%s %d]", __func__, __LINE__);
    
    NSBundle *bundle        = [NSBundle mainBundle];
    ScrapInfo *scrapInfo    = [[ScrapInfo alloc] init];
    scrapInfo.title         = [NSString stringWithFormat:@"[%@]", [bundle objectForInfoDictionaryKey:@"CFBundleName"]];
    scrapInfo.desc          = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    scrapInfo.imageURLs     = @[@"http://www.daumkakao.com/images/operating/temp_mov.jpg"];
    scrapInfo.type = ScrapTypeVideo;
    
    NSString * text = [NSString stringWithFormat:@"[%@]2015/09/17 12:30 111-22-***33 당풍니 입금 100,000원 https://itunes.apple.com/kr/app/nhnonghyeob-mobailkadeu-aebkadeu/id698023004?l=en&mt=8",
                       [bundle objectForInfoDictionaryKey:@"CFBundleName"]];
    
    return [StoryLinkHelper makeStoryLinkWithPostingText:text
                                             appBundleID:[bundle bundleIdentifier]
                                              appVersion:[bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                                                 appName:[bundle objectForInfoDictionaryKey:@"CFBundleName"]
                                               scrapInfo:scrapInfo];
}


- (NSString *)kakaoStoryContent {
    
    NSBundle *bundle        = [NSBundle mainBundle];
    ScrapInfo *scrapInfo    = [[ScrapInfo alloc] init];
    scrapInfo.title         = [NSString stringWithFormat:@"[%@]", [bundle objectForInfoDictionaryKey:@"CFBundleName"]];
    scrapInfo.desc          = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    scrapInfo.imageURLs     = @[@"http://www.daumkakao.com/images/operating/temp_mov.jpg"];
    scrapInfo.type          = ScrapTypeVideo;
    
    NSString *content = [NSString stringWithFormat:@"[%@] %@ %@ %@ %@ %@ https://itunes.apple.com/kr/app/nhnonghyeob-mobailkadeu-aebkadeu/id698023004?l=en&mt=8",
                         [bundle objectForInfoDictionaryKey:@"CFBundleName"],
                         [self.transactionObject formattedTransactionDate],
                         [self.transactionObject transactionAccountNumber],
                         [self.transactionObject transactionDetails],
                         [self.transactionObject transactionTypeDesc],
                         [self.transactionObject formattedTransactionAmount]];
    
    return [StoryLinkHelper makeStoryLinkWithPostingText:content
                                             appBundleID:[bundle bundleIdentifier]
                                              appVersion:[bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                                                 appName:[bundle objectForInfoDictionaryKey:@"CFBundleName"]
                                               scrapInfo:scrapInfo];
}

- (IBAction)shareOnFacebook:(id)sender {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [controller setInitialText:[NSString stringWithFormat:@"[%@]\n%@",
                                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"], _snsContent.text]];
    [controller addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:@"http://www.daumkakao.com/images/operating/temp_mov.jpg"]]]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)shareOnTwitter:(id)sender {
    
    SLComposeViewController * tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:[NSString stringWithFormat:@"[%@]\n%@",
                                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"], _snsContent.text]];
    [tweetSheet addURL:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/nhnonghyeob-mobailkadeu-aebkadeu/id698023004?l=en&mt=8"]];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

- (IBAction)shareViaSMS:(id)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }

    NSString *message = [NSString stringWithFormat:@"[%@]\n%@",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"], _snsContent.text];
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setBody:message];
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareViaCalendar:(id)sender {
    
    [self checkEventStoreAccessForCalendar];
}

-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (status)
    {
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized:
        {
            [self addEventToCalendar];
        }
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined:
        {
            [self requestCalendarAccess];
        }
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            NSLog(@"EKAuthorizationStatusRestricted");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


// Prompt the user for access to their Calendar
-(void)requestCalendarAccess {
    
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                    completion:^(BOOL granted, NSError *error){
                                        [self addEventToCalendar];
    }];
}

-(void)addEventToCalendar {
    
    EKEvent *newEvent   = [EKEvent eventWithEventStore:self.eventStore];
    newEvent.title      = [NSString stringWithFormat:@"[%@]", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
    newEvent.notes      = _snsContent.text;
    
    EKEventEditViewController *addEvent = [[EKEventEditViewController alloc] init];
    addEvent.eventStore                 = self.eventStore;
    addEvent.event                      = newEvent;
    addEvent.editViewDelegate           = self;
    [self presentViewController:addEvent animated:YES completion:nil];
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)closeSNSView {
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
