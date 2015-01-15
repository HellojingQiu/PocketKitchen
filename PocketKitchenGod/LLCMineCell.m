//
//  LLCMineCell.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCMineCell.h"

@implementation LLCMineCell

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    self.pictureImageView.autoresizingMask = UIViewAutoresizingNone;
  }
  return self;
}

@end
