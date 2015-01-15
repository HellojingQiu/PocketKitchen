//
//  LLCMaterialModel.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCMaterialModel.h"

@implementation LLCMaterialModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@", self.TblSeasoning];
}

@end
