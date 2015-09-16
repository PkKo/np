//
//  StatisticMainViewController.h
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface StatisticMainViewController : CommonViewController

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

- (IBAction)backToPrvView:(UIBarButtonItem *)sender;
- (IBAction)showMenu:(id)sender;
- (IBAction)clickSearchButton;

@end
