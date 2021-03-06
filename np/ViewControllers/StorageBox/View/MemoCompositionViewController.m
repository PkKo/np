//
//  MemoComposityViewController.m
//  np
//
//  Created by Infobank2 on 9/23/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "MemoCompositionViewController.h"
#import "StorageBoxUtil.h"
#import "DBManager.h"
#import "MainPageViewController.h"
#import "HomeViewController.h"


@interface MemoCompositionViewController () {
    BOOL isNewMemo;
}

@end

@implementation MemoCompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [StorageBoxUtil getDimmedBackgroundColor];
    
    [self updateMemo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeComposer {
    [self removeComposer];
}

- (IBAction)removeComposer {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)saveToStorageBox {
    
    BOOL hasKeyboard = [self.memo isFirstResponder];
    
    if (hasKeyboard) {
        [self.memo resignFirstResponder];
    }
    
    [self.transactionObject setTransactionMemo:[self.memo text]];
    if (isNewMemo) {
        [[DBManager sharedInstance] saveTransaction:self.transactionObject];
    } else {
        [[DBManager sharedInstance] updateTransaction:self.transactionObject];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESH_BADGES object:nil];
    
    [self performSelector:@selector(showAlert) withObject:nil afterDelay: hasKeyboard ? 0.6 : 0.0];
    
}

- (void)showAlert {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"보관함에 저장되었습니다.\n보관함으로 이동하시겠습니까?"
                                                    delegate:self
                                           cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 1: // 확인
        {
            MainPageViewController *newTopViewController = [[MainPageViewController alloc] init];
            [newTopViewController setStartPageIndex:INBOX];
            
            [((MainPageViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).slidingViewController.topViewController) tabSelect:INBOX];
            break;
        }
        default:
            break;
    }
    
    [self removeComposer];
}

- (IBAction)shareSNS {
    StorageBoxUtil * util = [[StorageBoxUtil alloc] init];
    [util showSNSShareInViewController:self.parentViewController withTransationObject:self.transactionObject];
    
    [self removeComposer];
}

#pragma mark - database
- (void)updateMemo {
    
    [[[StorageBoxUtil alloc] init] updateTextFieldBorder:self.fakeMemo];
    
    NSString * memoStr = [[DBManager sharedInstance] findTransactionMemoById:self.transactionObject.transactionId];
    if (memoStr == nil) {
        isNewMemo = YES;
    } else {
        [self.memo setText:memoStr];
        isNewMemo = NO;
    }
}

#pragma mark - Keyboard
- (IBAction)validateTextEditing:(UITextField *)sender {
    if ([[sender text] length] > 10) {
        [sender setText:[[sender text] substringToIndex:10]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)onKeyboardShow:(NSNotification *)notifcation {
    CGFloat snsViewY    = 0;
    CGRect viewFrame    = self.view.frame;
    CGRect snsViewFrame = self.snsView.frame;
    CGFloat keyboardHeight;
    
    NSDictionary * keyboardInfo = [notifcation userInfo];
    NSValue * keyboardFrame     = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameRect    = [keyboardFrame CGRectValue];
    keyboardHeight              = keyboardFrameRect.size.height;
    
    CGPoint separatorInSubPos   = self.separator.frame.origin;
    CGPoint separatorInMainPos  = [self.snsWithoutCloseBtnView convertPoint:separatorInSubPos toView:self.snsView];
    
    snsViewY = viewFrame.size.height - (separatorInMainPos.y + keyboardHeight);
    snsViewY = snsViewY < 0 ? 0 : snsViewY;
    
    snsViewFrame.origin.y = snsViewY;
    [self.snsView setFrame:snsViewFrame];
}

- (void)onKeyboardHide:(NSNotification *)notifcation {
    
    CGRect viewFrame    = self.view.frame;
    CGRect snsViewFrame = self.snsView.frame;
    CGFloat snsViewY    = viewFrame.size.height - snsViewFrame.size.height;
    
    snsViewFrame.origin.y = snsViewY;
    [self.snsView setFrame:snsViewFrame];
    
}
@end
