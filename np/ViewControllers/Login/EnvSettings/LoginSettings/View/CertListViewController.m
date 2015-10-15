//
//  CertListViewController.m
//  np
//
//  Created by Infobank2 on 10/14/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "CertListViewController.h"
#import "StorageBoxUtil.h"
#import "CertViewCell.h"

@interface CertListViewController ()

@end

@implementation CertListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[StorageBoxUtil getDimmedBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"CertViewCell" owner:self options:nil];
    CertViewCell * cell = (CertViewCell *)[nibArr objectAtIndex:0];
    return cell.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CertViewCell";
    
    CertViewCell *cell = (CertViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"CertViewCell" owner:self options:nil];
        cell            = (CertViewCell *)[nibArr objectAtIndex:0];
    }
    return cell;
}

- (IBAction)closeCertListView {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
@end
