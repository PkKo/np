//
//  HttpRequest.m
//  LINK
//
//  Created by Ko on 2015. 3. 9..
//  Copyright (c) 2015년 Infobank. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

@synthesize receivedData;
@synthesize response;
@synthesize result;
@synthesize target;
@synthesize selector;

+(HttpRequest *)getInstance
{
    static HttpRequest *mRequest;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        mRequest = [[HttpRequest alloc] init];
    });
    
    return mRequest;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        
    }
    
    return self;
}

#pragma mark - setDelegate
-(void)setDelegate:(id)mTarget selector:(SEL)mSelector
{
    //데이터의 파싱까지 종료된 이후 실행할 셀렉터를 설정한다
    self.target = mTarget;
    self.selector = mSelector;
}

#pragma mark - request function
-(BOOL)requestUrlWithAPI:(NSString *)api bodyObject:(NSDictionary *)bodyObject
{
    //호출할 API와 서버주소로 URL
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_URL, api];
    //서버 주소 설정
    requestUrl = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //통신방식 정의
    [requestUrl setHTTPMethod:@"POST"];
    /*
    //SBJson writer
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSLog(@"postData = %@", [writer stringWithObject:bodyObject]);
    //dictionary 형태를 JSON data로 바꿔준다
    NSData *postData = [NSData dataWithData:[writer dataWithObject:bodyObject]];*/
    
    NSString *strData = [NSString string];
    
    NSEnumerator *keyEnumerator = [bodyObject keyEnumerator];
    for(NSString *key in keyEnumerator)
    {
        if([strData length] == 0)
        {
            strData = [NSString stringWithFormat:@"%@=%@", key, [bodyObject objectForKey:key]];
        }
        else
        {
            strData = [NSString stringWithFormat:@"%@&%@=%@", strData, key, [bodyObject objectForKey:key]];
        }

    }
    
    NSLog(@"postData = %@", strData);
    
    postData = [strData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //data를 헤더에 붙여준다
    [requestUrl setHTTPBody:postData];
    [requestUrl setValue:[NSString stringWithFormat:@"%lu", postData.length] forHTTPHeaderField:@"Content-Length"];
    [requestUrl setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //연결을 시도하는 connection 생성
    connection = [[NSURLConnection alloc] initWithRequest:requestUrl delegate:self];
    
    //연결이 되면 데이터를 받을 변수 초기화
    if(connection) {
        receivedData = [[NSMutableData alloc] init];
        return YES;
    }
    
    return NO;
}

- (BOOL)requestRestart
{
    if(requestUrl != nil && postData != nil)
    {
        //data를 헤더에 붙여준다
        [requestUrl setHTTPBody:postData];
        [requestUrl setValue:[NSString stringWithFormat:@"%lu", postData.length] forHTTPHeaderField:@"Content-Length"];
        [requestUrl setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //연결을 시도하는 connection 생성
        connection = [[NSURLConnection alloc] initWithRequest:requestUrl delegate:self];
        
        //연결이 되면 데이터를 받을 변수 초기화
        if(connection)
        {
            receivedData = [[NSMutableData alloc] init];
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)requestUrl:(NSString *)url bodyObject:(NSDictionary *)bodyObject
{
    //NSLog(@"%s",__FUNCTION__);
    //서버에 연결한다
    requestUrl = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //통신방식 정의
    [requestUrl setHTTPMethod:@"POST"];
    //SBJson writer
//    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    //NSLog(@"postData = %@", [writer stringWithObject:bodyObject]);
    //dictionary 형태를 JSON data로 바꿔준다
//    postData = [NSData dataWithData:[writer dataWithObject:bodyObject]];
    
    postData = [NSJSONSerialization dataWithJSONObject:bodyObject options:NSJSONWritingPrettyPrinted error:nil];
    //data를 헤더에 붙여준다
    [requestUrl setHTTPBody:postData];
    
    //연결을 시도하는 connection 생성
    connection = [[NSURLConnection alloc] initWithRequest:requestUrl delegate:self];
    
    //연결이 되면 데이터를 받을 변수 초기화
    if(connection) {
        receivedData = [[NSMutableData alloc] init];
        return YES;
    }
    
    return NO;
}

-(BOOL)requestUrl:(NSString *)url bodyString:(NSString *)bodyString
{
    //NSLog(@"%s",__FUNCTION__);
    //서버에 연결한다
    requestUrl = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //통신방식 정의
    [requestUrl setHTTPMethod:@"POST"];
    //NSLog(@"%@\n%@", url, bodyString);
    //SBJson writer
    //SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    //NSLog(@"postData = %@", [writer stringWithObject:bodyObject]);
    //dictionary 형태를 JSON data로 바꿔준다
    postData = [bodyString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //data를 헤더에 붙여준다
    [requestUrl setHTTPBody:postData];
    
    //연결을 시도하는 connection 생성
    connection = [[NSURLConnection alloc] initWithRequest:requestUrl delegate:self];
    
    //연결이 되면 데이터를 받을 변수 초기화
    if(connection) {
        receivedData = [[NSMutableData alloc] init];
        return YES;
    }
    
    return NO;
}

-(BOOL)requestUrlGET:(NSString *)url
{
    //NSLog(@"%s",__FUNCTION__);
    //서버에 연결한다
    requestUrl = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    //NSLog(@"requestUrl = %@", requestUrl);
    
    //통신방식 정의
    [requestUrl setHTTPMethod:@"GET"];
    NSString *contentType = [NSString stringWithFormat:@"text/html"];
    [requestUrl addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    //연결을 시도하는 connection 생성
    connection = [[NSURLConnection alloc] initWithRequest:requestUrl delegate:self];
    
    //연결이 되면 데이터를 받을 변수 초기화
    if(connection) {
        receivedData = [[NSMutableData alloc] init];
        return YES;
    }
    
    return NO;
}

/*
-(BOOL)requestUrlWithEncode:(NSString *)url bodyObject:(NSDictionary *)bodyObject encodingKey:(NSString *)encodingKey
{
    //서버에 연결한다
    requestUrl = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //통신방식 정의
    [requestUrl setHTTPMethod:@"POST"];
    
    //SBJson writer
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    //dictionary 형태를 JSON String으로 바꿔준다
    NSString *bodyString = [writer stringWithObject:bodyObject];
    //입력받은 encoding key로 암호화한다
    NSString *encodedString = [CommonUtility encrypt3DESWithKey:bodyString key:encodingKey];
    //암호화된 스트링을 데이터로 변환
    postData = [encodedString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"bodyString = %@\nencodedString = %@\npostData = %@",bodyString, encodedString, postData);
    //data를 헤더에 붙여준다
    [requestUrl setHTTPBody:postData];
    
    //연결을 시도하는 connection 생성
    connection = [[NSURLConnection alloc] initWithRequest:requestUrl delegate:self];
    
    //연결이 되면 데이터를 받을 변수 초기화
    if(connection) {
        receivedData = [[NSMutableData alloc] init];
        return YES;
    }
    
    return NO;
}*/

- (void)cancelRequestAsync
{
    if (connection)
    {
        [connection cancel];
        connection = nil;
    }
    if (receivedData)
    {
        receivedData = nil;
    }
}

#pragma mark - connection response
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)mResponse
{
    //데이터를 전송받기 전 헤더를 받아온다
    self.response = mResponse;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //데이터 전송도중 호출된다. 여러번 나눠서 호출될 수 있다
    [receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //에러가 발생했을 경우 호출된다
    NSLog(@"%s", __FUNCTION__);
    if([self target] != nil && [[self target] respondsToSelector:@selector(didFailWithError:)])
    {
        [[self target] performSelector:@selector(didFailWithError:) withObject:error];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //데이터 전송이 끝났을 때 호출된다. 데이터 구성을 한다. 파싱을 같이 하자
    //NSLog(@"receivedData = %@", receivedData);
    result = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"didFinishLoading result = %@", result);
    NSError *error;
    //Dictionary 형태로 변환
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
        
    //델리게이트가 있으면 실행한다
    if([self target] && [[self target] respondsToSelector:[self selector]])
    {
        if(error)
        {
            [[self target] performSelector:[self selector] withObject:result];
        }
        else
        {
            [[self target] performSelector:[self selector] withObject:responseDic];
        }
    }
    
    requestUrl = nil;
    postData = nil;
}
@end