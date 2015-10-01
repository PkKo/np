//
//  RegistAccountViewController.m
//  공인인증서, 계좌인증 뷰컨트롤러
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
#import "EccEncryptor.h"
#import "RegistCertListView.h"
#import "RegistPhoneViewController.h"

@interface RegistAccountViewController ()

@end

@implementation RegistAccountViewController

@synthesize contentView;
@synthesize certControllArray;
@synthesize currentTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mMenuButton setHidden:YES];
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
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
    }
    
    // 1-4. 공인인증서로 가입 진행
    
    /*
     * 계좌번호로 가입하려는 경우
     */
    // 2-1. 계좌번호 입력 뷰 생성
    // 2-2. 이후 서버와 통신진행
    
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
}

- (void)passwordCheck
{
    int rc = 0;
    rc = [[CertManager sharedInstance] p12ImportWithUrl:NH_BANK_CERT_URL password:currentTextField.text];
    
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
    RegistCertListView *certListView = [RegistCertListView view];
    [certListView initCertList];
    [certListView setViewDelegate:self];
    [contentView addSubview:certListView];
}

- (void)certInfoSelected:(CertInfo *)certInfo
{
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
        NSString *sig = [[CertManager sharedInstance] getSignature];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, @"PMCNA100R.cmd"];
        
        NSMutableDictionary *requestBody = [[NSMutableDictionary alloc] init];
        [requestBody setObject:strTbs forKey:@"SSLSIGN_TBS_DATA"];
        [requestBody setObject:sig forKey:@"SSLSIGN_SIGNATURE"];
#ifdef DEV_MODE
        [requestBody setObject:@"1" forKey:@"REQ_LOGINTYPE"];
//        [requestBody setObject:@"Y" forKey:@"dummyYn"];
#endif
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
    
    if([[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS])
    {
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
            currentTextField = nil;
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
    [textField resignFirstResponder];
    currentTextField = textField;
    [self showNFilterKeypad];
}

- (void)showNFilterKeypad
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

- (void)onPasswordConfirmNFilter:(NSString *)pPlainText encText:(NSString *)pEncText dummyText:(NSString *)pDummyText tagName:(NSString *)pTagName
{
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    NSString *plainText = [ec makeDecNoPadWithSeedkey:pPlainText];
    
    if(currentTextField != nil)
    {
        [currentTextField setText:plainText];
    }
    else
    {
        [self certInfoRequest:plainText];
    }
}

@end
