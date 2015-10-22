//
//  RegistCertListView.m
//  np
//
//  Created by Infobank1 on 2015. 9. 23..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "RegistCertListView.h"
#import "CertTableCell.h"

@implementation RegistCertListView

@synthesize viewDelegate;
@synthesize certTableView;
@synthesize certControllArray;

- (void)initCertList
{
    // 인증서 목록 로드
    certControllArray = [CertLoader getCertControlArray];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, certTableView.frame.size.width, 0)];
    [certTableView setTableFooterView:footerView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [certControllArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseId = [NSString stringWithFormat:@"%@", [CertTableCell class]];
    CertTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [CertTableCell cell];
    }
    
    CertInfo *info = [certControllArray objectAtIndex:indexPath.row];
    
    // 사용자명
    NSString *name = nil;
    
    NSArray *subjectDN2 = [info.subjectDN2 componentsSeparatedByString:@","];
    if([subjectDN2 count] > 0)
    {
        NSArray *dnName = [[subjectDN2 objectAtIndex:0] componentsSeparatedByString:@"="];
        if([dnName count] > 1)
        {
            name = [dnName objectAtIndex:1];
        }
    }
    
    if(name == nil)
    {
        name = info.subjectCN;
    }
    [cell.nameLabel setText:name];
    
    // 발급자
    [cell.issuerLabel setText:info.issuer];
    
    // 구분
    [cell.policyLabel setText:info.policy];
    
    // 만료일자
    [cell.notAfterLabel setText:info.notAfter];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(viewDelegate != nil && [viewDelegate respondsToSelector:@selector(certInfoSelected:)])
    {
        [viewDelegate performSelector:@selector(certInfoSelected:) withObject:[certControllArray objectAtIndex:indexPath.row]];
    }
}
@end
