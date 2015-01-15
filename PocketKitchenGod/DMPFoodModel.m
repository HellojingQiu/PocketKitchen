//
//  DMPFoodModel.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPFoodModel.h"

@implementation DMPFoodModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"DMPFoodModel 属性%@赋值错误",key);
}
@end
