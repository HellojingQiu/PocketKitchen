//
//  DMPBottomModel.h
//  PocketKitchenGod
//
//  Created by Damon on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMPBottomModel : NSObject
@property (nonatomic,assign) SEL action;
@property (nonatomic,weak) id target;
@property (nonatomic, copy) NSString * imageName;
@property (nonatomic, copy) NSString * imageNameH;
@property (nonatomic, assign) NSUInteger tag;
- (id)initBottomModelWithNormalImageName:(NSString *)imageName
                      highlightImageName:(NSString *)imageNameH
                                  target:(id)target
                                  action:(SEL)action tag:(NSUInteger)tag;
@end
