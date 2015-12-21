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
}

/*
 2015/09/17 12:30
 111-22-***33
 당풍니 입금 100,000원
 */
- (void)composeSNSContent {
    
    NSString *content = [NSString stringWithFormat:@"%@\n%@\n%@ %@ %@원",
                         [self.transactionObject formattedTransactionDate],
                         [self.transactionObject getMaskingTransactionAccountNumber],
                         [self.transactionObject transactionDetails],
                         [self.transactionObject transactionTypeDesc],
                         [self.transactionObject formattedTransactionAmount]];
    
    [_snsContent setSelectable:YES];
    [_snsContent setText:content];
    [_snsContent setSelectable:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showServiceNotReadyAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"서비스 준비중입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)shareOnKakaoTalk:(id)sender {
    
    BOOL isReady = YES;
    
    if (!isReady) {
        [self showServiceNotReadyAlert];
        return;
    }
    
    if ([KOAppCall canOpenKakaoTalkAppLink]) {
        
        [KOAppCall openKakaoTalkAppLink:[self kakaotalkMessage]];
        
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/kakaotalk-messenger/id362057947?l=en&mt=8"]];
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
    
    return @[label, appLink];
}

- (IBAction)shareOnKakaoStory:(id)sender {
    
    
    BOOL isReady = YES;
    
    if (!isReady) {
        [self showServiceNotReadyAlert];
        return;
    }
    
    if (![StoryLinkHelper canOpenStoryLink]) {
        NSLog(@"Cannot open kakao story.");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/kakaostory/id486244601?l=en&mt=8"]];
        return;
    }
    
    [StoryLinkHelper openStoryLinkWithURLString:[self kakaoStoryContent]];
}

- (NSString *)kakaoStoryContent {
    
    NSBundle *bundle        = [NSBundle mainBundle];
    ScrapInfo *scrapInfo    = [[ScrapInfo alloc] init];
    scrapInfo.title         = [NSString stringWithFormat:@"[%@]", [bundle objectForInfoDictionaryKey:@"CFBundleName"]];
    scrapInfo.desc          = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
    scrapInfo.type          = ScrapTypeVideo;
    
    NSString *content = [NSString stringWithFormat:@"[%@] %@ %@ %@ %@ %@원",
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
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)shareOnTwitter:(id)sender {
    
    SLComposeViewController * tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:[NSString stringWithFormat:@"[%@]\n%@",
                                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"], _snsContent.text]];
    [tweetSheet addURL:[NSURL URLWithString:APP_STORE_APP_URL]];
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
