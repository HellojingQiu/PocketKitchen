//
//  LLCAppDelegate.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCAppDelegate.h"

#import "LLCGuidanceViewController.h"
#import "LLCMainViewController.h"

@implementation LLCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LLCMainViewController alloc] init]];
//  [self createPlists];
  application.applicationSupportsShakeToEdit = YES;
    
  self.window.backgroundColor = [UIColor blackColor];
  [self.window makeKeyAndVisible];
  return YES;
}

//- (void)createPlists {
//  if (![[NSFileManager defaultManager] fileExistsAtPath:kStorePlist_Path isDirectory:NULL]) {
//    [[NSFileManager defaultManager] createDirectoryAtPath:kStorePlist_Path withIntermediateDirectories:NO attributes:nil error:nil];
//  }
//  
//  if (![[NSFileManager defaultManager] fileExistsAtPath:kRecord_Plist_Path isDirectory:NULL]) {
//    [[NSFileManager defaultManager] createDirectoryAtPath:kRecord_Plist_Path withIntermediateDirectories:NO attributes:nil error:nil];
//  }
//}

- (void)applicationWillResignActive:(UIApplication *)application {
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
  
}

@end
