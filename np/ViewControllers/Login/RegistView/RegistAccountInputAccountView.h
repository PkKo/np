//
//  RegistAccountInputAccountView.h
//  np
//
//  Created by Infobank1 on 2015. 10. 13..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistAccountInputAccountView : UIView

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *certifiedAccountView;
@property (strong, nonatomic) IBOutlet UIView *addNewAccountView;
@property (strong, nonatomic) IBOutlet CommonTextField *addNewAccountInput;
@property (strong, nonatomic) IBOutlet CommonTextField *addNewAccountPassInput;
@property (strong, nonatomic) IBOutlet CommonTextField *addNewAccountBirthInput;
@property (strong, nonatomic) NSString *encodedPassword;
@property (strong, nonatomic) IBOutlet UILabel *certifiedAccountNumberLabel;
@property (strong, nonatomic) NSString *certifiedAccountNum;

- (IBAction)changeAccountView:(id)sender;
@end
