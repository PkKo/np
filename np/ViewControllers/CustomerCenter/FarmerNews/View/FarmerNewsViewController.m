//
//  FarmerNewsViewController.m
//  np
//
//  Created by Infobank2 on 11/4/15.
//  Copyright © 2015 Infobank1. All rights reserved.
//

#import "FarmerNewsViewController.h"
#import "ArticleObject.h"

@interface FarmerNewsViewController () {
    NSArray * articles;
    int _prvSltedRow;
    ArticleTableViewCell * openCell;
}

@end

@implementation FarmerNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"%s", __func__);
    [self startIndicator];
    
    _prvSltedRow = -1;
    
    [self.mNaviView.mBackButton setHidden:NO];
    [self.mNaviView.mTitleLabel setText:@"농민뉴스"];
    articles = [[NSArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"%s", __func__);
    [self requestNongminNews];
    [self.articleTableView reloadData];
    [self stopIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data Parsing

- (void)requestNongminNews {
    
    CFStringEncoding encoding = (CFStringEncoding)CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);//
    
    NSString * dataString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.nongmin.com/xml/ar_xml_nh.htm"] encoding:encoding error:nil];
    
    NSRange  range;
    NSString * element;
    
    NSRange subRangeStart;
    NSRange subRangeEnd;
    int     startLocation;
    int     elementLength;
    
    NSMutableArray * _articles = [NSMutableArray array];
    
    do {
        range = [dataString rangeOfString:@"<article>"];
        
        if (range.location == NSNotFound) {
            break;
        }
        
        ArticleObject * article = [[ArticleObject alloc] init];
        
        //subject
        element         = @"<subject><![CDATA[";
        subRangeStart   = [dataString rangeOfString:element];
        subRangeEnd     = [dataString rangeOfString:@"]]></subject>"];
        
        startLocation   = (int)subRangeStart.location + (int)element.length;
        elementLength   = (int)subRangeEnd.location - startLocation;
        article.subject = [NSString stringWithFormat:@"%@", [dataString substringWithRange:NSMakeRange(startLocation, elementLength)]];
        
        // regDate
        element         = @"<reg-date>";
        subRangeStart   = [dataString rangeOfString:element];
        subRangeEnd     = [dataString rangeOfString:@"</reg-date>"];
        
        startLocation   = (int)subRangeStart.location + (int)element.length;
        elementLength   = (int)subRangeEnd.location - startLocation;
        article.regDate = [[NSString stringWithFormat:@"%@", [dataString substringWithRange:NSMakeRange(startLocation, elementLength)]] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        
        //contents
        element         = @"<contents><![CDATA[";
        subRangeStart   = [dataString rangeOfString:element];
        subRangeEnd     = [dataString rangeOfString:@"]]></contents>"];
        
        startLocation   = (int)subRangeStart.location + (int)element.length;
        elementLength   = (int)subRangeEnd.location - startLocation;
        article.contents= [NSString stringWithFormat:@"%@", [dataString substringWithRange:NSMakeRange(startLocation, elementLength)]];
        
        //imagePath
        element         = @"<img-path>";
        subRangeStart   = [dataString rangeOfString:element];
        subRangeEnd     = [dataString rangeOfString:@"</img-path>"];
        
        startLocation   = (int)subRangeStart.location + (int)element.length;
        elementLength   = (int)subRangeEnd.location - startLocation;
        if (startLocation < subRangeEnd.location) {
            article.imgPath= [NSString stringWithFormat:@"%@", [dataString substringWithRange:NSMakeRange(startLocation, elementLength)]];
        }
        
        [article setIsDetailsShown:NO];

        
        [_articles addObject:article];
        
        range = [dataString rangeOfString:@"</article>"];
        
        dataString = [dataString substringFromIndex:range.location + @"</article>".length];
    } while (YES);
    
    articles = [_articles copy];
}

#pragma mark - UITableViewDataSource Protocol
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"MyArticleTableViewCell";
    
    ArticleTableViewCell *cell = (ArticleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    ArticleObject * article;
    
    if (cell == nil) {
        NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"ArticleTableViewCell" owner:self options:nil];
        cell            = (ArticleTableViewCell *)[nibArr objectAtIndex:0];
        
    }
    cell.delegate           = self;
    article                 = [articles objectAtIndex:[indexPath row]];
    cell.regDate.text       = article.regDate;
    cell.headline.text      = article.subject;
    
    if (article.isDetailsShown) {
        
        if (article.imgPath) {
            [cell.photo setHidden:NO];
            
            //NSLog(@"\n\n------->article.imgPath: %@", article.imgPath);
            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:article.imgPath]]];
            //NSLog(@"image   : %@", NSStringFromCGSize(image.size)) ;
            
            CGSize scaledPhotoSize  = [self scaleImage:image toSize:CGSizeMake(284, 166)];
            CGRect photoFrame       = cell.photo.frame;
            photoFrame.size         = scaledPhotoSize;
            [cell.photo setFrame:photoFrame];
            [cell.photo setImage:image];
            
            //[cell.photo setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:article.imgPath]]]];
        } else {
            [cell.photo setHidden:YES];
        }
        
        [cell updateSubject:article.subject];
        [cell updateDetails:article.contents];
        article.cellSize        = cell.frame.size;
    }
    
    [cell hideDetailsView:!article.isDetailsShown];
    
    return cell;
}

- (CGSize)scaleImage:(UIImage *)image toSize: (CGSize)size {
    
    float newHeight = size.width / image.size.width * image.size.height;
    //NSLog(@"size: %@", NSStringFromCGSize(CGSizeMake(size.width, newHeight)));
    return CGSizeMake(size.width, newHeight);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (openCell) {
        if (indexPath.row == _prvSltedRow) {
            return ((ArticleObject *)[articles objectAtIndex:indexPath.row]).cellSize.height;
        }
    }
    
    return 77;
    
}

#pragma mark - Details
- (void)showDetails:(BOOL)isShown ofDetailsView:(UIView *)detailsView {
    
    [self startIndicator];
    [self performSelector:@selector(showDetails:) withObject:@[[NSNumber numberWithBool:isShown], detailsView] afterDelay:0.07];
}

- (void)showDetails:(NSArray *)detailsViewInfo {
    
    BOOL    isShown         = [(NSNumber *)[detailsViewInfo objectAtIndex:0] boolValue];
    UIView * detailsView    = (UIView *)[detailsViewInfo objectAtIndex:1];
    NSIndexPath * selectedIndexPath;
    
    for (ArticleObject * article in articles) {
        [article setIsDetailsShown:NO];
    }
    
    if (openCell) {
        [openCell hideDetailsView:YES];
        openCell = nil;
        [self stopIndicator];
    }
    
    if (isShown) {
        
        if ([detailsView.superview.superview isKindOfClass:[ArticleTableViewCell class]]) {
            
            ArticleTableViewCell * cell     = (ArticleTableViewCell*)detailsView.superview.superview;
            NSIndexPath     * indexPath     = [self.articleTableView indexPathForCell:cell];
            
            ArticleObject * selectedArticle = [articles objectAtIndex:indexPath.row];
            [selectedArticle setIsDetailsShown:YES];
            
            openCell            = cell;
            _prvSltedRow        = (int)indexPath.row;
            selectedIndexPath   = indexPath;
        }
    }
    
    
    
    [self.articleTableView reloadData];
    
    if (isShown && selectedIndexPath) {
        
        __weak FarmerNewsViewController *me = self;
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [me.articleTableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } completion:^(BOOL finished) {
            [self stopIndicator];
        }];
    }
}

@end
