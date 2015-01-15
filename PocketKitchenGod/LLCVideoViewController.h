//
//  LLCVideoViewController.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCVideoRootViewController.h"

/** 视频界面 */
@interface LLCVideoViewController : LLCVideoRootViewController

/** 数据源 */
@property (nonatomic, strong) NSArray *dataArray;
/** 当前索引 */
@property (nonatomic, assign) NSInteger currentIndex;

/** 
 @abstract
    外部调用此方法跳转到食物的详细界面
 @param
    vegetableID: 将食物数据模型的 vegetable_id传入
 */
- (void)loadSingleFoodWithVegetableID:(NSString *)vegetableID;

@end
