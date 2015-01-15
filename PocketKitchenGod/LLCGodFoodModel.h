//
//  LLCGodFoodModel.h
//  只能选材
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 食物类别数据模型 */
@interface LLCGodFoodModel : NSObject

/** 类别名 */
@property (nonatomic, copy) NSString *categoryName;
/** 类别内的食物们 */
@property (nonatomic, strong) NSMutableArray *subFoodModels;

@end
