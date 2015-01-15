//
//  LLCPageControl.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 页码指示器 **/
@interface LLCPageControl : UIView

/** 页数的setter/getter方法 */
- (NSInteger)pageCount;
- (void)setPageCount:(NSInteger)pageCount;

/** 
 @abstract
    初始化函数
 @param
    frame: 背景view的frame
 @param
    count: 点个数
 @param
    radius: 点半径
 */
- (id)initWithFrame:(CGRect)frame
         pointCount:(NSUInteger)count
  pointCornerRadius:(CGFloat)radius;

/** 熄灭指定索引后所有的点 */
- (void)extinguishPointsAfterPage:(NSInteger)page;

/** 点亮指定索引前的所有点 */
- (void)lightPointBeforePage:(NSInteger)page;

@end
