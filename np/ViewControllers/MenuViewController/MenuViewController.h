//
//  MenuViewController.h
//  mp
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *mMenuTitleArray;
}

@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
- (IBAction)closeMenu:(id)sender;
@end
