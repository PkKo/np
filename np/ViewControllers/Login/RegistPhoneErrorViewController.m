//
//  RegistPhoneErrorViewController.m
//  np
//
//  Created by Infobank1 on 2015. 11. 24..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistPhoneErrorViewController.h"

@interface RegistPhoneErrorViewController ()

@end

@implementation RegistPhoneErrorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mTitleLabel setHidden:YES];
    [self.mNaviView.mBackButton setHidden:YES];
    [self.mNaviView.mMenuButton setHidden:YES];
    [self.mNaviView.imgTitleView setHidden:NO];
    
    [_scrollView setContentInset:UIEdgeInsetsZero];
    [_scrollView setContentSize:_contentView.frame.size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(_contentView.frame.size.height > _scrollView.frame.size.height)
    {
        [_scrollView setContentSize:_contentView.frame.size];
        [_scrollView setScrollEnabled:YES];
    }
    [_scrollView setContentInset:UIEdgeInsetsZero];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
