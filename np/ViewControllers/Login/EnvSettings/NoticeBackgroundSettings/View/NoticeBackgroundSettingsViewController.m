//
//  NoticeBackgroundSettingsViewController.m
//  np
//
//  Created by Infobank2 on 10/19/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "NoticeBackgroundSettingsViewController.h"
#import "LoginUtil.h"
#import "StatisticMainUtil.h"

@interface NoticeBackgroundSettingsViewController () {
    UIView * _selectedBgColorView;
}

@end

@implementation NoticeBackgroundSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"알림 배경 설정"];
    [self resizeContainerScrollView];
    [self showSavedBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Background color Selection
- (void)showSavedBackgroundColor {
    
    LoginUtil * util = [[LoginUtil alloc] init];
    UIColor * savedBgColor = [util getNoticeBackgroundColour];
    
    for (UIView * view in self.containerView.subviews) {
        
        if (![view isKindOfClass:[UILabel class]]) {
            
            NSString * viewBgColorStr   = [StatisticMainUtil hexStringFromColor:[view tintColor]];
            NSString * savedBgColorStr  = [StatisticMainUtil hexStringFromColor:savedBgColor];
            
            if ([viewBgColorStr isEqualToString:savedBgColorStr]) {
                [self doSelectBackgroundColor:view];
                break;
            }
        }
    }
}

- (IBAction)selectBackgroundColor:(UITapGestureRecognizer *)sender {
    [self doSelectBackgroundColor:[sender view]];
}

- (void)doSelectBackgroundColor:(UIView *)view {
    
    if (_selectedBgColorView == view) {
        return;
    }
    
    [self toggleBgColorSelecting:view];
    [self toggleBgColorSelecting:_selectedBgColorView];
    
    _selectedBgColorView = view;
}

- (void)toggleBgColorSelecting:(UIView *)bgColorSelectingView {
    
    if (!bgColorSelectingView) {
        return;
    }
    
    NSArray * subviews = [bgColorSelectingView subviews];
    
    for (UIView * subview in subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview setHidden:!subview.isHidden];
        }
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel * colorName = (UILabel *)subview;
            [colorName setHighlighted:!colorName.isHighlighted];
        }
    }
}

#pragma mark - Customize
- (void)resizeContainerScrollView {
    
    CGFloat screenHeight                    = [[UIScreen mainScreen] bounds].size.height;
    CGRect containerScrollViewFrame         = self.containerScrollView.frame;
    containerScrollViewFrame.size.height    = screenHeight - self.containerScrollView.superview.frame.origin.y - 40;
    [self.containerScrollView setFrame:containerScrollViewFrame];
    
    [self.containerScrollView setContentSize:self.containerView.frame.size];
}

#pragma mark - Cancel/Done
- (IBAction)clickCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickDone {
    [[[LoginUtil alloc] init] saveNoticeBackgroundColour:[_selectedBgColorView tintColor]];
    [self clickCancel];
}

@end
