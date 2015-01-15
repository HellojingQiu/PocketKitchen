//
//  LLCCookMethodModel.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/** "做法" 数据模型 */
@interface LLCCookMethodModel : NSObject

/** 描述 */
@property (nonatomic, copy) NSString *describe;
/** 图片地址 */
@property (nonatomic, copy) NSString *imagePath;
/** 步骤号 */
@property (nonatomic, copy) NSString *order_id;

@end
