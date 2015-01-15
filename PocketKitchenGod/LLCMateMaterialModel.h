//
//  LLCMateMaterialModel.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/** "配料"数据模型 */
@interface LLCMateMaterialModel : NSObject

/** 图片地址 */
@property (nonatomic, copy) NSString *imagePath;
/** 配料名称 */
@property (nonatomic, copy) NSString *name;
/** 顺序号 */
@property (nonatomic, copy) NSString *orderId;
/** 好像没啥用 */
@property (nonatomic, copy) NSString *seasoningId;

@end
