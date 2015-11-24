//
//  MenuTableEtcView.h
//  np
//
//  Created by Infobank1 on 2015. 9. 22..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateButton.h"

@interface MenuTableEtcView : UIView

- (IBAction)gotoFarmerNews;
- (IBAction)gotoNotice;
- (IBAction)gotoFAQ;
- (IBAction)gotoTelEnquiry;

@property (strong, nonatomic) IBOutlet DelegateButton *nongminButton;
@property (strong, nonatomic) IBOutlet UILabel *nongminLabel;
@property (strong, nonatomic) IBOutlet DelegateButton *telButton;
@property (strong, nonatomic) IBOutlet UILabel *telLabel;
@property (strong, nonatomic) IBOutlet DelegateButton *faqButton;
@property (strong, nonatomic) IBOutlet UILabel *faqLabel;
@property (strong, nonatomic) IBOutlet DelegateButton *noticeButton;
@property (strong, nonatomic) IBOutlet UILabel *noticeLabel;
@end
