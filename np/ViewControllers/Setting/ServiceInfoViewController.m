//
//  ServiceInfoViewController.m
//  앱소개 페이지
//
//  Created by Infobank1 on 2015. 11. 4..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "ServiceInfoViewController.h"
#import "ServiceGuideViewController.h"
#import "RegistAccountViewController.h"

@interface ServiceInfoViewController ()

@end

@implementation ServiceInfoViewController

@synthesize contentView;
@synthesize scrollView;
@synthesize pageControl;
@synthesize initialImg;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self initPages];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initPages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registStart:(id)sender
{
    RegistAccountViewController *vc = [[RegistAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Page Control
- (IBAction)changePage:(id)sender {
    
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

#pragma mark - Scroll View
- (void)initPages
{
    CGFloat numberOfPages       = self.pageControl.numberOfPages;
    CGFloat scrollViewWith      = contentView.frame.size.width;
    CGFloat scrollViewHeight    = self.scrollView.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(scrollViewWith * numberOfPages, scrollViewHeight);
    
    for (int pageIndex = 0; pageIndex < numberOfPages; pageIndex++) {
        
        UIImageView * page = [[UIImageView alloc] initWithFrame:CGRectMake(scrollViewWith * pageIndex, 0, scrollViewWith, scrollViewHeight)];
        [page setImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_service_0%d", (pageIndex + 1)]]];
        [self.scrollView addSubview:page];
    }
    
    [initialImg setHidden:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setIndicatorForCurrentPage];
    [self changePage:nil];
}
@end
