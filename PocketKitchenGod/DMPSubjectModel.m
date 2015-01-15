//
//  DMPSubjectModel.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSubjectModel.h"

@implementation DMPSubjectModel
- (id)init {
    if (self = [super init]) {
        self.diseaseArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)addDiseaseModel:(DMPDiseaseModel *)model {
    [self.diseaseArray addObject:model];
}
- (void) setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"DMPSubjectModel属性:%@赋值错误",key);
}
@end
