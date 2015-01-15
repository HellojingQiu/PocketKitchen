//
//  BSIHTTPRequest.m
//  BookShare
//
//  Created by yang on 2/11/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "BSIHTTPRequest.h"

@implementation BSIHTTPRequest
@synthesize tag = _tag;
@synthesize delegate = _delegate;
@synthesize url = _url;

#define SAFELY_RELEASE(a) [(a) release], (a) = nil;
#define SAFELY_AUTORELEASE(a) [(a) autorelease]
- (void)dealloc
{
    SAFELY_RELEASE(_postParams);
    SAFELY_RELEASE(_data);
    SAFELY_RELEASE(_connection);
    SAFELY_RELEASE(_postFileParams);
    [super dealloc];
}
+ (id) requestWithURL:(NSURL *)url {
    return SAFELY_AUTORELEASE([[[self class] alloc] initWithURL:url]);
}
- (id) initWithURL:(NSURL *)url {
    if (self = [super init]) {
        self.url = url;
        _method = HttpMethodGET;
        _postParams = [[NSMutableDictionary alloc] init];
        _postFileParams = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSURLRequest *) buildContentTypeUrlEncoded {
    NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:self.url];
    [r setHTTPMethod:kHttpRequestMethodPost];
    
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *keys = _postParams.allKeys;
    for (NSString *oneKey in keys) {
        id v = [_postParams objectForKey:oneKey];
        v = [v stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *ss = [NSString stringWithFormat:@"%@=%@", oneKey, v];
        [arr addObject:ss];
    }
    NSString *postBody = [arr componentsJoinedByString:@"&"];
    NSLog(@"post body is %@", postBody);
    NSData *data = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    NSString *contentLength = [NSString stringWithFormat:@"%d", data.length];
    [r setValue:kContentTypeURLEncoded forHTTPHeaderField:@"Content-Type"];
    [r setValue:contentLength forHTTPHeaderField:@"Content-Length"];
    [r setHTTPBody:data];
    return r;
}

#define QFBOUNDARY @"--QianFengIsABestOne--"
- (NSURLRequest *) buildContentTypeMultipartFormData {
    NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:self.url];
    [r setHTTPMethod:kHttpRequestMethodPost];
    
    NSString *s = @"";
    NSArray *keys = _postParams.allKeys;
    for (NSString *oneKey in keys) {
        id v = [_postParams objectForKey:oneKey];
        
        s = [s stringByAppendingFormat:@"--%@\r\n", QFBOUNDARY];
        s = [s stringByAppendingFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", oneKey];
        s = [s stringByAppendingFormat:@"\r\n"];
        s = [s stringByAppendingFormat:@"%@", v];
        s = [s stringByAppendingFormat:@"\r\n"];
    }
    
    NSMutableData *postFileData = [NSMutableData data];
    for (NSDictionary *dict in _postFileParams) {
        NSData *data = [dict objectForKey:@"Data"];
        NSString *fileName = [dict objectForKey:@"FileName"];
        NSString *contentType = [dict objectForKey:@"ContentType"];
        NSString *key = [dict objectForKey:@"Key"];
        
        NSString *s2 = @"";
        s2 = [s2 stringByAppendingFormat:@"--%@\r\n", QFBOUNDARY];
        if (fileName == nil) fileName = @"noname.png";
        s2 = [s2 stringByAppendingFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, fileName];
        if (contentType) {
            s2 = [s2 stringByAppendingFormat:@"Content-Type: %@\r\n", contentType];
        }
        s2 = [s2 stringByAppendingFormat:@"\r\n"];
        
        [postFileData appendData:[s2 dataUsingEncoding:NSUTF8StringEncoding]];
        [postFileData appendData:data];
        [postFileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [postFileData appendData:[s dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *endString = [NSString stringWithFormat:@"--%@--\r\n", QFBOUNDARY];
    [postFileData appendData:[endString dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *contentLength = [NSString stringWithFormat:@"%d", postFileData.length];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", QFBOUNDARY];
    [r addValue:contentType forHTTPHeaderField:@"Content-Type"];

    [r setValue:contentLength forHTTPHeaderField:@"Content-Length"];
    [r setHTTPBody:postFileData];
    return r;
}

- (void) startAsynchronous {
    NSURLRequest *request;
    if (_method == HttpMethodGET) {
        request = [NSURLRequest requestWithURL:self.url];
    } else if (_method == HttpMethodPOST) {
        if (_postFileParams.count > 0)
            _contentType = ContentTypeMultipartFormData;
        if (_contentType == ContentTypeURLEncoded) {
            request = [self buildContentTypeUrlEncoded];
        } else if (_contentType == ContentTypeMultipartFormData) {
            request = [self buildContentTypeMultipartFormData];
        }
    }
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_data release];
    _data = [[NSMutableData alloc] init];
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}
- (NSData *) responseData {
    return _data;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([_delegate respondsToSelector:@selector(requestFinished:)]) {
        [_delegate requestFinished:self];
    }
    SAFELY_RELEASE(_data);
    SAFELY_RELEASE(_connection);
}

@end
