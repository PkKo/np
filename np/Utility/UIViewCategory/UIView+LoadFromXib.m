//
//  UIView+LoadFromXib.m
//  RSSService
//
//  Created by Kim MockSung on 12. 12. 10..
//  Copyright (c) 2012년 JPKim. All rights reserved.
//

#import "UIView+LoadFromXib.h"

@implementation UIView (LoadFromXib)

+ (id)view
{
    NSString *className  = NSStringFromClass([self class]);
    UINib   * nib        = [UINib nibWithNibName:className bundle:nil];
    NSArray * nibObjects = [nib instantiateWithOwner:nil options:nil];
    
    NSAssert2(([nibObjects count] > 0) && [[nibObjects objectAtIndex:0] isKindOfClass:[self class]],
              @"Xib '%@' does not appear to contain a valid %@",
              NSStringFromClass([self class]), NSStringFromClass([self class]));
    
    id view = [nibObjects objectAtIndex:0];
     
    
    return view;
}

+ (id)viewForAddAccount
{
    NSString *nibName  = @"RegistAccountAllListViewAddAccount";
    UINib   * nib        = [UINib nibWithNibName:nibName bundle:nil];
    NSArray * nibObjects = [nib instantiateWithOwner:nil options:nil];
    
    NSAssert2(([nibObjects count] > 0) && [[nibObjects objectAtIndex:0] isKindOfClass:[self class]],
              @"Xib '%@' does not appear to contain a valid %@",
              NSStringFromClass([self class]), NSStringFromClass([self class]));
    
    id view = [nibObjects objectAtIndex:0];
    
    
    return view;
}


+ (id)view_iPhone5
{

    NSString *className  = NSStringFromClass([self class]);
    UINib   * nib        = [UINib nibWithNibName:[NSString stringWithFormat:@"%@_iPhone5",className] bundle:nil];
    NSArray * nibObjects = [nib instantiateWithOwner:nil options:nil];
    
    NSAssert2(([nibObjects count] > 0) && [[nibObjects objectAtIndex:0] isKindOfClass:[self class]],
              @"Xib '%@' does not appear to contain a valid %@",
              NSStringFromClass([self class]), NSStringFromClass([self class]));
    
    id view = [nibObjects objectAtIndex:0];
    
    
    return view;
    
}

+ (id)cell
{
    return [self view];
}

@end

@implementation UIView (Container)

+ (UIView *)viewWithViewList:(NSArray *)viewList
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    for (int i = 0; i < [viewList count] ; i++) {
        
        UIView *viewContainer = [viewList objectAtIndex:i];
        [viewContainer setFrame:CGRectMake(CGRectGetMinX(view.frame), CGRectGetMaxY(view.frame), CGRectGetWidth(viewContainer.frame), CGRectGetHeight(viewContainer.frame))];
        [view addSubview:viewContainer];
        
        [view setFrame:CGRectMake(CGRectGetMinX(view.frame), CGRectGetMinY(view.frame), CGRectGetWidth(viewContainer.frame), CGRectGetHeight(view.frame) + CGRectGetHeight(viewContainer.frame))];
    }
    
    return view;
}

+ (UIView *)horizontalViewWithViewList:(NSArray *)viewList
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    for(int i = 0; i < [viewList count]; i++) {
        UIView *viewContainer = [viewList objectAtIndex:i];
        [viewContainer setFrame:CGRectMake(CGRectGetMaxX(view.frame), CGRectGetMinY(view.frame), CGRectGetWidth(viewContainer.frame), CGRectGetHeight(viewContainer.frame))];
        [view addSubview:viewContainer];
        
        [view setFrame:CGRectMake(CGRectGetMinX(view.frame), CGRectGetMinY(view.frame), CGRectGetWidth(view.frame) + CGRectGetWidth(viewContainer.frame),  CGRectGetHeight(viewContainer.frame))];
    }
    
    return view;
}

@end
