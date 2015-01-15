//
//  NSFileManager+NSFileManager_pathMethod.m
//  HeXunLive
//
//  Created by Damon's on 14-2-11.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import "NSFileManager+NSFileManager_pathMethod.h"

@implementation NSFileManager (NSFileManager_pathMethod)
+ (BOOL)isTimeOutWithPath:(NSString *)path time:(NSTimeInterval)timeout {
    NSDictionary * info = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSDate * creatDate = [info objectForKey:NSFileCreationDate];
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:creatDate];
    if (time > timeout) {
        return YES;
    }else
        return NO;
}



@end
