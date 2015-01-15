//
//  LLCVideoTabBar.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 视频页面点选播放视频的tabBar */
@interface LLCVideoTabBar : UIView

/** 材料准备按钮 */
@property (weak, nonatomic) IBOutlet UIButton *prepareButton;
/** 制作方法按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cookMethodButton;

@end
