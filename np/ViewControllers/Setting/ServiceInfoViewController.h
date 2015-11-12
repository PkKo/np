//
//  ServiceInfoViewController.h
//  np
//
//  Created by Infobank1 on 2015. 11. 4..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface ServiceInfoViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIImageView *initialImg;
@property (strong, nonatomic) IBOutlet UIButton *preButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)registStart:(id)sender;
- (IBAction)changePage:(id)sender;
- (IBAction)goNextPage;
- (IBAction)goPreviousPage;
@end
