//
//  CustomizedPickerViewController.m
//  np
//
//  Created by Infobank2 on 10/8/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "CustomizedPickerViewController.h"
#import "StorageBoxUtil.h"

@interface CustomizedPickerViewController ()

@property (nonatomic, assign) id parentTarget;
@property (nonatomic, assign) SEL parentAction;
@end

@implementation CustomizedPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[StorageBoxUtil getDimmedBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectRowByValue:(NSString * )value {
    [self.pickerView selectRow:[self.items indexOfObject:value] inComponent:0 animated:YES];
}

- (IBAction)closePickerView {
    
    NSInteger selectedIndex = [self.pickerView selectedRowInComponent:0];
    
    if (self.parentTarget) {
        [self.parentTarget performSelector:self.parentAction
                                withObject:[self.items objectAtIndex:selectedIndex] afterDelay:0];
    }
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - picker view
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.items objectAtIndex:row];
}

#pragma mark - datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.items count];
}

#pragma mark - target action
- (void)addTarget:(id)target action:(nonnull SEL)action {
    self.parentTarget = target;
    self.parentAction = action;
}

@end
