//
//  LLCMainModel.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 主界面数据模型 **/
@interface LLCMainModel : NSObject

@property (nonatomic, copy) NSString *materialVideoPath;      // 材料准备视频地址
@property (nonatomic, copy) NSString *productionProcessPath;  // 制作方法视频地址
@property (nonatomic, copy) NSString *catalogId;              // 分类id
@property (nonatomic, copy) NSString *clickCount;             // 点击数
@property (nonatomic, copy) NSString *cookingMethod;          // 制作方法
@property (nonatomic, copy) NSString *cookingWay;             // "烹饪时间"
@property (nonatomic, copy) NSString *effect;                 // 效果
@property (nonatomic, copy) NSString *fittingCrowd;           // 适合人群
@property (nonatomic, copy) NSString *fittingRestriction;     // 材料用量
@property (nonatomic, copy) NSString *timeLength;             // 烹饪时长
@property (nonatomic, copy) NSString *taste;                  // 口味
@property (nonatomic, copy) NSString *method;                 // 成分
@property (nonatomic, copy) NSString *downloadCount;          // 下载数
@property (nonatomic, copy) NSString *imagePathLandscape;     // 大图
@property (nonatomic, copy) NSString *imagePathPortrait;      // 小图
@property (nonatomic, copy) NSString *imagePathThumbnails;    // 图标
@property (nonatomic, copy) NSString *vegetable_id;           // 食材id
@property (nonatomic, copy) NSString *vegetableCookingId;     // 食材制作id
@property (nonatomic, copy) NSString *name;                   // 菜名
@property (nonatomic, copy) NSString *englishName;            // 菜名拼音
@property (nonatomic, copy) NSString *price;                  // 价格

@end
