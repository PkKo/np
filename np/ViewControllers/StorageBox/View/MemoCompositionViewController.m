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
    self.view.backgroundColor = [StorageBoxUtil getDimmedBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
