//
//  LLCFacilityHUD.m
//  PhotoBrosswer
//
//  Created by 李超 on 14-2-14.
//  Copyright (c) 2014年 李超. All rights reserved.
//

#import "LLCFacilityHUD.h"

#define kBackgroundImage_Name @"提示底.png"

#define kDismiss_Animation_Duration 1
#define kInHUD_Tag 223
#define kHUD_Tag 411
@interface LLCFacilityHUD ()
{
  id _hudTarget;
  SEL _hudAction;
  
  UILabel *_displayLabel;
}
@end

@implementation LLCFacilityHUD

- (id)initWithPosition:(CGPoint)position {
  if (self = [super init]) {
    [self layoutSelfWithPosition:position];
  }
  return self;
}

/** 添加回调 */
- (void)addHUDTarget:(id)target completeAction:(SEL)action {
  _hudTarget = target;
  _hudAction = action;
}

/** 布局 */
- (void)layoutSelfWithPosition:(CGPoint)position {
  UIImage *backgroundImage = [UIImage imageNamed:kBackgroundImage_Name];
  UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
  
  self.bounds = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
  self.center = position;
  
  backgroundImageView.frame = self.bounds;
  
  [self addSubview:backgroundImageView];
}

/** 加载 */
- (void)loading {
  UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  act.tag = kInHUD_Tag;
  act.backgroundColor = [UIColor grayColor];
  act.center = CGPointMake(self.frame.size.width/2,
                           self.frame.size.height/2);
  act.backgroundColor = [UIColor clearColor];
  [self addSubview:act];
  
  _displayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  _displayLabel.backgroundColor = [UIColor clearColor];
  _displayLabel.textColor = [UIColor whiteColor];
  _displayLabel.text = @"加载中...";
  _displayLabel.font = [UIFont systemFontOfSize:15];
  [_displayLabel sizeToFit];
  
  _displayLabel.center = CGPointMake(act.center.x, act.frame.origin.y+act.frame.size.height+5+_displayLabel.bounds.size.height/2);
  [self addSubview:_displayLabel];
  
  [act startAnimating];
}

/** 成功 */
- (void)successed {
  UIImage *successImage = [UIImage imageNamed:@"保存成功.png"];
  UIImageView *successImageView = [[UIImageView alloc] initWithImage:successImage];
  [successImageView sizeToFit];
  successImageView.center = CGPointMake(self.frame.size.width/2,
                                        self.frame.size.height/2);
  [self addSubview:successImageView];
  _displayLabel.text = @"加载成功";
  [_displayLabel sizeToFit];
  
  [self dismissed];
}

- (void)failed {
  _displayLabel.text = @"加载失败";
  [_displayLabel sizeToFit];
  
  [self dismissed];
}

/** 撤销hud */
- (void)dismissed {
  UIActivityIndicatorView *act = (UIActivityIndicatorView *)[self viewWithTag:kInHUD_Tag];
  [act stopAnimating];
  [act removeFromSuperview];
  [UIView animateWithDuration:kDismiss_Animation_Duration
                   animations:^{
    self.alpha = 0;
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  
    if (_hudTarget && [_hudTarget respondsToSelector:_hudAction]) {
      [_hudTarget performSelector:_hudAction withObject:nil];
    }
  }];
}


+ (void)hudLoadingAppearOnView:(UIView *)view {
    // 加载hud
    UIView *oldHud = [view viewWithTag:kHUD_Tag];
    if (oldHud != nil) {
        [oldHud removeFromSuperview];
    }
  
    LLCFacilityHUD *hud = [[LLCFacilityHUD alloc] initWithPosition:view.center];
    hud.tag = kHUD_Tag;
    [view addSubview:hud];
    [hud loading];

}
+ (void)hudSuccessAppearOnView:(UIView *)view {
    LLCFacilityHUD *hud = (LLCFacilityHUD *)[view viewWithTag:kHUD_Tag];
    [hud successed];
}
+(void)hudFailAppearOnView:(UIView *)view {
    LLCFacilityHUD *hud = (LLCFacilityHUD *)[view viewWithTag:kHUD_Tag];
    [hud failed];
}
+ (void)hudDismissedOnView:(UIView *)view {
  LLCFacilityHUD *hud = (LLCFacilityHUD *)[view viewWithTag:kHUD_Tag];
  [hud dismissed];
}
@end
