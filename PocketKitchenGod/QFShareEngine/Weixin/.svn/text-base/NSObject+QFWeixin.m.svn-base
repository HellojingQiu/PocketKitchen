//
//  NSObject+QFWeixin.m
//  BookShare
//
//  Created by yang on 9/12/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "NSObject+QFWeixin.h"
#import "QFShareEngine.h"

@implementation NSObject (QFWeixin)
/* 微信朋友圈 回话/Session必须要增加下面2个函数 */
- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [QFShareEngine handleOpenURL:url];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [QFShareEngine handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
