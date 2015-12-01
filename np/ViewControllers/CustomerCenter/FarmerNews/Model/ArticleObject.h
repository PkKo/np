//
//  ArticleObject.h
//  np
//
//  Created by Phuong Nhi Dang on 11/5/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleObject : NSObject

@property (nonatomic, copy) NSString * subject;
@property (nonatomic, copy) NSString * regDate;
@property (nonatomic, copy) NSString * contents;
@property (nonatomic, copy) NSString * imgPath;

@property (nonatomic, assign) BOOL isDetailsShown;
@property (nonatomic, assign) BOOL isAlreadyShownDetails;
@property (nonatomic, assign) CGSize cellSize;

@end
