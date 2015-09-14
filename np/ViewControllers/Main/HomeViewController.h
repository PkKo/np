//
//  HomeViewController.h
//  mp
//
//  Created by Infobank1 on 2015. 9. 9..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

typedef enum HomeViewType
{
    TIMELINE    = 0,
    BANKING,
    OTHER
} HomeViewType;

@interface HomeViewController : CommonViewController

@property (assign, nonatomic) HomeViewType mViewType;

@end
