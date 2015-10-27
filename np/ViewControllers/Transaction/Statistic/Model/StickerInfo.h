//
//  StickerInfo.h
//  np
//
//  Created by Infobank2 on 10/27/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StickerInfo : NSObject

@property (nonatomic, copy) NSString    * stickerName;
@property (nonatomic, copy) NSString    * stickerColorHexString;
@property (nonatomic, strong) UIImage   * stickerImage;

- (instancetype)initStickerInfoWithStickerName:(NSString *)stickerName stickerColorHexStr:(NSString *)stickerColorHexStr stickerImage:(UIImage *)stickerImage;
@end
