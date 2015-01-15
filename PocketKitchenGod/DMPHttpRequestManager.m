//
//  DMPHttpRequestManager.m
//  HeXunLive
//
//  Created by Damon's on 14-2-11.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import "DMPHttpRequestManager.h"

@implementation DMPHttpRequestManager
{
    NSMutableDictionary * _dict;
}

- (id)init {
    if (self = [super init]) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return self;
}
+(DMPHttpRequestManager *)shareManager {
    static DMPHttpRequestManager * manager = nil;
    @synchronized(self) {
        if (!manager) {
            manager = [[DMPHttpRequestManager alloc] init];
        }
    }
    return manager;
}
- (void)addRequestWithKey:(NSString *)key WithRequest:(id)request {
    [_dict setObject:request forKey:key];
}
- (void)removeRequestWithKey:(NSString *)key {
    [_dict removeObjectForKey:key];
}
- (id) requestForKey:(NSString *)key {
    return [_dict valueForKey:key];
}
@end
