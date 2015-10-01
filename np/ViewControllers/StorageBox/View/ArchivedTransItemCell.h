//
//  ArchivedTransItemCell.h
//  np
//
//  Created by Infobank2 on 9/30/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchivedTransItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView    * transacTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel        * transacTime;
@property (weak, nonatomic) IBOutlet UILabel        * transacName;
@property (weak, nonatomic) IBOutlet UILabel        * transacAmount;
@property (weak, nonatomic) IBOutlet UILabel        * transacAccountNo;
@property (weak, nonatomic) IBOutlet UILabel        * transacBalance;
@property (weak, nonatomic) IBOutlet UITextField    * transacMemo;

- (IBAction)editMemo;

@end
