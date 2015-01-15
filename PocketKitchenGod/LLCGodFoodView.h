//
//  LLCGodFoodView.h
//  只能选材
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 智能选菜tableView */
@interface LLCGodFoodView : UIView

/**
   以frame和背景色的初始化方法
 */
- (id)initWithFrame:(CGRect)frame andTableBackgroungColor:(UIColor *)color;

@property (nonatomic, strong) UILabel *titleLabel;      // 展示类别名
@property (nonatomic, strong) NSMutableArray *dataArray;  // 数据源
@property (nonatomic, strong) UITableView *tableView; // 展示食材的

// 食材被点击后的执行方法和对象
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

- (void)reloadData;

@end
