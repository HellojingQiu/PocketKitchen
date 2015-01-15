//
//  LLCButtonModel.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 类别按钮数据模型, 万道没事的tabBar用到 */
@interface LLCButtonModel : NSObject

@property (nonatomic, copy) NSString *caralogName; // 类别名
@property (nonatomic, copy) NSString *imagePathName; // 类别图片地址
@property (nonatomic, strong) NSMutableArray *subCaralogArray; // 类别内的子类别们

@end
