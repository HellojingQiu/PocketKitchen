//
//  LLCRequestModel.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLCRequestModel : NSObject

@property (nonatomic, assign) NSInteger page;               // 页数
@property (nonatomic, copy) NSString *oficeid;              // 领域
@property (nonatomic, copy) NSString *diseaseId;            // 食疗id
@property (nonatomic, copy) NSString *vegetable_id;         // 食材id
@property (nonatomic, copy) NSString *user_id;              // 用户id
@property (nonatomic, assign) NSInteger type;               // 视频选项类型
@property (nonatomic, copy) NSString *material_id;          // 材料id
@property (nonatomic, copy) NSString *child_catalog_name;   // 子目录名
@property (nonatomic, copy) NSString *year;                 // 年
@property (nonatomic, copy) NSString *month;                // 月
@property (nonatomic, copy) NSString *day;                  // 日
@property (nonatomic, copy) NSString *username;             // 用户名
@property (nonatomic, copy) NSString *password;             // 密码
@property (nonatomic, copy) NSString *email;                // 邮箱

@end
