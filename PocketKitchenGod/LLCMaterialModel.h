//
//  LLCMaterialModel.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/** "材料"数据模型 */
@interface LLCMaterialModel : NSObject

/** 图片路径 */
@property (nonatomic, copy) NSString *imagePath;
/** 食材ID */
@property (nonatomic, copy) NSString *materialId;
/** 食材名 */
@property (nonatomic, copy) NSString *materialName;
/** 配料们 */
@property (nonatomic, retain) NSDictionary *TblSeasoning;

@end
