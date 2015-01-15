//
//  LLCSubFoodModel.h
//  只能选材
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 食物数据模型 */
@interface LLCSubFoodModel : NSObject

/** 食物名 */
@property (nonatomic, copy) NSString *foodName;
/** 食物的图片名 */
@property (nonatomic, copy) NSString *foodImagName;
/** 食物ID */
@property (nonatomic, copy) NSString *materialId;

@end
