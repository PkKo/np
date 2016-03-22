//
//  RegistAccountAllRowCell.h
//  np
//
//  Created by Infobank1 on 1/14/16.
//  Copyright © 2016 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountObject.h"

@interface RegistAccountAllRowCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView  * checkbox;
@property (strong, nonatomic) IBOutlet UILabel      * accountNo;
@property (strong, nonatomic) IBOutlet UILabel *btmLine;

- (UIControlState)accountState;
- (void)setAccountState:(UIControlState)state;

@end
