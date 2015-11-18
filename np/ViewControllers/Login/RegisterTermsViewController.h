//
//  RegisterTermsViewController.h
//  np
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface RegisterTermsViewController : CommonViewController<UIWebViewDelegate>
{
    CGFloat contentViewHeight;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

//서비스 이용약관 웹뷰
@property (strong, nonatomic) IBOutlet UIWebView *serviceTermWebView;
@property (strong, nonatomic) IBOutlet UIImageView *serviceTermAgreeImg;
@property (strong, nonatomic) IBOutlet UILabel *serviceTermAgreeText;
@property (strong, nonatomic) IBOutlet UIWebView *personalDataTermWebView;
@property (strong, nonatomic) IBOutlet UIImageView *personalDataTermAgreeImg;
@property (strong, nonatomic) IBOutlet UILabel *personalDataTermAgreeText;
@property (strong, nonatomic) IBOutlet UIImageView *pushAgreeImg;
@property (strong, nonatomic) IBOutlet UILabel *pushAgreeText;
@property (strong, nonatomic) IBOutlet UIView *serviceTermsView;
@property (strong, nonatomic) IBOutlet UIWebView *totalTermsWebView;

- (IBAction)showServiceTerm:(id)sender;
- (IBAction)checkServiceTermAgree:(id)sender;
- (IBAction)showPersonalTerm:(id)sender;
- (IBAction)checkPersonalTermAgree:(id)sender;
- (IBAction)checkPushAgree:(id)sender;

- (IBAction)nextButtonClick:(id)sender;
- (IBAction)closeServiceTermsView:(id)sender;
@end
