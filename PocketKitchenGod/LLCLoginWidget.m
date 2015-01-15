//
//  LLCLoginWidget.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCLoginWidget.h"
#import "LLCUserInfoManager.h"


@implementation LLCLoginWidget

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
  }
  return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  [self.remmeberButton addTarget:self action:
   @selector(remmeberPwd:) forControlEvents:UIControlEventTouchUpInside];
  
  // 从单例中获取记住密码的状态, 设置记住密码按钮的状态
  self.isRemmberPwd = [[LLCUserInfoManager sharedUserInfo] isRemmberPassword];
  
  if (self.isRemmberPwd) {
    self.remmeberButton.selected = YES;
  } else {
    self.remmeberButton.selected = NO;
  }
  
  [self.forgetPasswordButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

/** 修改对"记住密码"的记录 */
- (void)remmeberPwd:(UIButton *)button {
  button.selected = !button.selected;
  self.isRemmberPwd = !self.isRemmberPwd;
  
  [[LLCUserInfoManager sharedUserInfo] updateIsRemmberPassword:self.isRemmberPwd];
}

@end
