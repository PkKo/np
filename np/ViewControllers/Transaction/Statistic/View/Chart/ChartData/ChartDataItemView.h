//
//  ChartDataItemView.h
//  np
//
//  Created by Phuong Nhi Dang on 9/27/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartDataItemView : UIView
@property (weak, nonatomic) IBOutlet UIButton *itemColor;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *itemValue;

- (void)updateUI;
@end
