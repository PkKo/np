//
//  CertificateRoamingPhoneViewController.m
//  np
//
//  Created by Infobank1 on 2015. 10. 28..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CertificateRoamingPhoneViewController.h"
#import "CertificateRoamingPassViewController.h"
#import "CertManager.h"

@interface CertificateRoamingPhoneViewController ()

@end

@implementation CertificateRoamingPhoneViewController

@synthesize mainView;
@synthesize scrollView;
@synthesize bottomView;

@synthesize certNumOne;
@synthesize certNumTwo;
@synthesize certNumThree;
@synthesize certNumFour;

@synthesize descriptionOneLabel;
@synthesize descriptionTwoLabel;
@synthesize descriptionThreeLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mTitleLabel setText:@"공인인증센터"];
//    [self.mNaviView.mMenuButton setHidden:YES];
    
    certNumOne.layer.borderColor = [UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f].CGColor;
    certNumOne.layer.borderWidth = 1.0f;
    certNumTwo.layer.borderColor = [UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f].CGColor;
    certNumTwo.layer.borderWidth = 1.0f;
    certNumThree.layer.borderColor = [UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f].CGColor;
    certNumThree.layer.borderWidth = 1.0f;
    certNumFour.layer.borderColor = [UIColor colorWithRed:176.0f/255.0f green:177.0f/255.0f blue:182.0f/255.0f alpha:1.0f].CGColor;
    certNumFour.layer.borderWidth = 1.0f;
    
    NSMutableAttributedString *textTwo = [[NSMutableAttributedString alloc] initWithString:descriptionTwoLabel.text];
    [textTwo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:48.0/255.0f green:158.0/255.0f blue:251.0/255.0f alpha:1.0f] range:NSMakeRange(0, 28)];
    [textTwo addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(28, 8)];
    [descriptionTwoLabel setAttributedText:textTwo];
    
    NSMutableAttributedString *textThree = [[NSMutableAttributedString alloc] initWithString:descriptionThreeLabel.text];
    [textThree addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(0, 16)];
    [textThree addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:48.0/255.0f green:158.0/255.0f blue:251.0/255.0f alpha:1.0f] range:NSMakeRange(16, 8)];
    [textThree addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:144.0/255.0f green:145.0/255.0f blue:150.0/255.0f alpha:1.0f] range:NSMakeRange(24, 8)];
    [descriptionThreeLabel setAttributedText:textThree];
    
//    [scrollView setContentInset:UIEdgeInsetsZero];
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, bottomView.frame.origin.y + bottomView.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
    [self.keyboardCloseButton setEnabled:YES];
    [self.keyboardCloseButton setHidden:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.keyboardCloseButton setHidden:YES];
    [self.keyboardCloseButton setEnabled:NO];
    self.currentTextField = nil;
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
            break;
    }
    
    return YES;
}

#pragma mark - UIButtonAction
- (IBAction)nextButtonClick:(id)sender
{
    if(certNumOne.text.length < 4 || certNumTwo.text.length < 4 || certNumThree.text.length < 4 || certNumFour.text.length < 4)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증번호를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        [self getCertInfo];
    }
}

#pragma mark - CertManager
- (void)getCertInfo
{
    [[CertManager sharedInstance] setAuthNumber:[NSString stringWithFormat:@"%@%@%@%@", certNumOne.text, certNumTwo.text, certNumThree.text, certNumFour.text]];
    
    // 농협 스마트뱅킹 리얼 주소
    int rc = [[CertManager sharedInstance] verifyP12Uploaded:@"https://newsmart.nonghyup.com/so/jsp/btworks/roaming/getcert.jsp"];
    
    if (rc == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증서가 업로드 되었습니다. 계속 진행하세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        alert.tag = 9999;
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"인증서가 업로드 되지 않았습니다. 다시 시도해 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 9999)
    {
        ECSlidingViewController *eVc = [[ECSlidingViewController alloc] init];
        CertificateRoamingPassViewController *viewController = [[CertificateRoamingPassViewController alloc] init];
        // 농협 스마트뱅킹 리얼 주소
        viewController.p12Url = [NSString stringWithFormat:@"https://newsmart.nonghyup.com/so/jsp/btworks/roaming/getcert.jsp"];
        eVc.topViewController = viewController;
        [self.navigationController pushViewController:eVc animated:YES];
    }
}
@end
