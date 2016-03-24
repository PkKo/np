//
//  MainPageViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 24..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface MainPageViewController : CommonViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (assign, nonatomic) NSInteger startPageIndex;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *pageViewControllerArray;
@property (strong, nonatomic) IBOutlet UIView *tabButtonView;

@property (strong, nonatomic) IBOutlet UIButton *timeLineButton;
@property (strong, nonatomic) IBOutlet UIImageView *timeLineSelectImg;
@property (strong, nonatomic) IBOutlet UIButton *incomeButton;
@property (strong, nonatomic) IBOutlet UIImageView *incomeSelectImg;
@property (strong, nonatomic) IBOutlet UIButton *etcButton;
@property (strong, nonatomic) IBOutlet UIImageView *etcSelectImg;
@property (strong, nonatomic) IBOutlet UIButton *inboxButton;
@property (strong, nonatomic) IBOutlet UIImageView *inboxSelectImg;

- (void)tabSelect:(NSInteger)index;
- (IBAction)tabButtonClick:(id)sender;
@end
