//
//  LoginCertListViewController.m
//  np
//
//  Created by Infobank2 on 10/12/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "LoginCertListViewController.h"
#import "EccEncryptor.h"
#import "LoginUtil.h"
#import "LoginCertController.h"
#import "StatisticMainUtil.h"

@interface LoginCertListViewController ()

@end

@implementation LoginCertListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mTitleLabel setText:@""];
    [self updateUI];
    [self refreshView];
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

- (IBAction)gotoCertCenter {
}

- (IBAction)gotoLoginSettings {
}

- (IBAction)gotoNB {
}
- (IBAction)gotoFAQ {}

- (IBAction)gotoTelInquiry {}

#pragma mark - Certificate Verification
- (IBAction)clickOnCert:(UITapGestureRecognizer *)sender {
    
    LoginUtil * util = [[LoginUtil alloc] init];
    [util showSecureKeypadInParent:self topBar:@"공인인증서 로그인" title:@"비밀번호 입력"
                        textLength:20
                        doneAction:@selector(confirmPassword:) cancelAction:nil];
}

- (void)confirmPassword:(NSString *)pw {
    
    EccEncryptor * ec   = [EccEncryptor sharedInstance];
    NSString * password = [ec makeDecNoPadWithSeedkey:pw];
    
    LoginCertController * controller = [[LoginCertController alloc] init];
    BOOL succeed = [controller checkPasswordOfCert:password];
    
    if (succeed) {
        
    } else {
        
    }
}

#pragma mark - Refrest View
- (void)refreshView {
    
    LoginCertController * controller = [[LoginCertController alloc] init];
    CertInfo * certInfo = [controller getCert];
    
    if (certInfo) {
        
        self.certView.hidden = NO;
        
        NSDateFormatter * formatter = [StatisticMainUtil getDateFormatterWithStyle:@"yyyy/MM/dd"];
        self.certName.text      = certInfo.subjectDN2;
        self.certIssuer.text    = certInfo.issuer;
        self.certType.text      = certInfo.policy;
        self.issueDate.text     = [formatter stringFromDate:certInfo.dtNotBefore];
        self.expiryDate.text    = [formatter stringFromDate:certInfo.dtNotAfter];
        
        
    } else {
        
        self.certView.hidden = YES;
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"안내" message:@"등록된 공인인증서가 없습니다.\n공인인증센터로 이동하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            NSLog(@"공인인증센터로 이동");
            break;
            
        default:
            break;
    }
}

- (void)updateUI {
    
    [self.fakeNoticeTextField.layer setBorderWidth:1.0f];
    [self.fakeNoticeTextField.layer setBorderColor:[[UIColor colorWithRed:208.0f/255.0f green:209.0f/255.0f blue:214.0f/255.0f alpha:1] CGColor]];
}

@end
