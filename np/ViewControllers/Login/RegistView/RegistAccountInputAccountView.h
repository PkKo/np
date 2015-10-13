//
//  RegistAccountInputAccountView.h
//  np
//
//  Created by Infobank1 on 2015. 10. 13..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistAccountInputAccountView : UIView

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *certifiedAccountView;
@property (strong, nonatomic) IBOutlet UIView *addNewAccountView;

- (IBAction)changeAccountView:(id)sender;
@end
