//
//  LLCStoreCell.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-21.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCStoreCell.h"

@implementation LLCStoreCell

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  // 字体转动
  self.freeLabelLeft.layer.anchorPoint = CGPointMake(0.5, 0.5);
  CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI / 6);
  self.freeLabelLeft.transform = trans;
  
  self.freeLabelRight.layer.anchorPoint = CGPointMake(0.5, 0.5);
  CGAffineTransform transR = CGAffineTransformMakeRotation(M_PI / 6);
  self.freeLabelRight.transform = transR;
}

@end
