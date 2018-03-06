//
//  HKFilteredProtocol.m
//  BlackCard
//
//  Created by pz on 2017/12/5.
//  Copyright © 2017年 冒险元素. All rights reserved.
//

#import "HKFilteredProtocol.h"

@implementation HKFilteredProtocol
//这个方法是决定这个 protocol 是否可以处理传入的 request 的如是返回 true 就代表可以处理,如果返回 false 那么就不处理这个 request 。
+(BOOL)canInitWithRequest:(NSURLRequest *)request{
    //看看是否已经处理过了，防止无限循环
    if ([NSURLProtocol propertyForKey:@"FilteredKey" inRequest:request]){
        return NO;
    }
//    NSLog(@"===>%@",[request.URL absoluteString]);
    return YES;
}
//这个方法主要是用来返回格式化好的request，如果自己没有特殊需求的话，直接返回当前的request就好了。如果你想做些其他的，比如地址重定向，或者请求头的重新设置，你可以copy下这个request然后进行设置。
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    return request;
}

//该方法主要是判断两个请求是否为同一个请求，如果为同一个请求那么就会使用缓存数据。通常都是调用父类的该方法。
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return [super requestIsCacheEquivalent:a toRequest:b];
}
//开始处理这个请求
- (void)startLoading{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:@"FilteredKey" inRequest:mutableReqeust];
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
}
//结束处理这个请求
- (void)stopLoading{
    if (self.connection != nil)
    {
        [self.connection cancel];
        self.connection = nil;
    }
}

#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
//    [connection.currentRequest.URL absoluteString];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@",dic);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}


@end
