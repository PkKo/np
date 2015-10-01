//
//  CustomizedDatePickerViewController.h
//  np
//
//  Created by Phuong Nhi Dang on 9/28/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomizedDatePickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)closeDatePicker:(id)sender;
- (IBAction)chooseDate:(id)sender;

- (void)setMinMaxDateToSelectWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate;
- (void)addTargetForDoneButton:(id)target action:(SEL)action;
@end
