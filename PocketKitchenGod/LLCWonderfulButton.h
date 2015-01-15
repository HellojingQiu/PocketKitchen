//
//  LLCWonderfulButton.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 类别按钮 */
@interface LLCWonderfulButton : UIView

@property (weak, nonatomic) IBOutlet UIButton *theButton;         // 按钮
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;         // 标题
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView; // 标题图片

@end
