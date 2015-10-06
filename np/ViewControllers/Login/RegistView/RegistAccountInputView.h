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

- (IBAction)checkAccount:(id)sender;
@end
