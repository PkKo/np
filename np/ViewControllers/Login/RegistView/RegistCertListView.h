//
//  RegistCertListView.h
//  np
//
//  Created by Infobank1 on 2015. 9. 23..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistCertListView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id viewDelegate;
@property (strong, nonatomic) IBOutlet UITableView *certTableView;
@property (strong, nonatomic) NSMutableArray *certControllArray;

- (void)initCertList;
@end
