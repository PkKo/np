//
//  EnvMgmtViewController.m
//  np
//
//  Created by Infobank2 on 10/19/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "EnvMgmtViewController.h"
#import "LoginUtil.h"
#import "NoticeBackgroundSettingsViewController.h"
#import "DrawPatternLockViewController.h"
#import "LoginCertListViewController.h"
#import "LoginAccountVerificationViewController.h"
#import "LoginSimpleVerificationViewController.h"
#import "DBManager.h"

#define ALERT_TAG_ALERT_CONFIRM 132
#define ALERT_TAG_ALERT_DONE    133

@interface EnvMgmtViewController ()

@end

@implementation EnvMgmtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"환경설정"];
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toggleUsingSimpleView:(UIButton *)simpleViewSwitch {
    [simpleViewSwitch setSelected:!simpleViewSwitch.isSelected];
    LoginUtil * util = [[LoginUtil alloc] init];
    [util saveUsingSimpleViewFlag:simpleViewSwitch.isSelected];
}

-(IBAction)gotoLoginSettings {
    [[[LoginUtil alloc] init] gotoLoginSettings:self.navigationController];
}

-(IBAction)gotoSimpleLoginMgmt {
    [[[LoginUtil alloc] init] gotoSimpleLoginMgmt:self.navigationController animated:YES];
}

-(IBAction)gotoPatternLoginMgmt {
    [[[LoginUtil alloc] init] gotoPatternLoginMgmt:self.navigationController animated:YES];
}

-(IBAction)gotoNoticeBgColorSettings {
    NoticeBackgroundSettingsViewController *noticeBgColorSettings = [[NoticeBackgroundSettingsViewController alloc] initWithNibName:@"NoticeBackgroundSettingsViewController" bundle:nil];
    ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:noticeBgColorSettings];
    [self.navigationController pushViewController:eVC animated:YES];
}

-(void)refreshUI {
    LoginUtil * util = [[LoginUtil alloc] init];
    [self.usingSimpleViewBtn setSelected:[util isUsingSimpleView]];
}

#pragma mark - Reset data 

-(IBAction)resetData {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"NH스마트알림 모든 데이터 (전체, 입출금, 보관함 등)가 초기화 됩니다.\n초기화 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    alert.tag = ALERT_TAG_ALERT_CONFIRM;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
            
        case ALERT_TAG_ALERT_CONFIRM:
        {
            if (buttonIndex == 1) {
                // remove data here
                [self startIndicator];
                [self performSelector:@selector(resetService) withObject:nil afterDelay:0.06];
            }
            break;
        }
            
        case ALERT_TAG_ALERT_DONE:
        {
            [[[LoginUtil alloc] init] showMainPage];
            break;
        }
        default:
            break;
    }
}

- (void)resetService {
    
    NSUserDefaults * prefs  = [NSUserDefaults standardUserDefaults];
    NSString * user_id      = [prefs stringForKey:RESPONSE_CERT_UMS_USER_ID];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_RESET_DATA];
    NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
    
    [requestBody setObject:PUSH_APP_ID forKey:@"app_id"];
    [requestBody setObject:user_id forKey:@"user_id"];
    
    NSString *bodyString = [CommonUtil getBodyString:requestBody];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(receiveResponse:)];
    [req requestUrl:url bodyString:bodyString];
}

- (void)receiveResponse:(NSDictionary *)response {
    
    NSLog(@"RESPONSE: %@", response);
    [self stopIndicator];
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO]) {
        
        [[DBManager sharedInstance] deleteAllTransactions];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"모든 데이터 초기화 처리가\n완료되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alert.tag = ALERT_TAG_ALERT_DONE;
        [alert show];
        
    } else {
        
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
