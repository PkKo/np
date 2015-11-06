//
//  SplashViewController.h
//  mp
//
//  Created by Infobank1 on 2015. 9. 8..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface SplashViewController : UIViewController<UIAlertViewDelegate, IBInboxProtocol>
{
    int categoryIndex;
}

@property (strong, nonatomic) IBOutlet UILabel *loadingTextLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *loadingProgressBar;
@end
