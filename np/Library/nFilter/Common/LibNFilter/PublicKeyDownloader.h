//
//  PublicKeyDownloader.h
//  nFilterModuleBasic
//
//  Created by 발팀 개 on 10. 3. 10..
//  Copyright 2010 NSHC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PublicKeyDownloader : NSObject {

	id _pTarget;
	SEL _pEventOnGetPubkey;
	
	NSString* _serverkey;
}

+ (PublicKeyDownloader *)sharedInstance;

- (void)setServerPublickey:(NSString *)pServerPublickey;
- (void)setServerPublickeyURL:(NSString *)pXmlURL;
- (NSString *)getServerPubkey;

@end
