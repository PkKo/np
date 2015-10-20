//
//  CertListViewController.h
//  np
//
//  Created by Infobank2 on 10/14/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * certificates; // array of CertInfo
- (void)addTargetForCloseBtn:(id)target action:(SEL)action;

@property (weak, nonatomic) IBOutlet UITableView *certTableView;
- (IBAction)closeCertListView;

@end
