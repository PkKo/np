//
//  SplashLayerPopupView.h
//  np
//
//  Created by Infobank1 on 2015. 11. 11..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashLayerPopupView : UIView

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIButton *closeDayOptionButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIImageView *contentImage;
@property (strong, nonatomic) NSString *linkOutUrl;
@property (strong, nonatomic) IBOutlet UIButton *linkUrlButton;

- (IBAction)closeLayerView:(id)sender;
- (IBAction)linkUrlOpen:(id)sender;
@end
