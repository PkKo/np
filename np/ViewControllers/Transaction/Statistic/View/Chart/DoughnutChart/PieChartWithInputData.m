//
//  PieChartWithDatasource.m
//  np
//
//  Created by Infobank2 on 9/17/15.
//  Copyright (c) 2015 Infobank1. All rights reserved.
//

#import "PieChartWithInputData.h"
#import "PieChart.h"

@interface PieChartWithInputData() <PieChartDataSource, PieChartDelegate>
{
    PieChart * _pieChart;
    NSArray * _colorArr; // array of UIColor;
    NSArray * _sliceArr; // array of double
}
@end

@implementation PieChartWithInputData



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    NSLog(@"%s:%d", __func__, __LINE__);
    
    if (self != nil) {
        _pieChart = [[PieChart alloc] initWithFrame:frame];
        _pieChart.delegate = self;
        _pieChart.datasource = self;
        [self addSubview:_pieChart];
    }
    
    return self;
}

- (void)reloadChartWithColorArray:(NSArray *)colorArr sliceArr:(NSArray *)sliceArr {
    
    _colorArr = colorArr;
    _sliceArr = sliceArr;
    
    [_pieChart reloadData];
}

#pragma mark - PieCharDelegate
- (CGFloat)centerCircleRadius {
    return 40;
}

#pragma mark - PieCharDataSource
-(int)numberOfSlicesInPieChart:(PieChart *)PieChart {
    return (int)[_sliceArr count];
}

- (UIColor *)pieChart:(PieChart *)PieChart colorForSliceAtIndex:(NSUInteger)index {
    return _colorArr[index];
}

-(double)pieChart:(PieChart *)PieChart valueForSliceAtIndex:(NSUInteger)index {
    return [[_sliceArr objectAtIndex:index] doubleValue];
}

@end
