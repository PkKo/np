//
//  NotiSettingMenuViewController.m
//  알림설정 메뉴
//
//  Created by Infobank1 on 2015. 9. 24..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "NotiSettingMenuViewController.h"
#import "AccountManageViewController.h"
#import "ExchangeSettingViewController.h"

@interface NotiSettingMenuViewController ()

@end

@implementation NotiSettingMenuViewController

@synthesize allNotiButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:NO];
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"알림설정"];
    
    [allNotiButton setEnabled:[[IBNgmService sharedInstance] pushEnabled]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)allNotiOnOff:(id)sender
{
    if([allNotiButton isSelected])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"안내" message:@"알림설정을 끄면 설정하신 동안\n금융정보/기타 알림 PUSH 메시지를\n받을 수 없습니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        [alertView setTag:123];
        [alertView show];
    }
    else
    {
        // 알림 켜기
        [IBNgmService setApnsAllow:YES];
        [allNotiButton setSelected:YES];
    }
}

- (IBAction)moveAccountSetting:(id)sender
{
    AccountManageViewController *vc = [[AccountManageViewController alloc] init];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
    
    [self.navigationController pushViewController:eVC animated:YES];
}

- (IBAction)moveExchangeSetting:(id)sender
{
    ExchangeSettingViewController *vc = [[ExchangeSettingViewController alloc] init];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
    
    [self.navigationController pushViewController:eVC animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == 123 && buttonIndex == BUTTON_INDEX_OK)
    {
        // 알림 끄기
        [IBNgmService setApnsAllow:NO];
        [allNotiButton setSelected:NO];
    }
}
@end
