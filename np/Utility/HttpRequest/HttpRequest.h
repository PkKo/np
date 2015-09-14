//
//  HttpRequest.h
//  LINK
//
//  Created by Ko on 2015. 3. 9..
//  Copyright (c) 2015년 Infobank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject
{
    NSURLConnection *connection;
    NSMutableData *receivedData;
    NSURLResponse *response;
    NSString *result;
    id target;
    SEL selector;
    NSMutableURLRequest *requestUrl;
    NSData* postData;
}

@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSURLResponse *response;
@property (strong, nonatomic) NSString *result;
@property (strong, nonatomic) id target;
@property (assign, nonatomic) SEL selector;

+(HttpRequest *)getInstance;
-(void)setDelegate:(id)mTarget selector:(SEL)mSelector;
-(BOOL)requestUrlWithAPI:(NSString *)api bodyObject:(NSDictionary *) bodyObject;
-(BOOL)requestUrl:(NSString *)url bodyObject:(NSDictionary *)bodyObject;
-(BOOL)requestUrl:(NSString *)url bodyString:(NSString *)bodyString;
-(BOOL)requestUrlGET:(NSString *)url;
-(BOOL)requestUrlWithEncode:(NSString *)url bodyObject:(NSDictionary *)bodyObject encodingKey:(NSString *)encodingKey;
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)mResponse;
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;
-(BOOL)requestRestart;
@end