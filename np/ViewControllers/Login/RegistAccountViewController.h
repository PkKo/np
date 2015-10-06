//
//  RegistAccountViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 22..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "CertInfo.h"

@interface RegistAccountViewController : CommonViewController<UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSMutableArray *certControllArray;
@property (strong, nonatomic) IBOutlet UIButton *certSelectBtn;
@property (strong, nonatomic) IBOutlet UIButton *accountSelectBtn;

- (void)certInfoSelected:(CertInfo *)certInfo;
- (IBAction)changeRegistView:(id)sender;
- (void)checkRegistAccountRequest:(NSDictionary *)accountInfo;
@end
