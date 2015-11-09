//
//  MenuTableCell.h
//  np
//
//  Created by Infobank1 on 2015. 9. 14..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *menuTitleImg;
@property (strong, nonatomic) IBOutlet UILabel *mMenuTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *menuSeparateLine;

@property (strong, nonatomic) IBOutlet CircleView *countBgView;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@end
