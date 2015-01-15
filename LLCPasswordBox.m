//
//  LLCPasswordBox.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-21.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCPasswordBox.h"

@implementation LLCPasswordBox

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
  }
  return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  [self.firstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
