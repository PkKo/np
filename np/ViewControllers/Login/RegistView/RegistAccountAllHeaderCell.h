//
//  RegistAccountAllHeaderCell.h
//  np
//
//  Created by Infobank1 on 1/14/16.
//  Copyright © 2016 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistAccountAllHeaderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *accountCategory;
@property (strong, nonatomic) IBOutlet UIImageView *sectionIcon;

- (void)highlightSectionHeader:(BOOL)isHighlighted isRegisteredAccount:(BOOL)isRegisteredAccount;

@end
