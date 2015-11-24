//
//  CertificateListViewController.m
//  공인인증서 목록
//
//  Created by Infobank1 on 2015. 9. 15..
//  Copyright (c) 2015년 Infobank1. All rights reserved.
//

#import "CertificateListViewController.h"
#import "CertInfo.h"
#import "CertManager.h"
#import "CertLoader.h"
#import "CertInfoViewController.h"
#import "CertTableCell.h"

#define CERT_LIST_EMPTY     200

@interface CertificateListViewController ()

@end

@implementation CertificateListViewController

@synthesize mCertListTable;
@synthesize mCertControllArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mNaviView.mTitleLabel setText:@"공인인증센터"];
    [self.mNaviView.mMenuButton setHidden:YES];

    // 인증서 목록 로드
    mCertControllArray = [CertLoader getCertControlArray];
    
    // 인증서 삭제시 받을 노티피케이션
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCertList:) name:@"CertDeletedNotification" object:nil];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mCertListTable.frame.size.width, 0)];
    [mCertListTable setTableFooterView:footerView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([mCertControllArray count] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"안내" message:@"현재 저장된 인증서가 없습니다.\n인증서 가져오기를 진행해주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
        [alertView setTag:CERT_LIST_EMPTY];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCertList:(NSNotification *)notification
{
    mCertControllArray  = [CertLoader getCertControlArray];
    [mCertListTable reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mCertControllArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *reuseId = [NSString stringWithFormat:@"%@", [CertTableCell class]];
    CertTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [CertTableCell cell];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    CertInfo *info = [mCertControllArray objectAtIndex:indexPath.row];
    
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
    
    // 공인인증서 상세 화면으로 이동
    CertInfoViewController *vc = [[CertInfoViewController alloc] init];
    [vc setCertInfo:[mCertControllArray objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        switch ([alertView tag])
        {
            case CERT_LIST_EMPTY:
            {
                [self.navigationController popViewControllerAnimated:YES];
                break;
            }
                
            default:
                break;
        }
    }
}
@end
