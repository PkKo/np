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

@interface SNSViewController () <MFMessageComposeViewControllerDelegate, EKEventEditViewDelegate>

@property (nonatomic, strong) EKEventStore *eventStore;

@end

@implementation SNSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.eventStore = [[EKEventStore alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareOnKakaoTalk:(id)sender {
    if ([KOAppCall canOpenKakaoTalkAppLink]) {
        
        [KOAppCall openKakaoTalkAppLink:[self kakaotalkMessage]];
        
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kakaotalk.com"]];
    }
}

- (NSArray *)kakaotalkMessage {
    KakaoTalkLinkObject *label = [KakaoTalkLinkObject createLabel:@"2015/09/21\r111-22-****33\r당풍니 입금 100,000원"];
    KakaoTalkLinkObject *image = [KakaoTalkLinkObject createImage:@"https://developers.kakao.com/assets/img/link_sample.jpg"
                                                            width:138 height:80];
    KakaoTalkLinkObject *webLink = [KakaoTalkLinkObject createWebLink:@"NH 스마트알림 앱 다운로드"
                                                                  url:@"https://itunes.apple.com/kr/app/nhnonghyeob-mobailkadeu-aebkadeu/id698023004?l=en&mt=8"];
    
    return @[label, image, webLink];
}

- (IBAction)shareOnKakaoStory:(id)sender {
    if (![StoryLinkHelper canOpenStoryLink]) {
        NSLog(@"Cannot open kakao story.");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://story.kakao.com/s/login"]];
        return;
    }
    
    [StoryLinkHelper openStoryLinkWithURLString:[self kakaoStoryContent]];
}

- (NSString *)kakaoStoryContent {
    
    NSBundle *bundle        = [NSBundle mainBundle];
    ScrapInfo *scrapInfo    = [[ScrapInfo alloc] init];
    scrapInfo.title         = @"[NH 스마트알림]";
    scrapInfo.desc          = @"NH 스마트알림";
    scrapInfo.imageURLs     = @[@"http://www.daumkakao.com/images/operating/temp_mov.jpg"];
    scrapInfo.type          = ScrapTypeNone;
    
    return [StoryLinkHelper makeStoryLinkWithPostingText:@"[NH 스마트알림]\r" \
                                                        "2015/09/21\r" \
                                                        "111-22-****33\r" \
                                                        "당풍니 입금 100,000원"
                                             appBundleID:[bundle bundleIdentifier]
                                              appVersion:[bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                                                 appName:[bundle objectForInfoDictionaryKey:@"CFBundleName"]
                                               scrapInfo:scrapInfo];
}

- (IBAction)shareOnFacebook:(id)sender {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [controller setInitialText:@"[NH 스마트알림]\r" \
                                "2015/09/21\r" \
                                "111-22-****33\r" \
                                "당풍니 입금 100,000원"];
    [controller addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:@"http://www.daumkakao.com/images/operating/temp_mov.jpg"]]]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)shareOnTwitter:(id)sender {
    
    SLComposeViewController * tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"[NH 스마트알림]\r" \
                                 "2015/09/21\r" \
                                 "111-22-****33\r" \
                                 "당풍니 입금 100,000원"];
    [tweetSheet addURL:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/nhnonghyeob-mobailkadeu-aebkadeu/id698023004?l=en&mt=8"]];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

- (IBAction)shareViaSMS:(id)sender {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }

    NSString *message = [NSString stringWithFormat:@"[NH 스마트알림]\r" \
                                                 "2015/09/21\r" \
                                                 "111-22-****33\r" \
                                                 "당풍니 입금 100,000원"];
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
    newEvent.title      = @"[NH 스마트알림]";
    newEvent.notes      = [NSString stringWithFormat:@"[NH 스마트알림]\r" \
                                                  "2015/09/21\r" \
                                                  "111-22-****33\r" \
                                                  "당풍니 입금 100,000원"];
    
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
}

@end
