//
//  LLCVideoDetailViewController.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//


#import "DMPSubIIRootViewController.h"

/** 请求类型 */
typedef enum {
  eMaterialRequest = 33,
  eCookMehtodRequest = 34,
  eNousRequest = 35,
  eFittingRequest = 36,
}DetailRequestType;

@class LLCMainModel;
/** 食物详细界面 */
@interface LLCVideoDetailViewController :DMPSubIIRootViewController

@property (nonatomic, assign) NSInteger type; /** 请求类型 */
@property (nonatomic, assign) NSInteger currentIndex; /** 当前索引 */
@property (nonatomic, assign) DetailRequestType currentRequestType; /** 请求类型 */
@property (nonatomic, strong) LLCMainModel *mainModel; /** 单个的数据模型 */

@end
