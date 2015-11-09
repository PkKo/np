//
//  BannerInfo.h
//  np
//
//  Created by Infobank1 on 2015. 11. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerInfo : NSObject

@property (strong, nonatomic) NSString *bannerSeq;
@property (strong, nonatomic) NSString *createDate;
@property (strong, nonatomic) NSString *editDate;
@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSString *linkInUrl;
@property (strong, nonatomic) NSString *linkOutUrl;
@property (strong, nonatomic) NSString *linkType;
@property (strong, nonatomic) NSString *viewEndDate;
@property (strong, nonatomic) NSString *viewStartDate;
@property (strong, nonatomic) NSString *viewType;

@end
