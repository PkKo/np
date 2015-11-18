//
//  CustomizedDatePickerViewController.m
//  np
//
//  Created by Phuong Nhi Dang on 9/28/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "CustomizedDatePickerViewController.h"
#import "StorageBoxUtil.h"


@interface CustomizedDatePickerViewController ()

@property (nonatomic, assign) id doneTarget;
@property (nonatomic, assign) SEL doneSelector;

@end

@implementation CustomizedDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[StorageBoxUtil getDimmedBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayPreviousSelectedDate:(NSDate *)initialDate {
    [self.datePicker setDate:initialDate];
}

- (void)setMinMaxDateToSelectWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate {
    
    [self.datePicker setMinimumDate:minDate];
    [self.datePicker setMaximumDate:maxDate];
}

- (IBAction)closeDatePicker:(id)sender {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)chooseDate:(id)sender {
    if (self.doneTarget) {
        [self.doneTarget performSelector:self.doneSelector withObject:[self.datePicker date] afterDelay:0];
    }
    
    [self closeDatePicker:self];
}

- (void)addTargetForDoneButton:(id)target action:(SEL)action {
    self.doneTarget     = target;
    self.doneSelector   = action;
}

@end
