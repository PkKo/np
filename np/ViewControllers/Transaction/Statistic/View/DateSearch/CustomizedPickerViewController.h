//
//  CustomizedPickerViewController.h
//  np
//
//  Created by Infobank2 on 10/8/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomizedPickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)closePickerView;

@property (nonatomic, strong) NSArray * _Nonnull items;
- (void)addTarget:(nonnull id)target action:(nonnull SEL)action;
- (void)selectRowByValue:(NSString * )value;
@end
