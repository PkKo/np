//
//  HomeEtcDetailViewController.m
//  np
//
//  Created by Infobank1 on 2015. 11. 9..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "HomeEtcDetailViewController.h"
#import "LoadingImageView.h"

@interface HomeEtcDetailViewController ()

@end

@implementation HomeEtcDetailViewController

@synthesize inboxData;
@synthesize scrollView;
@synthesize contentView;
@synthesize contentDate;
@synthesize contentTitle;
@synthesize contentText;
@synthesize contentLinkButton;
@synthesize imgScrollView;
@synthesize imgPageControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mNaviView.mTitleLabel setText:@"상세보기"];
    
    imgUrl = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(inboxData != nil)
    {
        [self startIndicator];
        [IBInbox loadWithListener:self];
        [IBInbox requestInboxSingMessage:inboxData.serverMessageKey];
    }
}

- (void)setImageView
{
    if(imgUrl == nil || [imgUrl count] == 0)
    {
        [imgScrollView setHidden:YES];
        [imgPageControl setHidden:YES];
        [contentView setFrame:CGRectMake(contentView.frame.origin.x, imgScrollView.frame.origin.y,
                                         contentView.frame.size.width,
                                         contentView.frame.size.height)];
    }
    else
    {
        [imgScrollView setHidden:NO];
        [imgPageControl setHidden:NO];
        [imgPageControl setNumberOfPages:[imgUrl count]];
        CGFloat numberOfPages       = imgPageControl.numberOfPages;
        CGFloat scrollViewWith      = imgScrollView.frame.size.width;
        CGFloat scrollViewHeight    = imgScrollView.frame.size.height;
        
        self.imgScrollView.contentSize = CGSizeMake(scrollViewWith * numberOfPages, scrollViewHeight);
        
        for (int pageIndex = 0; pageIndex < numberOfPages; pageIndex++)
        {
            LoadingImageView * page = [[LoadingImageView alloc] initWithFrame:CGRectMake(scrollViewWith * pageIndex, 0, scrollViewWith, scrollViewHeight)];
            [self getImageInBackground:page url:[imgUrl objectAtIndex:pageIndex]];
            /*
            UIWebView *webPage = [[UIWebView alloc] initWithFrame:CGRectMake(scrollViewWith * pageIndex, 0, scrollViewWith, scrollViewHeight)];
            [webPage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[imgUrl objectAtIndex:pageIndex]]]];
            [webPage setScalesPageToFit:YES];
            [webPage.scrollView setScrollEnabled:NO];*/
            [self.imgScrollView addSubview:page];
        }
    }
    
    [contentDate setText:[CommonUtil getDateString:[NSDate dateWithTimeIntervalSince1970:(inboxData.regDate / 1000)]]];
    [contentTitle setText:inboxData.title];
    [contentText setText:inboxData.text];
    [contentText sizeToFit];
    
    CGSize contentSize = CGSizeMake(contentView.frame.size.width, contentView.frame.origin.y + contentText.frame.origin.y + contentText.frame.size.height);
    [scrollView setContentSize:contentSize];
    [scrollView setContentInset:UIEdgeInsetsZero];
}

- (void)getImageInBackground:(LoadingImageView *)imageView url:(NSString *)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        [imageView startLoadingAnimation];
        UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            if(downloadedImage)
            {
                [imageView stopLoadingAnimation];
                [imageView setImage:downloadedImage];
            }
        });
    });
}

#pragma mark - IBInboxProtocol Delegate
- (void)loadingInboxList
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)inboxLoadFailed:(int)responseCode
{
    [self stopIndicator];
    NSLog(@"%s", __FUNCTION__);
}

- (void)loadedContents:(BOOL)success contents:(ContentsData *)contents
{
    NSLog(@"%s, content = %@", __FUNCTION__, contents);
    [self stopIndicator];
    if(contents != nil)
    {
        for (ContentsPayload *payload in contents.payloadList)
        {
            if([payload.key isEqualToString:@"img"] && [payload.value length] > 0)
            {
                NSArray *imgUrlArray = [payload.value componentsSeparatedByString:@","];
                for(NSString *imgUrlString in imgUrlArray)
                {
                    [imgUrl addObject:[NSString stringWithFormat:@"%@%@", IPNS_INBOX_IMAGE, imgUrlString]];
                }
            }
        }
    }
    
    // 이미지 세팅
    [self setImageView];
}

- (void)loadedInboxList:(BOOL)success messageList:(NSArray *)messageList
{
    NSLog(@"%s, message = %@", __FUNCTION__, messageList);
}

- (void)loadedSingleMessage:(BOOL)success message:(InboxMessageData *)message
{
    NSLog(@"%s, message = %@", __FUNCTION__, message);
    if(success)
    {
        for (ContentsPayload *payload in message.payloadList)
        {
            if([payload.key isEqualToString:@"mck"])
            {
                contentKey = payload.value;
            }
            else if([payload.key isEqualToString:@"lu"])
            {
                linkUrl = payload.value;
                [contentLinkButton setHidden:NO];
            }
            else if([payload.key isEqualToString:@"vi"] && [payload.value length] > 0)
            {
                [imgUrl addObject:[NSString stringWithFormat:@"%@%@", IPNS_INBOX_IMAGE, payload.value]];
            }
        }
        
        if(contentKey != nil && [contentKey length] > 0)
        {
            [IBInbox requestContents:contentKey];
        }
        else
        {
            [self stopIndicator];
            [self setImageView];
        }
    }
    else
    {
        [self stopIndicator];
    }
}

/**
 @brief 외부 링크로 이동
 */
- (IBAction)linkActionClick:(id)sender
{
    if(linkUrl != nil && [linkUrl length] > 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkUrl]];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setIndicatorForCurrentPage];
    [self changePage:nil];
}

- (IBAction)changePage:(id)sender
{
    CGFloat scrollViewWith      = self.imgScrollView.frame.size.width;
    CGFloat scrollViewHeight    = self.imgScrollView.frame.size.height;
    CGFloat scrollViewY         = self.imgScrollView.frame.origin.y;
    
    [self.imgScrollView scrollRectToVisible:CGRectMake(scrollViewWith * self.imgPageControl.currentPage, scrollViewY, scrollViewWith, scrollViewHeight) animated:YES];
}

- (void)setIndicatorForCurrentPage {
    CGFloat scrollViewWith  = self.imgScrollView.frame.size.width;
    float pagePos           =  self.imgScrollView.contentOffset.x * 1.0f  / scrollViewWith;
    [self.imgPageControl setCurrentPage:round(pagePos)];
}
@end
