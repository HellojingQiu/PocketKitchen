//
//  LLCNousModel.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/** "相关常识"数据模型 */
@interface LLCNousModel : NSObject

/** 图片地址 */
@property (nonatomic, copy) NSString *imagePath;
/** 原料解析 */
@property (nonatomic, copy) NSString *nutritionAnalysis;
/** 制作过程 */
@property (nonatomic, copy) NSString *productionDirection;

@end
