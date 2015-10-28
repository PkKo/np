//
//  IBInbox.h
//  IBNgmService
//
//  Created by soulkey on 12. 9. 25..
//  Copyright (c) 2012년 Infobank Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FileKey, MessageContents, InboxMessageData;

#pragma mark -
#pragma mark MessageContentsReqData

@interface InboxRequestData : NSObject

@property (nonatomic) int maxCount;
@property (nonatomic) BOOL ascending;
@property (nonatomic) int32_t start;

@end

@interface AccountInboxRequestData : NSObject

@property (nonatomic) int size;
@property (nonatomic) BOOL ascending;
@property (nonatomic) NSArray *accountNumberList;
@property (nonatomic) NSString * startDate;
@property (nonatomic) NSString * endDate;
@property (nonatomic) NSString * nextServerMsgKey;
@property (nonatomic) NSString * queryType;

@end


#pragma mark -
#pragma mark StickerSummaryData
@interface StickerSummaryData : NSObject

@property (nonatomic) int64_t sum;
@property (nonatomic) int32_t stickerCode;
@property (nonatomic) int32_t count;

@end


#pragma mark -
#pragma mark DeviceFeedBackData
@interface DeviceFeedBackData : NSObject

@property (nonatomic) NSString *channel;
@property (nonatomic) int scheduleId;
@property (nonatomic) NSString *msgKey;
@property (nonatomic) NSArray *payLoads;

@end





#pragma mark -
#pragma mark IBInbox

@interface IBInbox : NSObject

//////////////////////////////////////////////////////////////////////////////
//								Open API									//
//////////////////////////////////////////////////////////////////////////////

+ (void)loadWithListener:(id)listener;

+ (void)requestInboxList;
+ (void)requestInboxListWithReqData:(InboxRequestData *)reqData;
+ (void)requestInboxListWithReqCategory:(int)category data:(InboxRequestData *)reqData;

+ (void)requestInboxCategoryInfo;

+ (void)requestDeleteMessages:(NSArray *)sMsgKeys;

+ (void)requestReadMessageWithMsgKey:(NSArray *)sMsgKeys readMethod:(int)readMethod;

+ (void)requestContents:(NSString *)contentKey;

+ (void)reqAddStickerInfoWithMsgKey:(NSString *)sMsgKey stickerCode:(int)stickerCode;

+ (void)reqGetStickerSummaryWithAccountNumberList:(NSArray *)accountNumberList startDate:(NSString *)startDate endDate:(NSString *)endDate;

+ (void)reqQueryAccountInboxListWithSize:(AccountInboxRequestData *)reqData;
@end
