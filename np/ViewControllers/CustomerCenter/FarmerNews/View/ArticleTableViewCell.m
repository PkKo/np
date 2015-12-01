//
//  ArticleTableViewCell.m
//  np
//
//  Created by Phuong Nhi Dang on 11/5/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "ArticleTableViewCell.h"
#import "StorageBoxUtil.h"

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
    
    CGFloat screenWidth             = [[UIScreen mainScreen] bounds].size.width;
    
    self.subject.text       = subject;
    CGRect subjectFrame     = self.subject.frame;
    CGFloat subjectWidth    = screenWidth - (subjectFrame.origin.x + (screenWidth - self.imgOpen.frame.origin.x));
    subjectFrame.size.width = subjectWidth;
    [self.subject setFrame:subjectFrame];
    [self.subject sizeToFit];
    
    subjectFrame.size.height= self.subject.frame.size.height;
    [self.subject setFrame:subjectFrame];
    
    CGRect headlineViewFrame        = self.headlineView.frame;
    headlineViewFrame.size.height   = subjectFrame.origin.y + subjectFrame.size.height + 22;
    
    [self.headlineView setFrame:headlineViewFrame];
}

- (void )updateDetails:(NSString *)details {
    
    details = [details stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br>"];
    details = [details stringByReplacingOccurrencesOfString:@"[b]" withString:@"<b>"];
    details = [details stringByReplacingOccurrencesOfString:@"[/b]" withString:@"</b>"];
    
    details = [NSString stringWithFormat:@"<html>"
     "  <head>"
     "    <style type='text/css'>"
     "      body { font-size: 11pt; color: #60616D; text-align: justify; }"
     "    </style>"
     "  </head>"
     "  <body>%@</body>"
     "</html>", details];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[details dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    self.contents.attributedText= attributedString;
    
    CGFloat screenWidth         = [[UIScreen mainScreen] bounds].size.width;
    CGRect contentsFrame        = self.contents.frame;
    CGFloat contentsWidth       = screenWidth - (contentsFrame.origin.x * 2);
    contentsFrame.size.width    = contentsWidth;
    [self.contents setFrame:contentsFrame];
    [self.contents sizeToFit];
    contentsFrame.size.height   = self.contents.frame.size.height;
    contentsFrame.origin.y      = self.photo.isHidden ? 20 : self.photo.frame.origin.y + self.photo.frame.size.height + 20;
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
