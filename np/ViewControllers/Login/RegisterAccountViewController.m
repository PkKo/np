//
//  RegisterAccountViewController.m
//  가입 - 계좌등록
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegisterAccountViewController.h"
#import "RegistCompleteViewController.h"
#import "NFilterNum.h"
#import "nFilterNumForPad.h"
#import "EccEncryptor.h"
#import "LoginUtil.h"
#import "StatisticMainUtil.h"
#import "AccountObject.h"

@interface RegisterAccountViewController ()

@end

@implementation RegisterAccountViewController

@synthesize scrollView;
@synthesize contentView;
@synthesize nextButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mMenuButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
    // 공인인증서 인증 or 계좌인증 체크하여 뷰 구성을 따로한다.
    if([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_CERT])
    {
        // 공인인증서 인증 - 전 계좌 조회하여 계좌리스트 구성
        isCertMode = YES;
        // 전 계좌 조회 루틴 실행
//        [self allAccountListRequest];
//        allAccountList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_ACCOUNT_LIST]];
        allAccountList = ((AppDelegate *)[UIApplication sharedApplication].delegate).tempAllAccountList;
        [self makeAllAccountListView];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_ACCOUNT])
    {
        // 계좌인증 - 입력한 계좌 혹은 다른 계좌번호를 입력받을 수 있도록 뷰 구성
        isCertMode = NO;
        certifiedAccountNumber = [CommonUtil decrypt3DES:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_ACCOUNT_LIST] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
        [self makeInputAccountView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect accountListTableRect         = allListView.accountListTable.frame;
    CGRect convertedAccountListTableRect= [allListView convertRect:accountListTableRect toView:self.view];
    CGFloat accountListTableHeight      = nextButton.frame.origin.y - convertedAccountListTableRect.origin.y;
    
    accountListTableRect.size.height    = accountListTableHeight;
    
    [allListView.accountListTable setFrame:accountListTableRect];
}

#pragma mark - 공인인증 : 전계좌 리스트 뷰 구성
- (void)makeAllAccountListView
{
    allListView = [RegistAccountAllListView view];
    [allListView initAccountList:allAccountList customerName:[CommonUtil decrypt3DES:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_USER_NAME] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey]];
    
    // NHI TEST
    //[allListView highlightDefaultAccount];
    
    [allListView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [contentView addSubview:allListView];
    [nextButton setTag:0];
}

#pragma mark - 계좌인증 : 계좌번호 확인 및 입력 뷰 구성
- (void)makeInputAccountView
{
    inputAccountView = [RegistAccountInputAccountView view];
    [inputAccountView setDelegate:self];
    [[inputAccountView certifiedAccountNumberLabel] setText:[CommonUtil getAccountNumberAddDash:certifiedAccountNumber]];
    [[inputAccountView addNewAccountInput] setDelegate:self];
    [[inputAccountView addNewAccountPassInput] setDelegate:self];
    [[inputAccountView addNewAccountBirthInput] setDelegate:self];
    [inputAccountView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [contentView addSubview:inputAccountView];
    [nextButton setTag:1];
}

- (void)changeAccountInputView:(NSNumber *)isInputView
{
    if([isInputView boolValue])
    {
        if(inputAccountView.addNewAccountInput.text.length > 0 && inputAccountView.addNewAccountPassInput.text.length > 0 && inputAccountView.addNewAccountBirthInput.text.length > 0)
        {
            [nextButton setEnabled:YES];
            [nextButton setBackgroundColor:BUTTON_BGCOLOR_ENABLE];
        }
        else
        {
            [nextButton setEnabled:NO];
            [nextButton setBackgroundColor:BUTTON_BGCOLOR_DISABLE];
        }
    }
    else
    {
        certifiedAccountNumber = [inputAccountView.certifiedAccountNumberLabel.text stringByReplacingOccurrencesOfString:STRING_DASH withString:@""];
        [nextButton setEnabled:YES];
        [nextButton setBackgroundColor:BUTTON_BGCOLOR_ENABLE];
    }
}

#pragma mark - UIButton Action
- (IBAction)nextButtonClick:(id)sender
{
    switch ([nextButton tag])
    {
        case 0:
        {
            // 계좌옵션 설정 뷰를 보여줌
            // NHI TEST
            //certifiedAccountNumber = [[allAccountList objectAtIndex:[allListView getSelectedIndex]] objectForKey:@"EAAPAL00R0_OUT_SUB.acno"];
            
            certifiedAccountNumber = [allListView getFirstSelectedAccount];
            
            NSArray * selectedAccounts = [allListView getSelectedAccounts];
            if (selectedAccounts && [selectedAccounts count] > 1) {
                
                AccountType accountType = [(AccountObject *)[selectedAccounts objectAtIndex:0] accountType];
                [self createRegistAccountOptionSettingView:accountType response:nil];
                
            } else {
                [self accountOptionSearchReqeust];
            }
            /*
            optionView = [RegistAccountOptionSettingView view];
            [optionView setDelegate:self];
            [optionView initDataWithAccountNumber:accountNum];
            [optionView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
            [contentView addSubview:optionView];*/
            break;
        }
        case 1:
        {
            // 계좌 인증 루틴 실행 - UMS 서버와 통신
            if(![inputAccountView.certifiedAccountView isHidden])
            {
                certifiedAccountNumber = [inputAccountView.certifiedAccountNumberLabel.text stringByReplacingOccurrencesOfString:STRING_DASH withString:@""];
                [self accountOptionSearchReqeust];
            }
            else if(![inputAccountView.addNewAccountView isHidden])
            {
                [self checkRegistAccountRequest];
            }
            break;
        }
        case 2:
        {
            // option view에서 데이터 가져와서 해당 계좌에 대한 옵션 설정을 마친 후
            [self accountOptionSetReqeust];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - 계좌인증 확인
- (void)checkRegistAccountRequest
{
    if([inputAccountView.addNewAccountInput.text length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"계좌번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if([inputAccountView.addNewAccountPassInput.text length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"계좌 비밀번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if([inputAccountView.addNewAccountBirthInput.text length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"생년월일을 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [self startIndicator];
    
    certifiedAccountNumber = [inputAccountView.addNewAccountInput.text stringByReplacingOccurrencesOfString:STRING_DASH withString:@""];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:certifiedAccountNumber forKey:REQUEST_ACCOUNT_NUMBER];
    [reqBody setObject:inputAccountView.addNewAccountPassInput.text forKey:REQUEST_ACCOUNT_PASSWORD];
    [reqBody setObject:inputAccountView.addNewAccountBirthInput.text forKey:REQUEST_ACCOUNT_BIRTHDAY];
    /*
    [reqBody setObject:[CommonUtil decrypt3DES:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_CRM_MOBILE] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey] forKey:REQUEST_CERT_CRM_MOBILE];*/
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_ACCOUNT_CHECK];
    
    // Request Start
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(checkRegistAccountResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)checkRegistAccountResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        // 계좌번호로 인증한걸로 저장한다.
        [self accountOptionSearchReqeust];
        /*
        optionView = [RegistAccountOptionSettingView view];
        [optionView setDelegate:self];
        [optionView initDataWithAccountNumber:inputAccountView.addNewAccountInput.text];
        [optionView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
        [contentView addSubview:optionView];*/
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - 계좌옵션 조회
- (void)accountOptionSearchReqeust
{
    [self startIndicator];
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    /*
#if !DEV_MODE
    [reqBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_RLNO] forKey:REQUEST_NOTI_OPTION_SEARCH_RLNO];
#else
    [reqBody setObject:@"9805282169468" forKey:REQUEST_NOTI_OPTION_SEARCH_RLNO];
#endif*/
    [reqBody setObject:certifiedAccountNumber forKey:REQUEST_NOTI_OPTION_SEARCH_ACNO];
    
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
        NSInteger accountType = [[response objectForKey:@"account_type"] integerValue];
        
        if(accountType < 1 || accountType > 4)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"입출금 알림 신청이 불가능한 계좌입니다.\n입출식,외환,수익증권,신탁 계좌만 신청이 가능합니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        
        [self createRegistAccountOptionSettingView:(AccountType)accountType response:response];
        
        /*
        [self.mNaviView.mBackButton removeTarget:self action:@selector(moveBack) forControlEvents:UIControlEventTouchUpInside];
        [self.mNaviView.mBackButton addTarget:self action:@selector(accountChangeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        optionView = [RegistAccountOptionSettingView view];
        [optionView setDelegate:self];
        
        
        //NHI TEST
        NSArray * accountNumbers = [allListView getSelectedAccounts];
        NSInteger numberOfAccounts = 0;
        if (accountNumbers && accountNumbers.count > 1) {
            
            numberOfAccounts = accountNumbers.count - 1;
            [[optionView accountNicknameInput] setText:@""];
            [[optionView accountNicknameInput] setEnabled:NO];
            [[optionView accountNicknameInput] setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:225.0f/255.0f blue:230.0f/255.0f alpha:1]];
        }
        
        //[optionView initDataWithAccountNumber:certifiedAccountNumber];
        [optionView initDataWithAccountNumber:certifiedAccountNumber numberOfAccounts:numberOfAccounts];
        
        
        [optionView setAccountType:accountType];
        [optionView.accountChangeButton addTarget:self action:@selector(accountChangeClick:) forControlEvents:UIControlEventTouchUpInside];
        [optionView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
        
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
        
        [optionView makeAllOptionDataView];
        [contentView addSubview:optionView];
        [nextButton setTag:2];
        [optionView.descLabel1 sizeToFit];
        [optionView.descLabel2 sizeToFit];
        [optionView.descLabel3 sizeToFit];
        [optionView.descLabel4 sizeToFit];
         */
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)createRegistAccountOptionSettingView:(AccountType)accountType response:(NSDictionary *)response {
    
    
    [self.mNaviView.mBackButton removeTarget:self action:@selector(moveBack) forControlEvents:UIControlEventTouchUpInside];
    [self.mNaviView.mBackButton addTarget:self action:@selector(accountChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    optionView = [RegistAccountOptionSettingView view];
    [optionView setDelegate:self];
    
    
    //NHI TEST
    NSArray * accountNumbers = [allListView getSelectedAccounts];
    NSInteger numberOfAccounts = 0;
    if (accountNumbers && accountNumbers.count > 1) {
        
        numberOfAccounts = accountNumbers.count - 1;
        [[optionView accountNicknameInput] setPlaceholder:@""];
        [[optionView accountNicknameInput] setEnabled:NO];
        [[optionView accountNicknameInput] setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:225.0f/255.0f blue:230.0f/255.0f alpha:1]];
        [[optionView accountNicknameTitle] setText:@"계좌별칭 (다계좌 등록시 별칭입력 불가)"];
    }
    
    //[optionView initDataWithAccountNumber:certifiedAccountNumber];
    [optionView initDataWithAccountNumber:certifiedAccountNumber numberOfAccounts:numberOfAccounts];
    
    
    [optionView setAccountType:accountType];
    [optionView.accountChangeButton addTarget:self action:@selector(accountChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [optionView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    
    if (response) {
        
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
    }
    
    [optionView makeAllOptionDataView];
    [contentView addSubview:optionView];
    [nextButton setTag:2];
    [optionView.descLabel1 sizeToFit];
    [optionView.descLabel2 sizeToFit];
    [optionView.descLabel3 sizeToFit];
    [optionView.descLabel4 sizeToFit];
    
}

- (void)accountChangeClick:(id)sender
{
    [optionView removeFromSuperview];
    receiptsPaymentId = @"";
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_CERT])
    {
        [nextButton setTag:0];
    }
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_ACCOUNT])
    {
        [nextButton setTag:1];
    }
    
    [self.mNaviView.mBackButton removeTarget:self action:@selector(accountChangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.mNaviView.mBackButton addTarget:self action:@selector(moveBack) forControlEvents:UIControlEventTouchUpInside];
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
    
    // NHI TEST
    [reqBody setObject:[optionView.accountNumberLabel.text stringByReplacingOccurrencesOfString:STRING_DASH withString:@""] forKey:REQUEST_NOTI_OPTION_ACCOUNT_NUMBER];
    
    NSLog(@"key:%@ - value: %@", REQUEST_NOTI_OPTION_ACCOUNT_NUMBER, [optionView.accountNumberLabel.text stringByReplacingOccurrencesOfString:STRING_DASH withString:@""]);
    
    NSArray * selectedAccounts = [allListView getSelectedAccounts];
    if (selectedAccounts && selectedAccounts.count > 1) {
        
        int numberOfAccounts = selectedAccounts.count;
        
        for (int accountIdx = 1; accountIdx < numberOfAccounts; accountIdx++) {
            AccountObject * account = (AccountObject *)[selectedAccounts objectAtIndex:accountIdx];
            [reqBody setObject:account.accountNo forKey:[NSString stringWithFormat:@"%@_0%d", REQUEST_NOTI_OPTION_ACCOUNT_NUMBER, (accountIdx + 1)]];
            
            NSLog(@"key: %@ - value:%@", [NSString stringWithFormat:@"%@_0%d", REQUEST_NOTI_OPTION_ACCOUNT_NUMBER, (accountIdx + 1)], account.accountNo);
        }
    }
    
    
    
    if(receiptsPaymentId != nil && [receiptsPaymentId length] > 0)
    {
        [reqBody setObject:receiptsPaymentId forKey:REQUEST_NOTI_OPTION_RECEIPTS_ID];
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_NOTI_OPTION];
    
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(accountOptionSetResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
}

- (void)accountOptionSetResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        NSString *umsId = [response objectForKey:@"user_id"];
        if(umsId != nil)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[CommonUtil encrypt3DESWithKey:umsId key:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey] forKey:RESPONSE_CERT_UMS_USER_ID];
//            [IBNgmService registerUserWithAccountId:umsId verifyCode:[umsId dataUsingEncoding:NSUTF8StringEncoding]];
            [IBNgmService registerUserWithAccountId:umsId verifyCode:[umsId dataUsingEncoding:NSUTF8StringEncoding] phoneNumber:[CommonUtil decrypt3DES:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_CRM_MOBILE] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey]];
            
            NSMutableDictionary *additionalInfo = [[NSMutableDictionary alloc] init];
            [additionalInfo setObject:[CommonUtil decrypt3DES:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_USER_NAME] decodingKey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey] forKey:@"TAG1"];
            [IBNgmService setAdditionalInfo:additionalInfo];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:IS_USER];
        
        if([optionView.accountNicknameInput.text length] > 0)
        {
            NSMutableDictionary *nickNameDic = [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_NICKNAME_DICTIONARY];
            if(nickNameDic == nil)
            {
                nickNameDic = [[NSMutableDictionary alloc] init];
            }
            [nickNameDic setObject:optionView.accountNicknameInput.text forKey:[optionView.accountNumberLabel.text stringByReplacingOccurrencesOfString:STRING_DASH withString:@""]];

            [[NSUserDefaults standardUserDefaults] setObject:nickNameDic forKey:ACCOUNT_NICKNAME_DICTIONARY];
        }
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_CERT])
        {
            // 공인인증 로그인으로 설정
            [[[LoginUtil alloc] init] saveLoginMethod:LOGIN_BY_CERTIFICATE];
        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:REGIST_TYPE] isEqualToString:REGIST_TYPE_ACCOUNT])
        {
            // 계좌인증 로그인으로 설정
            [[[LoginUtil alloc] init] saveLoginMethod:LOGIN_BY_ACCOUNT];
        }
        
        // 가입계좌 가져오기
        LoginUtil * util        = [[LoginUtil alloc] init];
        [util saveAllAccountsAndAllTransAccounts:response];
        
        [[[LoginUtil alloc] init] setLogInStatus:YES];

        // 등록완료 뷰 컨트롤러로 이동
        RegistCompleteViewController *vc = [[RegistCompleteViewController alloc] init];
        ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
//        [self.navigationController pushViewController:eVC animated:YES];
        [self.navigationController setViewControllers:@[eVC] animated:YES];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController = eVC;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert setTag:90003];
        [alert show];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    
    if([self.currentTextField isSecureTextEntry])
    {
        [textField resignFirstResponder];
        [self showNFilterKeypad];
    }
    else
    {
        [self.keyboardCloseButton setHidden:NO];
        [self.keyboardCloseButton setEnabled:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.keyboardCloseButton setHidden:YES];
    [self.keyboardCloseButton setEnabled:NO];
    
    if(![self.currentTextField isSecureTextEntry])
    {
        self.currentTextField = nil;
    }
    
    if(!isCertMode && inputAccountView.addNewAccountInput.text.length > 0 && inputAccountView.addNewAccountPassInput.text.length > 0 && inputAccountView.addNewAccountBirthInput.text.length > 0)
    {
        [nextButton setEnabled:YES];
        [nextButton setBackgroundColor:BUTTON_BGCOLOR_ENABLE];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.currentTextField != optionView.accountNicknameInput)
    {
        if(![string isEqualToString:@""])
        {
            NSString *replacedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            if(replacedString.length <= [textField tag])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)showNFilterKeypad
{
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
//        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterNum" bundle:nil];
        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterSerialNum" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
        
        //콜백함수 설정
        [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
        [vc setLengthWithTagName:@"PasswordInput" length:4 webView:nil];
        [vc setFullMode:YES];
        [vc setSupportRetinaHD:YES];
        [vc setTopBarText:@"계좌비밀번호"];
        [vc setTitleText:@"계좌 비밀번호 입력"];
        [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
    }
    else
    {
        nFilterNumForPad *vc = [[nFilterNumForPad alloc] initWithNibName:@"nFilterNumForPad" bundle:nil];
        //서버 공개키 설정
        [vc setServerPublickey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
        
        //콜백함수 설정
        [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
        [vc setLengthWithTagName:@"PasswordInput" length:4 webView:nil];
        [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
    }
}

- (void)onPasswordConfirmNFilter:(NSString *)pPlainText encText:(NSString *)pEncText dummyText:(NSString *)pDummyText tagName:(NSString *)pTagName
{
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pPlainText];
    
    if(self.currentTextField != nil)
    {
        [self.currentTextField setText:plainText];
    }
    
    self.currentTextField = nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView tag] == 90003)
    {
        [self accountChangeClick:nil];
    }
}

#pragma mark - Keyboard
- (void)onKeyboardShow:(NSNotification *)notifcation {
    
    if (![[inputAccountView addNewAccountBirthInput] isFirstResponder]) {
        return;
    }
    
    CGFloat keyboardHeight;
    NSDictionary * keyboardInfo = [notifcation userInfo];
    NSValue * keyboardFrame     = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameRect    = [keyboardFrame CGRectValue];
    keyboardHeight              = keyboardFrameRect.size.height;
    
    CGPoint addNewAccountBirthInputPos = [inputAccountView convertPoint:inputAccountView.addNewAccountBirthInput.frame.origin toView:self.scrollView];
    [self.scrollView setContentOffset:CGPointMake(0, addNewAccountBirthInputPos.y)];
}

- (void)onKeyboardHide:(NSNotification *)notifcation
{
    [self.scrollView setContentOffset:CGPointZero];
}

@end
