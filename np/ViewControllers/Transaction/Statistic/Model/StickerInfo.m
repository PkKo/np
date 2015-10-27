//
//  StickerInfo.m
//  np
//
//  Created by Infobank2 on 10/27/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "StickerInfo.h"

@implementation StickerInfo

- (instancetype)initStickerInfoWithStickerName:(NSString *)stickerName stickerColorHexStr:(NSString *)stickerColorHexStr stickerImage:(UIImage *)stickerImage {
    self = [super init];
    if (self) {
        self.stickerName            = stickerName;
        self.stickerColorHexString  = stickerColorHexStr;
        self.stickerImage           = stickerImage;
    }
    return self;
}

@end
