//
//  AccountOptionSettingViewController.m
//  np
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "AccountOptionSettingViewController.h"
#import "AccountManageViewController.h"
#import "ServiceDeactivationController.h"

@interface AccountOptionSettingViewController ()

@end

@implementation AccountOptionSettingViewController

@synthesize accountNumber;
@synthesize contentView;
@synthesize isNewAccount;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:NO];
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"입출금 알림 계좌관리"];
    
    optionView = [RegistAccountOptionSettingView view];
    [optionView setDelegate:self];
    [optionView initDataWithAccountNumber:[CommonUtil getAccountNumberAddDash:accountNumber]];
    [optionView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [[optionView accountDeleteButton] setHidden:isNewAccount];
    [[optionView accountDeleteButton] addTarget:self action:@selector(accountDeleteAlert) forControlEvents:UIControlEventTouchUpInside];
    [[optionView accountDeleteButton] setEnabled:!isNewAccount];
    [[optionView accountChangeButton] addTarget:self action:@selector(moveBack) forControlEvents:UIControlEventTouchUpInside];
    if(!isNewAccount)
    {
        NSString *accountNickname = [[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_NICKNAME_DICTIONARY] objectForKey:accountNumber];
        if(accountNickname != nil)
        {
            [[optionView accountNicknameInput] setText:accountNickname];
        }
    }
    [contentView addSubview:optionView];
    
    [self accountOptionSearchReqeust];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [optionView.descLabel1 sizeToFit];
    [optionView.descLabel2 sizeToFit];
    [optionView.descLabel3 sizeToFit];
    [optionView.descLabel4 sizeToFit];
}

#pragma mark - UIButtonAction
/**
 @brief 확인버튼 클릭
 */
- (IBAction)optionSettingConfirm:(id)sender
{
    // 옵션 값 확인해서 세팅한다.
    [self accountOptionSetReqeust];
}

- (IBAction)optionSettingCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 계좌옵션 조회
- (void)accountOptionSearchReqeust
{
    [self startIndicator];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_UMS_USER_ID] forKey:@"user_id"];
    [reqBody setObject:[accountNumber stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:REQUEST_NOTI_OPTION_SEARCH_ACNO];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_NOTI_OPTION_SEARCH];
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(accountOptionSearchResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)accountOptionSearchResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        accountType = [[response objectForKey:@"account_type"] integerValue];
        
        if(accountType < 1 || accountType > 4)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"입출금 알림 신청이 불가능한 계좌입니다.\n입출식,외환,수익증권,신탁 계좌만 신청이 가능합니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
            
            // 뒤로가기
            NSInteger viewIndex = [[self.navigationController viewControllers] count] - 1;
            while(viewIndex >= 0)
            {
                ECSlidingViewController *eVC = [[self.navigationController viewControllers] objectAtIndex:viewIndex];
                if([eVC.topViewController isKindOfClass:[AccountManageViewController class]])
                {
                    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:viewIndex] animated:YES];
                    break;
                }
                
                viewIndex--;
            }
            
            return;
        }
        
        if([(NSArray *)[[response objectForKey:@"list"] objectForKey:@"sub"] count] > 0)
        {
            NSDictionary *optionData = [[[response objectForKey:@"list"] objectForKey:@"sub"] objectAtIndex:0];
            // 옵션 초기화
            receiptsPaymentId = [optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_RPID];
            // 입출금 선택
            optionView.selectedType = (AlarmSettingType)[[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_EVENT_TYPE] integerValue];
            // 통지가격
            if([[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_PRICE] integerValue] < 0)
            {
                optionView.selectedAmount = 0;
            }
            else
            {
                optionView.selectedAmount = (AmountSettingType)[[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_PRICE] integerValue];
            }
            // 제한시간 설정
            optionView.notiTimeFlag = [[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_TIME_FLAG] boolValue];
            // 알림제한 시작
            optionView.notiStartTime = [[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_UNNOTI_ST] intValue];
            // 알림제한 종료
            optionView.notiEndTime = [[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_UNNOTI_ET] intValue];
            // 잔액표시 여부
            optionView.balanceFlag = [[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_BALANCE_FLAG] intValue];
            // 자동이체 선택
            optionView.notiAutoFlag = [[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_AUTO_FLAG] intValue];
            // 알림 주기
            optionView.notiPeriodType = [[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_PERIOD_TYPE] intValue];
            // 지정시간
            optionView.notiPeriodTime1 = [[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_NOTI_TIME_ONE] intValue];
            optionView.notiPeriodTime2 = [[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_NOTI_TIME_TWO] intValue];
            optionView.notiPeriodTime3 = [[optionData objectForKey:RESPONSE_NOTI_OPTION_SEARCH_NOTI_TIME_THREE] intValue];
        }
        
        totalNotiCount = [[response objectForKey:@"totalNotiCount"] integerValue];
        
        // 계좌 타입
        [optionView setAccountType:accountType];
        [optionView makeAllOptionDataView];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView setTag:90003];
        [alertView show];
    }
}

#pragma mark - 계좌옵션 설정
- (void)accountOptionSetReqeust
{
    /*
     // 입출금 선택(1:입출 2:입금 3:출금)
     @synthesize selectedType;
     // 통지금액(0:x, 1:천, 2:만, 3:십만, 4:백만, 5:천만, 6:일억, 7:십억)
     @synthesize selectedAmount;
     // 제한시간 설정(0:미설정, 1:설정)
     @synthesize notiTimeFlag;
     // 알림제한시간(시작)(-1:미설정, 0~23시)
     @synthesize notiStartTime;
     // 알림제한시간(종료)(-1:미설정, 0~23시)
     @synthesize notiEndTime;
     // 잔액표시여부(1:표시, 2:미표시)
     @synthesize balanceFlag;
     // 자동이체 선택(1:발송, 2:미발송, 3:실시간)
     @synthesize notiAutoFlag;
     // 알림주기(1:실시간 2:지정)
     @synthesize notiPeriodType;
     // 지정시간 1(-1:미설정, 0~23시)
     @synthesize notiPeriodTime1;
     @synthesize notiPeriodTime2;
     @synthesize notiPeriodTime3;
     */
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    
    [reqBody setObject:[accountNumber stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:REQUEST_NOTI_OPTION_ACCOUNT_NUMBER];
    [reqBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_UMS_USER_ID] forKey:@"user_id"];
    if(receiptsPaymentId != nil && [receiptsPaymentId length] > 0)
    {
        [reqBody setObject:receiptsPaymentId forKey:REQUEST_NOTI_OPTION_RECEIPTS_ID];
    }
    else
    {
        [reqBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_CRM_MOBILE] forKey:@"mobile_number"];
    }
    [reqBody setObject:[NSNumber numberWithInt:optionView.selectedType] forKey:REQUEST_NOTI_OPTION_EVENT_TYPE];
    [reqBody setObject:[NSNumber numberWithInt:optionView.selectedAmount] forKey:REQUEST_NOTI_OPTION_PRICE];
    [reqBody setObject:[NSNumber numberWithBool:optionView.notiTimeFlag] forKey:REQUEST_NOTI_OPTION_TIME_FLAG];
    [reqBody setObject:[NSNumber numberWithInt:optionView.notiStartTime] forKey:REQUEST_NOTI_OPTION_UNNOTI_ST];
    [reqBody setObject:[NSNumber numberWithInt:optionView.notiEndTime] forKey:REQUEST_NOTI_OPTION_UNNOTI_ET];
    [reqBody setObject:[NSNumber numberWithInt:optionView.balanceFlag] forKey:REQUEST_NOTI_OPTION_BALANCE_FLAG];
    [reqBody setObject:[NSNumber numberWithInt:optionView.notiAutoFlag] forKey:REQUEST_NOTI_OPTION_AUTO_FLAG];
    [reqBody setObject:[NSNumber numberWithInt:optionView.notiPeriodType] forKey:REQUEST_NOTI_OPTION_PERIOD_TYPE];
    [reqBody setObject:[NSNumber numberWithInt:optionView.notiPeriodTime1] forKey:REQUEST_NOTI_OPTION_NOTI_TIME_ONE];
    [reqBody setObject:[NSNumber numberWithInt:optionView.notiPeriodTime2] forKey:REQUEST_NOTI_OPTION_NOTI_TIME_TWO];
    [reqBody setObject:[NSNumber numberWithInt:optionView.notiPeriodTime3] forKey:REQUEST_NOTI_OPTION_NOTI_TIME_THREE];
    
    if(optionView.notiStartTime < 0 && optionView.notiEndTime >= 0)
    {
        //종료시간만 있음
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"알림 시작 시간을 선택해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if(optionView.notiStartTime >= 0 && optionView.notiEndTime < 0)
    {
        // 시작 시간만 있음
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"알림 끝 시간을 선택해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [self startIndicator];
    NSString *url = @"";
    if(isNewAccount)
    {
        url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_NOTI_OPTION_NEW_SET];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_NOTI_OPTION_SET];
    }
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(accountOptionSetResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)accountOptionSetResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        if([optionView.accountNicknameInput.text length] > 0)
        {
            NSMutableDictionary *nickNameDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_NICKNAME_DICTIONARY]];
            if(nickNameDic == nil)
            {
                nickNameDic = [[NSMutableDictionary alloc] init];
            }
            [nickNameDic setObject:optionView.accountNicknameInput.text forKey:[optionView.accountNumberLabel.text stringByReplacingOccurrencesOfString:STRING_DASH withString:@""]];
            
            [[NSUserDefaults standardUserDefaults] setObject:nickNameDic forKey:ACCOUNT_NICKNAME_DICTIONARY];
        }
        
        /*
        if(isNewAccount)
        {
            NSMutableArray *allAccountList = [NSMutableArray arrayWithArray:[[[LoginUtil alloc] init] getAllAccounts]];
            NSString *addedAccountNumber = [[[[response objectForKey:@"list"] objectForKey:@"sub"] objectAtIndex:0] objectForKey:@"UMSD020001_OUT_SUB.account_number"];
            if(![allAccountList containsObject:addedAccountNumber])
            {
                [allAccountList addObject:addedAccountNumber];
                [[[LoginUtil alloc] init] saveAllAccounts:allAccountList];
            }
        }*/
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"입출금 알림 설정이 완료되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView setTag:90000];
        [alertView show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert setTag:90003];
        [alert show];
    }
}

#pragma mark - 계좌 삭제
- (void)accountDeleteAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"계좌삭제를 하시면 해당 계좌의 입출금 PUSH 알림 서비스를 받을수 없습니다.\n삭제하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alertView setTag:90001];
    [alertView show];
}

- (void)accountDeleteRequest
{
    [self startIndicator];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_UMS_USER_ID] forKey:@"user_id"];
    [reqBody setObject:[accountNumber stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:REQUEST_NOTI_OPTION_SEARCH_ACNO];
    [reqBody setObject:PUSH_APP_ID forKey:@"app_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_NOTI_ACCOUNT_DELETE];
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(accountDeleteResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)accountDeleteResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        NSString *deletedAccountNumber = [[[[response objectForKey:@"list"] objectForKey:@"sub"] objectAtIndex:0] objectForKey:@"UMSD030001_OUT_SUB.account_number"];
        if(deletedAccountNumber != nil && [deletedAccountNumber length] > 0)
        {
            deletedAccountNumber = [deletedAccountNumber stringByReplacingOccurrencesOfString:STRING_DASH withString:@""];
            
            NSMutableDictionary *nickNameDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_NICKNAME_DICTIONARY]];
            if([nickNameDic objectForKey:deletedAccountNumber] != nil)
            {
                [nickNameDic removeObjectForKey:deletedAccountNumber];
                [[NSUserDefaults standardUserDefaults] setObject:nickNameDic forKey:ACCOUNT_NICKNAME_DICTIONARY];
            }
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"알림 계좌가 삭제되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView setTag:90000];
        [alertView show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert setTag:90003];
        [alert show];
    }
}

#pragma mark - 이용해지
- (void)serviceDeactivateRequest
{
    [[ServiceDeactivationController sharedInstance] deactivateService:@"Y"];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == 90000)
    {
        // 뒤로가기
        NSInteger viewIndex = [[self.navigationController viewControllers] count] - 1;
        while(viewIndex >= 0)
        {
            ECSlidingViewController *eVC = [[self.navigationController viewControllers] objectAtIndex:viewIndex];
            if([eVC.topViewController isKindOfClass:[AccountManageViewController class]])
            {
                [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:viewIndex] animated:YES];
                break;
            }
            
            viewIndex--;
        }
    }
    else if([alertView tag] == 90001 && buttonIndex == BUTTON_INDEX_OK)
    {
        if(totalNotiCount < 2)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"확인" message:@"해당 계좌를 삭제하면 알림 서비스를 받을수 없습니다.\n삭제하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
            [alertView setTag:90002];
            [alertView show];
        }
        else
        {
            [self accountDeleteRequest];
        }
    }
    else if([alertView tag] == 90002 && buttonIndex == BUTTON_INDEX_OK)
    {
        // 이용해지 전문을 태운다.
        [self serviceDeactivateRequest];
    }
    else if([alertView tag] == 90003)
    {
//        [self.navigationController popViewControllerAnimated:YES];
        // 뒤로가기
        NSInteger viewIndex = [[self.navigationController viewControllers] count] - 1;
        while(viewIndex >= 0)
        {
            ECSlidingViewController *eVC = [[self.navigationController viewControllers] objectAtIndex:viewIndex];
            if([eVC.topViewController isKindOfClass:[AccountManageViewController class]])
            {
                [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:viewIndex] animated:YES];
                break;
            }
            
            viewIndex--;
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    [self.keyboardCloseButton setHidden:NO];
    [self.keyboardCloseButton setEnabled:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.keyboardCloseButton setEnabled:NO];
    [self.keyboardCloseButton setHidden:YES];
    self.currentTextField = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.currentTextField == optionView.accountNicknameInput)
    {
        if(![string isEqualToString:@""])
        {
            if(range.location == [textField tag])
            {
                return NO;
            }
        }
    }
    
    return YES;
}
@end
