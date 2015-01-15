//
//  DMPMetrialView.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>
//条件展示视图类
@class DMPSearchDisPlayView;
@class DMPMetrialView;

@protocol DMPMetrialViewDelegate <NSObject>

@required
/**
 设置展示块个数代理方法
 */
- (NSInteger)numberOfDisplayerForDmpMetrialView:(DMPMetrialView *)metrialView ;
/**
 设置展示块布局代理方法
 */
- (DMPSearchDisPlayView *)dmpMetrialView:(DMPMetrialView *)metrialView displayerAtIndex:(NSInteger)index;

@optional
/**
 展示块点击删除时调用的代理方法
 */
- (void)dmpMetrialView:(DMPMetrialView *)metrialView DeleteDisplayerAtIndex:(NSInteger)index;

@end

@interface DMPMetrialView : UIView
@property (nonatomic, weak) id<DMPMetrialViewDelegate>delegate;
/**
 初始化一个DMPMetralView
 @prarm distanceV displayer距离垂直边界的距离
 @prarm distanceH dislplayer距离水平边界的距离
 @prarm displayerSize displayer的尺寸
 @prarm placeTitle MetralView的placeHolder
 @prarm name 背景图的名字
 */
- (id)initWithFrame:(CGRect)frame
                    distanceToVerticalSide:(CGFloat)distanceV
                    distanceToHorizontalSide:(CGFloat)distanceH
                    displayerSize:(CGSize)displayerSize
                    placeHolder:(NSString *)placeTitle
                    backgroundImageName:(NSString *)name;
/**
 重置数据
 */
- (void)reloadData ;
/**
 从MetralView的重用队列中获取一个displayer,
 @return 重用队列中若无,返回空,否则返回一个复用的displayer
 */
- (DMPSearchDisPlayView *) dequeueDisplayerWithidentifier:(NSString *)identifier;
@end
