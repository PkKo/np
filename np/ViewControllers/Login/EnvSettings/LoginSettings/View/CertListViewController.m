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
#import "LoginCertController.h"
#import "StatisticMainUtil.h"
#import "LoginUtil.h"

@interface CertListViewController ()
@property (nonatomic, assign) id closeBtnTarget;
@property (nonatomic, assign) SEL closeBtnAction;

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
    
    return [self.certificates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CertViewCell";
    
    CertViewCell *cell = (CertViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"CertViewCell" owner:self options:nil];
        cell            = (CertViewCell *)[nibArr objectAtIndex:0];
    }
    
    CertInfo * certInfo = [self.certificates objectAtIndex:[indexPath row]];
    
    NSDateFormatter * formatter = [StatisticMainUtil getDateFormatterWithStyle:@"yyyy/MM/dd"];
    cell.certName.text      = [certInfo.subjectDN2 substringFromIndex:3];
    cell.certIssuer.text    = certInfo.issuer;
    cell.certType.text      = certInfo.policy;
    cell.issueDate.text     = [formatter stringFromDate:certInfo.dtNotBefore];
    cell.expiryDate.text    = [formatter stringFromDate:certInfo.dtNotAfter];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CertInfo * selectedCert = (CertInfo *)[self.certificates objectAtIndex:[indexPath row]];
    
    [[[LoginUtil alloc] init] saveCertToLogin:selectedCert];
    
    if (self.closeBtnTarget) {
        [self.closeBtnTarget performSelector:self.closeBtnAction withObject:selectedCert afterDelay:0];
    }
    
    [self closeCertListView];
}

#pragma mark - Close View
- (IBAction)closeCertListView {
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)addTargetForCloseBtn:(id)target action:(SEL)action {
    self.closeBtnTarget = target;
    self.closeBtnAction = action;
}
@end
