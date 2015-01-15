//
//  LLCHeaderScrollView.h
//  标签栏
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 视频界面tabBar */
@protocol LLCHeaderScrollViewDelegate;
@interface LLCHeaderScrollView : UIView

@property (nonatomic, weak) id<LLCHeaderScrollViewDelegate> llcHeaderScrollViewDelegate;

/** 
 @abstract
    初始化方法
 @param 
    frame: frane
 @param
    normalImageNames: 正常状态下的背景图片
 @param
    selectedImageNames: 选中状态下的背景图片
 @param
    titles: 标题
 */
- (id)initWithFrame:(CGRect)frame
itemsNormalImageName:(NSArray *)normalImageNames
itemsSelectedImageName:(NSArray *)selectedImageNames
             titles:(NSArray *)titles;

@end

@protocol LLCHeaderScrollViewDelegate <NSObject>

/** tabBar上的按钮被选中 */
- (void)llcHeaderScrollViewDidSelectedItemAtIndex:(NSInteger)index;

@end