//
//  HomeEtcTimeLineCell.h
//  np
//
//  Created by Infobank1 on 2015. 10. 20..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeEtcTimeLineCell : UITableViewCell

@property (strong, nonatomic) IBOutlet IndexPathButton *stickerButton;
@property (strong, nonatomic) IBOutlet UIImageView *upperLine;
@property (strong, nonatomic) IBOutlet UIImageView *underLine;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *depthImage;
@end
