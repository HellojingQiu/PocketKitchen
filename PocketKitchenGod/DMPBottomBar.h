//
//  DMPBottomBar.h
//  PocketKitchenGod
//
//  Created by Damon on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>
//底部bar类
@interface DMPBottomBar : UIView
/**
 根据数组中的DMPBottomModel来初始化DMPBottomBar
 */
- (void) setItemsWithModels:(NSArray *)models;
@end
