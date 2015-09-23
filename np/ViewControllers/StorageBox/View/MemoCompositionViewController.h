//
//  MemoComposityViewController.h
//  np
//
//  Created by Infobank2 on 9/23/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionObject.h"
#import "TransactionObject.h"

@interface MemoCompositionViewController : UIViewController

@property (nonatomic) TransactionObject *transactionObject;

- (IBAction)removeComposer;
- (IBAction)saveToStorageBox;
- (IBAction)shareSNS;


@end
