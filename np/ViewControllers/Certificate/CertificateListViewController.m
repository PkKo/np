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

#define CERT_LIST_EMPTY     200

@interface CertificateListViewController ()

@end

@implementation CertificateListViewController

@synthesize mCertListTable;
@synthesize mCertControllArray;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 인증서 목록 로드
    mCertControllArray = [CertLoader getCertControlArray];
    
    // 인증서 삭제시 받을 노티피케이션
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCertList:) name:@"CertDeletedNotification" object:nil];
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CertInfo *certInfo = [mCertControllArray objectAtIndex:indexPath.row];

    return nil;
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
