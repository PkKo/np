//
//  MenuViewController.h
//  mp
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableEtcView.h"

@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSArray *mMenuTitleArray;
    MenuTableEtcView *bottomMenu;
    float cellHeight;
}

@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) IBOutlet UIView *bottomMenuView;
@property (strong, nonatomic) IBOutlet UIImageView *loginImg;
@property (strong, nonatomic) IBOutlet UILabel *loginTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *loginButtonTextLabel;
- (IBAction)closeMenu:(id)sender;
- (IBAction)loginButtonClick:(id)sender;
@end
