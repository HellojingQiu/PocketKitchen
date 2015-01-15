//
//  LLCUserInfoManager.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCUserInfoManager.h"

@implementation LLCUserInfoManager

+ (id)sharedUserInfo {
  static LLCUserInfoManager *user = nil;
  @synchronized(self) {
    if (user == nil) {
      user = [[LLCUserInfoManager alloc] init];
    }
  }
  return user;
}

- (id)init {
  if (self = [super init]) {
    self.userID = @"";
    self.userName = @"";
    self.userPasswd = @"";
    self.hasLogin = NO;
    
    // 读取上次用户选取的"记住密码"的状态
    NSDictionary *record = [NSDictionary dictionaryWithContentsOfFile:kRecord_Plist_Path];
    self.isRemmberPassword = [[record objectForKey:@"isRemmberPassword"] isEqualToString:@"YES"] ? YES : NO;
  }
  return self;
}


- (void)updateIsRemmberPassword:(BOOL)isRemmberPassword {
  
  // 如果用户取消了记住密码功能
  if (!isRemmberPassword) {
    // 1. 清空记录
    [self cleanPasswordBox];
  }
  
  // 2. 更改"记住密码"状态
  self.isRemmberPassword = isRemmberPassword;
  NSMutableDictionary *record = [NSMutableDictionary dictionaryWithContentsOfFile:kRecord_Plist_Path];
  if (record == nil) {
    record = [[NSMutableDictionary alloc] init];
  }
  
  NSString *isRemmberNumber = [NSString stringWithFormat:@"%@", isRemmberPassword ? @"YES" : @"NO"];
  [record setValue:isRemmberNumber forKey:@"isRemmberPassword"];
  [record writeToFile:kRecord_Plist_Path atomically:YES];
}

- (void)updateUserInfo {
  // 确认用户输入的账号和密码,并记录
  self.userName = self.tempUserName;
  self.userPasswd = self.tempUserPwd;

  // 将用户要记住的账号和密码存入 passwordBox中
  NSMutableDictionary *pwdArr = [NSMutableDictionary dictionaryWithContentsOfFile:kRecord_Plist_Path];
  if (pwdArr == nil) {
    pwdArr = [[NSMutableDictionary alloc] init];
  }
  NSMutableArray *pwds = [pwdArr objectForKey:@"passwordBox"];
  if (pwds == nil) {
    pwds = [[NSMutableArray alloc] init];
  }
  
  // 如果passwordBox中已经存入了两个账号和密码, 按情况清除一个
  int i = 0;
  for (NSArray *aPwd in pwds) {
    // 当前输入的账号已经存在passwordBox中, 则替换
    if ([[aPwd objectAtIndex:0] isEqualToString:self.userName] && [[aPwd objectAtIndex:1] isEqualToString:self.userPasswd]) {
      [pwds removeObject:aPwd];
      i++;
      break;
    }
  }

  // 否则清除最早存储的账号和密码
  if (i == 0 && pwds.count == 2) {
    [pwds removeObjectAtIndex:0];
  }
  
  [pwds addObject:@[self.userName, self.userPasswd]];
  [pwdArr setObject:pwds forKey:@"passwordBox"];
  [pwdArr writeToFile:kRecord_Plist_Path atomically:YES];
}

- (void)setTempUserName:(NSString *)tempUserName andTempUserPwd:(NSString *)pwd {
  self.tempUserName = tempUserName;
  self.tempUserPwd = pwd;
}

- (void)cleanPasswordBox {
  NSMutableDictionary *pwdArr = [NSMutableDictionary dictionaryWithContentsOfFile:kRecord_Plist_Path];

  NSMutableArray *pwds = [pwdArr objectForKey:@"passwordBox"];
  
  [pwds removeAllObjects];
  [pwds writeToFile:kRecord_Plist_Path atomically:YES];
}

@end
