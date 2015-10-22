//
//  RegistCertListView.h
//  np
//
//  Created by Infobank1 on 2015. 9. 23..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CertInfo.h"
#import "CertManager.h"
#import "CertLoader.h"

@protocol RegistCertListDelegate <NSObject>

- (void)certInfoSelected:(CertInfo *)certInfo;
@end

@interface RegistCertListView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id<RegistCertListDelegate> viewDelegate;
@property (strong, nonatomic) IBOutlet UITableView *certTableView;
@property (strong, nonatomic) NSMutableArray *certControllArray;

- (void)initCertList;
@end
