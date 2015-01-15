//
//  LLCMainDateModel.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 主界面日期控件数据模型 */
@interface LLCMainDateModel : NSObject

@property (nonatomic, copy) NSString *alertInfoAvoid;   // 忌
@property (nonatomic, copy) NSString *alertInfoFitting; // 宜
@property (nonatomic, copy) NSString *LunarCalendar;    // 农历

@end
