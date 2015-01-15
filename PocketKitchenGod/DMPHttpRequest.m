//
//  DMPHttpRequest.m
//  HeXunLive
//
//  Created by Damon's on 14-2-11.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import "DMPHttpRequest.h"
#import "NSString+Hashing.h"
#import "NSFileManager+NSFileManager_pathMethod.h"
#import "DMPHttpRequestManager.h"
@implementation DMPHttpRequest
{
    NSURLConnection * _urlConnection;
}

- (id)init {
    if (self = [super init]) {
        self.downloadData = [[NSMutableData alloc] init];
    }
    return self;
}
- (NSString *)getFilePath {
    return [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", [self.requestString MD5Hash]];
}

- (void) startRequest {
    if (_urlConnection) {
        _urlConnection = nil;
    }
    NSURL * url = [NSURL URLWithString:self.requestString];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void)cancel {
    [_urlConnection cancel];
}
+ (void) requestWithUrlString:(NSString *)url
                    isRefresh:(BOOL)isRefresh
                     delegate:(id<DMPHttpRequestDelegate>)delegate
                          tag:(NSInteger)tag {
  DMPHttpRequest * request = [[DMPHttpRequest alloc] init];
  request.requestString = url;
  request.isRefresh = isRefresh;
  request.tag = tag;
  request.delegate = delegate;
  NSString * dataPath = [request getFilePath];
  NSFileManager * file = [NSFileManager defaultManager];
  if ([file fileExistsAtPath:dataPath] && ![NSFileManager isTimeOutWithPath:dataPath time:60*60] && !isRefresh) {
    [request.downloadData setLength:0];
    [request.downloadData appendData:[NSData dataWithContentsOfFile:dataPath]];
    if ([request.delegate respondsToSelector:@selector(dmpHttpRequestDidFinished:)]) {
      [request.delegate dmpHttpRequestDidFinished:request];
    }
  }else {
    [request startRequest];
    [[DMPHttpRequestManager shareManager] addRequestWithKey:request.requestString WithRequest:request];
  }
}

+ (void) requestWithUrlString:(NSString *)url
                    isRefresh:(BOOL)isRefresh
                     delegate:(id<DMPHttpRequestDelegate>)delegate {
  [self requestWithUrlString:url isRefresh:isRefresh delegate:delegate];
}

+ (void)requestCancelWithUrlString:(NSString *)url {
    DMPHttpRequest * request = [[DMPHttpRequestManager shareManager] requestForKey:url];
    [request cancel];
    [[DMPHttpRequestManager shareManager] removeRequestWithKey:url];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",[error localizedDescription]);
    if ([self.delegate respondsToSelector:@selector(dmpHttpRequest:DidFailWithError:)]) {
        [self.delegate dmpHttpRequest:self DidFailWithError:error];
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.downloadData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.downloadData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.downloadData writeToFile:[self getFilePath] atomically:YES];
  
    if ([self.delegate respondsToSelector:@selector(dmpHttpRequestDidFinished:)]) {
        [self.delegate dmpHttpRequestDidFinished:self];
    }
    [[DMPHttpRequestManager shareManager] removeRequestWithKey:self.requestString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
