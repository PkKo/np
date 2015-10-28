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
#import "CertificateRoamingPassViewController.h"
#import "NFilterChar.h"
#import "NFilterNum.h"
#import "nFilterCharForPad.h"
#import "nFilterNumForPad.h"
#import "EccEncryptor.h"
#import "RegistPhoneViewController.h"
#import "RegistAccountInputView.h"

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
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mMenuButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
    [self showRegistCertView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
}

- (void)showRegistCertView
{
    if([[contentView subviews] count] > 0)
    {
        [self removeAllSubViews];
    }
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
    [contentView addSubview:inputView];
    
    // 2-2. 이후 서버와 통신진행
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
    [vc.nextButton removeTarget:vc action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [vc.nextButton addTarget:self action:@selector(checkCertUploaded) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:vc.mainView];
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
//        NSString *sig = [[[CertManager sharedInstance] getSignature] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSString *sig = [[CertManager sharedInstance] getSignature];
        NSString *sig = [CommonUtil getURLEncodedString:[[CertManager sharedInstance] getSignature]];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_CERT];
        
        NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
        [requestBody setObject:strTbs forKey:REQUEST_CERT_SSLSIGN_TBS];
        [requestBody setObject:sig forKey:REQUEST_CERT_SSLSIGN_SIGNATURE];
        [requestBody setObject:@"1" forKey:REQUEST_CERT_LOGIN_TYPE];
//        [requestBody setObject:@"Y" forKey:@"dummyYn"];
        /*
        NSString *tbs = [NSString stringWithFormat:@"%@=%@", @"SSLSIGN_TBS_DATA", strTbs];
        NSString *sigStr = [NSString stringWithFormat:@"%@=%@", @"SSLSIGN_SIGNATURE", sig];
        NSString *loginType = [NSString stringWithFormat:@"%@=%@", @"REQ_LOGINTYPE", @"1"];
        NSString *bodyString = [NSString stringWithFormat:@"%@&%@&%@", tbs, sigStr, loginType];
         */
        
        NSString *bodyString = [CommonUtil getBodyString:requestBody];
        
        HttpRequest *req = [HttpRequest getInstance];
        [req setDelegate:self selector:@selector(certInfoResponse:)];
//        [req requestUrl:url bodyObject:requestBody];
        [req requestUrl:url bodyString:bodyString];
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
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSLog(@"%@", cookies);
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] || [[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        // 공인인증서로 인증한걸로 저장한다.
        [[NSUserDefaults standardUserDefaults] setObject:REGIST_TYPE_CERT forKey:REGIST_TYPE];
        if([(NSArray *)[response objectForKey:RESPONSE_CERT_ACCOUNT_LIST] count] > 0)
        {
            NSArray *allAccountList = [NSArray arrayWithArray:[[response objectForKey:@"list"] objectForKey:RESPONSE_CERT_ACCOUNT_LIST]];
            [[NSUserDefaults standardUserDefaults] setObject:allAccountList forKey:RESPONSE_CERT_ACCOUNT_LIST];
        }
        NSString *crmMobile = [response objectForKey:RESPONSE_CERT_CRM_MOBILE];
//        NSString *umsId = [response objectForKey:RESPONSE_CERT_UMS_USER_ID];
//        NSString *ibId = [response objectForKey:RESPONSE_CERT_IB_USER_ID];
        NSString *rlno = [response objectForKey:RESPONSE_CERT_RLNO];
        
        [[NSUserDefaults standardUserDefaults] setObject:crmMobile forKey:RESPONSE_CERT_CRM_MOBILE];
        [[NSUserDefaults standardUserDefaults] setObject:rlno forKey:RESPONSE_CERT_RLNO];
        // 인증 성공한 이후 휴대폰 인증으로 이동
        RegistPhoneViewController *vc = [[RegistPhoneViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        NSString *message = [response objectForKey:RESULT_MESSAGE];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)certMakeSessionRequest
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSHTTPCookie *reqCookie = nil;
    for(NSHTTPCookie *cookie in cookies)
    {
        if([cookie.name isEqualToString:@"MCPU_SSID"])
        {
            reqCookie = cookie;
            break;
        }
    }
    
    if(reqCookie != nil)
    {
        HttpRequest *httpReq = [HttpRequest getInstance];
        
        [httpReq setDelegate:self selector:@selector(certMakeSessionResponse:)];
        
//        NSString *reqBody = [NSString stringWithFormat:@"%@=%@", reqCookie.name, reqCookie.value];
        NSString *strTbs = @"abc";
        NSString *sig = [CommonUtil getURLEncodedString:[[CertManager sharedInstance] getSignature]];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, @"PMCNA100R.cmd"];
        
        NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
        [requestBody setObject:strTbs forKey:@"SSLSIGN_TBS_DATA"];
        [requestBody setObject:sig forKey:@"SSLSIGN_SIGNATURE"];
        [requestBody setObject:@"1" forKey:@"REQ_LOGINTYPE"];
        [requestBody setObject:reqCookie.value forKey:reqCookie.name];
        [httpReq requestUrl:url bodyObject:requestBody];
    }
}

- (void)certMakeSessionResponse:(NSDictionary *)response
{
    NSLog(@"%s, response = %@", __FUNCTION__, response);
}

#pragma mark - 계좌인증 확인
- (void)checkRegistAccountRequest:(NSDictionary *)accountInfo
{
    [self startIndicator];
    
    tempAccountNum = [accountInfo objectForKey:REQUEST_ACCOUNT_NUMBER];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:[accountInfo objectForKey:REQUEST_ACCOUNT_NUMBER] forKey:REQUEST_ACCOUNT_NUMBER];
    [reqBody setObject:[accountInfo objectForKey:REQUEST_ACCOUNT_PASSWORD] forKey:REQUEST_ACCOUNT_PASSWORD];
    [reqBody setObject:[accountInfo objectForKey:REQUEST_ACCOUNT_BIRTHDAY] forKey:REQUEST_ACCOUNT_BIRTHDAY];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_ACCOUNT];
    
    // Request Start
    HttpRequest *req = [HttpRequest getInstance];
    [req setDelegate:self selector:@selector(checkRegistAccountResponse:)];
    [req requestUrl:url bodyString:[CommonUtil getBodyString:reqBody]];
    
//    [self performSelector:@selector(checkRegistAccountResponse:) withObject:nil afterDelay:1];
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
        // 계좌번호로 인증한걸로 저장한다.
        [[NSUserDefaults standardUserDefaults] setObject:REGIST_TYPE_ACCOUNT forKey:REGIST_TYPE];
        NSString *crmMobile = [response objectForKey:RESPONSE_CERT_CRM_MOBILE];
        NSString *rlno = [response objectForKey:RESPONSE_CERT_RLNO];
        [[NSUserDefaults standardUserDefaults] setObject:tempAccountNum forKey:RESPONSE_CERT_ACCOUNT_LIST];
        [[NSUserDefaults standardUserDefaults] setObject:crmMobile forKey:RESPONSE_CERT_CRM_MOBILE];
        [[NSUserDefaults standardUserDefaults] setObject:rlno forKey:RESPONSE_CERT_RLNO];
        // 인증 성공한 이후 휴대폰 인증으로 이동
        RegistPhoneViewController *vc = [[RegistPhoneViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
        [self.keyboardCloseButton setEnabled:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.keyboardCloseButton setEnabled:NO];
    
    if(![self.currentTextField isSecureTextEntry])
    {
        self.currentTextField = nil;
    }
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
            [vc setServerPublickey:@""];
            
            //콜백함수 설정
            [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
            [vc setLengthWithTagName:@"PasswordInput" length:20 webView:nil];
            [vc setFullMode:YES];
            [vc setTopBarText:@"공인인증센터"];
            [vc setTitleText:@"공인인증서 비밀번호 입력"];
            [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
        }
        else
        {
            nFilterCharForPad *vc = [[nFilterCharForPad alloc] initWithNibName:@"nFilterCharForPad" bundle:nil];
            //서버 공개키 설정
            [vc setServerPublickey:@""];
            
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
            NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterNum" bundle:nil];
            //        NFilterNum *vc = [[NFilterNum alloc] initWithNibName:@"NFilterSerialNum" bundle:nil];
            //서버 공개키 설정
            [vc setServerPublickey:@""];
            
            //콜백함수 설정
            [vc setCallbackMethod:self methodOnConfirm:@selector(onPasswordConfirmNFilter:encText:dummyText:tagName:) methodOnCancel:nil];
            [vc setLengthWithTagName:@"PasswordInput" length:4 webView:nil];
            [vc setFullMode:YES];
            [vc setTopBarText:@"계좌비밀번호"];
            [vc setTitleText:@"계좌 비밀번호 입력"];
            [vc setRotateToInterfaceOrientation:self.interfaceOrientation parentView:self.view];
        }
        else
        {
            nFilterNumForPad *vc = [[nFilterNumForPad alloc] initWithNibName:@"nFilterNumForPad" bundle:nil];
            //서버 공개키 설정
            [vc setServerPublickey:@""];
            
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
