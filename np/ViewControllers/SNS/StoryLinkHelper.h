//
//  StoryLinkHelper.h
//  np
//
//  Created by Phuong Nhi Dang on 9/20/15.
//  Copyright (c) 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ScrapType) {
    ScrapTypeNone = 0,
    ScrapTypeWebsite,
    ScrapTypeVideo,
    ScrapTypeMusic,
    ScrapTypeBook,
    ScrapTypeArticle,
    ScrapTypeProfile
};

@interface ScrapInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSArray *imageURLs;
@property (nonatomic, assign) ScrapType type;

@end

@interface StoryLinkHelper : NSObject

+ (BOOL)canOpenStoryLink;

+ (NSString *)makeStoryLinkWithPostingText:(NSString *)postingText
                             appBundleID:(NSString *)appBundleID
                              appVersion:(NSString *)appVersion
                                 appName:(NSString *)appName
                               scrapInfo:(ScrapInfo *)scrapInfo;

+ (BOOL)openStoryLinkWithPostingText:(NSString *)postingText
                         appBundleID:(NSString *)appBundleID
                          appVersion:(NSString *)appVersion
                             appName:(NSString *)appName
                           scrapInfo:(ScrapInfo *)scrapInfo;

+ (BOOL)openStoryLinkWithURLString:(NSString *)URLString;

@end
