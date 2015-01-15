//
//  DMPDiseaseModel.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPDiseaseModel.h"

@implementation DMPDiseaseModel
- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"DMPDiseaseModel:属性%@赋值错误",key);
}
@end
