//
//  EccEncryptor.h
//  nFilterModuleBasic
//
//  Created by 발팀 개 on 10. 3. 11..
//  Copyright 2010 NSHC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EccEncryptor : NSObject {
	
	NSData *_publicKeyOfMine;
	NSData *_privateKeyOfMine;
	NSData *_sharedKey;
	NSData *_sharedKey2;	
	NSMutableData *_rcvPublicKeyDataFromServer;
    
	NSArray *_arrKeyNum;
	NSArray *_arrKeyNum2;
}

+ (EccEncryptor *)sharedInstance;

- (NSArray *)makeGapWithKeypads:(NSInteger)pSeed
					   gapCount:(NSInteger)pGapCount widthPixel:(NSInteger)pWidthPixel;

- (void)setServerPublickeyURL:(NSString *)pXmlURL;
- (void)setServerPublickey:(NSString *)pServerPublickey;
- (void)makeSharedKey;

- (NSString *)makeEncWithPadding:(NSData *)pPlainText;
- (NSString *)makeEncWithPadding2:(NSMutableArray *)pPlainText;
- (NSString *)makeEncWithPadding3:(NSMutableArray *)pPlainText;
- (NSString *)makeEncNoPadding:(NSData *)pPlainText;
- (NSString *)makeEncNoPadding2:(NSMutableArray *)pPlainText;
- (NSString *)makeEncPadding:(NSData *)pPlainText;
- (NSString *)makeEncPadding2:(NSMutableArray *)pPlainText;
- (NSString *)makeDecNoPadWithSeedkey:(NSString *)pPlainText;
- (NSString *)makeEncNoPadWithSeedkey2:(NSMutableArray *)pPlainText;
- (NSString *)makeEncNoPadWithSeedkey3:(NSMutableArray *)pPlainText;

- (NSArray *)getKeypadArray;
- (NSArray *)getKeypadArray2;
- (NSArray *)getKeypadArray:(NSData *)pSeedKey;
- (NSArray *)Permutation:(int)maxsize;

- (void)getSeedKeyNClientPublickeyWithServerPublickey:(NSString *)pServerPublicKey
                                      ClientPublickey:(NSString **)vClientPublickey SeedKey:(NSData **)vSeedKey;
- (void)getSeedKeyNClientPublickeyWithServerPublickeyURL:(NSString *)pServerPublicKeyURL
                                         ClientPublickey:(NSString **)vClientPublickey SeedKey:(NSData **)vSeedKey;

- (NSString *)makeEncNoPadWithSeedkey:(NSData *)pPlainText;
- (NSString *)makeEncNoPadWithSeedkey:(NSData *)pPlainText seedKey:(NSData *)pSeedKey;
- (NSString *)makeEncPadWithSeedKey:(NSData *)pPlainText seedKey:(NSData *)pSeedKey;

- (NSInteger)getRandNum:(NSData *)pSeedKey;
- (NSInteger)getRandNum;

- (NSData *) encyptWithAES:(NSData *)pPlainText pubkey:(NSString*)pPubkey;
- (NSData *) encyptWithAES2:(NSMutableArray *)pPlainText pubkey:(NSString*)pPubkey;
- (NSString *)genKey:(NSString *)pubKey;
- (NSString *) getIV:(NSString*)val;
@end
