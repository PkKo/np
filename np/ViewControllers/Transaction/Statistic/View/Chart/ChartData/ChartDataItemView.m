//
//  ChartDataItemView.m
//  np
//
//  Created by Phuong Nhi Dang on 9/27/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ChartDataItemView.h"

@implementation ChartDataItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)updateUI {
    self.itemColor.layer.cornerRadius = self.itemColor.layer.frame.size.width / 2;
}
@end
