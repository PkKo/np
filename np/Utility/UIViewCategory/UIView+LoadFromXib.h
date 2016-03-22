//
//  UIView+LoadFromXib.h
//  RSSService
//
//  Created by Kim MockSung on 12. 12. 10..
//  Copyright (c) 2012년 JPKim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LoadFromXib)

+ (id)view;
+ (id)viewForAddAccount;
+ (id)view_iPhone5;
+ (id)cell;

@end

@interface UIView (Container)

+ (UIView *)viewWithViewList:(NSArray *)viewList;
+ (UIView *)horizontalViewWithViewList:(NSArray *)viewList;
@end
