//
//  MenuViewController.h
//  mp
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableEtcView.h"

typedef enum MenuIndex
{
    ALL_TIMELINE        = 0,
    DEPOSIT_TIMELINE,
    ETC_TIMELINE,
    STORAGE,
    
    NOTI_SETTING,
    NOTI_ONOFF_SETTING,
    NOTI_ACCOUNT_SETTING,
    NOTI_EXCHANGE_SETTING,
    
    SETTINGS,
    SETTINGS_QUICKVIEW_ONOFF,
    SETTINGS_PIN,
    SETTINGS_PATTERN,
    SETTINGS_LOGIN,
    SETTINGS_BG,
    SETTINGS_DELETE_DATA,
    
    CUSTOMER_CENTER,
    CERTIFICATE_CENTER,
    NH_APPZONE
}MenuIndex;

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
