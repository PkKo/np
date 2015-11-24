//
//  AccountAddViewController.m
//  np
//
//  Created by Infobank1 on 2015. 10. 21..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "AccountAddViewController.h"
#import "NFilterNum.h"
#import "nFilterNumForPad.h"
#import "NFilterChar.h"
#import "nFilterCharForPad.h"
#import "EccEncryptor.h"
#import "CertInfo.h"
#import "CertManager.h"
#import "CertLoader.h"
#import "RegistCertMenuView.h"
#import "CertificateRoamingViewController.h"
#import "CertificateRoamingPhoneViewController.h"
#import "RegistCertPassView.h"
#import "AccountOptionSettingViewController.h"

@interface AccountAddViewController ()

@end

@implementation AccountAddViewController

@synthesize accountCertTab;
@synthesize CertTab;
@synthesize accountInputView;
@synthesize accountInputField;
@synthesize accountPasswordField;
@synthesize birthdayInputField;

@synthesize certMenuView;
@synthesize certMenuContentView;

@synthesize nextButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setHidden:NO];
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@"계좌추가"];
    
    certControllArray = [CertLoader getCertControlArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeCertView:(id)sender
{
    UIButton *currentButton = (UIButton *)sender;
    if(currentButton == accountCertTab)
    {
        isCertRegist = NO;
        [accountCertTab setEnabled:NO];
        [CertTab setEnabled:YES];
        [accountInputView setHidden:NO];
        [certMenuView setHidden:YES];
        [nextButton setHidden:NO];
        [nextButton setEnabled:YES];
        [nextButton setBackgroundColor:BUTTON_BGCOLOR_ENABLE];
    }
    else if(currentButton == CertTab)
    {
        [accountCertTab setEnabled:YES];
        [CertTab setEnabled:NO];
        [accountInputView setHidden:YES];
        [certMenuView setHidden:NO];
        [nextButton setHidden:YES];
        [nextButton setBackgroundColor:BUTTON_BGCOLOR_ENABLE];
        
        [self makeCertMenuView];
    }
}

#pragma mark - 공인인증서 관련 뷰
- (void)certPopView
{
    UIView *lastView = [[certMenuContentView subviews] lastObject];
    [lastView removeFromSuperview];
}

- (void)makeCertMenuView
{
    if([[certMenuContentView subviews] count] > 0)
    {
        for(UIView *subview in [certMenuContentView subviews])
        {
            [subview removeFromSuperview];
        }
    }
    
    if([certControllArray count] > 0)
    {
        isCertRegist = NO;
        [self moveToCertListView];
        [nextButton setHidden:YES];
        /*
        [nextButton setEnabled:NO];
        [nextButton setBackgroundColor:BUTTON_BGCOLOR_DISABLE];*/
    }
    else
    {
        isCertRegist = YES;
        // 1-2-2. 공인인증서가 없으면 가져오기 메뉴 뷰 생성
        RegistCertMenuView *menuView = [RegistCertMenuView view];
        [menuView setFrame:CGRectMake(0, 0, certMenuContentView.frame.size.width, certMenuContentView.frame.size.height)];
        [[menuView getCertFromPCBtn] addTarget:self action:@selector(moveToGetCertFromPcView) forControlEvents:UIControlEventTouchUpInside];
        [[menuView getCertFromPhoneBtn] addTarget:self action:@selector(moveToGetCertFromPhoneView) forControlEvents:UIControlEventTouchUpInside];
        [certMenuContentView addSubview:menuView];
        [nextButton setEnabled:YES];
        [nextButton setBackgroundColor:BUTTON_BGCOLOR_ENABLE];
    }
}

- (void)moveToCertListView
{
    RegistCertListView *certListView = [RegistCertListView view];
    [certListView setFrame:CGRectMake(0, 0, certMenuContentView.frame.size.width, certMenuContentView.frame.size.height)];
    [certListView initCertList];
    [certListView setViewDelegate:self];
    [certMenuContentView addSubview:certListView];
}

#pragma mark - 공인인증서 인증 관련 공인인증서 가져오기 Method
- (void)moveToGetCertFromPcView
{
    // 1-3. 공인인증서 가져오기 실행
    CertificateRoamingViewController *vc = [[CertificateRoamingViewController alloc] init];
    UIView *view = vc.view;
    [view setFrame:CGRectMake(0, 0, certMenuContentView.frame.size.width, certMenuContentView.frame.size.height)];
    [vc.mainView setFrame:CGRectMake(0, 0, certMenuContentView.frame.size.width, certMenuContentView.frame.size.height)];
    [vc.nextButton setHidden:YES];
    [nextButton setTag:10001];
    [certMenuContentView addSubview:vc.mainView];
}

- (void)moveToGetCertFromPhoneView
{
    CertificateRoamingPhoneViewController *vc = [[CertificateRoamingPhoneViewController alloc] init];
    UIView *view = vc.view;
    [view setFrame:CGRectMake(0, 0, certMenuContentView.frame.size.width, certMenuContentView.frame.size.height)];
    [vc.mainView setFrame:CGRectMake(0, 0, certMenuContentView.frame.size.width, certMenuContentView.frame.size.height)];
    [vc.certNumOne setDelegate:self];
    [vc.certNumTwo setDelegate:self];
    [vc.certNumThree setDelegate:self];
    [vc.certNumFour setDelegate:self];
    [vc.nextButton setHidden:YES];
    [nextButton setTag:10002];
    [certMenuContentView addSubview:vc.mainView];
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
    [passView setFrame:CGRectMake(0, 0, certMenuContentView.frame.size.width, certMenuContentView.frame.size.height)];
    [certMenuContentView addSubview:passView];
    
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

- (void)certInfoSelected:(CertInfo *)certInfo
{
    // 실제 사용가능한 인증서인지 확인한 후 가입 진행한다.
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
        NSString *sig = [CommonUtil getURLEncodedString:[[CertManager sharedInstance] getSignature]];
        
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
        // 공인인증서로 인증한걸로 저장한다.
        if([(NSArray *)[[response objectForKey:RESPONSE_CERT_ACCOUNT_LIST] objectForKey:@"allAccountList"] count] > 0)
        {
            allAccountList = [NSMutableArray arrayWithArray:[[response objectForKey:RESPONSE_CERT_ACCOUNT_LIST] objectForKey:@"allAccountList"]];
            NSMutableArray *tempAllAccountList = [NSMutableArray arrayWithArray:allAccountList];
            NSArray *joinedAccounts = [[[LoginUtil alloc] init] getAllAccounts];
            for(NSDictionary *account in allAccountList)
            {
                for (NSString *accountNumber in joinedAccounts)
                {
                    if([[account objectForKey:@"EAAPAL00R0_OUT_SUB.acno"] isEqualToString:accountNumber])
                    {
                        [tempAllAccountList removeObject:account];
                    }
                }
            }
            allAccountList = tempAllAccountList;
            allListView = [RegistAccountAllListView view];
            [allListView initAccountList:allAccountList customerName:[response objectForKey:@"user_name"]];
            [allListView setFrame:CGRectMake(0, 0, certMenuContentView.frame.size.width, certMenuContentView.frame.size.height)];
            [allListView setBackgroundColor:[UIColor colorWithRed:240.0/255.0f green:241.0/255.0f blue:246.0/255.0f alpha:1.0f]];
            [certMenuContentView addSubview:allListView];
            [nextButton setHidden:NO];
            [nextButton setEnabled:YES];
            [nextButton setBackgroundColor:BUTTON_BGCOLOR_ENABLE];
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
- (void)checkRegistAccountRequest
{
    NSArray *allAccounts = [[[LoginUtil alloc] init] getAllAccounts];
    if([allAccounts containsObject:accountInputField.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"이미 등록된 계좌입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [self startIndicator];
    
    NSMutableDictionary *reqBody = [[NSMutableDictionary alloc] init];
    [reqBody setObject:accountInputField.text forKey:REQUEST_ACCOUNT_NUMBER];
    [reqBody setObject:accountPasswordField.text forKey:REQUEST_ACCOUNT_PASSWORD];
    [reqBody setObject:birthdayInputField.text forKey:REQUEST_ACCOUNT_BIRTHDAY];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_ACCOUNT];
    
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
        // 계좌 옵션 설정으로
        AccountOptionSettingViewController *vc = [[AccountOptionSettingViewController alloc] init];
        [vc setAccountNumber:accountInputField.text];
        [vc setIsNewAccount:YES];
        ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
        
        [self.navigationController pushViewController:eVC animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[response objectForKey:RESULT_MESSAGE] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - UIButtonAction
- (IBAction)nextButtonClick:(id)sender
{
    if(![CertTab isEnabled])
    {
        if([sender tag] == 10001)
        {
            // PC에서 공인인증서 가져오기
            [self checkCertUploaded];
        }
        else if([sender tag] == 10002)
        {
            // 스마트폰에서 공인인증서 가져오기
            [self checkCertUploadedFromPhone];
        }
        else
        {
            // 공인인증서로 추가
            // 계좌번호가 있으면 옵션 설정 뷰 컨트롤러로 이동한다.
            if([allAccountList count] > 0)
            {
                AccountOptionSettingViewController *vc = [[AccountOptionSettingViewController alloc] init];
                [vc setAccountNumber:[[allAccountList objectAtIndex:[allListView getSelectedIndex]] objectForKey:@"EAAPAL00R0_OUT_SUB.acno"]];
                [vc setIsNewAccount:YES];
                ECSlidingViewController *eVC = [[ECSlidingViewController alloc] initWithTopViewController:vc];
                
                [self.navigationController pushViewController:eVC animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"추가할 계좌가 존재하지 않습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
                [alertView show];
                return;
            }
        }
    }
    else if(![accountCertTab isEnabled])
    {
        if([accountInputField.text length] == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"계좌번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        
        if([accountPasswordField.text length] == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"계좌비밀번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        
        if([birthdayInputField.text length] == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"생년월일을 입렵해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        
        [self checkRegistAccountRequest];
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
    [self.keyboardCloseButton setEnabled:NO];
    [self.keyboardCloseButton setHidden:YES];
    
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
    if(![CertTab isEnabled])
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
            [vc setSupportRetinaHD:YES];
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
    else if(![accountCertTab isEnabled])
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
            [vc setSupportRetinaHD:YES];
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
    
    self.currentTextField = nil;
    
    if(![CertTab isEnabled])
    {
        if(isCertRegist)
        {
            [self moveToCertPassView];
        }
        else
        {
            [self certInfoRequest:plainText];
        }
    }
}
@end
