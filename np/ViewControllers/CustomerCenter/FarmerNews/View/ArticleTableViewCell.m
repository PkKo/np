//
//  ArticleTableViewCell.m
//  np
//
//  Created by Phuong Nhi Dang on 11/5/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ArticleTableViewCell.h"

@implementation ArticleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toggleDetails:(UITapGestureRecognizer *)sender {
    [_delegate showDetails:self.detailsView.isHidden ofDetailsView:self.detailsView];
}

- (IBAction)closeDetails:(UITapGestureRecognizer *)sender {
    [_delegate showDetails:NO ofDetailsView:self.detailsView];
}

- (void)hideDetailsView:(BOOL)isHidden {
    [self.headline setHidden:!isHidden];
    [self.subject setHidden:isHidden];
    [self.detailsView setHidden:isHidden];
    [self.rowSeparator setHidden:!isHidden];
    
    [self.imgOpen setHidden:!isHidden];
    [self.imgClose setHidden:isHidden];
}

- (void)updateSubject:(NSString *)subject {
    
    [self.subject setSelectable:YES];
    [self.subject setFont:[UIFont systemFontOfSize:16]];
    self.subject.text = subject;
    [self.subject setSelectable:NO];
    /*
    [self.subject sizeToFit];
    [self.subject layoutIfNeeded];
    
    CGRect headlineViewFrame    = self.headlineView.frame;
    CGSize headlineViewSize     = self.headlineView.frame.size;
    headlineViewSize.height     = self.subject.frame.size.height + self.regDate.frame.size.height;
    
    NSLog(@"\n\n======>self.subject.frame: %@", NSStringFromCGRect(self.subject.frame));
    NSLog(@"headlineViewSize: %@\n\n", NSStringFromCGSize(headlineViewSize));
    
    [self.headlineView setFrame:headlineViewFrame];
     */
}

- (void )updateDetails:(NSString *)details {
    
    //NSLog(@"original details: %@", details);
    
    [self.contents setSelectable:YES];
    
    details = [details stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br>"];
    details = [details stringByReplacingOccurrencesOfString:@"[b]" withString:@"<b>"];
    details = [details stringByReplacingOccurrencesOfString:@"[/b]" withString:@"</b>"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[details dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [self.contents setFont:[UIFont systemFontOfSize:14]];
    [self.contents setTextColor:[UIColor colorWithRed:96.0f/255.0f green:97.0f/255.0f blue:109.0f/255.0f alpha:1]];
    [self.contents setTextAlignment:NSTextAlignmentJustified];
    
    [self.contents setSelectable:NO];
    
    [self.contents sizeToFit];
    [self.contents layoutIfNeeded];
    
    CGRect contentsFrame    = self.contents.frame;
    contentsFrame.origin.y  = self.photo.isHidden ? 0 : self.photo.frame.size.height + 20;
    [self.contents setFrame:contentsFrame];
    
    CGRect footerViewFrame      = self.footerView.frame;
    footerViewFrame.origin.y    = contentsFrame.origin.y + contentsFrame.size.height + 20;
    [self.footerView setFrame:footerViewFrame];
    
    CGSize detailsViewSize = self.detailsView.frame.size;
    detailsViewSize.height = footerViewFrame.origin.y + footerViewFrame.size.height;
    
    CGRect detailsViewFrame     = self.detailsView.frame;
    detailsViewFrame.origin.y   = self.headlineView.frame.size.height;
    detailsViewFrame.size       = detailsViewSize;
    [self.detailsView setFrame:detailsViewFrame];
    
    [self resizeCellToFitContent];
}

- (void)resizeCellToFitContent {
    
    CGRect cellFrame = self.frame;
    CGSize cellSize = self.frame.size;
    cellSize.height = self.headlineView.frame.size.height + self.detailsView.frame.size.height;
    
    cellFrame.size = cellSize;
    
    [self setFrame:cellFrame];
}

@end
