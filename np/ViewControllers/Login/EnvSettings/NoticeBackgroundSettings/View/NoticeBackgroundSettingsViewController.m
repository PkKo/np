//
//  NoticeBackgroundSettingsViewController.m
//  np
//
//  Created by Infobank2 on 10/19/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "NoticeBackgroundSettingsViewController.h"
@interface NoticeBackgroundSettingsViewController () {
    UIView * _selectedBgColorView;
}

@end

@implementation NoticeBackgroundSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"알림 배경 설정"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Background color Selection
- (IBAction)selectBackgroundColor:(UITapGestureRecognizer *)sender {
    UIView * view = [sender view];
    
    if (_selectedBgColorView == view) {
        return;
    }
    
    [self toggleBgColorSelecting:view];
    [self toggleBgColorSelecting:_selectedBgColorView];
    
    _selectedBgColorView = view;
}

- (void)toggleBgColorSelecting:(UIView *)bgColorSelectingView {
    
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

#pragma mark - Cancel/Done
- (IBAction)clickCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickDone {
    [self clickCancel];
}

@end
