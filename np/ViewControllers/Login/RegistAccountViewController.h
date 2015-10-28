//
//  RegistAccountViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 22..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "CertInfo.h"
#import "RegistCertListView.h"

@interface RegistAccountViewController : CommonViewController<UIAlertViewDelegate, UITextFieldDelegate, RegistCertListDelegate>
{
    BOOL isCertRoaming;
    NSString *tempAccountNum;
    
    NSString *certNumOneString;
    NSString *certNumTwoString;
    NSString *certNumThreeString;
    NSString *certNumFourString;
}

@property (strong, nonatomic) IBOutlet UIScrollView *contentView;
@property (strong, nonatomic) NSMutableArray *certControllArray;
@property (strong, nonatomic) IBOutlet UIButton *certSelectBtn;
@property (strong, nonatomic) IBOutlet UIButton *accountSelectBtn;

- (void)certInfoSelected:(CertInfo *)certInfo;
- (IBAction)changeRegistView:(id)sender;
- (void)checkRegistAccountRequest:(NSDictionary *)accountInfo;
@end
