//
//  EccEncryptor.m
//  nFilterModuleBasic
//
//  Created by 발팀 개 on 10. 3. 11..
//  Copyright 2010 NSHC. All rights reserved.
//

#import "EccEncryptor.h"
#import "PublicKeyDownloader.h"
#import "NSDataKNAdditions.h"
#import "NSStringKNAdditions.h"
#import "KNStringutil.h"
#import "ns_api.h"
#import "nperm.h"
#import "NSData+AESCrypt.h"
#import <CommonCrypto/CommonDigest.h>

static EccEncryptor *instance = nil;
@implementation EccEncryptor

+ (EccEncryptor *)sharedInstance {
    
	if (instance == nil) {
		instance = [[EccEncryptor alloc] init];
	}
	return instance;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        _publicKeyOfMine = [[NSData alloc] init];
        _privateKeyOfMine = [[NSData alloc] init];
        _sharedKey = [[NSData alloc] init];
        _rcvPublicKeyDataFromServer = [[NSMutableData alloc] init];
		_sharedKey2 = [[NSData alloc] init];
		[self generateSharedKey2];
    }
    
	return self;
}

// 시드와 넓이를 주면서 몇개로 나눠달라는 값을 준다
- (NSArray *)makeGapWithKeypads:(NSInteger)pSeed
					   gapCount:(NSInteger)pGapCount widthPixel:(NSInteger)pWidthPixel {
//	NS_RV   ret;
	NSString *strSeed = [[NSString alloc] initWithFormat:@"1234%ld6789", (long)pSeed];
	unsigned char *chrSeed = (unsigned char *) [strSeed UTF8String];
	unsigned char *chrArray;
	unsigned int arrLen = 0;
	
	NSMutableArray *arrNums = [[NSMutableArray alloc] initWithCapacity:20];
	NM_GenKeyGapString(chrSeed, (int)[strSeed length], (int)pGapCount, (int)pWidthPixel, &chrArray, &arrLen);
	
	{
		int i=0;
		for (i=0;i<arrLen;i++)
		{
			//printf("%d,",chrArray[i]);
			NSString *strNum = [NSString stringWithFormat:@"%d", chrArray[i]];
			//NSLog(@"INDEX: %@, VALUE: %@", strIndex,  strNum);
			[arrNums addObject:strNum];
		}
	}
	
	N_FreeGapString(chrArray, arrLen);
	return	arrNums;
}

- (void)setServerPublickeyURL:(NSString *)pXmlURL {
	PublicKeyDownloader *pd = [PublicKeyDownloader sharedInstance];
	[pd setServerPublickeyURL:pXmlURL];
    [self makeSharedKey];
}

- (void)setServerPublickey:(NSString *)pServerPublickey {
	PublicKeyDownloader *pd = [PublicKeyDownloader sharedInstance];
	[pd setServerPublickey:pServerPublickey];
    [self makeSharedKey];
}

- (void)makeSharedKey {
	//NSLog(@"MAKE SHARED KEY START");
	// 서버의 공개키 가져오기
	PublicKeyDownloader *pd = [PublicKeyDownloader sharedInstance];
	NSString *strPubkeyBase64 = [pd getServerPubkey];
	//NSLog(@"서버 공개키: %@", strPubkeyBase64);
	
	//_rcvPublicKeyDataFromServer = [[NSData alloc] initWithBase64EncodedString:strPubkeyBase64];
    _rcvPublicKeyDataFromServer = [[NSMutableData alloc] initWithBase64EncodedString:strPubkeyBase64];
	
	// 1. 나의 공개키와 개인키를 만든다
	NS_ULONG ecp_id = NSF_WTLS_EC_3,
    kg_type = NSO_CTX_EC_KEYPAIR_GEN,
    prk_type = NSO_PRIVATE_KEY,
    puk_type = NSO_PUBLIC_KEY,
    kdrv_type = NSO_CTX_ECDH_DERIVE,
    skey_type = NSO_SECRET_KEY,
    ecpt_type = NSF_ECPT_COMPRESS;
	
	NS_CONTEXT keygenctx = {
		{NSA_OBJECT_TYPE, &kg_type, 0, FALSE, FALSE},
		{NSA_EC_NUMBER,
			&ecp_id, sizeof(ecp_id), FALSE, FALSE},
		{NSA_ECPT_FORM,
			&ecpt_type, sizeof(ecpt_type), FALSE, FALSE}
	};
	NS_OBJECT oPublicKeyA = {
		{NSA_OBJECT_TYPE, &puk_type, sizeof(puk_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE},
	};
	NS_OBJECT oPrivateKeyA = {
		{NSA_OBJECT_TYPE, &prk_type, sizeof(prk_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},
	};
	NS_OBJECT oPublicKeyB = {
		{NSA_OBJECT_TYPE, &puk_type, sizeof(puk_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE},
	};
	NS_CONTEXT ecdhctx = {
		{NSA_OBJECT_TYPE, &kdrv_type, sizeof(kdrv_type), FALSE, FALSE},
		{NSA_EC_NUMBER,   &ecp_id,
			sizeof(ecp_id), FALSE, FALSE},
		{NSA_ECPT_FORM, &ecpt_type,
			sizeof(ecpt_type), FALSE, FALSE},
		{NSA_ECDH_PEERS_PUBLICKEY, NULL, 0, FALSE, FALSE}
	};
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},
	};
	NS_RV   ret;
    
    
	// 난수생성시 엔트로피 수집
	NS_ULONG data_type = NSO_DATA, rand_ctx = NSO_CTX_RANDOM_X9_62;
	NS_CONTEXT randctx = {
		{NSA_OBJECT_TYPE, &rand_ctx, sizeof(int), FALSE, FALSE}
	};
	NSString *strRand = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
	const char *seed = [strRand UTF8String];
	NS_OBJECT oSeed = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, &seed, (int)strlen(seed), TRUE, FALSE}
	};
	NSR_OK;
	if((ret=N_seed_random(&randctx, (NS_OBJECT_PTR)&oSeed)) != NSR_OK) {
		printf("N_seed_random failed: %s\n",N_get_errmsg(ret));
	}
	// 난수생성시 엔트로피 수집 끝
    
	if( (ret = N_generate_keypair(&keygenctx,
								  (NS_OBJECT_PTR)&oPublicKeyA,
								  (NS_OBJECT_PTR)&oPrivateKeyA)) != NSR_OK ) {
		printf("N_generate_keypair failed: %s\n",N_get_errmsg(ret));
	}
	
	_publicKeyOfMine = [[NSData alloc] initWithBytes:oPublicKeyA[1].pValue length:oPublicKeyA[1].ulValueLen];
	_privateKeyOfMine = [[NSData alloc] initWithBytes:oPrivateKeyA[1].pValue length:oPrivateKeyA[1].ulValueLen];
    //	NSLog(@"나의 공개키: %@", [_publicKeyOfMine stringWithHexBytes1]);
    //	NSLog(@"나의 개인키: %@", [_privateKeyOfMine stringWithHexBytes1]);
	
	const void* bytes = [_rcvPublicKeyDataFromServer bytes];
	
	oPublicKeyB[1].pValue = malloc( [_rcvPublicKeyDataFromServer length] );
	memcpy(oPublicKeyB[1].pValue, bytes, [_rcvPublicKeyDataFromServer length]);
	oPublicKeyB[1].ulValueLen = (int)[_rcvPublicKeyDataFromServer length];
	
	ecdhctx[3].pValue = oPublicKeyB[1].pValue;
	ecdhctx[3].ulValueLen = oPublicKeyB[1].ulValueLen;
	if( (ret = N_derive_key(&ecdhctx,
							(NS_OBJECT_PTR)&oPrivateKeyA,
							(NS_OBJECT_PTR)oSecretKeyA)) != NSR_OK )
	{
		//printf("N_derive_key failed: %s\n",N_get_errmsg(ret));
	}
	
	_sharedKey = [[NSData alloc] initWithBytes:oSecretKeyA[1].pValue length:oSecretKeyA[1].ulValueLen];
    //	NSLog(@"암호 시드키: %@", [_sharedKey stringWithHexBytes1]);
	
	//N_FreeGapString(permStr, permSize);
    N_FreeGapString((unsigned char *)oPublicKeyA[1].pValue, oPublicKeyA[1].ulValueLen);
    N_FreeGapString((unsigned char *)oPublicKeyB[1].pValue, oPublicKeyB[1].ulValueLen);
    N_FreeGapString((unsigned char *)oPrivateKeyA[1].pValue, oPrivateKeyA[1].ulValueLen);
    N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
}

- (void) generateSharedKey2 {
	// 1. 나의 공개키와 개인키를 만든다
	NS_ULONG ecp_id = NSF_WTLS_EC_3,
	kg_type = NSO_CTX_EC_KEYPAIR_GEN,
	prk_type = NSO_PRIVATE_KEY,
	puk_type = NSO_PUBLIC_KEY,
	kdrv_type = NSO_CTX_ECDH_DERIVE,
	skey_type = NSO_SECRET_KEY,
	ecpt_type = NSF_ECPT_COMPRESS;
	
	NS_CONTEXT keygenctx = {
		{NSA_OBJECT_TYPE, &kg_type, 0, FALSE, FALSE},
		{NSA_EC_NUMBER,
			&ecp_id, sizeof(ecp_id), FALSE, FALSE},
		{NSA_ECPT_FORM,
			&ecpt_type, sizeof(ecpt_type), FALSE, FALSE}
	};
	NS_OBJECT oPublicKeyA = {
		{NSA_OBJECT_TYPE, &puk_type, sizeof(puk_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE},
	};
	NS_OBJECT oPrivateKeyA = {
		{NSA_OBJECT_TYPE, &prk_type, sizeof(prk_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},
	};
	NS_CONTEXT ecdhctx = {
		{NSA_OBJECT_TYPE, &kdrv_type, sizeof(kdrv_type), FALSE, FALSE},
		{NSA_EC_NUMBER,   &ecp_id,
			sizeof(ecp_id), FALSE, FALSE},
		{NSA_ECPT_FORM, &ecpt_type,
			sizeof(ecpt_type), FALSE, FALSE},
		{NSA_ECDH_PEERS_PUBLICKEY, NULL, 0, FALSE, FALSE}
	};
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},
	};
	NS_RV   ret;
	
	
	// 난수생성시 엔트로피 수집
	NS_ULONG data_type = NSO_DATA, rand_ctx = NSO_CTX_RANDOM_X9_62;
	NS_CONTEXT randctx = {
		{NSA_OBJECT_TYPE, &rand_ctx, sizeof(int), FALSE, FALSE}
	};
	NSString *strRand = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
	const char *seed = [strRand UTF8String];
	NS_OBJECT oSeed = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, &seed, (int)strlen(seed), TRUE, FALSE}
	};
	NSR_OK;
	if((ret=N_seed_random(&randctx, (NS_OBJECT_PTR)&oSeed)) != NSR_OK) {
		printf("N_seed_random failed: %s\n",N_get_errmsg(ret));
	}
	// 난수생성시 엔트로피 수집 끝
	
	if( (ret = N_generate_keypair(&keygenctx,
								  (NS_OBJECT_PTR)&oPublicKeyA,
								  (NS_OBJECT_PTR)&oPrivateKeyA)) != NSR_OK ) {
		printf("N_generate_keypair failed: %s\n",N_get_errmsg(ret));
	}
	
	
	ecdhctx[3].pValue = oPublicKeyA[1].pValue;
	ecdhctx[3].ulValueLen = oPublicKeyA[1].ulValueLen;
	if( (ret = N_derive_key(&ecdhctx,
							(NS_OBJECT_PTR)&oPrivateKeyA,
							(NS_OBJECT_PTR)oSecretKeyA)) != NSR_OK )
	{
		//printf("N_derive_key failed: %s\n",N_get_errmsg(ret));
	}
	
	_sharedKey2 = [[NSData alloc] initWithBytes:oSecretKeyA[1].pValue length:oSecretKeyA[1].ulValueLen];
	//		NSLog(@"암호 시드키: %@", [_sharedKey2 stringWithHexBytes1]);
	
	//N_FreeGapString(permStr, permSize);
	N_FreeGapString((unsigned char *)oPublicKeyA[1].pValue, oPublicKeyA[1].ulValueLen);
	N_FreeGapString((unsigned char *)oPrivateKeyA[1].pValue, oPrivateKeyA[1].ulValueLen);
	N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
}

- (NSArray *)getKeypadArray {
    
    [self makeSharedKey];
    _arrKeyNum = [[NSArray alloc] initWithArray:[self getKeypadArray:_sharedKey]];
    return _arrKeyNum;
}

- (NSArray *)getKeypadArray2 {
	_arrKeyNum2 = [[NSArray alloc] initWithArray:[self getKeypadArray:_sharedKey2]];
	return _arrKeyNum2;
}

- (NSArray *)getKeypadArray:(NSData *)pSeedKey {
	//NSLog(@"GET KEYPAD ARRAY START");
    
    //NSLog(@"GETKEYPADARRAY: %@", pSeedKey.base64Encoding);
    
	NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_RV   ret;
	
    // 시드키 구조체 만들기
	const void* bytes = [pSeedKey bytes];
	oSecretKeyA[1].pValue = malloc( [pSeedKey length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [pSeedKey length]);
	oSecretKeyA[1].ulValueLen = (int)[pSeedKey length];
	
	// 순열 생성
	unsigned char *permStr;
	int permSize=10;
	
    ret=N_GenPermutation((unsigned char *)oSecretKeyA[1].pValue,oSecretKeyA[1].ulValueLen,&permStr,permSize);
	if(ret != NFR_OK) {
		NSLog(@"키재배열 중 오류");
	} else {
		//printf("키패드 순열: "); for(int i=0;i<permSize;i++) { printf("%d,",permStr[i]); }
	} // 키재배열을 위한 순열생성 끝
	
    
	NSString *nums = [[NSString alloc] initWithFormat:@"%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",
					  permStr[0], permStr[1], permStr[2], permStr[3], permStr[4],
					  permStr[5], permStr[6], permStr[7], permStr[8], permStr[9]];
	//NSLog(@"키패드 순열: %@", nums);
    
	NSArray* arrKeyNum = [[NSArray alloc] initWithArray:[nums componentsSeparatedByString:@","]];
	
	// 메모리 해제
	N_FreeGapString(permStr, permSize);
	N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
	return arrKeyNum;
}

- (NSArray *)Permutation:(int)maxsize {
	//NSLog(@"GET KEYPAD ARRAY START");
	
	//NSLog(@"GETKEYPADARRAY: %@", pSeedKey.base64Encoding);
	
	NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_RV   ret;
	
	// 시드키 구조체 만들기
	const void* bytes = [_sharedKey2 bytes];
	oSecretKeyA[1].pValue = malloc( [_sharedKey2 length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [_sharedKey2 length]);
	oSecretKeyA[1].ulValueLen = (int)[_sharedKey2 length];
	
	// 순열 생성
	unsigned char *permStr;
	int permSize=maxsize;
	
	ret=N_GenPermutation((unsigned char *)oSecretKeyA[1].pValue,oSecretKeyA[1].ulValueLen,&permStr,permSize);
	if(ret != NFR_OK) {
		NSLog(@"키재배열 중 오류");
	} else {
		//printf("키패드 순열: "); for(int i=0;i<permSize;i++) { printf("%d,",permStr[i]); }
	} // 키재배열을 위한 순열생성 끝
	
	
	NSString *nums = @"";
	//[[NSString alloc] initWithFormat:@"%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",
	//				  permStr[0], permStr[1], permStr[2], permStr[3], permStr[4],
	//				  permStr[5], permStr[6], permStr[7], permStr[8], permStr[9]];

	for (int i = 0; i < maxsize; i++) {
		nums = [nums stringByAppendingString:[[NSString alloc] initWithFormat:@"%d,", permStr[i]]];
	}
	//NSLog(@"키패드 순열: %@", nums);
	
	NSArray* arrKeyNum = [[NSArray alloc] initWithArray:[nums componentsSeparatedByString:@","]];
	
	// 메모리 해제
	N_FreeGapString(permStr, permSize);
	N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
	return arrKeyNum;
}


// 숫자키패드형 암호화 (뒤에 패딩을 붙인다)
- (NSString *)makeEncPadWithSeedKey:(NSData *)pPlainText seedKey:(NSData *)pSeedKey {
    
    NSString *tmpText = [[NSString alloc] initWithData:pPlainText encoding:NSUTF8StringEncoding];
    
    NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_OBJECT oSecretKeyACONST = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}, };
	
	const void* bytes = [pSeedKey bytes];
	oSecretKeyA[1].pValue = malloc( [pSeedKey length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [pSeedKey length]);
	oSecretKeyA[1].ulValueLen = (int)[pSeedKey length];
	
	const void* bytes2 = [pSeedKey bytes];
	oSecretKeyACONST[1].pValue = malloc( [pSeedKey length] );
	memcpy(oSecretKeyACONST[1].pValue, bytes2, [pSeedKey length]);
	oSecretKeyACONST[1].ulValueLen = (int)[pSeedKey length];
	
	//NSLog(@"시드키: %@", [pSeedKey stringWithHexBytes1]);
	
	unsigned char *padString, *chrPtr;
	unsigned int ret =0, padStringSize;
    unsigned char *chrPtrTemp = (unsigned char *)malloc(oSecretKeyA[1].ulValueLen);
    memcpy(chrPtrTemp, oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
    chrPtr=&(chrPtrTemp[3]); /* 똑같은 패딩이 생기지 않도록 이 부분을 증가시킬 것이다 */
	
	// 사용자의 입력값 개수만큼 돌면서 패딩하자
	// 여기다 메로릭!!
	//NSArray *arrStringUserInput = [pPlainText splitToSize:1];
	NSArray *arrStringUserInput = [[KNStringutil sharedInstance] splitBy1Size:[tmpText dataUsingEncoding: NSUTF8StringEncoding]];
	NSMutableData* ndPadded = [[NSMutableData alloc] initWithCapacity:10];
	
	//NSLog(@"배열값: %@", arrStringUserInput);
	
	//for (int i = 0; i < [arrStringUserInput count] -1; i++) {
	for (int i = 0; i < [arrStringUserInput count]; i++) {
		(*chrPtr)++;
		// 패딩공간 만들어라 사이즈는 10을 넘지 않는다
		ret=N_GenPadString((unsigned char *)chrPtrTemp, oSecretKeyA[1].ulValueLen, 1, 10, &padString, &padStringSize);
		//printf("padString="); for(int j=0;j<padStringSize;j++){ printf("%d,",padString[j]); } printf("\n");
		
		{
			unsigned char *randStr;
			int randByte;
			randByte=(int)padString[0]&0xff;
			N_GenRandFromSeed( chrPtr, oSecretKeyA[1].ulValueLen, &randStr, randByte);
			/* 랜덤값 들어있는 배열생성 */
			for(int i2=0;i2<randByte;i2++) { randStr[i2]=randStr[i2]%10; }
			/* 특정 위치에 사용자 입력값 지정 */
			randStr[	(int)padString[1]&0xff]= [[arrStringUserInput objectAtIndex:i] intValue];
			/* 출력 */
			//printf("inputStr="); for(int i3=0;i3<randByte;i3++) { printf("%x,",randStr[i3]); } printf("\n");
			//NSData *padded = [NSData dataWithBytesNoCopy:randStr length:randByte];
			NSData *padded = [[NSData alloc] initWithBytes:randStr length:randByte];
			[ndPadded appendData:padded];
			
			N_FreeGapString(randStr, randByte);
		}
		
		N_FreeGapString(padString, padStringSize);
	} // 패딩 for
	
	NSString *strPadded = [NSString stringWithFormat:@"%@", [ndPadded stringWithHexBytes1]];
	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"00" withString:@"--"];
	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"0" withString:@""];
	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"--" withString:@"0"];
	//NSLog(@"패딩완료: %@", strPadded);
	
	NS_ULONG    op_mode = NSO_CTX_SEED_CFB,
	data_type = NSO_DATA;
	
	NS_BYTE iv[16]={0};
	NS_CONTEXT encctx = {
		{NSA_OBJECT_TYPE, &op_mode, sizeof(op_mode), FALSE, FALSE},
		{ NSA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	
	//memset(iv,0,sizeof(iv));
	NS_BYTE *DataBuf = (unsigned char *)[strPadded UTF8String];
	NSUInteger len = strlen((char *)DataBuf);
	// N_hex_dump(DataBuf, len, "data buf to send");
	NS_OBJECT oData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, DataBuf, (int)len, TRUE, FALSE}
	};
	NS_OBJECT oEncryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE}
	};
	
	// 암호화 시작
	if( (ret = N_encrypt_init(&encctx,(NS_OBJECT_PTR)&oSecretKeyACONST)) != NSR_OK )
		printf("N_encrypt_init failed: %s\n",N_get_errmsg(ret));
	if( (ret = N_encrypt(&encctx, (NS_OBJECT_PTR)&oData,(NS_OBJECT_PTR)&oEncryptedData)) != NSR_OK )
		printf("N_encrypt failed: %s\n",N_get_errmsg(ret));
	NSData *ndDataToSend = [[NSData alloc] initWithBytes:oEncryptedData[1].pValue length:oEncryptedData[1].ulValueLen];
	
	// 공개키BASE64 + 암호화된값BASE64
	NSString *strReturn = [ndDataToSend base64Encoding];
	// NSLog(@"서버에 보내는 암호화된 값 BASE64: %@", strReturn);
	
    N_FreeGapString((unsigned char *)oSecretKeyACONST[1].pValue, oSecretKeyACONST[1].ulValueLen);
    N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
    N_FreeGapString((unsigned char *)oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen);
    
    free(chrPtrTemp);
    
	return strReturn;
}

// 숫자키패드형 암호화 (뒤에 패딩을 붙인다)
- (NSString *)makeEncWithPadWithSeedKey:(NSData *)pPlainText seedKey:(NSData *)pSeedKey {
    
    NSString *tmpText = [[NSString alloc] initWithData:pPlainText encoding:NSUTF8StringEncoding];
    
    NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_OBJECT oSecretKeyACONST = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}, };
	
	const void* bytes = [pSeedKey bytes];
	oSecretKeyA[1].pValue = malloc( [pSeedKey length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [pSeedKey length]);
	oSecretKeyA[1].ulValueLen = (int)[pSeedKey length];
	
	const void* bytes2 = [pSeedKey bytes];
	oSecretKeyACONST[1].pValue = malloc( [pSeedKey length] );
	memcpy(oSecretKeyACONST[1].pValue, bytes2, [pSeedKey length]);
	oSecretKeyACONST[1].ulValueLen = (int)[pSeedKey length];
	
	//NSLog(@"시드키: %@", [pSeedKey stringWithHexBytes1]);
	
	unsigned char *padString, *chrPtr;
	unsigned int ret =0, padStringSize;
    unsigned char *chrPtrTemp = (unsigned char *)malloc(oSecretKeyA[1].ulValueLen);
    memcpy(chrPtrTemp, oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
    chrPtr=&(chrPtrTemp[3]); /* 똑같은 패딩이 생기지 않도록 이 부분을 증가시킬 것이다 */
	
	// 사용자의 입력값 개수만큼 돌면서 패딩하자
	// 여기다 메로릭!!
	//NSArray *arrStringUserInput = [pPlainText splitToSize:1];
	NSArray *arrStringUserInput = [[KNStringutil sharedInstance] splitBy1Size:[tmpText dataUsingEncoding: NSUTF8StringEncoding]];
	NSMutableData* ndPadded = [[NSMutableData alloc] initWithCapacity:10];
	
    //	NSLog(@"배열값: %@", arrStringUserInput);
	
	//for (int i = 0; i < [arrStringUserInput count] -1; i++) {
	for (int i = 0; i < [arrStringUserInput count]; i++) {
		(*chrPtr)++;
		// 패딩공간 만들어라 사이즈는 10을 넘지 않는다
		ret=N_GenPadString((unsigned char *)chrPtrTemp, oSecretKeyA[1].ulValueLen, 1, 10, &padString, &padStringSize);
		//printf("padString="); for(int j=0;j<padStringSize;j++){ printf("%d,",padString[j]); } printf("\n");
		
		{
			unsigned char *randStr;
			int randByte, asciiCode;
            char randChar;
			randByte=(int)padString[0]&0xff;
			N_GenRandFromSeed( chrPtr, oSecretKeyA[1].ulValueLen, &randStr, randByte);
			/* 랜덤값 들어있는 배열생성 */
			for(int i2=0;i2<randByte;i2++) {
                asciiCode = randStr[i2]%94+33;
                randChar = (char)asciiCode;
                randStr[i2] = randChar;
            }
			/* 특정 위치에 사용자 입력값 지정 */
            randStr[(int)padString[1]&0xff] = [[arrStringUserInput objectAtIndex:i] UTF8String][0];
            
            /* 출력 */
			//printf("inputStr="); for(int i3=0;i3<randByte;i3++) { printf("%x,",randStr[i3]); } printf("\n");
			//NSData *padded = [NSData dataWithBytesNoCopy:randStr length:randByte];
			NSData *padded = [[NSData alloc] initWithBytes:randStr length:randByte];
			[ndPadded appendData:padded];
			
			N_FreeGapString(randStr, randByte);
		}
		
		N_FreeGapString(padString, padStringSize);
	} // 패딩 for
    
    
	NSString *strPadded = [[NSString alloc] initWithData:ndPadded encoding:NSUTF8StringEncoding];
    //	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"00" withString:@"--"];
    //	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"0" withString:@""];
    //	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"--" withString:@"0"];
    //	NSLog(@"패딩완료: %@", strPadded);
	
	NS_ULONG    op_mode = NSO_CTX_SEED_CFB,
	data_type = NSO_DATA;
	
	NS_BYTE iv[16]={0};
	NS_CONTEXT encctx = {
		{NSA_OBJECT_TYPE, &op_mode, sizeof(op_mode), FALSE, FALSE},
		{ NSA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	
	//memset(iv,0,sizeof(iv));
	NS_BYTE *DataBuf = (unsigned char *)[strPadded UTF8String];
	NSUInteger len = strlen((char *)DataBuf);
	// N_hex_dump(DataBuf, len, "data buf to send");
	NS_OBJECT oData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, DataBuf, (int)len, TRUE, FALSE}
	};
	NS_OBJECT oEncryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE}
	};
	
	// 암호화 시작
	if( (ret = N_encrypt_init(&encctx,(NS_OBJECT_PTR)&oSecretKeyACONST)) != NSR_OK )
		printf("N_encrypt_init failed: %s\n",N_get_errmsg(ret));
	if( (ret = N_encrypt(&encctx, (NS_OBJECT_PTR)&oData,(NS_OBJECT_PTR)&oEncryptedData)) != NSR_OK )
		printf("N_encrypt failed: %s\n",N_get_errmsg(ret));
	NSData *ndDataToSend = [[NSData alloc] initWithBytes:oEncryptedData[1].pValue length:oEncryptedData[1].ulValueLen];
	
	// 공개키BASE64 + 암호화된값BASE64
	NSString *strReturn = [ndDataToSend base64Encoding];
	// NSLog(@"서버에 보내는 암호화된 값 BASE64: %@", strReturn);
	
    N_FreeGapString((unsigned char *)oSecretKeyACONST[1].pValue, oSecretKeyACONST[1].ulValueLen);
    N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
    N_FreeGapString((unsigned char *)oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen);
    free(chrPtrTemp);
	return strReturn;
}

- (NSInteger)getRandNum:(NSData *)pSeedKey {
    
    NS_ULONG skey_type = NSO_SECRET_KEY;
    NS_OBJECT oSecretKeyA = {
        {NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
        {NSA_VALUE, NULL, 0, TRUE, FALSE},	};
    
    NS_RV   ret;
    
    //NSLog(@"랜던값 구하기 - 넘어온시드키: %@", [pSeedKey stringWithHexBytes1]);
    
    const void* bytes = [pSeedKey bytes];
    oSecretKeyA[1].pValue = malloc( [pSeedKey length] );
    memcpy(oSecretKeyA[1].pValue, bytes, [pSeedKey length]);
    oSecretKeyA[1].ulValueLen = [pSeedKey length];
    
    unsigned char *randStr;
    ret=N_GenRandFromSeed((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen, &randStr, 1);
    NSInteger randNum = (int)randStr[0]&0xff;
    
    N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
    
    return randNum;
}

- (NSInteger)getRandNum {
    return [self getRandNum:_sharedKey];
}

// 암호화하지만, 앞부분에 공개키를 붙이지 않고 순수 암호화된 값을 리턴
- (NSString *)makeEncNoPadWithSeedkey:(NSData *)pPlainText seedKey:(NSData *)pSeedKey {
    
    NSString *tmpText = [[NSString alloc] initWithData:pPlainText encoding:NSUTF8StringEncoding];
    
	NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_OBJECT oSecretKeyACONST = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}, };
	
	NS_RV   ret;
	
	//NSLog(@"생성된 시드키: %@", [pSeedKey stringWithHexBytes1]);
	
	const void* bytes = [pSeedKey bytes];
	oSecretKeyA[1].pValue = malloc( [pSeedKey length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [pSeedKey length]);
	oSecretKeyA[1].ulValueLen = (int)[pSeedKey length];
	
	const void* bytes2 = [pSeedKey bytes];
	oSecretKeyACONST[1].pValue = malloc( [pSeedKey length] );
	memcpy(oSecretKeyACONST[1].pValue, bytes2, [pSeedKey length]);
	oSecretKeyACONST[1].ulValueLen = (int)[pSeedKey length];
	
	//NSLog(@"암호 대칭키: %@", [_sharedKey stringWithHexBytes1]);
	
	NS_ULONG    op_mode = NSO_CTX_SEED_CFB,
	data_type = NSO_DATA;
	
	NS_BYTE iv[16]={0};
	NS_CONTEXT encctx = {
		{NSA_OBJECT_TYPE, &op_mode, sizeof(op_mode), FALSE, FALSE},
		{ NSA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	
	//memset(iv,0,sizeof(iv));
    NS_BYTE *DataBuf = (unsigned char *)[tmpText UTF8String];
	NSUInteger len = strlen((char *)DataBuf);
	// N_hex_dump(DataBuf, len, "data buf to send");
	NS_OBJECT oData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, DataBuf, (int)len, TRUE, FALSE}
	};
	NS_OBJECT oEncryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE}
	};
	
	// 암호화 시작
	if( (ret = N_encrypt_init(&encctx,(NS_OBJECT_PTR)&oSecretKeyACONST)) != NSR_OK )
		printf("N_encrypt_init failed: %s\n",N_get_errmsg(ret));
	if( (ret = N_encrypt(&encctx, (NS_OBJECT_PTR)&oData,(NS_OBJECT_PTR)&oEncryptedData)) != NSR_OK )
		printf("N_encrypt failed: %s\n",N_get_errmsg(ret));
	// N_hex_dump(oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen, "encrypted data");
	NSData *ndDataToSend = [[NSData alloc] initWithBytes:oEncryptedData[1].pValue length:oEncryptedData[1].ulValueLen];
	
	// 암호화된값BASE64
	NSString *strReturn = [[NSString alloc] initWithFormat:@"%@", [ndDataToSend base64Encoding] ];
	//NSLog(@"서버에 보내는 암호화된 값 BASE64: %@", strReturn);
	
    N_FreeGapString((unsigned char *)oSecretKeyACONST[1].pValue, oSecretKeyACONST[1].ulValueLen);
    N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
    N_FreeGapString((unsigned char *)oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen);
	
	return strReturn;
}

// 서버공개키를 지정하면 클라이언트의 공개키와 시드키를 반환
- (void)getSeedKeyNClientPublickeyWithServerPublickey:(NSString *)pServerPublicKey
                                      ClientPublickey:(NSString **)vClientPublickey SeedKey:(NSData **)vSeedKey {
    
    // 공개키는 이 순간 만들어진다
	[self setServerPublickey:pServerPublicKey];
    [self getKeypadArray];
    //if (_arrKeyNum)
    //    [_arrKeyNum release];
    
    //_arrKeyNum = [[NSArray alloc] initWithArray:[self getKeypadArray]];
    //NSLog(@"키패드순열: %@", _arrKeyNum);
	
	*vClientPublickey = [NSString stringWithFormat:@"%@", [_publicKeyOfMine base64Encoding]];
	*vSeedKey = [NSData dataWithData:_sharedKey];
}

// 서버공개키 URL를 지정하면 클라이언트의 공개키와 시드키를 반환
- (void)getSeedKeyNClientPublickeyWithServerPublickeyURL:(NSString *)pServerPublicKeyURL
                                         ClientPublickey:(NSString **)vClientPublickey SeedKey:(NSData **)vSeedKey {
	// 서버로부터 공개키 긁어오기
	NSURL *url = [NSURL URLWithString:pServerPublicKeyURL];
	NSData* dataServerkey = [[NSData alloc] initWithContentsOfURL:url];
	NSString* strServerkey = [[NSString alloc] initWithData:dataServerkey encoding:NSUTF8StringEncoding];
	NSArray* arr = [strServerkey componentsSeparatedByString:@"<pub desc=\"base64pubkey\">"];
	NSString *pServerPublicKey = [NSString stringWithFormat:@"%@",
                                  [[[arr objectAtIndex:1] componentsSeparatedByString:@"</pub>"] objectAtIndex:0]];
    
	// 공개키는 이 순간 만들어진다
    [self setServerPublickey:pServerPublicKey];
    
	*vClientPublickey = [NSString stringWithFormat:@"%@", [_publicKeyOfMine base64Encoding]];
	*vSeedKey = [NSData dataWithData:_sharedKey];
}

// 암호화하지만, 앞부분에 공개키를 붙여서 "클라이언트공개키+암호화값" 을 리턴
- (NSString *)makeEncNoPadding:(NSData *)pPlainText {
    
    
	// 2. 암호화 작업
	NSString *encData = [self makeEncNoPadWithSeedkey:pPlainText seedKey:_sharedKey];
	
	// 3. 암호화된값 앞에 클라이언트 공개키 붙이기
	NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@", [_publicKeyOfMine base64Encoding], encData];
    return encDataPlusPublickey;
}

// 암호화하지만, 앞부분에 공개키를 붙여서 "클라이언트공개키+암호화값" 을 리턴
- (NSString *)makeEncPadding:(NSData *)pPlainText {
    
	// 2. 암호화 작업
	NSString *encData = [self makeEncWithPadWithSeedKey:pPlainText seedKey:_sharedKey];
    
	// 3. 암호화된값 앞에 클라이언트 공개키 붙이기
#pragma mark - NFSTR옵션
	NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@%@%@", [_publicKeyOfMine base64Encoding], [[@"NF_STR" dataUsingEncoding:NSUTF8StringEncoding] base64Encoding], [[@"v12" dataUsingEncoding:NSUTF8StringEncoding] base64Encoding], encData];
	//NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@%@", [_publicKeyOfMine base64Encoding], [[@"v12" dataUsingEncoding:NSUTF8StringEncoding] base64Encoding], encData];
    
    return encDataPlusPublickey;
}

// 암호화하지만, 앞부분에 공개키를 붙여서 "클라이언트공개키+암호화값" 을 리턴
- (NSString *)makeEncNoPadding2:(NSMutableArray *)pPlainText {
	
	NSString *plainText = @"";
	// 0. 암호화할 데이터
	//    NSString* plainText = [NSString stringWithFormat:@"%@", stringStore];
	for (id test in pPlainText) {
		NSData *a1 = [test AES256DecryptWithKey:[[PublicKeyDownloader sharedInstance] getServerPubkey] iv:[self getIV:[[PublicKeyDownloader sharedInstance] getServerPubkey]]];
		NSString *a = [[NSString alloc] initWithData:a1 encoding:NSUTF8StringEncoding];
		plainText = [plainText stringByAppendingString:a];
	}
	
	plainText = [plainText stringByReplacingOccurrencesOfString:@"₩" withString:@"\\"];
	
	NSData* textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
	
	// 2. 암호화 작업
//	NSString *encData = [self makeEncNoPadWithSeedkey:textData seedKey:_sharedKey];

//	NSString *tmpText = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
	
	NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_OBJECT oSecretKeyACONST = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}, };
	
	NS_RV   ret;
	
	//NSLog(@"생성된 시드키: %@", [pSeedKey stringWithHexBytes1]);
	
	const void* bytes = [_sharedKey bytes];
	oSecretKeyA[1].pValue = malloc( [_sharedKey length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [_sharedKey length]);
	oSecretKeyA[1].ulValueLen = (int)[_sharedKey length];
	
	const void* bytes2 = [_sharedKey bytes];
	oSecretKeyACONST[1].pValue = malloc( [_sharedKey length] );
	memcpy(oSecretKeyACONST[1].pValue, bytes2, [_sharedKey length]);
	oSecretKeyACONST[1].ulValueLen = (int)[_sharedKey length];
	
	//NSLog(@"암호 대칭키: %@", [_sharedKey stringWithHexBytes1]);
	
	NS_ULONG    op_mode = NSO_CTX_SEED_CFB,
	data_type = NSO_DATA;
	
	NS_BYTE iv[16]={0};
	NS_CONTEXT encctx = {
		{NSA_OBJECT_TYPE, &op_mode, sizeof(op_mode), FALSE, FALSE},
		{ NSA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	
	//memset(iv,0,sizeof(iv));
	// NS_BYTE *DataBuf = (unsigned char *)[plainText UTF8String];
	// NSUInteger len = strlen((char *)DataBuf);
	// N_hex_dump(DataBuf, len, "data buf to send");
	NS_OBJECT oData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}
	};
	NS_OBJECT oEncryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE}
	};
	
	const void* tmptextData = [textData bytes];
	oData[1].pValue = malloc([textData length]);
	memcpy(oData[1].pValue, tmptextData, [textData length]);
	oData[1].ulValueLen = (int)[textData length];
	
	// 암호화 시작
	if( (ret = N_encrypt_init(&encctx,(NS_OBJECT_PTR)&oSecretKeyACONST)) != NSR_OK )
		printf("N_encrypt_init failed: %s\n",N_get_errmsg(ret));
	if( (ret = N_encrypt(&encctx, (NS_OBJECT_PTR)&oData,(NS_OBJECT_PTR)&oEncryptedData)) != NSR_OK )
		printf("N_encrypt failed: %s\n",N_get_errmsg(ret));
	// N_hex_dump(oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen, "encrypted data");
	NSData *ndDataToSend = [[NSData alloc] initWithBytes:oEncryptedData[1].pValue length:oEncryptedData[1].ulValueLen];
	
	// 암호화된값BASE64
	NSString *strReturn = [[NSString alloc] initWithFormat:@"%@", [ndDataToSend base64Encoding] ];
	//NSLog(@"서버에 보내는 암호화된 값 BASE64: %@", strReturn);
	
	N_FreeGapString((unsigned char *)oSecretKeyACONST[1].pValue, oSecretKeyACONST[1].ulValueLen);
	N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
	N_FreeGapString((unsigned char *)oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen);
	N_clear_object((NS_OBJECT_PTR)&oData, 2);
	N_clear_object((NS_OBJECT_PTR)&oEncryptedData, 2);
	
	// 3. 암호화된값 앞에 클라이언트 공개키 붙이기
	NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@", [_publicKeyOfMine base64Encoding], strReturn];
	plainText = nil;
	textData = nil;
	strReturn = nil;
	ndDataToSend = nil;
	return encDataPlusPublickey;
}

// 암호화하지만, 앞부분에 공개키를 붙여서 "클라이언트공개키+암호화값" 을 리턴
- (NSString *)makeEncPadding2:(NSMutableArray *)pPlainText {
	NSString *plainText = @"";
	// 0. 암호화할 데이터
	//    NSString* plainText = [NSString stringWithFormat:@"%@", stringStore];
	for (id test in pPlainText) {
		NSData *a1 = [test AES256DecryptWithKey:[[PublicKeyDownloader sharedInstance] getServerPubkey] iv:[self getIV:[[PublicKeyDownloader sharedInstance] getServerPubkey]]];
		NSString *a = [[NSString alloc] initWithData:a1 encoding:NSUTF8StringEncoding];
		plainText = [plainText stringByAppendingString:a];
	}
	
	plainText = [plainText stringByReplacingOccurrencesOfString:@"₩" withString:@"\\"];
	
	NSData* textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
	
	// 2. 암호화 작업
	//NSString *encData = [self makeEncWithPadWithSeedKey:textData seedKey:_sharedKey];
	
	
	//NSString *tmpText = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
	
	NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_OBJECT oSecretKeyACONST = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}, };
	
	const void* bytes = [_sharedKey bytes];
	oSecretKeyA[1].pValue = malloc( [_sharedKey length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [_sharedKey length]);
	oSecretKeyA[1].ulValueLen = (int)[_sharedKey length];
	
	const void* bytes2 = [_sharedKey bytes];
	oSecretKeyACONST[1].pValue = malloc( [_sharedKey length] );
	memcpy(oSecretKeyACONST[1].pValue, bytes2, [_sharedKey length]);
	oSecretKeyACONST[1].ulValueLen = (int)[_sharedKey length];
	
	//NSLog(@"시드키: %@", [pSeedKey stringWithHexBytes1]);
	
	unsigned char *padString, *chrPtr;
	unsigned int ret =0, padStringSize;
	unsigned char *chrPtrTemp = (unsigned char *)malloc(oSecretKeyA[1].ulValueLen);
	memcpy(chrPtrTemp, oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
	chrPtr=&(chrPtrTemp[3]); /* 똑같은 패딩이 생기지 않도록 이 부분을 증가시킬 것이다 */
	
	// 사용자의 입력값 개수만큼 돌면서 패딩하자
	// 여기다 메로릭!!
	//NSArray *arrStringUserInput = [pPlainText splitToSize:1];
	NSArray *arrStringUserInput = [[KNStringutil sharedInstance] splitBy1Size:[plainText dataUsingEncoding: NSUTF8StringEncoding]];
	NSMutableData* ndPadded = [[NSMutableData alloc] initWithCapacity:10];
	
	//	NSLog(@"배열값: %@", arrStringUserInput);
	
	//for (int i = 0; i < [arrStringUserInput count] -1; i++) {
	for (int i = 0; i < [arrStringUserInput count]; i++) {
		(*chrPtr)++;
		// 패딩공간 만들어라 사이즈는 10을 넘지 않는다
		ret=N_GenPadString((unsigned char *)chrPtrTemp, oSecretKeyA[1].ulValueLen, 1, 10, &padString, &padStringSize);
		//printf("padString="); for(int j=0;j<padStringSize;j++){ printf("%d,",padString[j]); } printf("\n");
		
		{
			unsigned char *randStr;
			int randByte, asciiCode;
			char randChar;
			randByte=(int)padString[0]&0xff;
			N_GenRandFromSeed( chrPtr, oSecretKeyA[1].ulValueLen, &randStr, randByte);
			/* 랜덤값 들어있는 배열생성 */
			for(int i2=0;i2<randByte;i2++) {
				asciiCode = randStr[i2]%94+33;
				randChar = (char)asciiCode;
				randStr[i2] = randChar;
			}
			/* 특정 위치에 사용자 입력값 지정 */
			randStr[(int)padString[1]&0xff] = [[arrStringUserInput objectAtIndex:i] UTF8String][0];
			
			/* 출력 */
			//printf("inputStr="); for(int i3=0;i3<randByte;i3++) { printf("%x,",randStr[i3]); } printf("\n");
			//NSData *padded = [NSData dataWithBytesNoCopy:randStr length:randByte];
			NSData *padded = [[NSData alloc] initWithBytes:randStr length:randByte];
			[ndPadded appendData:padded];
			
			N_FreeGapString(randStr, randByte);
		}
		
		N_FreeGapString(padString, padStringSize);
	} // 패딩 for
	
	
	//  NSString *strPadded = [[NSString alloc] initWithData:ndPadded encoding:NSUTF8StringEncoding];
	//	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"00" withString:@"--"];
	//	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"0" withString:@""];
	//	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"--" withString:@"0"];
	//	NSLog(@"패딩완료: %@", strPadded);
	
	NS_ULONG    op_mode = NSO_CTX_SEED_CFB,
	data_type = NSO_DATA;
	
	NS_BYTE iv[16]={0};
	NS_CONTEXT encctx = {
		{NSA_OBJECT_TYPE, &op_mode, sizeof(op_mode), FALSE, FALSE},
		{ NSA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	
	//memset(iv,0,sizeof(iv));
	// NS_BYTE *DataBuf = (unsigned char *)[strPadded UTF8String];
	// NSUInteger len = strlen((char *)DataBuf);
	// N_hex_dump(DataBuf, len, "data buf to send");
	NS_OBJECT oData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}
	};
	NS_OBJECT oEncryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE}
	};
	
	const void* tmpNDPadded = [ndPadded bytes];
	oData[1].pValue = malloc([ndPadded length]);
	memcpy(oData[1].pValue, tmpNDPadded, [ndPadded length]);
	oData[1].ulValueLen = (int)[ndPadded length];
	
	// 암호화 시작
	if( (ret = N_encrypt_init(&encctx,(NS_OBJECT_PTR)&oSecretKeyACONST)) != NSR_OK )
		printf("N_encrypt_init failed: %s\n",N_get_errmsg(ret));
	if( (ret = N_encrypt(&encctx, (NS_OBJECT_PTR)&oData,(NS_OBJECT_PTR)&oEncryptedData)) != NSR_OK )
		printf("N_encrypt failed: %s\n",N_get_errmsg(ret));
	NSData *ndDataToSend = [[NSData alloc] initWithBytes:oEncryptedData[1].pValue length:oEncryptedData[1].ulValueLen];
	
	// 공개키BASE64 + 암호화된값BASE64
	NSString *strReturn = [ndDataToSend base64Encoding];
	// NSLog(@"서버에 보내는 암호화된 값 BASE64: %@", strReturn);
	
	N_FreeGapString((unsigned char *)oSecretKeyACONST[1].pValue, oSecretKeyACONST[1].ulValueLen);
	N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
	N_FreeGapString((unsigned char *)oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen);
	N_clear_object((NS_OBJECT_PTR)&oEncryptedData, 2);
	N_clear_object((NS_OBJECT_PTR)&oData, 2);
	free(chrPtrTemp);
	
	// 3. 암호화된값 앞에 클라이언트 공개키 붙이기
#pragma mark - NFSTR옵션
	NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@%@%@", [_publicKeyOfMine base64Encoding], [[@"NF_STR" dataUsingEncoding:NSUTF8StringEncoding] base64Encoding], [[@"v12" dataUsingEncoding:NSUTF8StringEncoding] base64Encoding], strReturn];
	//NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@%@", [_publicKeyOfMine base64Encoding], [[@"v12" dataUsingEncoding:NSUTF8StringEncoding] base64Encoding], strReturn];
	plainText = nil;
	textData = nil;
	return encDataPlusPublickey;
}

// 숫자키패드 순열을 이용하여 평문값을 인덱스값으로 바꾸기
-(NSString*)convertPalinTextForNum:(NSString*)pPlainText {
    NSMutableString* retString = [NSMutableString string];
    
    NSMutableArray* newArr = [NSMutableArray array];
    for (int i = 0; i < _arrKeyNum.count; i++) {
        //[[_arrKeyNum objectAtIndex:i] integerValue]
        NSString* obj = [NSString stringWithFormat:@"%ld", (long)[[_arrKeyNum objectAtIndex:i] integerValue]];;
        [obj stringByReplacingOccurrencesOfString:@" " withString:@""];
        //NSLog(@"새로만든 어레이에 집어넣을 값 '%@'", obj);
        [newArr addObject:obj];
    }
    //NSLog(@"새로만든어레이: %@", newArr);
    
    //
    for (int i = 0; i < pPlainText.length; i++) {
        //NSLog(@"%d 번째 FOR 문", i);
        NSString* uservalue = [pPlainText substringWithRange:NSMakeRange(i, 1)];
        //NSLog(@"뽑아낸값: %@", uservalue);
        //NSLog(@"어레이에서 찾아낸 인덱스: %d", [newArr indexOfObject:uservalue]);
        //NSInteger indexFromArr = [newArr indexOfObject:uservalue];
        //NSLog(@"변환한값: %@", [newArr objectAtIndex:indexFromArr]);
        [retString appendFormat:@"%lu", (unsigned long)[newArr indexOfObject:uservalue]];
    }
    //NSLog(@"숫자키패드 순열을 이용하여 값컨버팅: %@", retString);
    return retString;
}

// 숫자키패드는 값을 순열을 이용하여 바꿔줘야 한다
- (NSString *)makeEncWithPadding:(NSData *)pPlainText {
    
    NSString *tmpText = [[NSString alloc] initWithData:pPlainText encoding:NSUTF8StringEncoding];
    tmpText = [self convertPalinTextForNum:tmpText];
    tmpText = [tmpText stringByReplacingOccurrencesOfString:@" " withString:@""];

    // 2. 암호화 작업
	NSString *encData = [self makeEncPadWithSeedKey:[tmpText dataUsingEncoding:NSUTF8StringEncoding] seedKey:_sharedKey];
    
#pragma mark - NFNUM옵션
    // 3. 암호화된값 앞에 클라이언트 공개키 붙이기
	// NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@%@", [_publicKeyOfMine base64Encoding], [[@"NF_NUM" dataUsingEncoding:NSUTF8StringEncoding] base64Encoding], encData];
    NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@", [_publicKeyOfMine base64Encoding], encData];
    return encDataPlusPublickey;
}

// 숫자키패드는 값을 순열을 이용하여 바꿔줘야 한다
- (NSString *)makeEncWithPadding2:(NSMutableArray *)pPlainText {
	
//	NSString *tmpText = [[NSString alloc] initWithData:pPlainText encoding:NSUTF8StringEncoding];
//	tmpText = [self convertPalinTextForNum:tmpText];
//	tmpText = [tmpText stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	
	
	
	NSString *plainText = @"";
	// 0. 암호화할 데이터
	//    NSString* plainText = [NSString stringWithFormat:@"%@", stringStore];
	for (id test in pPlainText) {
		NSData *a1 = [test AES256DecryptWithKey:[[PublicKeyDownloader sharedInstance] getServerPubkey] iv:[self getIV:[[PublicKeyDownloader sharedInstance] getServerPubkey]]];
		NSString *a = [[NSString alloc] initWithData:a1 encoding:NSUTF8StringEncoding];
		plainText = [plainText stringByAppendingString:a];
	}
	
	plainText = [plainText stringByReplacingOccurrencesOfString:@"₩" withString:@"\\"];
	
	NSData* textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
	
	// 2. 암호화 작업
	//NSString *encData = [self makeEncWithPadWithSeedKey:textData seedKey:_sharedKey];
	
	
	NSString *tmpText = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
	
	
	
	
	
	
	// 2. 암호화 작업
//	NSString *encData = [self makeEncPadWithSeedKey:[tmpText dataUsingEncoding:NSUTF8StringEncoding] seedKey:_sharedKey];
	
	
	
	
	
	
	
	
	//NSString *tmpText = [[NSString alloc] initWithData:pPlainText encoding:NSUTF8StringEncoding];
	
	NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_OBJECT oSecretKeyACONST = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}, };
	
	const void* bytes = [_sharedKey bytes];
	oSecretKeyA[1].pValue = malloc( [_sharedKey length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [_sharedKey length]);
	oSecretKeyA[1].ulValueLen = (int)[_sharedKey length];
	
	const void* bytes2 = [_sharedKey bytes];
	oSecretKeyACONST[1].pValue = malloc( [_sharedKey length] );
	memcpy(oSecretKeyACONST[1].pValue, bytes2, [_sharedKey length]);
	oSecretKeyACONST[1].ulValueLen = (int)[_sharedKey length];
	
	//NSLog(@"시드키: %@", [pSeedKey stringWithHexBytes1]);
	
	unsigned char *padString, *chrPtr;
	unsigned int ret =0, padStringSize;
	unsigned char *chrPtrTemp = (unsigned char *)malloc(oSecretKeyA[1].ulValueLen);
	memcpy(chrPtrTemp, oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
	chrPtr=&(chrPtrTemp[3]); /* 똑같은 패딩이 생기지 않도록 이 부분을 증가시킬 것이다 */
	
	// 사용자의 입력값 개수만큼 돌면서 패딩하자
	// 여기다 메로릭!!
	//NSArray *arrStringUserInput = [pPlainText splitToSize:1];
	NSArray *arrStringUserInput = [[KNStringutil sharedInstance] splitBy1Size:[tmpText dataUsingEncoding: NSUTF8StringEncoding]];
	NSMutableData* ndPadded = [[NSMutableData alloc] initWithCapacity:10];
	
	//NSLog(@"배열값: %@", arrStringUserInput);
	
	//for (int i = 0; i < [arrStringUserInput count] -1; i++) {
	for (int i = 0; i < [arrStringUserInput count]; i++) {
		(*chrPtr)++;
		// 패딩공간 만들어라 사이즈는 10을 넘지 않는다
		ret=N_GenPadString((unsigned char *)chrPtrTemp, oSecretKeyA[1].ulValueLen, 1, 10, &padString, &padStringSize);
		//printf("padString="); for(int j=0;j<padStringSize;j++){ printf("%d,",padString[j]); } printf("\n");
		
		{
			unsigned char *randStr;
			int randByte;
			randByte=(int)padString[0]&0xff;
			N_GenRandFromSeed( chrPtr, oSecretKeyA[1].ulValueLen, &randStr, randByte);
			/* 랜덤값 들어있는 배열생성 */
			for(int i2=0;i2<randByte;i2++) { randStr[i2]=randStr[i2]%10; }
			/* 특정 위치에 사용자 입력값 지정 */
			randStr[	(int)padString[1]&0xff]= [[arrStringUserInput objectAtIndex:i] intValue];
			/* 출력 */
			//printf("inputStr="); for(int i3=0;i3<randByte;i3++) { printf("%x,",randStr[i3]); } printf("\n");
			//NSData *padded = [NSData dataWithBytesNoCopy:randStr length:randByte];
			NSData *padded = [[NSData alloc] initWithBytes:randStr length:randByte];
			[ndPadded appendData:padded];
			
			N_FreeGapString(randStr, randByte);
		}
		
		N_FreeGapString(padString, padStringSize);
	} // 패딩 for
	
	NSString *strPadded = [NSString stringWithFormat:@"%@", [ndPadded stringWithHexBytes1]];
	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"00" withString:@"--"];
	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"0" withString:@""];
	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"--" withString:@"0"];
	//NSLog(@"패딩완료: %@", strPadded);
	
	NS_ULONG    op_mode = NSO_CTX_SEED_CFB,
	data_type = NSO_DATA;
	
	NS_BYTE iv[16]={0};
	NS_CONTEXT encctx = {
		{NSA_OBJECT_TYPE, &op_mode, sizeof(op_mode), FALSE, FALSE},
		{ NSA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	
	//memset(iv,0,sizeof(iv));
//	NS_BYTE *DataBuf = (unsigned char *)[strPadded UTF8String];
//	NSUInteger len = strlen((char *)DataBuf);
	// N_hex_dump(DataBuf, len, "data buf to send");
	NS_OBJECT oData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}
	};
	NS_OBJECT oEncryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE}
	};
	
	NSData *tmpTextData = [strPadded dataUsingEncoding:NSUTF8StringEncoding];
	const void* tmpstrPadded = [tmpTextData bytes];
	oData[1].pValue = malloc([tmpTextData length]);
	memcpy(oData[1].pValue, tmpstrPadded, [tmpTextData length]);
	oData[1].ulValueLen = [tmpTextData length];
	
	// 암호화 시작
	if( (ret = N_encrypt_init(&encctx,(NS_OBJECT_PTR)&oSecretKeyACONST)) != NSR_OK )
		printf("N_encrypt_init failed: %s\n",N_get_errmsg(ret));
	if( (ret = N_encrypt(&encctx, (NS_OBJECT_PTR)&oData,(NS_OBJECT_PTR)&oEncryptedData)) != NSR_OK )
		printf("N_encrypt failed: %s\n",N_get_errmsg(ret));
	NSData *ndDataToSend = [[NSData alloc] initWithBytes:oEncryptedData[1].pValue length:oEncryptedData[1].ulValueLen];
	
	// 공개키BASE64 + 암호화된값BASE64
	NSString *strReturn = [ndDataToSend base64Encoding];
	// NSLog(@"서버에 보내는 암호화된 값 BASE64: %@", strReturn);
	
	N_FreeGapString((unsigned char *)oSecretKeyACONST[1].pValue, oSecretKeyACONST[1].ulValueLen);
	N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
	N_FreeGapString((unsigned char *)oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen);
	N_clear_object((NS_OBJECT_PTR)&oEncryptedData, 2);
	N_clear_object((NS_OBJECT_PTR)&oData, 2);
	free(chrPtrTemp);
	
	
	
	
	
	
#pragma mark - NFNUM옵션
	// 3. 암호화된값 앞에 클라이언트 공개키 붙이기
	// NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@%@", [_publicKeyOfMine base64Encoding], [[@"NF_NUM" dataUsingEncoding:NSUTF8StringEncoding] base64Encoding], strReturn];
	NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@", [_publicKeyOfMine base64Encoding], strReturn];
	plainText = nil;
	textData = nil;
	return encDataPlusPublickey;
}

// 순차숫자키패드는 값을 순열을 이용하여 바꿔줘야 한다
- (NSString *)makeEncWithPadding3:(NSMutableArray *)pPlainText {
	
	//	NSString *tmpText = [[NSString alloc] initWithData:pPlainText encoding:NSUTF8StringEncoding];
	//	tmpText = [self convertPalinTextForNum:tmpText];
	//	tmpText = [tmpText stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	
	
	
	NSString *plainText = @"";
	// 0. 암호화할 데이터
	//    NSString* plainText = [NSString stringWithFormat:@"%@", stringStore];
	for (id test in pPlainText) {
		NSData *a1 = [test AES256DecryptWithKey:[[PublicKeyDownloader sharedInstance] getServerPubkey] iv:[self getIV:[[PublicKeyDownloader sharedInstance] getServerPubkey]]];
		NSString *a = [[NSString alloc] initWithData:a1 encoding:NSUTF8StringEncoding];
		plainText = [plainText stringByAppendingString:a];
	}
	
	plainText = [plainText stringByReplacingOccurrencesOfString:@"₩" withString:@"\\"];
	
	//////////////////////////////////////////////////////////////////////////////////////
	NSMutableString* retString = [NSMutableString string];
	
	NSMutableArray* newArr = [NSMutableArray array];
	for (int i = 0; i < _arrKeyNum.count; i++) {
		//[[_arrKeyNum objectAtIndex:i] integerValue]
		NSString* obj = [NSString stringWithFormat:@"%ld", (long)[[_arrKeyNum objectAtIndex:i] integerValue]];;
		[obj stringByReplacingOccurrencesOfString:@" " withString:@""];
		//NSLog(@"새로만든 어레이에 집어넣을 값 '%@'", obj);
		[newArr addObject:obj];
	}
	//NSLog(@"새로만든어레이: %@", newArr);
	
	//
	for (int i = 0; i < plainText.length; i++) {
		//NSLog(@"%d 번째 FOR 문", i);
		NSString* uservalue = [plainText substringWithRange:NSMakeRange(i, 1)];
		//NSLog(@"뽑아낸값: %@", uservalue);
		//NSLog(@"어레이에서 찾아낸 인덱스: %d", [newArr indexOfObject:uservalue]);
		//NSInteger indexFromArr = [newArr indexOfObject:uservalue];
		//NSLog(@"변환한값: %@", [newArr objectAtIndex:indexFromArr]);
		[retString appendFormat:@"%lu", (unsigned long)[newArr indexOfObject:uservalue]];
	}
	//////////////////////////////////////////////////////////////////////////////////////
	
	// 2. 암호화 작업
	//NSString *encData = [self makeEncWithPadWithSeedKey:textData seedKey:_sharedKey];
	
	NSLog(@"plainText ====== %@", retString);
	NSData* textData = [retString dataUsingEncoding:NSUTF8StringEncoding];
	NSString *tmpText = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
	
	
	
	
	
	
	// 2. 암호화 작업
	//	NSString *encData = [self makeEncPadWithSeedKey:[tmpText dataUsingEncoding:NSUTF8StringEncoding] seedKey:_sharedKey];
	
	
	
	
	
	
	
	
	//NSString *tmpText = [[NSString alloc] initWithData:pPlainText encoding:NSUTF8StringEncoding];
	
	NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_OBJECT oSecretKeyACONST = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}, };
	
	const void* bytes = [_sharedKey bytes];
	oSecretKeyA[1].pValue = malloc( [_sharedKey length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [_sharedKey length]);
	oSecretKeyA[1].ulValueLen = (int)[_sharedKey length];
	
	const void* bytes2 = [_sharedKey bytes];
	oSecretKeyACONST[1].pValue = malloc( [_sharedKey length] );
	memcpy(oSecretKeyACONST[1].pValue, bytes2, [_sharedKey length]);
	oSecretKeyACONST[1].ulValueLen = (int)[_sharedKey length];
	
	//NSLog(@"시드키: %@", [pSeedKey stringWithHexBytes1]);
	
	unsigned char *padString, *chrPtr;
	unsigned int ret =0, padStringSize;
	unsigned char *chrPtrTemp = (unsigned char *)malloc(oSecretKeyA[1].ulValueLen);
	memcpy(chrPtrTemp, oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
	chrPtr=&(chrPtrTemp[3]); /* 똑같은 패딩이 생기지 않도록 이 부분을 증가시킬 것이다 */
	
	// 사용자의 입력값 개수만큼 돌면서 패딩하자
	// 여기다 메로릭!!
	//NSArray *arrStringUserInput = [pPlainText splitToSize:1];
	NSArray *arrStringUserInput = [[KNStringutil sharedInstance] splitBy1Size:[tmpText dataUsingEncoding: NSUTF8StringEncoding]];
	NSMutableData* ndPadded = [[NSMutableData alloc] initWithCapacity:10];
	
	//NSLog(@"배열값: %@", arrStringUserInput);
	
	//for (int i = 0; i < [arrStringUserInput count] -1; i++) {
	for (int i = 0; i < [arrStringUserInput count]; i++) {
		(*chrPtr)++;
		// 패딩공간 만들어라 사이즈는 10을 넘지 않는다
		ret=N_GenPadString((unsigned char *)chrPtrTemp, oSecretKeyA[1].ulValueLen, 1, 10, &padString, &padStringSize);
		//printf("padString="); for(int j=0;j<padStringSize;j++){ printf("%d,",padString[j]); } printf("\n");
		
		{
			unsigned char *randStr;
			int randByte;
			randByte=(int)padString[0]&0xff;
			N_GenRandFromSeed( chrPtr, oSecretKeyA[1].ulValueLen, &randStr, randByte);
			/* 랜덤값 들어있는 배열생성 */
			for(int i2=0;i2<randByte;i2++) { randStr[i2]=randStr[i2]%10; }
			/* 특정 위치에 사용자 입력값 지정 */
			randStr[	(int)padString[1]&0xff]= [[arrStringUserInput objectAtIndex:i] intValue];
			/* 출력 */
			//printf("inputStr="); for(int i3=0;i3<randByte;i3++) { printf("%x,",randStr[i3]); } printf("\n");
			//NSData *padded = [NSData dataWithBytesNoCopy:randStr length:randByte];
			NSData *padded = [[NSData alloc] initWithBytes:randStr length:randByte];
			[ndPadded appendData:padded];
			
			N_FreeGapString(randStr, randByte);
		}
		
		N_FreeGapString(padString, padStringSize);
	} // 패딩 for
	
	NSString *strPadded = [NSString stringWithFormat:@"%@", [ndPadded stringWithHexBytes1]];
	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"00" withString:@"--"];
	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"0" withString:@""];
	strPadded = [strPadded stringByReplacingOccurrencesOfString:@"--" withString:@"0"];
	//NSLog(@"패딩완료: %@", strPadded);
	
	NS_ULONG    op_mode = NSO_CTX_SEED_CFB,
	data_type = NSO_DATA;
	
	NS_BYTE iv[16]={0};
	NS_CONTEXT encctx = {
		{NSA_OBJECT_TYPE, &op_mode, sizeof(op_mode), FALSE, FALSE},
		{ NSA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	
	//memset(iv,0,sizeof(iv));
	//	NS_BYTE *DataBuf = (unsigned char *)[strPadded UTF8String];
	//	NSUInteger len = strlen((char *)DataBuf);
	// N_hex_dump(DataBuf, len, "data buf to send");
	NS_OBJECT oData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}
	};
	NS_OBJECT oEncryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE}
	};
	
	NSData *tmpTextData = [strPadded dataUsingEncoding:NSUTF8StringEncoding];
	const void* tmpstrPadded = [tmpTextData bytes];
	oData[1].pValue = malloc([tmpTextData length]);
	memcpy(oData[1].pValue, tmpstrPadded, [tmpTextData length]);
	oData[1].ulValueLen = [tmpTextData length];
	
	// 암호화 시작
	if( (ret = N_encrypt_init(&encctx,(NS_OBJECT_PTR)&oSecretKeyACONST)) != NSR_OK )
		printf("N_encrypt_init failed: %s\n",N_get_errmsg(ret));
	if( (ret = N_encrypt(&encctx, (NS_OBJECT_PTR)&oData,(NS_OBJECT_PTR)&oEncryptedData)) != NSR_OK )
		printf("N_encrypt failed: %s\n",N_get_errmsg(ret));
	NSData *ndDataToSend = [[NSData alloc] initWithBytes:oEncryptedData[1].pValue length:oEncryptedData[1].ulValueLen];
	
	// 공개키BASE64 + 암호화된값BASE64
	NSString *strReturn = [ndDataToSend base64Encoding];
	// NSLog(@"서버에 보내는 암호화된 값 BASE64: %@", strReturn);
	
	N_FreeGapString((unsigned char *)oSecretKeyACONST[1].pValue, oSecretKeyACONST[1].ulValueLen);
	N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
	N_FreeGapString((unsigned char *)oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen);
	N_clear_object((NS_OBJECT_PTR)&oEncryptedData, 2);
	N_clear_object((NS_OBJECT_PTR)&oData, 2);
	free(chrPtrTemp);
	
	
	
	
	
	
#pragma mark - NFNUM옵션
	// 3. 암호화된값 앞에 클라이언트 공개키 붙이기
	// NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@%@", [_publicKeyOfMine base64Encoding], [[@"NF_NUM" dataUsingEncoding:NSUTF8StringEncoding] base64Encoding], strReturn];
	NSString *encDataPlusPublickey = [NSString stringWithFormat:@"%@%@", [_publicKeyOfMine base64Encoding], strReturn];
	plainText = nil;
	textData = nil;
	return encDataPlusPublickey;
}

// 암호화하지만, 앞부분에 공개키를 붙이지 않고 순수 암호화된 값을 리턴
- (NSString *)makeEncNoPadWithSeedkey:(NSData *)pPlainText {
    
    NSString *tmpText = [[NSString alloc] initWithData:pPlainText encoding:NSUTF8StringEncoding];
    
	NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_OBJECT oSecretKeyACONST = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}, };
	
	NS_RV   ret;
	
	//NSLog(@"생성된 시드키: %@", [pSeedKey stringWithHexBytes1]);
	
	const void* bytes = [_sharedKey bytes];
	oSecretKeyA[1].pValue = malloc( [_sharedKey length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [_sharedKey length]);
	oSecretKeyA[1].ulValueLen = (int)[_sharedKey length];
	
	const void* bytes2 = [_sharedKey bytes];
	oSecretKeyACONST[1].pValue = malloc( [_sharedKey length] );
	memcpy(oSecretKeyACONST[1].pValue, bytes2, [_sharedKey length]);
	oSecretKeyACONST[1].ulValueLen = (int)[_sharedKey length];
	
	//NSLog(@"암호 대칭키: %@", [_sharedKey stringWithHexBytes1]);
	
	NS_ULONG    op_mode = NSO_CTX_SEED_CFB,
	data_type = NSO_DATA;
	
	NS_BYTE iv[16]={0};
	NS_CONTEXT encctx = {
		{NSA_OBJECT_TYPE, &op_mode, sizeof(op_mode), FALSE, FALSE},
		{ NSA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	
	//memset(iv,0,sizeof(iv));
    NS_BYTE *DataBuf = (unsigned char *)[tmpText UTF8String];
	NSUInteger len = strlen((char *)DataBuf);
	// N_hex_dump(DataBuf, len, "data buf to send");
	NS_OBJECT oData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, DataBuf, (int)len, TRUE, FALSE}
	};
	NS_OBJECT oEncryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE}
	};
	
	// 암호화 시작
	if( (ret = N_encrypt_init(&encctx,(NS_OBJECT_PTR)&oSecretKeyACONST)) != NSR_OK )
		printf("N_encrypt_init failed: %s\n",N_get_errmsg(ret));
	if( (ret = N_encrypt(&encctx, (NS_OBJECT_PTR)&oData,(NS_OBJECT_PTR)&oEncryptedData)) != NSR_OK )
		printf("N_encrypt failed: %s\n",N_get_errmsg(ret));
	// N_hex_dump(oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen, "encrypted data");
	NSData *ndDataToSend = [[NSData alloc] initWithBytes:oEncryptedData[1].pValue length:oEncryptedData[1].ulValueLen];
	
	// 암호화된값BASE64
	NSString *strReturn = [[NSString alloc] initWithFormat:@"%@", [ndDataToSend base64Encoding] ];
    //    NSString *strReturn = [[NSString alloc] initWithData:ndDataToSend encoding:NSUTF8StringEncoding];
	//NSLog(@"서버에 보내는 암호화된 값 BASE64: %@", strReturn);
	
    N_FreeGapString((unsigned char *)oSecretKeyACONST[1].pValue, oSecretKeyACONST[1].ulValueLen);
    N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
    N_FreeGapString((unsigned char *)oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen);
	
	return strReturn;
}

// 암호화하지만, 앞부분에 공개키를 붙이지 않고 순수 암호화된 값을 리턴
- (NSString *)makeEncNoPadWithSeedkey2:(NSMutableArray *)pPlainText {
	NSString *plainText = @"";
	// 0. 암호화할 데이터
	//    NSString* plainText = [NSString stringWithFormat:@"%@", stringStore];
	for (id test in pPlainText) {
		NSData *a1 = [test AES256DecryptWithKey:[[PublicKeyDownloader sharedInstance] getServerPubkey] iv:[self getIV:[[PublicKeyDownloader sharedInstance] getServerPubkey]]];
		NSString *a = [[NSString alloc] initWithData:a1 encoding:NSUTF8StringEncoding];
		plainText = [plainText stringByAppendingString:a];
	}
	
	plainText = [plainText stringByReplacingOccurrencesOfString:@"₩" withString:@"\\"];
	
	NSData* textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];

	// 2. 암호화 작업
	//NSString *encData = [self makeEncWithPadWithSeedKey:textData seedKey:_sharedKey];
	
	
	//NSString *tmpText = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
	
	NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_OBJECT oSecretKeyACONST = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}, };
	
	NS_RV   ret;
	
	//NSLog(@"생성된 시드키: %@", [pSeedKey stringWithHexBytes1]);
	
	const void* bytes = [_sharedKey2 bytes];
	oSecretKeyA[1].pValue = malloc( [_sharedKey2 length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [_sharedKey2 length]);
	oSecretKeyA[1].ulValueLen = (int)[_sharedKey2 length];
	
	const void* bytes2 = [_sharedKey2 bytes];
	oSecretKeyACONST[1].pValue = malloc( [_sharedKey2 length] );
	memcpy(oSecretKeyACONST[1].pValue, bytes2, [_sharedKey2 length]);
	oSecretKeyACONST[1].ulValueLen = (int)[_sharedKey2 length];
	
	//NSLog(@"암호 대칭키: %@", [_sharedKey stringWithHexBytes1]);
	
	NS_ULONG    op_mode = NSO_CTX_SEED_CFB,
	data_type = NSO_DATA;
	
	NS_BYTE iv[16]={0};
	NS_CONTEXT encctx = {
		{NSA_OBJECT_TYPE, &op_mode, sizeof(op_mode), FALSE, FALSE},
		{ NSA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	
	//memset(iv,0,sizeof(iv));
	// NS_BYTE *DataBuf = (unsigned char *)[plainText UTF8String];
	// NSUInteger len = strlen((char *)DataBuf);
	// N_hex_dump(DataBuf, len, "data buf to send");
	NS_OBJECT oData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}
	};
	NS_OBJECT oEncryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE}
	};
	
	const void* tmptextData = [textData bytes];
	oData[1].pValue = malloc([textData length]);
	memcpy(oData[1].pValue, tmptextData, [textData length]);
	oData[1].ulValueLen = [textData length];
	
	// 암호화 시작
	if( (ret = N_encrypt_init(&encctx,(NS_OBJECT_PTR)&oSecretKeyACONST)) != NSR_OK )
		printf("N_encrypt_init failed: %s\n",N_get_errmsg(ret));
	if( (ret = N_encrypt(&encctx, (NS_OBJECT_PTR)&oData,(NS_OBJECT_PTR)&oEncryptedData)) != NSR_OK )
		printf("N_encrypt failed: %s\n",N_get_errmsg(ret));
	// N_hex_dump(oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen, "encrypted data");
	NSData *ndDataToSend = [[NSData alloc] initWithBytes:oEncryptedData[1].pValue length:oEncryptedData[1].ulValueLen];
	
	// 암호화된값BASE64
	NSString *strReturn = [[NSString alloc] initWithFormat:@"%@", [ndDataToSend base64Encoding] ];
	//    NSString *strReturn = [[NSString alloc] initWithData:ndDataToSend encoding:NSUTF8StringEncoding];
	//NSLog(@"서버에 보내는 암호화된 값 BASE64: %@", strReturn);
	
	N_FreeGapString((unsigned char *)oSecretKeyACONST[1].pValue, oSecretKeyACONST[1].ulValueLen);
	N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
	N_FreeGapString((unsigned char *)oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen);
	N_clear_object((NS_OBJECT_PTR)&oData, 2);
	N_clear_object((NS_OBJECT_PTR)&oEncryptedData, 2);
	
	plainText = nil;
	return strReturn;
}

// 암호화하지만, 앞부분에 공개키를 붙이지 않고 순수 암호화된 값을 리턴
- (NSString *)makeEncNoPadWithSeedkey3:(NSMutableArray *)pPlainText {
	NSString *plainText = @"";
	// 0. 암호화할 데이터
	//    NSString* plainText = [NSString stringWithFormat:@"%@", stringStore];
	for (id test in pPlainText) {
		NSData *a1 = [test AES256DecryptWithKey:[[PublicKeyDownloader sharedInstance] getServerPubkey] iv:[self getIV:[[PublicKeyDownloader sharedInstance] getServerPubkey]]];
		NSString *a = [[NSString alloc] initWithData:a1 encoding:NSUTF8StringEncoding];
		plainText = [plainText stringByAppendingString:a];
	}
	
	plainText = [plainText stringByReplacingOccurrencesOfString:@"₩" withString:@"\\"];
	plainText = [plainText stringByReplacingOccurrencesOfString:@" " withString:@""];
	//NSLog(@"aaaaa : %@", plainText);
	NSArray *arr = [self getKeypadArray2];
	//NSLog(@"aaaaa : %d", [plainText length]);
	//NSLog( @"arr %@", arr );
	NSString *pl = @"";
	for (int i = 0; i < [plainText length]; i++) {
		pl = [pl stringByAppendingString:arr[[[plainText substringWithRange:NSMakeRange(i, 1)] intValue]]];
	}
	pl = [pl stringByReplacingOccurrencesOfString:@" " withString:@""];
	//NSLog(@"bbbbb %@", pl);
	//NSData* textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
	
	// 2. 암호화 작업
	//NSString *encData = [self makeEncWithPadWithSeedKey:textData seedKey:_sharedKey];
	
	
	//NSString *tmpText = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
	
	NS_ULONG skey_type = NSO_SECRET_KEY;
	NS_OBJECT oSecretKeyA = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},	};
	
	NS_OBJECT oSecretKeyACONST = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}, };
	
	NS_RV   ret;
	
	//NSLog(@"생성된 시드키: %@", [pSeedKey stringWithHexBytes1]);
	
	const void* bytes = [_sharedKey2 bytes];
	oSecretKeyA[1].pValue = malloc( [_sharedKey2 length] );
	memcpy(oSecretKeyA[1].pValue, bytes, [_sharedKey2 length]);
	oSecretKeyA[1].ulValueLen = (int)[_sharedKey2 length];
	
	const void* bytes2 = [_sharedKey2 bytes];
	oSecretKeyACONST[1].pValue = malloc( [_sharedKey2 length] );
	memcpy(oSecretKeyACONST[1].pValue, bytes2, [_sharedKey2 length]);
	oSecretKeyACONST[1].ulValueLen = (int)[_sharedKey2 length];
	
	//NSLog(@"암호 대칭키: %@", [_sharedKey stringWithHexBytes1]);
	
	NS_ULONG    op_mode = NSO_CTX_SEED_CFB,
	data_type = NSO_DATA;
	
	NS_BYTE iv[16]={0};
	NS_CONTEXT encctx = {
		{NSA_OBJECT_TYPE, &op_mode, sizeof(op_mode), FALSE, FALSE},
		{ NSA_SEED_IV, iv, 16, TRUE, FALSE}
	};
	
	//memset(iv,0,sizeof(iv));
	// NS_BYTE *DataBuf = (unsigned char *)[pl UTF8String];
	// NSUInteger len = strlen((char *)DataBuf);
	// N_hex_dump(DataBuf, len, "data buf to send");
	NS_OBJECT oData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}
	};
	NS_OBJECT oEncryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE}
	};
	
	NSData *NDpl = [pl dataUsingEncoding:NSUTF8StringEncoding];
	const void* tmpNDPL = [NDpl bytes];
	oData[1].pValue = malloc([NDpl length]);
	memcpy(oData[1].pValue, tmpNDPL, [NDpl length]);
	oData[1].ulValueLen = [NDpl length];
	
	// 암호화 시작
	if( (ret = N_encrypt_init(&encctx,(NS_OBJECT_PTR)&oSecretKeyACONST)) != NSR_OK )
		printf("N_encrypt_init failed: %s\n",N_get_errmsg(ret));
	if( (ret = N_encrypt(&encctx, (NS_OBJECT_PTR)&oData,(NS_OBJECT_PTR)&oEncryptedData)) != NSR_OK )
		printf("N_encrypt failed: %s\n",N_get_errmsg(ret));
	// N_hex_dump(oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen, "encrypted data");
	NSData *ndDataToSend = [[NSData alloc] initWithBytes:oEncryptedData[1].pValue length:oEncryptedData[1].ulValueLen];
	
	// 암호화된값BASE64
	NSString *strReturn = [[NSString alloc] initWithFormat:@"%@", [ndDataToSend base64Encoding] ];
	//    NSString *strReturn = [[NSString alloc] initWithData:ndDataToSend encoding:NSUTF8StringEncoding];
	//NSLog(@"서버에 보내는 암호화된 값 BASE64: %@", strReturn);
	
	N_FreeGapString((unsigned char *)oSecretKeyACONST[1].pValue, oSecretKeyACONST[1].ulValueLen);
	N_FreeGapString((unsigned char *)oSecretKeyA[1].pValue, oSecretKeyA[1].ulValueLen);
	N_FreeGapString((unsigned char *)oEncryptedData[1].pValue, oEncryptedData[1].ulValueLen);
	N_clear_object((NS_OBJECT_PTR)&oData, 2);
	N_clear_object((NS_OBJECT_PTR)&oEncryptedData, 2);
	
	plainText = nil;
	return strReturn;
}


// 패딩없는 암호화값 복호화하여 리턴
- (NSString *)makeDecNoPadWithSeedkey:(NSString *)pPlainText {
	//    [self makeSharedKey];
	
	int nMode = NSO_CTX_SEED_CFB;
	
	char *SEEDKey = (char *)[_sharedKey2 bytes];
	int nSEEDKeyLen = (int)[_sharedKey2 length];
	
	NSData *dataEncrypted = [NSData dataWithBase64EncodedString:pPlainText];
	
	char *EncryptedData = (char *)[dataEncrypted bytes];
	int nEcnDataLen = (int)[dataEncrypted length];
	
	//char *szDecData;
	NSData *ndDataToSend = nil;
	
	NS_ULONG seed_cbc_pad = NSO_CTX_SEED_CBC_PAD,
	seed_cbc = NSO_CTX_SEED_CBC,
	seed_ofb = NSO_CTX_SEED_OFB,
	seed_cfb = NSO_CTX_SEED_CFB,
	seed_ecb = NSO_CTX_SEED_ECB,
	skey_type = NSO_SECRET_KEY,
	data_type = NSO_DATA;
	
	NS_CONTEXT encctx = {
		{NSA_OBJECT_TYPE, &seed_cbc_pad, sizeof(seed_cbc_pad), FALSE, FALSE}
	};
	NS_OBJECT oEncryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, FALSE, FALSE}
	};
	NS_OBJECT oDecryptedData = {
		{NSA_OBJECT_TYPE, &data_type, sizeof(data_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE}
	};
	NS_OBJECT oSecretKey = {
		{NSA_OBJECT_TYPE, &skey_type, sizeof(skey_type), FALSE, FALSE},
		{NSA_VALUE, NULL, 0, TRUE, FALSE},
	};
	int ret = 0;
	
	/* NSAFER Crypto Start !*/
	// start 직후 기본적으로 NSS_MODULE_APPROVAL 상태이다.
	N_safer_start();
	//다음과 같이 NSS_MODULE_DISAPPROVAL 상태로 변경이 가능하다.
	//N_change_state(NSS_MODULE_DISAPPROVAL);
	
	if(SEEDKey == NULL || EncryptedData == NULL) {
		NSLog(@"복호화오류0");
		return nil;
		//return -1;
	}
	
	if(SEEDKey != NULL){
		oSecretKey[1].ulValueLen = nSEEDKeyLen;
		oSecretKey[1].pValue = (char*)calloc(1,oSecretKey[1].ulValueLen);
		memcpy(oSecretKey[1].pValue, SEEDKey, oSecretKey[1].ulValueLen);
	}
	if(oSecretKey[1].ulValueLen > NS_SEED_BLOCK_BYTE_LEN)
		oSecretKey[1].ulValueLen = NS_SEED_BLOCK_BYTE_LEN;
	
	if(EncryptedData != NULL){
		oEncryptedData[1].ulValueLen = nEcnDataLen;
		oEncryptedData[1].pValue = (char*)calloc(1,oEncryptedData[1].ulValueLen);
		memcpy(oEncryptedData[1].pValue, EncryptedData, oEncryptedData[1].ulValueLen);
	}
	
	if(nMode == 1){
		encctx[0].pValue = &seed_ecb;
	}else if(nMode == 2){
		encctx[0].pValue = &seed_cbc;
	}else if(nMode == 3){
		encctx[0].pValue = &seed_cbc_pad;
	}else if(nMode == 4){
		encctx[0].pValue = &seed_ofb;
	}else if(nMode == 5){
		encctx[0].pValue = &seed_cfb;
	}else{
		NSLog(@"복호화오류1");
		goto err;
	}
	
	if( (ret = N_decrypt_init(&encctx,
							  (NS_OBJECT_PTR)&oSecretKey)) != NSR_OK )
	{
		NSLog(@"복호화오류2");
		goto err;
	}
	
	if( (ret = N_decrypt(&encctx,
						 (NS_OBJECT_PTR)&oEncryptedData,
						 (NS_OBJECT_PTR)&oDecryptedData)) != NSR_OK )
	{
		NSLog(@"복호화오류3");
		goto err;
	}
	
	if( (oDecryptedData[1].pValue != NULL)
	   && (oDecryptedData[1].ulValueLen > 0) )
	{
		ndDataToSend = [[NSData alloc] initWithBytes:oDecryptedData[1].pValue
											  length:oDecryptedData[1].ulValueLen];
		//        NSLog(@"복호화완료: %d", [ndDataToSend length]);
		//(*szDecData) = (char*)calloc(1,oDecryptedData[1].ulValueLen);
		//memcpy((*szDecData), oDecryptedData[1].pValue, oDecryptedData[1].ulValueLen);
	}
	
err:
	N_clear_object((NS_OBJECT_PTR)&oSecretKey, 2);
	N_clear_object((NS_OBJECT_PTR)&oEncryptedData, 2);
	N_clear_object((NS_OBJECT_PTR)&oDecryptedData, 2);
	
	NSString *resultForPlain = [[NSString alloc] initWithData:ndDataToSend encoding:NSUTF8StringEncoding];
	
	return resultForPlain;
}

- (NSData *) encyptWithAES:(NSData *)pPlainText pubkey:(NSString*)pPubkey {
    PublicKeyDownloader *pd = [PublicKeyDownloader sharedInstance];
	NSString *strPubkeyBase64 = [pd getServerPubkey];
    NSString *key = [self genKey:strPubkeyBase64];
    NSString *plainText = [[NSString alloc] initWithData:pPlainText encoding:NSUTF8StringEncoding];
    
	NSData *encryptedData = [[plainText dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key iv:[self getIV:strPubkeyBase64]];
    return encryptedData;
}

- (NSData *) encyptWithAES2:(NSMutableArray *)pPlainText pubkey:(NSString*)pPubkey {
	
	NSString *plainText = @"";
	// 0. 암호화할 데이터
	//    NSString* plainText = [NSString stringWithFormat:@"%@", stringStore];
	for (id test in pPlainText) {
		NSData *a1 = [test AES256DecryptWithKey:[[PublicKeyDownloader sharedInstance] getServerPubkey] iv:[self getIV:[[PublicKeyDownloader sharedInstance] getServerPubkey]]];
		NSString *a = [[NSString alloc] initWithData:a1 encoding:NSUTF8StringEncoding];
		plainText = [plainText stringByAppendingString:a];
	}
	
	plainText = [plainText stringByReplacingOccurrencesOfString:@"₩" withString:@"\\"];
	
	NSData* textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
	
	// 2. 암호화 작업
	//NSString *encData = [self makeEncWithPadWithSeedKey:textData seedKey:_sharedKey];
	
	
//	NSString *tmpText = [[NSString alloc] initWithData:textData encoding:NSUTF8StringEncoding];
	
	PublicKeyDownloader *pd = [PublicKeyDownloader sharedInstance];
	NSString *strPubkeyBase64 = [pd getServerPubkey];
	NSString *key = [self genKey:strPubkeyBase64];

	NSData *encryptedData = [textData AES256EncryptWithKey:key iv:[self getIV:strPubkeyBase64]];
//	NSData *encryptedData = [[NSData alloc] init];
//	tmpText = nil;
	textData = nil;
	plainText = nil;
	return encryptedData;
}

#pragma mark - 2.5 키생성
- (NSString *) genKey:(NSString *)pubKey {
    //협력업체코드
    NSString *coworkerCode = @"95428f9e76bc7c50532c582d097b23b7";
    //엔필터 공개코드
    NSString *nFilterPubkey = [[NSString alloc] initWithData:[self genNFilterPubkeyWithKey:pubKey] encoding:NSUTF8StringEncoding];
    //엔필터 비밀코드
    NSString *nFilterSeckey = [self genNFilterSeckeyWithKey:pubKey];
    //    NSLog(@"엔필터 공개코드 : %@", nFilterPubkey);
    //    NSLog(@"엔필터 비밀코드 : %@", nFilterSeckey);
    
    // 1. 엔필터 공개코드와 엔필터 비밀코드 XOR
    NSData *tmpKey2 = [self XOR:nFilterPubkey Key:nFilterSeckey];
    // 2. 1과 2의 값 XOR
    NSData *tmpKey3 = [self
                       XOR: coworkerCode
                       Key: [[NSString alloc] initWithData:tmpKey2 encoding:NSUTF8StringEncoding]];
    
    NSString *finalkey = [self md5:tmpKey3];
    //    NSLog(@"최종키 : %@", finalkey);
    
    return finalkey;
}

#pragma mark - 2.3 공개코드 생성
- (NSData *) genNFilterPubkeyWithKey:(NSString *)pubKey {
    NSString *md5Pubkey = [self md5:[pubKey dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *nFilterPubKey = [self XOR:md5Pubkey Key:pubKey];
    return nFilterPubKey;
}

#pragma mark - 2.4 비밀코드 생성
- (NSString *) genNFilterSeckeyWithKey:(NSString *)pubKey {
    
    // 1. 첫번째~네번째 조각 AND
    NSString *andKey1 = [self AND:[pubKey substringWithRange:NSMakeRange(0, 8)] Key:[pubKey substringWithRange:NSMakeRange(8, 8)]];
    NSString *andKey2 = [self AND:[pubKey substringWithRange:NSMakeRange(16, 8)] Key:[pubKey substringWithRange:NSMakeRange(24, 8)]];
    NSString *andkey = [self AND:andKey1 Key:andKey2];
    
    // 2. 다섯번째~여덟번째 조각 OR
    NSString *orkey1 = [self OR:[pubKey substringWithRange:NSMakeRange(32, 8)] Key:[pubKey substringWithRange:NSMakeRange(40, 8)]];
    NSString *orkey2 = [self OR:[pubKey substringWithRange:NSMakeRange(48, 8)] Key:[pubKey substringWithRange:NSMakeRange(56, 8)]];
    NSString *orkey = [self OR:orkey1 Key:orkey2];
    
    // 3. 1과 2번의 값을 XOR
    NSData *xorKey = [self XOR:andkey Key:orkey];
    
    // 4. 3의 값을 md5
    NSString *secKey = [self md5:xorKey];
    
    return secKey;
}

#pragma mark - XOR 샘플
- (NSData*) XOR:(NSString *)data Key:(NSString*)key {
    
    NSMutableData *result = [[data dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    char *dataPtr = (char *) [result mutableBytes];
    char *keyData = (char *) [[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    
    char *keyPtr = keyData;
    int keyIndex = 0;
    
    for (int x = 0; x < [data length]; x++)
    {
        *dataPtr = *dataPtr ^ *keyPtr;
        dataPtr++;
        keyPtr++;
        
        if (++keyIndex == [key length])
            keyIndex = 0, keyPtr = keyData;
    }
    
    return result;
}

#pragma mark - AND 샘플
- (NSString*) AND:(NSString*)input Key:(NSString*)key {
    
	NSMutableString* output = [[NSMutableString alloc] init];
    
	unsigned int vlen = (int)[input length];
	unsigned int klen = (int)[key length];
	unsigned int k = 0;
	
	for (int i = 0; i < vlen; i++) {
		unichar c = [input characterAtIndex:i] & [key characterAtIndex:k];
		[output appendString:[NSString stringWithFormat:@"%C", c]];
		
		k = (++k < klen ? k : 0);
	}
	
	NSString* final = [[NSString alloc] initWithString:output];
    
	return final;
}

#pragma mark - OR 샘플
- (NSString*) OR:(NSString*)input Key:(NSString*)key {
    
	NSMutableString* output = [[NSMutableString alloc] init];
    
	unsigned int vlen = (int)[input length];
	unsigned int klen = (int)[key length];
	unsigned int k = 0;
	
	for (int i = 0; i < vlen; i++) {
		unichar c = [input characterAtIndex:i] | [key characterAtIndex:k];
		[output appendString:[NSString stringWithFormat:@"%C", c]];
		
		k = (++k < klen ? k : 0);
	}
	
	NSString* final = [[NSString alloc] initWithString:output];
	return final;
}

#pragma mark - MD5 해시 샘플
- (NSString*) md5:(NSData*)srcStr {
    const char *cStr = (const char *)[srcStr bytes];
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, (int)[srcStr length], digest );
	NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				   digest[0], digest[1],
				   digest[2], digest[3],
				   digest[4], digest[5],
				   digest[6], digest[7],
				   digest[8], digest[9],
				   digest[10], digest[11],
				   digest[12], digest[13],
				   digest[14], digest[15]];
	return s;
}

#pragma mark - iv 생성 함수
- (NSString*) getIV:(NSString*)val {
	NSData* decodeVal = [[NSMutableData alloc] initWithBase64EncodedString:val];
	return [self md5:decodeVal];
}

@end
