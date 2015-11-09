//
//  HomeEtcDetailViewController.h
//  np
//
//  Created by Infobank1 on 2015. 11. 9..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "CommonViewController.h"

@interface HomeEtcDetailViewController : CommonViewController<IBInboxProtocol>

@property (strong, nonatomic) NHInboxMessageData *inboxData;
@end
