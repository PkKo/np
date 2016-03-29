//
//  InboxCategotyData+Category.m
//  np
//
//  Created by Infobank1 on 2015. 11. 5..
//  Copyright © 2015년 Infobank1. All rights reserved.
//

#import "NHInboxMessageData+Category.h"

@implementation NHInboxMessageData(NHInboxMessageData_Category)

// @property (nonatomic) NSString * serverMessageKey;
// @property (nonatomic) int64_t regDate;
// @property (nonatomic) int64_t readDate;
// @property (nonatomic) NSString * inboxType;
// @property (nonatomic) NSString * title;
// @property (nonatomic) NSString * text;
// @property (nonatomic) NSString * linkUrl;
// @property (nonatomic) NSString * nhAccountNumber;
// @property (nonatomic) int64_t amount;
// @property (nonatomic) int64_t balance;
// @property (nonatomic) NSString * oppositeUser;
// @property (nonatomic) int32_t stickerCode;
// @property (nonatomic) NSString * accountGb;
// @property (nonatomic) NSString * payType;											  


- (void) encodeWithCoder: (NSCoder *)encoder {
	[encoder encodeObject: self.serverMessageKey	forKey:@"serverMessageKey"];
	[encoder encodeObject: @(self.regDate)			forKey:@"regDate"];
	[encoder encodeObject: @(self.readDate)			forKey:@"readDate"];
	[encoder encodeObject: self.inboxType			forKey:@"inboxType"];
	[encoder encodeObject: self.title				forKey:@"title"];
	[encoder encodeObject: self.text				forKey:@"text"];
	[encoder encodeObject: self.linkUrl				forKey:@"linkUrl"];
	[encoder encodeObject: self.nhAccountNumber		forKey:@"nhAccountNumber"];
	[encoder encodeObject: @(self.amount)			forKey:@"amount"];
	[encoder encodeObject: @(self.balance)			forKey:@"balance"];
	[encoder encodeObject: self.oppositeUser		forKey:@"oppositeUser"];
	[encoder encodeObject: @(self.stickerCode)		forKey:@"stickerCode"];
	[encoder encodeObject: self.accountGb			forKey:@"accountGb"];
	[encoder encodeObject: self.payType				forKey:@"payType"];
}


- (id) initWithCoder: (NSCoder *)decoder {
    if (self = [super init]) {
		self.serverMessageKey	= [decoder decodeObjectForKey: @"serverMessageKey"];
		self.regDate			= ((NSNumber*)[decoder decodeObjectForKey: @"regDate"]).longLongValue;
		self.readDate			= ((NSNumber*)[decoder decodeObjectForKey: @"readDate"]).longLongValue;
		self.inboxType			= [decoder decodeObjectForKey: @"inboxType"];
		self.title				= [decoder decodeObjectForKey: @"title"];
		self.text				= [decoder decodeObjectForKey: @"text"];
		self.linkUrl			= [decoder decodeObjectForKey: @"linkUrl"];
		self.nhAccountNumber	= [decoder decodeObjectForKey: @"nhAccountNumber"];
		self.amount				= ((NSNumber*)[decoder decodeObjectForKey: @"amount"]).longLongValue;
		self.balance			= ((NSNumber*)[decoder decodeObjectForKey: @"balance"]).longLongValue;
		self.oppositeUser		= [decoder decodeObjectForKey: @"oppositeUser"];
		self.stickerCode		= ((NSNumber*)[decoder decodeObjectForKey: @"stickerCode"]).longValue;
		self.accountGb			= [decoder decodeObjectForKey: @"accountGb"];
		self.payType			= [decoder decodeObjectForKey: @"payType"];
	}
    
    return self;
}

@end
