//
//  StatisticMainUtil.m
//  Test2
//
//  Created by Infobank2 on 9/16/15.
//  Copyright (c) 2015 Infobank2. All rights reserved.
//

#import "StatisticMainUtil.h"
#import "AppDelegate.h"

@implementation StatisticMainUtil

+ (void)showStatisticView {
    
    UIStoryboard * statisticStoryBoard = [UIStoryboard storyboardWithName:@"StatisticMainStoryboard" bundle:nil];
    UIViewController * statisticViewController = [statisticStoryBoard instantiateViewControllerWithIdentifier:@"statisticMain"];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)delegate.window.rootViewController;
        
        [nav setNavigationBarHidden:YES];
        [nav pushViewController:statisticViewController animated:YES];
        
    }
}

+ (void)hideStatisticView {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)delegate.window.rootViewController;
        
        [nav setNavigationBarHidden:NO];
        [nav popViewControllerAnimated:YES];
        
    }
}

@end
