//
//  StickerSettingView.h
//  np
//
//  Created by Infobank1 on 2015. 10. 19..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StickerSettingDelegate <NSObject>

@required
- (void)selectedStickerIndex:(NSNumber *)index;

@end

@interface WithdrawStickerSettingView : UIView

@property (assign, nonatomic) id<StickerSettingDelegate> delegate;
- (IBAction)closeView:(id)sender;
- (IBAction)stickerSelect:(id)sender;
@end