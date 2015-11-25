//
//  HomeEtcDetailViewController.h
//  np
//
//  Created by Infobank1 on 2015. 11. 9..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface HomeEtcDetailViewController : CommonViewController<IBInboxProtocol, UIScrollViewDelegate>
{
    NSString *contentKey;
    NSString *linkUrl;
    NSMutableArray *imgUrl;
}

@property (strong, nonatomic) NHInboxMessageData *inboxData;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *contentDate;
@property (strong, nonatomic) IBOutlet UILabel *contentTitle;
@property (strong, nonatomic) IBOutlet UILabel *contentText;
@property (strong, nonatomic) IBOutlet UIButton *contentLinkButton;
@property (strong, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *imgPageControl;

- (IBAction)linkActionClick:(id)sender;
- (IBAction)changePage:(id)sender;
@end
