//
//  BSIHTTPRequest.h
//  BookShare
//
//  Created by yang on 2/11/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kContentTypeURLEncoded @"application/x-www-form-urlencoded"
#define kContentTypeMultipartFormData @"multipart/form-data"

#define kHttpRequestMethodGet @"GET"
#define kHttpRequestMethodPost @"POST"
typedef enum {
    ContentTypeURLEncoded = 1,
    ContentTypeMultipartFormData,
} HttpContentType;
typedef enum {
    HttpMethodGET = 1,
    HttpMethodPOST,
} HttpRequestMethod;
@protocol BSIHTTPRequestDelegate;
/* 这里不用ASI, 使用原生的NSUrlConnection */
@interface BSIHTTPRequest : NSObject <NSURLConnectionDataDelegate>{
    id <BSIHTTPRequestDelegate> _delegate;
    NSInteger _tag;
    NSURL *_url;
    NSMutableDictionary *_postParams;
    NSMutableArray *_postFileParams;
    HttpRequestMethod _method;
    HttpContentType _contentType;
    
    NSURLConnection *_connection;
    NSMutableData *_data;
}
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id <BSIHTTPRequestDelegate> delegate;
+ (id) requestWithURL:(NSURL *)url;
- (id) initWithURL:(NSURL *)url;
- (void) startAsynchronous;
- (NSData *) responseData;
@end

@protocol BSIHTTPRequestDelegate <NSObject>

- (void) requestFinished:(BSIHTTPRequest *)request;

@end


/*
 BSIHTTPRequest *request = [BSIHTTPRequest requestWithURL:url];
 [request setDelegate:self];
 [request setTag:100];
 [request startAsynchronous];

 */