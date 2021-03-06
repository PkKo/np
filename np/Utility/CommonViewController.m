//
//  CommonViewController.m
//  mp
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "SplashViewController.h"
#import "HomeViewController.h"



#define TOP_LAYOUT_OFFSET   22

@interface CommonViewController ()

@end

@implementation CommonViewController

@synthesize mNaviView;
@synthesize menuCloseView;
@synthesize mMenuCloseButton;
@synthesize keyboardCloseButton;
@synthesize currentTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeNaviAndMenuView];
    sessionRefreshRequest = [[HttpRequest alloc] init];


#if DEV_MODE
	if (NO == [self isKindOfClass: [HomeViewController class]]) {
		UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake(0, 5, 70, 25)];
		label.text          = @"DEV_MODE";
		label.font          = [UIFont systemFontOfSize: 10];
		label.textColor     = [UIColor blackColor];
		label.backgroundColor = [UIColor greenColor];
		[self.view addSubview: label];		
	}
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(![self.slidingViewController.underRightViewController isKindOfClass:[MenuViewController class]])
    {
        self.slidingViewController.underRightViewController = [[MenuViewController alloc] init];
    }
    
    [self.view bringSubviewToFront:loadingIndicatorBg];

	// 앱버전 체크처리
    AppDelegate* app = ((AppDelegate *)[UIApplication sharedApplication].delegate);
	[app performSelector: @selector(checkAppUpdate) withObject: nil afterDelay: 0.0];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([CommonUtil getNetworkStatus] == NotReachable)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크에 연결되지 않았습니다.\n네트워크 상태를 확인해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if([[[LoginUtil alloc] init] isLoggedIn])
    {
        [self sessionRefreshRequest];
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
    [self.mNaviView.mMenuButton addTarget:self action:@selector(showMenuView) forControlEvents:UIControlEventTouchUpInside];
    [self.mNaviView.mBackButton addTarget:self action:@selector(moveBack) forControlEvents:UIControlEventTouchUpInside];
    
    // 메뉴 닫기 버튼
    menuCloseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [menuCloseView setBackgroundColor:[UIColor clearColor]];
    [menuCloseView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    mMenuCloseButton = [[UIButton alloc] init];
    [mMenuCloseButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    [mMenuCloseButton addTarget:self action:@selector(closeMenuView) forControlEvents:UIControlEventTouchUpInside];
    [mMenuCloseButton setEnabled:NO];
    [mMenuCloseButton setFrame:CGRectMake(0, 0, menuCloseView.frame.size.width, menuCloseView.frame.size.height)];
    [mMenuCloseButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [menuCloseView addSubview:mMenuCloseButton];
    
    UIImageView *closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close_01.png"]];
    [closeImage setFrame:CGRectMake(self.view.frame.size.width - 24, 34, 16, 16)];
    [closeImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [menuCloseView addSubview:closeImage];
    
    [self.view addSubview:menuCloseView];
    [self.view bringSubviewToFront:menuCloseView];
    [menuCloseView setHidden:YES];
    
    // 키보드 닫기 버튼
    keyboardCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [keyboardCloseButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    [keyboardCloseButton addTarget:self action:@selector(keyboardClose) forControlEvents:UIControlEventTouchUpInside];
    [keyboardCloseButton setEnabled:NO];
    [keyboardCloseButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:keyboardCloseButton];
    [self.view bringSubviewToFront:keyboardCloseButton];
    [keyboardCloseButton setHidden:YES];
    
    // loading indicator
    loadingIndicatorBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [loadingIndicatorBg setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f]];
    [loadingIndicatorBg setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [loadingIndicatorBg setAutoresizesSubviews:YES];
    UIView *animationBg = [[UIView alloc] initWithFrame:CGRectMake(
                                                            (loadingIndicatorBg.frame.size.width - 50) / 2,
                                                            (loadingIndicatorBg.frame.size.height - 50) / 2,
                                                            50, 50)];
//    [animationBg setBackgroundColor:[UIColor colorWithRed:62.0/255.0f green:155.0/255.0f blue:233.0/255.0f alpha:1.0f]];
    [animationBg setBackgroundColor:[UIColor clearColor]];
    [animationBg setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [loadingIndicatorBg addSubview:animationBg];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(11.5f, 19.5f, 27, 11)];
    [logoView setImage:[UIImage imageNamed:@"loading_logo.png"]];
    [animationBg addSubview:logoView];
    
    loadingIndicatorImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [loadingIndicatorImg setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [loadingIndicatorImg setImage:[UIImage imageNamed:@"loading_circle.png"]];
    /*
    NSArray *loadingImageNames = @[@"loading_01.png",@"loading_02.png",@"loading_03.png",@"loading_04.png"];
    NSMutableArray *loadingImages = [[NSMutableArray alloc] init];
    for(NSString *name in loadingImageNames)
    {
        [loadingImages addObject:[UIImage imageNamed:name]];
    }
    [loadingIndicatorImg setBackgroundColor:[UIColor clearColor]];
    [loadingIndicatorImg setAnimationImages:loadingImages];
    [loadingIndicatorImg setAnimationDuration:0.25f];*/
    [animationBg addSubview:loadingIndicatorImg];
    [loadingIndicatorBg setHidden:YES];
    
    [self.view addSubview:loadingIndicatorBg];
    [self.view bringSubviewToFront:loadingIndicatorBg];
}

- (void)showMenuView
{
    [self.slidingViewController anchorTopViewToLeftAnimated:YES onComplete:^{
        [menuCloseView setHidden:NO];
        [mMenuCloseButton setEnabled:YES];
        [self.view bringSubviewToFront:menuCloseView];
    }];
}

- (void)closeMenuView
{
    [menuCloseView setHidden:YES];
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

- (void)didFailWithError:(NSError *)error
{
    [self stopIndicator];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:error.description delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alertView show];
}

- (void)startIndicator
{
    [self.view bringSubviewToFront:loadingIndicatorBg];
    [CommonUtil runSpinAnimationWithDuration:loadingIndicatorImg duration:10.0f];
//    [loadingIndicatorImg startAnimating];
    [loadingIndicatorBg setHidden:NO];
}

- (void)stopIndicator
{
    [CommonUtil stopSpinAnimation:loadingIndicatorImg];
//    [loadingIndicatorImg stopAnimating];
    [loadingIndicatorBg setHidden:YES];
}

- (void)timeoutError:(NSDictionary *)response
{
    [self stopIndicator];
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate) timeoutError:response];
}

- (void)sessionRefreshRequest
{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, REQUEST_APP_SESSION_REFRESH];
    [sessionRefreshRequest setDelegate:self selector:@selector(sessionRefreshResponse:)];
    [sessionRefreshRequest requestUrl:url bodyString:@""];
}

- (void)sessionRefreshResponse:(NSDictionary *)response
{
//    NSLog(@"%s", __FUNCTION__);
    if(response == nil)
    {
        return;
    }
    
    if(![[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS] && ![[response objectForKey:RESULT] isEqualToString:RESULT_SUCCESS_ZERO])
    {
        [((AppDelegate *)[UIApplication sharedApplication].delegate) timeoutError:response];
    }
}

@end
