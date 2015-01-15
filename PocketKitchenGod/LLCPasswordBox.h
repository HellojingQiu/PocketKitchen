//
//  LLCPasswordBox.h
//  PocketKitchenGod
//
//  Created by 李超 on 14-2-21.
//  Copyright (c) 2014年 李超. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 用于展示用户所存储的账号和密码, 点击账号输入框时展现 */
@interface LLCPasswordBox : UIView

/** 展示账号的按钮 */
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
/** 悄悄记录密码的标签 */
@property (weak, nonatomic) IBOutlet UILabel *hideLabel;

@end
