//
//  NSFileManager+NSFileManager_pathMethod.h
//  HeXunLive
//
//  Created by Damon's on 14-2-11.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import <Foundation/Foundation.h>
//文件类拓展
//查询缓存是否过期
@interface NSFileManager (NSFileManager_pathMethod)
/**
 查询缓存文件是否过期
 */
+ (BOOL) isTimeOutWithPath:(NSString *)path time:(NSTimeInterval)timeout;

@end
