//
//  HttpRequest.m
//  LINK
//
//  Created by Ko on 2015. 3. 9..
//  Copyright (c) 2015년 Infobank. All rights reserved.
//

#import "HttpRequest.h"
#import "CommonViewController.h"

@implementation HttpRequest

// @synthesize receivedData;
@synthesize response;
@synthesize result;
@synthesize target;
@synthesize selector;
@synthesize connectionDataDictionary;

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
        connectionDataDictionary = [[NSMutableDictionary alloc] init];
        
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
-(BOOL)requestUrl:(NSString *)url bodyObject:(NSDictionary *)bodyObject
{
    
	
	//NSLog(@"%s",__FUNCTION__);
    //서버에 연결한다
    requestUrl = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //통신방식 정의
    [requestUrl setHTTPMethod:@"POST"];
    //dictionary 형태를 JSON data로 바꿔준다
    postData = [NSJSONSerialization dataWithJSONObject:bodyObject options:NSJSONWritingPrettyPrinted error:nil];
    //data를 헤더에 붙여준다
    [requestUrl setHTTPBody:postData];
    
    //연결을 시도하는 connection 생성
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:requestUrl delegate:self];
    
    //연결이 되면 데이터를 받을 변수 초기화
    if(connection) {
        NSMutableData* receivedData = [[NSMutableData alloc] init];
		[connectionDataDictionary setObject:receivedData forKey: @(connection.hash)];
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
    //dictionary 형태를 JSON data로 바꿔준다
    postData = [bodyString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"MCPU_SSID"] != nil)
//    {
//        [requestUrl setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"MCPU_SSID"] forHTTPHeaderField:@"CooKie"];
//    }
    //data를 헤더에 붙여준다
    [requestUrl setHTTPBody:postData];
    
    //연결을 시도하는 connection 생성
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:requestUrl delegate:self];
    
    //연결이 되면 데이터를 받을 변수 초기화
    if(connection) {
        NSMutableData* receivedData = [[NSMutableData alloc] init];
		[connectionDataDictionary setObject:receivedData forKey: @(connection.hash)];
        return YES;
    }
    
    return NO;
}

-(BOOL)requestUrl:(NSString *)url bodyString:(NSString *)bodyString token:(NSString *)token
{
    //NSLog(@"%s",__FUNCTION__);
    //서버에 연결한다
    requestUrl = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //통신방식 정의
    [requestUrl setHTTPMethod:@"POST"];
    //dictionary 형태를 JSON data로 바꿔준다
    postData = [bodyString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //    if([[NSUserDefaults standardUserDefaults] objectForKey:@"MCPU_SSID"] != nil)
    //    {
    //        [requestUrl setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"MCPU_SSID"] forHTTPHeaderField:@"CooKie"];
    //    }
    [requestUrl setValue:token forHTTPHeaderField:@"CODE_RESPONSE_TOKEN"];
    //data를 헤더에 붙여준다
    [requestUrl setHTTPBody:postData];
    
    //연결을 시도하는 connection 생성
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:requestUrl delegate:self];
    
    //연결이 되면 데이터를 받을 변수 초기화
    if(connection) {
        NSMutableData* receivedData = [[NSMutableData alloc] init];
		[connectionDataDictionary setObject:receivedData forKey: @(connection.hash)];
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
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:requestUrl delegate:self];
    
    //연결이 되면 데이터를 받을 변수 초기화
    if(connection) {
        NSMutableData* receivedData = [[NSMutableData alloc] init];
		[connectionDataDictionary setObject:receivedData forKey: @(connection.hash)];
        return YES;
    }
    
    return NO;
}

//- (void)cancelRequestAsync
//{
//    if (connection)
//    {
//		[connection cancel];
//        connection = nil;
//    }
//     if (receivedData)
//     {
//         receivedData = nil;
//     }
//}

#pragma mark - connection response
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)mResponse
{
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)mResponse;
//    NSLog(@"%s, receivedHeader = %@", __FUNCTION__, httpResponse.allHeaderFields);
																					
    //데이터를 전송받기 전 헤더를 받아온다
    // self.response = mResponse;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSMutableData* receivedData = [connectionDataDictionary objectForKey: @(connection.hash)];
		
	if(data && receivedData) {
		//데이터 전송도중 호출된다. 여러번 나눠서 호출될 수 있다
		[receivedData appendData:data];
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connectionDataDictionary removeObjectForKey: @(connection.hash)];
    
    //에러가 발생했을 경우 호출된다
    NSLog(@"%s", __FUNCTION__);
    if([self target] != nil && [[self target] respondsToSelector:@selector(didFailWithError:)])
    {
        [[self target] performSelector:@selector(didFailWithError:) withObject:error];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableData* receivedData = [connectionDataDictionary objectForKey: @(connection.hash)];
	[connectionDataDictionary removeObjectForKey: @(connection.hash)];
    
	if(nil == receivedData) {
		return;
	}
	
	//데이터 전송이 끝났을 때 호출된다. 데이터 구성을 한다. 파싱을 같이 하자
//    NSLog(@"%s, receivedHeader = %@", __FUNCTION__, receivedData);
    result = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"didFinishLoading result = %@", result);
    NSError *error;
    //Dictionary 형태로 변환
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
    
    if([[responseDic objectForKey:RESULT] isEqualToString:@"SBIP90007"] || [[responseDic objectForKey:RESULT] isEqualToString:@"WFDB90401"])
    {
        if([self target] != nil && [[self target] respondsToSelector:@selector(timeoutError:)])
        {
            [[self target] performSelector:@selector(timeoutError:) withObject:responseDic];
        }
    }
    else
    {
        //델리게이트가 있으면 실행한다
        if([self target] && [[self target] respondsToSelector:[self selector]])
        {
            if(responseDic == nil)
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:@"서버에러가 발생했습니다.\n잠시 후 다시 시도해주세요." forKey:RESULT_MESSAGE];
                [dic setObject:@"-1" forKey:RESULT];
                responseDic = [NSDictionary dictionaryWithDictionary:dic];
            }
            [[self target] performSelector:[self selector] withObject:responseDic];
        }

    }
    
    requestUrl = nil;
    postData = nil;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if([challenge.protectionSpace.host isEqualToString:@"smartdev.nonghyup.com"])
    {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    
    if([challenge.protectionSpace.host isEqualToString:@"umspush.nonghyup.com"])
    {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
}
@end
