//
//  CertificateMenuViewController.h
//  mp
//
//  Created by Infobank1 on 2015. 9. 9..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface CertificateMenuViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *mCertMenuArray;
    CGFloat cellHeight;
}

@property (strong, nonatomic) IBOutlet UITableView *mCertMenuTableView;
@end
