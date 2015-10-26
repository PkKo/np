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
    
    if (self != nil) {
        
        CGFloat size = 114;
        
        UIView * whiteBgView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 114)/2, (frame.size.height - 114)/2, size, size)];
        [whiteBgView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:whiteBgView];
        
        _pieChart = [[PieChart alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
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
    return 50;
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
