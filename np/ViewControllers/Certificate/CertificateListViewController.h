//
//  CertificateListViewController.h
//  np
//
//  Created by Infobank1 on 2015. 9. 15..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface CertificateListViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mCertListTable;
@property (strong, nonatomic) NSMutableArray *mCertControllArray;
@end
