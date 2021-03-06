//
//  ArticleTableViewCell.h
//  np
//
//  Created by Phuong Nhi Dang on 11/5/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArticleTableViewCellDelegate <NSObject>

- (void)showDetails:(BOOL)isShown ofDetailsView:(UIView *)detailsView;

@end


@interface ArticleTableViewCell : UITableViewCell

@property (weak) id<ArticleTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView     * headlineView;
@property (weak, nonatomic) IBOutlet UIView     * detailsView;
@property (weak, nonatomic) IBOutlet UIView     * footerView;

@property (weak, nonatomic) IBOutlet UILabel        * regDate;
@property (weak, nonatomic) IBOutlet UILabel        * headline;
@property (weak, nonatomic) IBOutlet UILabel        * subject;
@property (weak, nonatomic) IBOutlet UIImageView    * imgOpen;
@property (weak, nonatomic) IBOutlet UIImageView    * imgClose;

@property (weak, nonatomic) IBOutlet UILabel        * rowSeparator;
@property (weak, nonatomic) IBOutlet UILabel        * contents;
@property (weak, nonatomic) IBOutlet UIImageView    * photo;

- (IBAction)toggleDetails:(UITapGestureRecognizer *)sender;
- (IBAction)closeDetails:(UITapGestureRecognizer *)sender;

- (void)updateSubject:(NSString *)subject;
- (void)updateDetails:(NSString *)details;
- (void)hideDetailsView:(BOOL)isHidden;
@end
