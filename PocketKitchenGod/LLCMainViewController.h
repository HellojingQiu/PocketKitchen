//
//  LLCMainViewController.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLCVideoRootViewController.h"
#import "DMPQRViewController.h"

/** 主界面 **/
@interface LLCMainViewController : LLCVideoRootViewController<ZXingDelegate,DecoderDelegate,DMPQRViewControllerDelegate>

@end
