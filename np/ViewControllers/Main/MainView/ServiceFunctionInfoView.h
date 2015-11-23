//
//  ServiceFunctionInfoView.h
//  np
//
//  Created by Infobank1 on 2015. 11. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceFunctionInfoView : UIView

@property (strong, nonatomic) IBOutlet UIButton *infoViewButton;
@property (assign, nonatomic) id delegate;

- (IBAction)infoButtonClick:(id)sender;
@end
