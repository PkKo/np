//
//  ArchivedTransItemCell.m
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ArchivedTransItemCell.h"

@implementation ArchivedTransItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickDeleteBtn {
    NSLog(@"%s", __func__);
    [self.deleteBtn setSelected:!self.deleteBtn.selected];
}

- (IBAction)editMemo {
    NSLog(@"%s", __func__);
}
@end
