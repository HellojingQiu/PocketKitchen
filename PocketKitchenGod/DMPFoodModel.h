//
//  DMPFoodModel.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMPFoodModel : NSObject
@property (nonatomic ,copy) NSString *clickCount;
@property (nonatomic, copy) NSString *imagePathLandscape;
@property (nonatomic, copy) NSString *imagePathPortrait;
@property (nonatomic, copy) NSString *imagePathThumbnails;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *vegetableId;
@property (nonatomic, copy) NSString *storeDate;

@end
