//
//  MemoComposityViewController.m
//  np
//
//  Created by Infobank2 on 9/23/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "MemoCompositionViewController.h"
#import "StorageBoxUtil.h"

@interface MemoCompositionViewController ()

@end

@implementation MemoCompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)removeComposer {
    NSLog(@"removeComposer");
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)saveToStorageBox {
    NSLog(@"saveToStorageBox");
}

- (IBAction)shareSNS {
    NSLog(@"shareSNS");
    
    StorageBoxUtil * util = [[StorageBoxUtil alloc] init];
    [util showSNSShareInViewController:self.parentViewController withTransationObject:self.transactionObject];
    
    [self removeComposer];
}
@end
