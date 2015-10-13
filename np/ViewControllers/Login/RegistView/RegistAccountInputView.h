//
//  RegistAccountInputView.h
//  np
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistAccountInputView : UIView

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UITextField *accountInputField;
@property (strong, nonatomic) IBOutlet UITextField *accountPassInputField;
@property (strong, nonatomic) IBOutlet UITextField *birthInputField;
@property (strong, nonatomic) IBOutlet UIButton *accountCheck;
@property (strong, nonatomic) IBOutlet UIButton *carrierSelectBtn;
@property (strong, nonatomic) IBOutlet CommonTextField *phoneNumInputField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (IBAction)checkAccount:(id)sender;
@end
