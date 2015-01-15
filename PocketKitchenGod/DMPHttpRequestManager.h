//
//  DMPHttpRequestManager.h
//  HeXunLive
//
//  Created by Damon's on 14-2-11.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import <Foundation/Foundation.h>
//请求管理类
//维护请求类的生命周期
@interface DMPHttpRequestManager : NSObject
/**
 将DMPHttpRequest加入到管理队列中
 @param key (NSString *)url
 */
- (void) addRequestWithKey:(NSString *)key WithRequest:(id)request;
/**
 将DMPHttpRequest根据key从管理队列中删除
 @param key (NSString *)url
 */
- (void) removeRequestWithKey:(NSString *)key;
- (id) requestForKey:(NSString *)key;
/**
 返回单例
 */
+ (DMPHttpRequestManager *)shareManager;

@end
