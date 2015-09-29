//
//  ChartDataView.m
//  np
//
//  Created by Phuong Nhi Dang on 9/27/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ChartDataView.h"
#import "ChartDataItemView.h"
#import "ChartItemData.h"
#import "ChartDataTotalView.h"
#import "StatisticMainUtil.h"

@implementation ChartDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)reloadData:(NSArray *)arr {
    
    NSLog(@"%s", __func__);
    
    CGFloat mainViewWith    = 0.0;
    CGFloat mainViewHeight  = 0.0;
    
    BOOL    isIncome    = NO;
    CGFloat total       = 0;
    
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    int numberOfItem    = (int)[arr count];
    
    for (int itemIdx = 0; itemIdx < numberOfItem; itemIdx++) {
        
        ChartItemData * item = [arr objectAtIndex:itemIdx];
        
        NSArray             * nibArr    = [[NSBundle mainBundle] loadNibNamed:@"ChartDataItemView" owner:self options:nil];
        ChartDataItemView   * itemView  = (ChartDataItemView *)[nibArr objectAtIndex:0];
        
        
        [[itemView itemColor] setBackgroundColor:[StatisticMainUtil colorFromHexString:item.itemColor]];
        [[itemView itemName] setText:[NSString stringWithFormat:@"%@(%@%%)", item.itemName, item.itemPercent]];
        [[itemView itemValue] setText:[NSString stringWithFormat:@"%@원", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[item.itemValue floatValue]]]]];
        
        total += [item.itemValue floatValue];
        
        CGRect itemViewFrame    = itemView.frame;
        itemViewFrame.origin.y  = itemIdx * itemViewFrame.size.height;
        [itemView setFrame:itemViewFrame];
        
        [self addSubview:itemView];
        
        if (itemIdx == numberOfItem - 1) {
            mainViewWith    = itemViewFrame.size.width;
            mainViewHeight  = itemViewFrame.size.height * numberOfItem;
            if ([[item itemType] isEqualToString:INCOME]) {
                isIncome = YES;
            }
        }
    }
    
    NSArray             * nibArr    = [[NSBundle mainBundle] loadNibNamed:@"ChartDataTotalView" owner:self options:nil];
    ChartDataTotalView   * totalView  = (ChartDataTotalView *)[nibArr objectAtIndex:0];
    
    [[totalView totalName] setText:isIncome ? @"수입합계" : @"지출합계"];
    [[totalView totalValue] setText:[NSString stringWithFormat:@"%@원", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:total]]]];
    
    CGRect totalViewFrame    = totalView.frame;
    totalViewFrame.origin.y  = mainViewHeight;
    [totalView setFrame:totalViewFrame];
    
    [self addSubview:totalView];
    
    mainViewHeight      += totalView.frame.size.height;
    
    CGRect frame        = self.frame;
    frame.size.width    = mainViewWith;
    frame.size.height   = mainViewHeight;
    [self setFrame:frame];
}

@end
