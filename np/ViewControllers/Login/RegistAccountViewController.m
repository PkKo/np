//
//  RegistAccountViewController.m
//  가입 - 공인인증서, 계좌인증 뷰컨트롤러
//
//  Created by Infobank1 on 2015. 9. 22..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistAccountViewController.h"
#import "CertInfo.h"
#import "CertManager.h"
#import "CertLoader.h"
#import "RegistCertMenuView.h"
#import "RegistCertPassView.h"
#import "CertificateRoamingViewController.h"
#import "CertificateRoamingPhoneViewController.h"
#import "CertificateRoamingPassViewController.h"
#import "NFilterChar.h"
#import "NFilterNum.h"
#import "nFilterCharForPad.h"
#import "nFilterNumForPad.h"
#import "EccEncryptor.h"
#import "RegistPhoneViewController.h"
#import "RegistAccountInputView.h"
#import "LoginUtil.h"
#import "RegistPhoneErrorViewController.h"

@interface RegistAccountViewController ()

@end

@implementation RegistAccountViewController

@synthesize contentView;
@synthesize certControllArray;
@synthesize certSelectBtn;
@synthesize accountSelectBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isSelfIdentified) {
        
        [self.mNaviView.mBackButton setHidden:YES];
        [self.mNaviView.mTitleLabel setText:@"본인인증"];
        
    } else {
        [self.mNaviView.mBackButton setHidden:YES];
        [self.mNaviView.mMenuButton setHidden:YES];
        [self.mNaviView.mTitleLabel setHidden:YES];
        [self.mNaviView.imgTitleView setHidden:NO];
    }
    
    
    [self showRegistCertView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.isSelfIdentified)
    {
        [contentView setContentInset:UIEdgeInsetsZero];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeAllSubViews
{
    for (UIView *subView in [contentView subviews])
    {
        [subView removeFromSuperview];
    }
}

- (void)certPopView
{
    UIView *lastView = [[contentView subviews] lastObject];
    [lastView removeFromSuperview];
    
    if([[contentView subviews] count] == 1)
    {
        [self.mNaviView.mBackButton setHidden:YES];
        [self.mNaviView.mBackButton removeTarget:self action:@selector(certPopView) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)showRegistCertView
{
    if([[contentView subviews] count] > 0)
    {
        [self removeAllSubViews];
    }
    [self.mNaviView.mBackButton setHidden:YES];
    /*
     * 공인인증서로 가입하려는 경우
     */
    // 1-1. 디바이스에 공인인증서가 있는지 체크
    certControllArray = [CertLoader getCertControlArray];
    
    if([certControllArray count] > 0)
    {
        // 1-2-1. 공인인증서가 있으면 공인인증서 리스트 뷰 생성
        [self moveToCertListView];
    }
    else
    {
        // 1-2-2. 공인인증서가 없으면 가져오기 메뉴 뷰 생성
        RegistCertMenuView *menuView = [RegistCertMenuView view];
        [menuView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
        [[menuView getCertFromPCBtn] addTarget:self action:@selector(moveToGetCertFromPcView) forControlEvents:UIControlEventTouchUpInside];
        [[menuView getCertFromPhoneBtn] addTarget:self action:@selector(moveToGetCertFromPhoneView) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:menuView];
        [contentView setContentSize:menuView.frame.size];
        isCertRoaming = YES;
    }
    
    // 1-4. 공인인증서로 가입 진행
}

- (void)showRegistAccountView
{
    if([[contentView subviews] count] > 0)
    {
        [self removeAllSubViews];
    }
    
    [self.mNaviView.mBackButton setHidden:YES];
    /*
     * 계좌번호로 가입하려는 경우
     */
    // 2-1. 계좌번호 입력 뷰 생성
    RegistAccountInputView *inputView = [RegistAccountInputView view];
    [inputView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [[inputView accountInputField] setDelegate:self];
    [[inputView accountPassInputField] setDelegate:self];
    [[inputView birthInputField] setDelegate:self];
    [[inputView phoneNumInputField] setDelegate:self];
    [inputView setDelegate:self];
    [inputView initData];
    
    if (self.isSelfIdentified) {
        [self hidePhoneNumAndAdjustNoticePosition:inputView];
    }
    
    [contentView addSubview:inputView];
    
    // 2-2. 이후 서버와 통신진행
}

- (void)hidePhoneNumAndAdjustNoticePosition:(RegistAccountInputView *)inputView {
    
    [inputView.carrierSelectBtn setHidden:YES];
    [inputView.phoneNumInputField setHidden:YES];
    [inputView.carrierDropdownImage setHidden:YES];
    
    CGPoint carrierSelectBtnPoint   = inputView.carrierSelectBtn.frame.origin;
    CGPoint notice1Point            = inputView.notice1.frame.origin;
    
    CGFloat moveUpDistance          = notice1Point.y - carrierSelectBtnPoint.y - 5;
    
    CGRect notice1Frame = inputView.notice1.frame;
    notice1Frame.origin.y -= moveUpDistance;
    [inputView.notice1 setFrame:notice1Frame];
    
    CGRect noticeAsterisk1Frame = inputView.noticeAsterisk1.frame;
    noticeAsterisk1Frame.origin.y -= moveUpDistance;
    [inputView.noticeAsterisk1 setFrame:noticeAsterisk1Frame];
    
    
    CGRect notice2Frame = inputView.notice2.frame;
    notice2Frame.origin.y -= moveUpDistance;
    [inputView.notice2 setFrame:notice2Frame];
    
    CGRect noticeAsterisk2Frame = inputView.noticeAsterisk2.frame;
    noticeAsterisk2Frame.origin.y -= moveUpDistance;
    [inputView.noticeAsterisk2 setFrame:noticeAsterisk2Frame];
}

/**
 @breif 인증방식 뷰 변경
 */
- (IBAction)changeRegistView:(id)sender
{
    UIButton *selBtn = (UIButton *)sender;
    if(selBtn == certSelectBtn)
    {
        [certSelectBtn setEnabled:NO];
        [accountSelectBtn setEnabled:YES];
        [self showRegistCertView];
    }
    else if(selBtn == accountSelectBtn)
    {
        [certSelectBtn setEnabled:YES];
        [accountSelectBtn setEnabled:NO];
        [self showRegistAccountView];
    }
}

#pragma mark - 공인인증서 인증 관련 공인인증서 가져오기 Method
- (void)moveToGetCertFromPcView
{
    // 1-3. 공인인증서 가져오기 실행
    CertificateRoamingViewController *vc = [[CertificateRoamingViewController alloc] init];
    UIView *view = vc.view;
    [view setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [vc.mainView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [vc.scrollView setContentInset:UIEdgeInsetsZero];
    [vc.nextButton removeTarget:vc action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [vc.nextButton addTarget:self action:@selector(checkCertUploaded) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:vc.mainView];
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mBackButton removeTarget:self action:@selector(moveBack) forControlEvents:UIControlEventTouchUpInside];
    [self.mNaviView.mBackButton addTarget:self action:@selector(certPopView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)moveToGetCertFromPhoneView
{
    CertificateRoamingPhoneViewController *vc = [[CertificateRoamingPhoneViewController alloc] init];
    UIView *view = vc.view;
    [view setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [vc.mainView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [vc.scrollView setContentInset:UIEdgeInsetsZero];
    [vc.certNumOne setDelegate:self];
    [vc.certNumTwo setDelegate:self];
    [vc.certNumThree setDelegate:self];
    [vc.certNumFour setDelegate:self];
    [vc.nextButton removeTarget:vc action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [vc.nextButton addTarget:self action:@selector(checkCertUploadedFromPhone) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:vc.mainView];
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mBackButton removeTarget:self action:@selector(moveBack) forControlEvents:UIControlEventTouchUpInside];
    [self.mNaviView.mBackButton addTarget:self action:@selector(certPopView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)checkCertUploaded
{
    // 농협 스마트뱅킹 리얼 주소
    int rc = [[CertManager sharedInstance] verifyP12Uploaded:NH_BANK_CERT_URL];
    
    if (rc == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"PC에서 인증서가 업로드 되었습니다. 계속 진행하세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alert.tag = 10001;
        [alert show];
        return;
    }
    else if (rc == 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서버와의 통신에 문제가 발생했습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (rc == 200)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"PC에서 인증서가 업로드되지 않았습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

- (void)checkCertUploadedFromPhone
{
    if([certNumOneString length] < 4 || [certNumTwoString length] < 4 || [certNumThreeString length] < 4 || [certNumFourString length] < 4)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        [[CertManager sharedInstance] setAuthNumber:[NSString stringWithFormat:@"%@%@%@%@", certNumOneString, certNumTwoString, certNumThreeString, certNumFourString]];
        
        // 농협 스마트뱅킹 리얼 주소
        int rc = [[CertManager sharedInstance] verifyP12Uploaded:NH_BANK_CERT_URL];
        
        if (rc == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"스마트폰에서 인증서가 업로드 되었습니다. 계속 진행하세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            alert.tag = 10001;
            [alert show];
            return;
        }
        else if (rc == 100)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서버와의 통신에 문제가 발생했습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            return;
        }
        else if (rc == 200)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"스마트폰에서 인증서가 업로드되지 않았습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
}

- (void)moveToCertPassView
{
    // 1-3-1. 공인인증서 비밀번호 확인 뷰
    RegistCertPassView *passView = [RegistCertPassView view];
    [passView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [contentView addSubview:passView];
    
    [passView.certPasswordInput setDelegate:self];
    [passView.certPasswordButton addTarget:self action:@selector(passwordCheck) forControlEvents:UIControlEventTouchUpInside];
    [passView.certPassCancelButton addTarget:self action:@selector(certPopView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)passwordCheck
{
    int rc = 0;
    rc = [[CertManager sharedInstance] p12ImportWithUrl:NH_BANK_CERT_URL password:self.currentTextField.text];

    if (rc == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증서 저장이 완료되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert setTag:10002];
        [alert show];
    }
    else if (rc == 100)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서버와의 통신에 문제가 발생했습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
    }
    else if (rc == 200)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"PC에서 인증서가 업로드되지 않았습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"비밀번호가 일치하지 않습니다." delegate:self cancelButtonTitle:@"네" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)moveToCertListView
{
    isCertRoaming = NO;
    
    if([[contentView subviews] count] > 0)
    {
        [self removeAllSubViews];
    }
    [self.mNaviView.mBackButton setHidden:YES];
    
    RegistCertListView *certListView = [RegistCertListView view];
    [certListView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [certListView initCertList];
    [certListView setViewDelegate:self];
    [contentView addSubview:certListView];
}

- (void)certInfoSelected:(CertInfo *)certInfo
{
//    [self sessionTestRequest];
    // 실제 사용가능한 인증서인지 확인한 후 가입 진행한다.
    NSLog(@"%s, certInfo = %@", __FUNCTION__, certInfo);
    [[CertManager sharedInstance] setCertInfo:certInfo];
    [[[LoginUtil alloc] init] saveCertToLogin:certInfo];
    
    [self showNFilterKeypad];
}

- (void)certInfoRequest:(NSString *)password
{
    int rc = 0;
    
    rc = [[CertManager sharedInstance] checkPassword:password];
    
    if(rc == 0)
    {
        [self startIndicator];
        
        NSString *strTbs = @"abc"; //서명할 원문
        [[CertManager sharedInstance] setTbs:strTbs];
        // 전자서명 API 호출
        NSString *sig = [CommonUtil getURLEncodedString:[[CertManager sharedInstance] getSignature]];
        
        if (self.isSelfIdentified)
        {
            NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_LOGIN_CERT];
            
            NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
            [requestBody setObject:strTbs forKey:REQUEST_CERT_SSLSIGN_TBS];
            [requestBody setObject:sig forKey:REQUEST_CERT_SSLSIGN_SIGNATURE];
            [requestBody setObject:@"1" forKey:REQUEST_CERT_LOGIN_TYPE];
            [requestBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_CRM_MOBILE] forKey:@"crmMobile"];
            [requestBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_UMS_USER_ID] forKey:@"user_id"];
            
            NSString *bodyString = [CommonUtil getBodyString:requestBody];
            
            HttpRequest *req = [HttpRequest getInstance];
            [req setDelegate:self selector:@selector(certInfoResponse:)];
            [req requestUrl:url bodyString:bodyString];
        }
        else
        {
            NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_CERT];
            
            NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
            [requestBody setObject:strTbs forKey:REQUEST_CERT_SSLSIGN_TBS];
            [requestBody setObject:sig forKey:REQUEST_CERT_SSLSIGN_SIGNATURE];
            [requestBody setObject:@"1" forKey:REQUEST_CERT_LOGIN_TYPE];
            
            NSString *bodyString = [CommonUtil getBodyString:requestBody];
            
            HttpRequest *req = [HttpRequest getInstance];
            [req setDelegate:self selector:@selector(certInfoResponse:)];
            [req requestUrl:url bodyString:bodyString];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"입력하신 인증서의 비밀번호가 맞지 않습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)certInfoResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        if (self.isSelfIdentified) {
            LoginUtil * util = [[LoginUtil alloc] init];
            if (self.loginMethod == LOGIN_BY_PATTERN) {
                [util removePatternPassword];
            } else if (self.loginMethod == LOGIN_BY_SIMPLEPW) {
                [util removeSimplePassword];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            // 공인인증서로 인증한걸로 저장한다.
            [[NSUserDefaults standardUserDefaults] setObject:REGIST_TYPE_CERT forKey:REGIST_TYPE];
            if([(NSArray *)[[response objectForKey:RESPONSE_CERT_ACCOUNT_LIST] objectForKey:@"allAccountList"] count] > 0)
            {
                NSArray *allAccountList = [NSArray arrayWithArray:[[response objectForKey:RESPONSE_CERT_ACCOUNT_LIST] objectForKey:@"allAccountList"]];
                [[NSUserDefaults standardUserDefaults] setObject:allAccountList forKey:RESPONSE_CERT_ACCOUNT_LIST];
            }
            NSString *crmMobile = [response objectForKey:RESPONSE_CERT_CRM_MOBILE];
            //        NSString *umsId = [response objectForKey:RESPONSE_CERT_UMS_USER_ID];
            //        NSString *ibId = [response objectForKey:RESPONSE_CERT_IB_USER_ID];
            NSString *rlno = [response objectForKey:RESPONSE_CERT_RLNO];
            NSString *userName = [response objectForKey:RESPONSE_CERT_USER_NAME];
            
            [[NSUserDefaults standardUserDefaults] setObject:crmMobile forKey:RESPONSE_CERT_CRM_MOBILE];
            [[NSUserDefaults standardUserDefaults] setObject:rlno forKey:RESPONSE_CERT_RLNO];
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:RESPONSE_CERT_USER_NAME];
            
            NSInteger userCount = [[response objectForKey:@"user_count"] integerValue];
            
            // 인증 성공한 이후 휴대폰 인증으로 이동
            RegistPhoneViewController *vc = [[RegistPhoneViewController alloc] init];
            [vc setIsRegisteredUser:userCount];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - 계좌인증 확인
- (void)checkRegistAccountRequest:(NSDictionary *)accountInfo
{
    inputAccountInfo = [NSMutableDictionary dictionaryWithDictionary:accountInfo];
    tempAccountNum = [inputAccountInfo objectForKey:REQUEST_ACCOUNT_NUMBER];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[inputAccountInfo objectForKey:REQUEST_ACCOUNT_NUMBER] forKey:REQUEST_ACCOUNT_NUMBER];
    [reqBody setObject:[inputAccountInfo objectForKey:REQUEST_ACCOUNT_PASSWORD] forKey:REQUEST_ACCOUNT_PASSWORD];
    [reqBody setObject:[inputAccountInfo objectForKey:REQUEST_ACCOUNT_BIRTHDAY] forKey:REQUEST_ACCOUNT_BIRTHDAY];
    
    if([tempAccountNum length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"계좌번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if([[inputAccountInfo objectForKey:REQUEST_ACCOUNT_PASSWORD] length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"비밀번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if([[inputAccountInfo objectForKey:REQUEST_ACCOUNT_BIRTHDAY] length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"생년월일을 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (!self.isSelfIdentified) {
        if([[inputAccountInfo objectForKey:@"mobile_number"] length] < 4)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        
        if([[inputAccountInfo objectForKey:@"mobile_number"] length] < 10)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰번호를 정확히 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    
    [self startIndicator];
    
    if(self.isSelfIdentified)
    {
        [reqBody setObject:[[NSUserDefaults standardUserDefaults] objectForKey:RESPONSE_CERT_CRM_MOBILE] forKey:@"crmMobile"];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_ACCOUNT_CHECK];
        
        // Request Start
        HttpRequest *req = [HttpRequest getInstance];
        [req setDelegate:self selector:@selector(checkRegistAccountResponse:)];
        [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
    }
    else
    {
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_ACCOUNT];
        
        // Request Start
        HttpRequest *req = [HttpRequest getInstance];
        [req setDelegate:self selector:@selector(checkRegistAccountResponse:)];
        [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
    }
}

- (void)checkRegistAccountResponse:(NSDictionary *)response
{
    [self stopIndicator];
    
#if 0
    // 계좌번호로 인증한걸로 저장한다.
    [[NSUserDefaults standardUserDefaults] setObject:REGIST_TYPE_ACCOUNT forKey:REGIST_TYPE];
    // 인증 성공한 이후 휴대폰 인증으로 이동
    RegistPhoneViewController *vc = [[RegistPhoneViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
#else
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        
        if (self.isSelfIdentified)
        {
            LoginUtil * util = [[LoginUtil alloc] init];
            if (self.loginMethod == LOGIN_BY_PATTERN) {
                [util removePatternPassword];
            } else if (self.loginMethod == LOGIN_BY_SIMPLEPW) {
                [util removeSimplePassword];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString *crmMobile = [response objectForKey:RESPONSE_CERT_CRM_MOBILE];
            NSString *rlno = [response objectForKey:RESPONSE_CERT_RLNO];
            NSString *userName = [response objectForKey:RESPONSE_CERT_USER_NAME];
            
            if(![[inputAccountInfo objectForKey:@"mobile_number"] isEqualToString:crmMobile])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"서비스 가입불가\n입력한 휴대폰번호가 NH농협에 미등록되어 있거나\n번호가 다른경우 가입이 불가능합니다." delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:@"자세히보기", nil];
                [alertView setTag:60001];
                [alertView show];
                return;
            }
            
            // 계좌번호로 인증한걸로 저장한다.
            [[NSUserDefaults standardUserDefaults] setObject:REGIST_TYPE_ACCOUNT forKey:REGIST_TYPE];
            
            [[NSUserDefaults standardUserDefaults] setObject:tempAccountNum forKey:RESPONSE_CERT_ACCOUNT_LIST];
            [[NSUserDefaults standardUserDefaults] setObject:crmMobile forKey:RESPONSE_CERT_CRM_MOBILE];
            [[NSUserDefaults standardUserDefaults] setObject:rlno forKey:RESPONSE_CERT_RLNO];
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:RESPONSE_CERT_USER_NAME];
            
            NSInteger userCount = [[response objectForKey:@"user_count"] integerValue];
            
            // 인증 성공한 이후 휴대폰 인증으로 이동
            RegistPhoneViewController *vc = [[RegistPhoneViewController alloc] init];
            [vc setIsRegisteredUser:userCount];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
#endif
}

#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ([alertView tag])
    {
        case 10001: // 공인인증서 비밀번호 입력
        {
            [self moveToCertPassView];
            break;
        }
        case 10002: // 공인인증서 목록
        {
            self.currentTextField = nil;
            [self moveToCertListView];
            break;
        }
        case 60001: // 휴대폰 오류 자세히 보기 뷰 생성
        {
            if(buttonIndex == BUTTON_INDEX_OK)
            {
                RegistPhoneErrorViewController *vc = [[RegistPhoneErrorViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
            
        default:
            break;
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
    
    switch ([textField tag])
    {
        case 20001:
            certNumOneString = textField.text;
            break;
        case 20002:
            certNumTwoString = textField.text;
            break;
        case 20003:
            certNumThreeString = textField.text;
            break;
        case 20004:
            certNumFourString = textField.text;
            break;
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch ([textField tag])
    {
        case 20001:
        case 20002:
        case 20003:
        case 20004:
        {
            if(![string isEqualToString:@""])
            {
                if(range.location == 3)
                {
                    [textField insertText:string];
                    [textField endEditing:YES];
                }
            }
            break;
        }
            
        default:
        {
            if(![string isEqualToString:@""])
            {
                if(range.location == [textField tag])
                {
                    return NO;
                }
            }
            break;
        }
    }
    
    return YES;
}

- (void)showNFilterKeypad
{
    if(![certSelectBtn isEnabled])
    {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            NFilterChar *vc = [[NFilterChar alloc] initWithNibName:@"NFilterChar" bundle:nil];
            //        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterSerialNum" bundle:nil];
            //서버 공개키 설정
            [vc setServerPublickey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
            
            //콜백함수 설정
            [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
            [vc setLengthWithTagName:@"PasswordInput" length:20 webView:nil];
            [vc setFullMode:YES];
            [vc setSupportRetinaHD:YES];
            [vc setTopBarText:@"공인인증센터"];
            [vc setTitleText:@"공인인증서 비밀번호 입력"];
            [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
        }
        else
        {
            nFilterCharForPad *vc = [[nFilterCharForPad alloc] initWithNibName:@"nFilterCharForPad" bundle:nil];
            //서버 공개키 설정
            [vc setServerPublickey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
            
            //콜백함수 설정
            [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
            [vc setLengthWithTagName:@"PasswordInput" length:20 webView:nil];
            [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
        }
    }
    else if(![accountSelectBtn isEnabled])
    {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
//            NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterNum" bundle:nil];
            NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterSerialNum" bundle:nil];
            //서버 공개키 설정
            [vc setServerPublickey:((AppDelegate *)[UIApplication sharedApplication].delegate).serverKey];
            
            //콜백함수 설정
            [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
            [vc setLengthWithTagName:@"PasswordInput" length:4 webView:nil];
            [vc setFullMode:YES];
//            [vc setToolBar:YES];
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
}

- (void)onPasswordConfirmNFilter:(NSString *)pPlainText encText:(NSString *)pEncText dummyText:(NSString *)pDummyText tagName:(NSString *)pTagName
{
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pPlainText];
    
    if(self.currentTextField != nil)
    {
        [self.currentTextField setText:plainText];
    }
    
    if(![certSelectBtn isEnabled])
    {
        if(isCertRoaming)
        {
            [self passwordCheck];
        }
        else
        {
            [self certInfoRequest:plainText];
        }
    }
    
    self.currentTextField = nil;
}

- (void)onKeyboardShow:(NSNotification *)notifcation
{
    if(![accountSelectBtn isEnabled])
    {
        RegistAccountInputView *inputView = [[contentView subviews] objectAtIndex:0];
        NSDictionary * keyboardInfo = [notifcation userInfo];
        NSValue * keyboardFrame     = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrameRect    = [keyboardFrame CGRectValue];
        CGRect textFieldRect        = self.currentTextField.frame;
        CGRect inputRect            = contentView.superview.frame;
        CGPoint point = CGPointMake(self.currentTextField.frame.origin.x, textFieldRect.origin.y + inputRect.origin.y + contentView.frame.origin.y);
        
        if(point.y >= keyboardFrameRect.origin.y)
        {
            NSLog(@"%s", __FUNCTION__);
            scrollPoint = CGPointMake(0, point.y + textFieldRect.size.height - keyboardFrameRect.origin.y);
            [inputView.scrollView setContentSize:CGSizeMake(inputView.scrollView.frame.size.width,
                                                            inputView.scrollView.contentSize.height + scrollPoint.y * 2)];
//            [inputView.scrollView setContentOffset:scrollPoint animated:YES];
            [inputView.scrollView scrollRectToVisible:CGRectMake(0, scrollPoint.y, inputView.scrollView.frame.size.width, inputView.scrollView.frame.size.height) animated:NO];
            [inputView.scrollView setContentOffset:scrollPoint animated:NO];
        }
    }
}

- (void)onKeyboardHide:(NSNotification *)notifcation
{
    if(![accountSelectBtn isEnabled])
    {
        RegistAccountInputView *inputView = [[contentView subviews] objectAtIndex:0];
        [inputView.scrollView setContentSize:CGSizeMake(inputView.scrollView.frame.size.width,
                                                        inputView.scrollView.contentSize.height - scrollPoint.y * 2)];
        scrollPoint = CGPointZero;
        [inputView.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

#pragma mark - Session Test Code
- (void)sessionTestRequest
{
    HttpRequest *req = [HttpRequest getInstance];
    
    [req setDelegate:self selector:@selector(sessionTestResponse:)];
    [req requestUrl:[NSString stringWithFormat:@"%@/%@", SERVER_URL, @"sessionTest.cmd"] bodyString:@""];
}

- (void)sessionTestResponse:(NSDictionary *)response
{
    NSLog(@"%@", response);
}

@end
