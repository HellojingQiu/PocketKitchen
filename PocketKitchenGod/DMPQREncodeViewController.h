//
//  DMPQREncodeViewController.h
//  PocketKitchenGod
//
//  Created by Damon on 14-2-23.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSubRootViewController.h"
#import <Decoder.h>
//生成二维码图片的VC类
@interface DMPQREncodeViewController : DMPSubRootViewController
/**
 根据codeString和naviBar的title来初始化VC
 */
- (id) initWithCodeString:(NSString *)codeString title:(NSString *)title;
@end
