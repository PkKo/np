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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ServiceGuideViewController *vc = [[ServiceGuideViewController alloc] init];
    [vc.containerScrollView setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height)];
    [contentView addSubview:vc.containerScrollView];
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
@end
