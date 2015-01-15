//
//  LLCSubButtonModel.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 子类别按钮数据模型 */
@interface LLCSubButtonModel : NSObject

@property (nonatomic, copy) NSString *childCatalogName;         // 类别名
@property (nonatomic, copy) NSString *catalogId;                // 类别ID
@property (nonatomic, copy) NSString *imagePathName;            // 图片地址
@property (nonatomic, copy) NSString *vegetableChildCatalogId;

@end
