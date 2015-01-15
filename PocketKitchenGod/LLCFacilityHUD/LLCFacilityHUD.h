//
//  LLCFacilityHUD.h
//  PhotoBrosswer
//
//  Created by yxx on 14-2-14.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 加载指示框 */
@interface LLCFacilityHUD : UIView

/**
 @abstract
    初始化方法
 @param
    position: 控件的中点位置
 */
- (id)initWithPosition:(CGPoint)position;

/**
 @abstract
    增加回调功能, 当hud撤销后, target将调用action
 */
- (void)addHUDTarget:(id)target completeAction:(SEL)action;

/**
 加载动画
 */
- (void)loading;

/**
 加载成功动画, 这个方法会自动调用 撤销动画
 */
- (void)successed;

/** 加载失败时调用 */
- (void)failed;

/**
 */
+ (void)hudLoadingAppearOnView:(UIView *)view;
+ (void)hudSuccessAppearOnView:(UIView *)view;
+ (void)hudFailAppearOnView:(UIView *)view;
+ (void)hudDismissedOnView:(UIView *)view;
@end
