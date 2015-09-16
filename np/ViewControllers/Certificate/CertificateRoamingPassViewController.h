//
//  CertificateRoamingPassViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 15..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface CertificateRoamingPassViewController : CommonViewController<UITextFieldDelegate>

@property (strong, nonatomic) NSData *p12Data;
@property (strong, nonatomic) NSString *p12Url;
@property (strong, nonatomic) IBOutlet UITextField *mPassInputText;

- (IBAction)passInputButtonClick:(id)sender;
@end
