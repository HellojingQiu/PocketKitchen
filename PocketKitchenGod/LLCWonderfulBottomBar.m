//
//  LLCWonderfulBottomBar.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCWonderfulBottomBar.h"
#import "LLCWonderfulBottomButton.h"

@implementation LLCWonderfulBottomBar

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    
    // 布局食材按钮们
    self.buttons = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8; i++) {
      LLCWonderfulBottomButton *aButton = [[[NSBundle mainBundle] loadNibNamed:@"LLCWonderfulBottomButton" owner:self options:nil] lastObject];
      
      aButton.center = CGPointMake(40+80*(i%4), 24+48*(i/4));
      [self.buttons addObject:aButton];
      [self addSubview:aButton];
    }
  }
  return self;
}

@end
