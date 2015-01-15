//
//  LLCDateIntroduceView.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCDateIntroduceView.h"

@interface LLCDateIntroduceView ()
<UIScrollViewDelegate>
{
  UILabel *_avoidLabel;
  UILabel *_fittingLabel;
  
  NSTimer *_timer; // 定时器
}
@end

@implementation LLCDateIntroduceView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
  }
  return self;
}

- (void)lanuchContent {
  // 忌
  _avoidLabel = [[UILabel alloc] init];
  _avoidLabel.text = self.avoidContent;
  _avoidLabel.backgroundColor = [UIColor clearColor];
  _avoidLabel.textColor = [UIColor whiteColor];
  _avoidLabel.font = [UIFont systemFontOfSize:12];
  
  CGSize avoidLabelSize = [_avoidLabel.text sizeWithFont:_avoidLabel.font];
  
  // 宜
  _fittingLabel = [[UILabel alloc] init];
  _fittingLabel.text = self.fittingContent;
  _fittingLabel.textColor = [UIColor whiteColor];
  _fittingLabel.backgroundColor = [UIColor clearColor];
  _fittingLabel.font = [UIFont systemFontOfSize:12];
  
  CGSize fittingLabelSize = [_fittingLabel.text sizeWithFont:_fittingLabel.font];
  
  // 滚动条
  self.moveScrollView.delegate = self;
  self.moveScrollView.contentSize = CGSizeMake(avoidLabelSize.width+fittingLabelSize.width+self.moveScrollView.frame.size.width*3, self.moveScrollView.frame.size.height);
  _fittingLabel.frame = CGRectMake(self.moveScrollView.frame.size.width, 0, fittingLabelSize.width, self.moveScrollView.frame.size.height);
  _avoidLabel.frame = CGRectMake(_fittingLabel.frame.origin.x+_fittingLabel.frame.size.width+self.moveScrollView.frame.size.width, 0, avoidLabelSize.width, self.moveScrollView.frame.size.height);
  
  [self.moveScrollView addSubview:_avoidLabel];
  [self.moveScrollView addSubview:_fittingLabel];
  
  self.moveScrollView.showsHorizontalScrollIndicator = NO;
  self.moveScrollView.showsVerticalScrollIndicator = NO;
  
  [self fire];
}

#pragma mark - 开始滚动
- (void)fire {
  _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(contentMove) userInfo:nil repeats:YES];
}

#pragma mark 内容移动
- (void)contentMove {
  CGPoint pos = self.moveScrollView.contentOffset;
  pos.x += 1;
  self.moveScrollView.contentOffset = pos;
}

#pragma mark 重置内容
- (void)resetContent {
  [_timer invalidate];
  
  CGPoint pos = self.moveScrollView.contentOffset;
  pos.x = 0;
  self.moveScrollView.contentOffset = pos;
}

#pragma mark - UIScroll View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGRect frame = self.moveScrollView.frame;
  CGPoint pos = self.moveScrollView.contentOffset;
  
  // 根据位移, 切换 "宜"/"忌"
  if (self.moveScrollView.contentOffset.x >= _avoidLabel.frame.size.width+frame.size.width) {
    self.statusLabel.image = [UIImage imageNamed:@"首页-忌.png"];
  }
  
  if (self.moveScrollView.contentOffset.x < frame.size.width+_fittingLabel.frame.size.width) {
    self.statusLabel.image = [UIImage imageNamed:@"首页-宜.png"];
  }
  
  if (self.moveScrollView.contentOffset.x >= self.moveScrollView.contentSize.width-frame.size.width) {
    pos.x = 0;
    self.moveScrollView.contentOffset = pos;
  }
}

@end
