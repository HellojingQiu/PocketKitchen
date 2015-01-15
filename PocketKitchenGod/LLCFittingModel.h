//
//  LLCFittingModel.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/** "相宜相克"数据模型 */
@interface LLCFittingModel : NSObject

/** 描述 */
@property (nonatomic, copy) NSString *contentDescription;
/** 图片ID */
@property (nonatomic, copy) NSString *fittingImageId;
/** 图片名 */
@property (nonatomic, copy) NSString *imageName;
/** 食材名 */
@property (nonatomic, copy) NSString *materialName;
/** YES:相宜/ NO:相克 */
@property (nonatomic, copy) NSString *isFitting;

@end
