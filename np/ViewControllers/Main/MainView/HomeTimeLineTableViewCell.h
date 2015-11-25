//
//  HomeTimeLineTableViewCell.h
//  np
//
//  Created by Infobank1 on 2015. 10. 1..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTimeLineTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *upperLine;
@property (strong, nonatomic) IBOutlet UIImageView *underLine;

@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet IndexPathButton *stickerButton;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountDescLabel;
@property (strong, nonatomic) IBOutlet UIImageView *separateLine;

@property (strong, nonatomic) IBOutlet IndexPathButton *pinButton;
@property (strong, nonatomic) IBOutlet IndexPathButton *moreButton;
@end
