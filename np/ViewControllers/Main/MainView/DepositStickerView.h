//
//  DepositStickerView.h
//  np
//
//  Created by Infobank1 on 2015. 10. 19..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawStickerSettingView.h"

@interface DepositStickerView : UIView

@property (assign, nonatomic) id<StickerSettingDelegate> delegate;

- (IBAction)stickerSelect:(id)sender;
- (IBAction)closeView:(id)sender;
@end
