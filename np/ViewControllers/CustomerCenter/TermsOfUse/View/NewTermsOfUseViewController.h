//
//  NewTermsOfUseViewController.h
//  np
//
//  Created by Infobank2 on 11/24/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

#define IS_LATEST_TERMS_OF_USE_YES   @"Y"
#define IS_LATEST_TERMS_OF_USE_NO    @"N"


@interface NewTermsOfUseViewController : CommonViewController<UIWebViewDelegate>
{
    BOOL serviceTermClick;
    BOOL personalTermClick;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIWebView *serviceTermWebView;
@property (strong, nonatomic) IBOutlet UIImageView *serviceTermAgreeImg;
@property (strong, nonatomic) IBOutlet UILabel *serviceTermAgreeText;
@property (strong, nonatomic) IBOutlet UIWebView *personalDataTermWebView;
@property (strong, nonatomic) IBOutlet UIImageView *personalDataTermAgreeImg;
@property (strong, nonatomic) IBOutlet UILabel *personalDataTermAgreeText;
@property (strong, nonatomic) IBOutlet UIView *serviceTermsView;
@property (strong, nonatomic) IBOutlet UIWebView *totalTermsWebView;

- (IBAction)showServiceTerm:(id)sender;
- (IBAction)checkServiceTermAgree:(id)sender;
- (IBAction)showPersonalTerm:(id)sender;
- (IBAction)checkPersonalTermAgree:(id)sender;

- (IBAction)clickOk:(id)sender;
- (IBAction)closeServiceTermsView:(id)sender;
@end
