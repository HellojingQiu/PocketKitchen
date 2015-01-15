//
//  DMPHttpRequest.h
//  HeXunLive
//
//  Created by Damon's on 14-2-11.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import <Foundation/Foundation.h>
//与服务器交互的类(请求类)
@protocol DMPHttpRequestDelegate;

@interface DMPHttpRequest : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, retain) NSMutableData * downloadData;       // 下载下来的数据
@property (nonatomic, copy) NSString * requestString;             // 请求地址
@property (nonatomic, assign) BOOL isRefresh;                     // 是否是刷新请求
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, weak) id<DMPHttpRequestDelegate> delegate;

/**
 向服务器发起请求
 */
+ (void) requestWithUrlString:(NSString *)url
                    isRefresh:(BOOL)isRefresh
                     delegate:(id<DMPHttpRequestDelegate>)delegate;

+ (void) requestWithUrlString:(NSString *)url
                    isRefresh:(BOOL)isRefresh
                     delegate:(id<DMPHttpRequestDelegate>)delegate
                          tag:(NSInteger)tag;
/**
根据地址取消请求
 */
+ (void) requestCancelWithUrlString:(NSString *)url;
@end

@protocol DMPHttpRequestDelegate <NSObject>

/**
 数据下载完,调用此方法
 */
- (void)dmpHttpRequestDidFinished:(DMPHttpRequest *)request;
@optional
- (void)dmpHttpRequest:(DMPHttpRequest *)request DidFailWithError:(NSError *)error;
@end
