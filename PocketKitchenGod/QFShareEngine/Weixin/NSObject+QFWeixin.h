//
//  NSObject+QFWeixin.h
//  BookShare
//
//  Created by yang on 9/12/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (QFWeixin)
- (BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url;
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@end
