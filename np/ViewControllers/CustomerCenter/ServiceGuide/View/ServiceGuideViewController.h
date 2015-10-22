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

@property (weak, nonatomic) IBOutlet UIScrollView   * containerScrollView;
@property (weak, nonatomic) IBOutlet UIView         * containerView;
@property (weak, nonatomic) IBOutlet UIScrollView   * scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl  * pageControl;

- (IBAction)changePage:(id)sender;
- (IBAction)goNextPage;
- (IBAction)goPreviousPage;
@end
