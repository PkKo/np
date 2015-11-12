//
//  ServiceGuideViewController.m
//  np
//
//  Created by Infobank2 on 10/21/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ServiceGuideViewController.h"

@interface ServiceGuideViewController ()

@end

@implementation ServiceGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"서비스안내"];
    [self.prvBtn setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page Control
- (IBAction)changePage:(id)sender {
    
    
    // enable/disable previous, next buttons
    if (self.pageControl.currentPage == 0) {
        
        [self.prvBtn setHidden:YES];
        [self.nxtBtn setHidden:NO];
        
    } else if (self.pageControl.currentPage == self.pageControl.numberOfPages - 1) {
        
        [self.prvBtn setHidden:NO];
        [self.nxtBtn setHidden:YES];
    } else {
        
        [self.prvBtn setHidden:NO];
        [self.nxtBtn setHidden:NO];
    }
    
    CGFloat scrollViewWith      = self.scrollView.frame.size.width;
    CGFloat scrollViewHeight    = self.scrollView.frame.size.height;
    CGFloat scrollViewY         = self.scrollView.frame.origin.y;
    
    [self.scrollView scrollRectToVisible:CGRectMake(scrollViewWith * self.pageControl.currentPage, scrollViewY, scrollViewWith, scrollViewHeight) animated:YES];
}

- (void)setIndicatorForCurrentPage {
    CGFloat scrollViewWith  = self.scrollView.frame.size.width;
    float pagePos           =  self.scrollView.contentOffset.x * 1.0f  / scrollViewWith;
    [self.pageControl setCurrentPage:round(pagePos)];
}

- (IBAction)goNextPage {
    
    if (self.pageControl.currentPage < self.pageControl.numberOfPages - 1) {
        self.pageControl.currentPage++;
    }
    [self changePage:nil];
}

- (IBAction)goPreviousPage {
    
    if (self.pageControl.currentPage > 0) {
        self.pageControl.currentPage--;
    }
    [self changePage:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initPages];
}

#pragma mark - Scroll View
- (void)initPages {
    
    CGFloat numberOfPages       = self.pageControl.numberOfPages;
    CGFloat scrollViewWith      = self.scrollView.frame.size.width;
    CGFloat scrollViewHeight    = self.scrollView.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(scrollViewWith * numberOfPages, scrollViewHeight);
    
    for (int pageIndex = 0; pageIndex < numberOfPages; pageIndex++) {
        
        UIImageView * page = [[UIImageView alloc] initWithFrame:CGRectMake(scrollViewWith * pageIndex, 0, scrollViewWith, scrollViewHeight)];
        [page setImage:[UIImage imageNamed:[NSString stringWithFormat:(IS_IPHONE_4_OR_LESS ? @"img_service_0%d_4s" : @"img_service_0%d"), (pageIndex + 1)]]];
        
        [self.scrollView addSubview:page];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setIndicatorForCurrentPage];
    [self changePage:nil];
}

- (void)resizeContainerScrollView {
    
    CGFloat screenHeight                    = [[UIScreen mainScreen] bounds].size.height;
    CGRect containerScrollViewFrame         = self.containerScrollView.frame;
    containerScrollViewFrame.size.height    = screenHeight - containerScrollViewFrame.origin.y;
    [self.containerScrollView setFrame:containerScrollViewFrame];
    
    [self.containerScrollView setContentSize:self.containerView.frame.size];
}

@end
