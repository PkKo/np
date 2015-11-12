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

#define MARGIN_TOP 5

@implementation ChartDataView

- (void)reloadData:(NSArray *)arr {
    
    CGFloat mainViewWith    = 0.0;
    CGFloat mainViewHeight  = 0.0;
    
    BOOL    isIncome    = NO;
    float total       = 0;
    
    NSNumberFormatter * numberFormatter = [StatisticMainUtil getNumberFormatter];
    
    int numberOfItem    = (int)[arr count];
    
    for (int itemIdx = 0; itemIdx < numberOfItem; itemIdx++) {
        
        ChartItemData * item = [arr objectAtIndex:itemIdx];
        
        NSArray             * nibArr    = [[NSBundle mainBundle] loadNibNamed:@"ChartDataItemView" owner:self options:nil];
        ChartDataItemView   * itemView  = (ChartDataItemView *)[nibArr objectAtIndex:0];
        
        
        [[itemView itemColor] setBackgroundColor:[StatisticMainUtil colorFromHexString:item.itemColor]];
        [[itemView itemName] setText:[NSString stringWithFormat:@"%@(%@%%)", item.itemName, item.itemPercent]];
        [[itemView itemValue] setText:[NSString stringWithFormat:@"%@원", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[item.itemValue floatValue]]]]];
        
        total += [item.itemValue floatValue];
        NSLog(@"item.itemName: %@ - [item.itemValue floatValue]: %f - total: %f", item.itemName, [item.itemValue floatValue], total);
        
        CGRect itemViewFrame        = itemView.frame;
        itemViewFrame.origin.y      = itemIdx * itemViewFrame.size.height + MARGIN_TOP;
        itemViewFrame.size.width    = [[UIScreen mainScreen] bounds].size.width - 36;
        
        [itemView setFrame:itemViewFrame];
        
        [self addSubview:itemView];
        [itemView updateUI];
        
        if (itemIdx == numberOfItem - 1) {
            mainViewWith    = itemViewFrame.size.width;
            mainViewHeight  = itemViewFrame.size.height * numberOfItem + MARGIN_TOP;
            if ([[item itemType] isEqualToString:TRANS_TYPE_INCOME]) {
                isIncome = YES;
            }
        }
    }
    
    NSArray             * nibArr    = [[NSBundle mainBundle] loadNibNamed:@"ChartDataTotalView" owner:self options:nil];
    ChartDataTotalView   * totalView  = (ChartDataTotalView *)[nibArr objectAtIndex:0];
    
    [[totalView totalName] setText:isIncome ? @"수입합계" : @"지출합계"];
    
    total = [[arr valueForKeyPath:@"@sum.itemValue"] floatValue];
    
    [[totalView totalValue] setText:[NSString stringWithFormat:@"%@원", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:total]]]];
    
    CGRect totalViewFrame       = totalView.frame;
    totalViewFrame.origin.y     = mainViewHeight;
    totalViewFrame.size.width    = [[UIScreen mainScreen] bounds].size.width - 36;
    [totalView setFrame:totalViewFrame];
    
    [self addSubview:totalView];
    
    mainViewHeight      += totalView.frame.size.height;
    
    CGRect frame        = self.frame;
    frame.size.width    = mainViewWith;
    frame.size.height   = mainViewHeight;
    [self setFrame:frame];
}

@end
