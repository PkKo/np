//
//  ServiceGuideViewController.h
//  np
//
//  Created by Infobank2 on 10/21/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface ServiceGuideViewController : CommonViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView   * containerScrollView;
@property (strong, nonatomic) IBOutlet UIView         * containerView;
@property (strong, nonatomic) IBOutlet UIScrollView   * scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl  * pageControl;

@property (strong, nonatomic) IBOutlet UIButton       * nxtBtn;
@property (strong, nonatomic) IBOutlet UIButton       * prvBtn;

- (IBAction)changePage:(id)sender;
- (IBAction)goNextPage;
- (IBAction)goPreviousPage;
- (void)initPages;
@end
