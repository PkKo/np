//
//  RegistAccountAllRowCell.m
//  np
//
//  Created by Infobank1 on 1/14/16.
//  Copyright © 2016 Infobank1. All rights reserved.
//

#import "RegistAccountAllRowCell.h"

@interface RegistAccountAllRowCell(){
    UIControlState checkboxState;
}

@end

@implementation RegistAccountAllRowCell

- (UIControlState)accountState {
    
    return checkboxState;
}

- (void)setAccountState:(UIControlState)state {
    
    checkboxState = state;
    
    NSString * imageName = nil;
    UIColor * bgColor = [UIColor colorWithWhite:1 alpha:1];
    UIColor * textColor;
    
    switch (state) {
            
        case UIControlStateNormal:
            imageName = @"cherkoff";
            textColor = [UIColor colorWithRed:48.0f/255.0f green:49.0f/255.0f blue:57.0f/255.0f alpha:1];
            break;
            
        case UIControlStateSelected:
            imageName = @"cherkon";
            textColor = [UIColor colorWithRed:48.0f/255.0f green:158.0f/255.0f blue:251.0f/255.0f alpha:1];
            break;
            
        case UIControlStateDisabled:
            imageName = @"cherkoff";
            bgColor = [UIColor colorWithRed:224.0f/255.0f green:225.0f/255.0f blue:230.0f/255.0f alpha:1];
            textColor = [UIColor colorWithRed:144.0f/255.0f green:145.0f/255.0f blue:150.0f/255.0f alpha:1];
            
            break;
        default:
            break;
    }
    
    if (imageName) {
        [self.checkbox setImage:[UIImage imageNamed:imageName]];
    }
    [self setBackgroundColor:bgColor];
    [self.accountNo setTextColor:textColor];
}

@end
