//
//  CommonViewController.m
//  mp
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

#define TOP_LAYOUT_OFFSET   22

@interface CommonViewController ()

@end

@implementation CommonViewController

@synthesize mNaviView;
@synthesize mMenuCloseButton;
@synthesize keyboardCloseButton;
@synthesize currentTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeNaviAndMenuView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.slidingViewController == nil)
    {
        NSLog(@"%s. slidingView nil", __FUNCTION__);
    }
    
    if(![self.slidingViewController.underRightViewController isKindOfClass:[MenuViewController class]])
    {
        self.slidingViewController.underRightViewController = [[MenuViewController alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)makeNaviAndMenuView
{
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0f green:101.0f/255.0f blue:179.0f/255.0f alpha:1.0f]];
    
    self.mNaviView = [NavigationView view];
    // 이미지 타이틀의 경우 일부에서만 보이면 된다.
    /**
     가입, 간편보기, 메인화면
     */
    [self.mNaviView.imgTitleView setHidden:YES];
    [self.mNaviView setFrame:CGRectMake(0, TOP_LAYOUT_OFFSET, self.view.frame.size.width, self.mNaviView.frame.size.height)];
    [self.view addSubview:self.mNaviView];
    /*
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        [self.mNaviView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.view.mas_top).offset(20);
            make.height.equalTo(@(self.mNaviView.frame.size.height));
        }];
    }*/
    
    [self.mNaviView.mMenuButton addTarget:self action:@selector(showMenuView) forControlEvents:UIControlEventTouchUpInside];
    [self.mNaviView.mBackButton addTarget:self action:@selector(moveBack) forControlEvents:UIControlEventTouchUpInside];
    
    mMenuCloseButton = [[UIButton alloc] init];
    [mMenuCloseButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    [mMenuCloseButton addTarget:self action:@selector(closeMenuView) forControlEvents:UIControlEventTouchUpInside];
    [mMenuCloseButton setEnabled:NO];
    [mMenuCloseButton setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [mMenuCloseButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [mMenuCloseButton setHidden:YES];
    [self.view addSubview:mMenuCloseButton];
    /*
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        [mMenuCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.top.equalTo(self.view.mas_top);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }*/
    
    [self.view bringSubviewToFront:mMenuCloseButton];
    
    keyboardCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [keyboardCloseButton setBackgroundColor:[UIColor clearColor]];
    [keyboardCloseButton addTarget:self action:@selector(keyboardClose) forControlEvents:UIControlEventTouchUpInside];
    [keyboardCloseButton setEnabled:NO];
    [keyboardCloseButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:keyboardCloseButton];
    
    [self.view bringSubviewToFront:keyboardCloseButton];
    
    loadingIndicatorBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [loadingIndicatorBg setBackgroundColor:[UIColor colorWithWhite:0.3f alpha:0.3f]];
    [loadingIndicatorBg setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [loadingIndicatorBg setAutoresizesSubviews:YES];
    [loadingIndicatorBg setHidden:YES];
    
    [self.view addSubview:loadingIndicatorBg];
}

- (void)showMenuView
{
    [self.slidingViewController anchorTopViewToLeftAnimated:YES onComplete:^{
        [mMenuCloseButton setHidden:NO];
        [mMenuCloseButton setEnabled:YES];
        [self.view bringSubviewToFront:mMenuCloseButton];
    }];
}

- (void)closeMenuView
{
    [mMenuCloseButton setHidden:YES];
    [mMenuCloseButton setEnabled:NO];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (void)moveBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardClose
{
    if(currentTextField != nil)
    {
        [currentTextField resignFirstResponder];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self stopIndicator];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:error.description delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alertView show];
}

- (void)startIndicator
{
    [loadingIndicatorBg setHidden:NO];
}

- (void)stopIndicator
{
    [loadingIndicatorBg setHidden:YES];
}

@end
