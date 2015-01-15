//
//  LLCWoderlfulTabBar.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLCWonderfulTabBarDelegate;

/** 万道菜tabBar */
@interface LLCWoderlfulTabBar : UIView

/** 代理 */
@property (nonatomic, assign) id<LLCWonderfulTabBarDelegate> llcWonderfulTabBarDelegate;

/** 以frame和按钮数据模型的初始化方法 */
- (id)initWithFrame:(CGRect)frame buttonModels:(NSArray *)models;

@end

@protocol LLCWonderfulTabBarDelegate <NSObject>

- (void)selectedCategoryID:(NSString *)categoryID;

/** 食材被选中后执行的代理方法,CategoryName:类别名/foodName:食物名  */
- (void)selectedCategoryID:(NSString *)categoryID CategoryName:(NSString *)categoryName foodName:(NSString *)foodName;

@end