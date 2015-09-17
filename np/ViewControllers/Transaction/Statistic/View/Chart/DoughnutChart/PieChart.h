//
//  PieChart.h
//  PieChartDemo
//
//  Created by Strokin Alexey on 8/27/13.
//  Copyright (c) 2013 Strokin Alexey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PieChartDelegate;
@protocol PieChartDataSource;

@interface PieChart : UIView 

@property (nonatomic, assign) id <PieChartDataSource> datasource;
@property (nonatomic, assign) id <PieChartDelegate> delegate;

-(void)reloadData;

@end



@protocol PieChartDelegate <NSObject>

- (CGFloat)centerCircleRadius;

@end



@protocol PieChartDataSource <NSObject>

@required
- (int)numberOfSlicesInPieChart:(PieChart *)PieChart;
- (double)pieChart:(PieChart *)PieChart valueForSliceAtIndex:(NSUInteger)index;
- (UIColor *)pieChart:(PieChart *)PieChart colorForSliceAtIndex:(NSUInteger)index;

@optional
- (NSString*)pieChart:(PieChart *)PieChart titleForSliceAtIndex:(NSUInteger)index;

@end
