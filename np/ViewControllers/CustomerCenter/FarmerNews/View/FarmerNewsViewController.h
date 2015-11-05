//
//  FarmerNewsViewController.h
//  np
//
//  Created by Infobank2 on 11/4/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "ArticleTableViewCell.h"

@interface FarmerNewsViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, ArticleTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *articleTableView;

@end
