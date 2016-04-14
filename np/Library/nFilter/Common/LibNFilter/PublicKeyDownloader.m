//
//  PublicKeyDownloader.m
//  nFilterModuleBasic
//
//  Created by 발팀 개 on 10. 3. 10..
//  Copyright 2010 NSHC. All rights reserved.
//

#import "PublicKeyDownloader.h"
#import "NSStringKNAdditions.h"

static PublicKeyDownloader *instance = nil;
@implementation PublicKeyDownloader

+ (PublicKeyDownloader *)sharedInstance {
	if (instance == nil) {
		instance = [[PublicKeyDownloader alloc] init];
	}
	return instance;
}

- (id)init {
	_serverkey = @"";
	return self;
}

- (void)setServerPublickeyURL:(NSString *)pXmlURL {
	if (pXmlURL == nil) {

		_serverkey = nil;
		_serverkey = [[NSString alloc] initWithFormat:
									@"MDIwGhMABBYCAqv0p592ZSkH5+f9RJrvTSlnBrEFBBSWvZfHXJGf9k2VJD+Ujk0ZbM/fkA=="];
									// @"MDIwGhMABBYCBPAGls2rN4qgQ/LfD0PbqTxaZqZrBBQw0BlWfrVf37PJd0zoXWV1yqw2xA=="];
		//NSLog(@"서버공개키 NIL 지정 - 기본값: %@", _serverkey);
		return;
	}
	
	// 서버로부터 공개키 긁어오기
	NSURL *url = [NSURL URLWithString:pXmlURL];
	NSData* dataServerkey = [[NSData alloc] initWithContentsOfURL:url];
	NSString* strServerkey = [[NSString alloc] initWithData:dataServerkey encoding:NSUTF8StringEncoding];

	NSArray* arr = [strServerkey componentsSeparatedByString:@"<pub desc=\"base64pubkey\">"];

	_serverkey = nil;
	_serverkey = [[NSString alloc] initWithFormat:@"%@", 
								[[[arr objectAtIndex:1] componentsSeparatedByString:@"</pub>"] objectAtIndex:0] ];
	
	NSLog(@"서버공개키 로드완료: %@", _serverkey);
}

- (void)setServerPublickey:(NSString *)pServerPublickey {
	_serverkey = nil;	
	_serverkey = [[NSString alloc] initWithFormat:@"%@", pServerPublickey];
}

- (NSString *)getServerPubkey {
	//NSLog(@"서버키 보내기 전값");
	//NSLog(@"%@", _serverkey);
    
	NSString* svrkey = [[NSString alloc] initWithFormat:@"%@", _serverkey];
	return	svrkey;
}

@end
