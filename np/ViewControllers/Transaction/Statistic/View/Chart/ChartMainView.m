//
//  ChartMainView.m
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import "ChartMainView.h"

@implementation ChartMainView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    NSLog(@"initWithCoder");
    if (self != nil) {
        [self loadPieChart];
    }
    
    return self;
}

- (void)loadPieChart {
    
    CGFloat pieWidth = 200;
    CGFloat pieHeight = pieWidth;
    CGFloat pieX = 40;//(self.bounds.size.width - pieWidth) / 2;
    CGFloat pieY = 30;
    
    PieChartWithInputData * pieChart = [[PieChartWithInputData alloc] initWithFrame:CGRectMake(pieX, pieY, pieWidth, pieHeight)];
    [pieChart setDataSourceWithColorArray:@[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]] sliceArr:@[@60, @10, @30]];
    [self addSubview:pieChart];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




@end
