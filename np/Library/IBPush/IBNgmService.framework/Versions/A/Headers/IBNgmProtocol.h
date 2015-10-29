//
//  IBNgmProtocol.h
//  IBNgmService
//
//  Created by soulkey on 12. 9. 20..
//  Copyright (c) 2012년 Infobank Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum EN_APNS_REQUEST_TYPE
{
	ApnsRequestTypeNone			= 0x00000000,
	ApnsRequestTypeContent		= 0x00000001,
}ApnsRequestType;

#define RECV_PUSHDATA_KEY_MSGKEY		@"MSGKEY"
#define RECV_PUSHDATA_KEY_CATEGORYNAME	@"CATEGORY_NAME"

#define RegistAccountUserCallBack @"registAccountUserCallback"

@class CheckedContentsToken, IBCheckedContentsSign;

#pragma mark -
#pragma mark ContentsPayload

@interface ContentsPayload : NSObject

@property (nonatomic, readonly) NSString * key;
@property (nonatomic, readonly) NSString * value;

@end


#pragma mark -
#pragma mark ContentsData

@interface ContentsData : NSObject

@property (nonatomic, readonly) NSString * contentKey;
@property (nonatomic, readonly) NSString * title;
@property (nonatomic, readonly) NSString * text;
@property (nonatomic, readonly) int contentType;
@property (nonatomic, readonly) int64_t	 date;
@property (nonatomic, readonly) NSArray * payloadList;

@end


#pragma mark -
#pragma mark MessageContents

@interface MessageContents : NSObject

@property (nonatomic, readonly) ContentsData    * contentsData;
@property (nonatomic, readonly) NSArray * contentsPayloadsList;

@end

#pragma mark -
#pragma mark InboxMessageData

@interface InboxMessageData : NSObject

@property (nonatomic) int64_t date;
@property (nonatomic) int64_t readTime;
@property (nonatomic) int64_t exp;
@property (nonatomic) int64_t expiryTime;
@property (nonatomic) int64_t categoryId;
@property (nonatomic, readonly) NSString *serverMessageKey;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSArray *payloadList;

@end


#pragma mark -
#pragma mark NHInboxMessageData
@interface NHInboxMessageData : NSObject

@property (nonatomic) NSString * serverMessageKey;
@property (nonatomic) int64_t regDate;
@property (nonatomic) NSString * inboxType;
@property (nonatomic) NSString * title;
@property (nonatomic) NSString * text;
@property (nonatomic) NSString * linkUrl;
@property (nonatomic) NSString * nhAccountNumber;
@property (nonatomic) int64_t amount;
@property (nonatomic) int64_t balance;
@property (nonatomic) NSString * oppositeUser;
@property (nonatomic) int32_t stickerCode;
@property (nonatomic) NSString * accountGb;

@end

#pragma mark -
#pragma mark InboxCategotyData

@interface InboxCategotyData : NSObject

@property (nonatomic) int32_t categoryId;
@property (nonatomic, readonly) NSString * categoryName;
@property (nonatomic, readonly) NSString * iconUrl;
@property (nonatomic, readonly) NSString * iconName;
@property (nonatomic) int32_t totalCount;
@property (nonatomic) int32_t unreadCount;

@end

#pragma mark -
#pragma mark IBApnsHelperProtocol

@protocol IBApnsHelperProtocol <NSObject>
@required

- (void)receivedApnsMessage:(NSDictionary *)userInfo pushData:(NSDictionary *)pushData requestType:(ApnsRequestType)requestType;

@optional

@end



#pragma mark -
#pragma mark IBInboxProtocol

@protocol IBInboxProtocol <NSObject>
@required

@optional

- (void)inboxLoadFailed:(int)responseCode;

- (void)loadingInboxList;

- (void)loadedInboxList:(BOOL)success messageList:(NSArray *)messageList;
- (void)loadedSingleMessage:(BOOL)success message:(InboxMessageData *)message;
- (void)removedMessages:(BOOL)success sMsgKeys:(NSArray *)sMsgKeys;

- (void)loadedInboxCategoryList:(NSArray *)categoryList;

- (void)readMessage:(BOOL)success sMsgKeys:(NSArray *)sMsgKeys;

- (void)loadedContents:(BOOL)success contents:(ContentsData *)contents;

- (void)stickerSummaryList:(BOOL)success summaryList:(NSArray *)summaryList;
- (void)addedSticker:(BOOL)success;
- (void)loadedAccountQueryInboxList:(BOOL)success messageList:(NSArray *)messageList;


@end

