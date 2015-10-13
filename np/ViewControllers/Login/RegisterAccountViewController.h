//
//  RegisterAccountViewController.h
//  np
//
//  Created by Infobank1 on 2015. 10. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"
#import "RegistAccountAllListView.h"

@interface RegisterAccountViewController : CommonViewController
{
    BOOL isCertMode;
    RegistAccountAllListView *allListView;
    NSMutableArray *allAccountList;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (IBAction)nextButtonClick:(id)sender;
@end
