//
//  DMPBottomModel.m
//  PocketKitchenGod
//
//  Created by Damon on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPBottomModel.h"

@implementation DMPBottomModel

- (id)initBottomModelWithNormalImageName:(NSString *)imageName
                      highlightImageName:(NSString *)imageNameH
                                  target:(id)target
                                  action:(SEL)action tag:(NSUInteger)tag {
    if (self = [super init]) {
        self.imageName = imageName;
        self.imageNameH = imageNameH;
        self.target = target;
        self.action = action;
        self.tag = tag;
    }
    return self;
}
@end
