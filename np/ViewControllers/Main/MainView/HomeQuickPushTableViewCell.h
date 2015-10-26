//
//  HomeQuickPushTableViewCell.h
//  np
//
//  Created by Infobank1 on 2015. 10. 1..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeQuickPushTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *stickerImg;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountDescLabel;
@end
