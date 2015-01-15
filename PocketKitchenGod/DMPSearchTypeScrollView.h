//
//  DMPSearchTypeScrollView.h
//  PocketKitchenGod
//
//  Created by Damon on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

//滑动选择视图类 单一条,所以搜索页面里是实例化了5次这个类
@interface DMPSearchTypeScrollView : UIScrollView
@property (nonatomic,weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) NSInteger currentSelectedIndex;
/**
 初始化DMPSearchTypeScrollView
 */
- (id)initWithFrame:(CGRect)frame
     WithImageNames:(NSArray *)names
      isTitleHidden:(BOOL)isHidden
             target:(id)target
             action:(SEL)action;
/**
 重置Button的状态
 */
- (void)resetBtnState;
@end
