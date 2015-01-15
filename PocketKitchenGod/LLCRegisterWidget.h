//
//  LLCRegisterWidget.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 用户注册界面 */
@interface LLCRegisterWidget : UIView

/** 邮箱输入框 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
/** 账号输入框 */
@property (weak, nonatomic) IBOutlet UITextField *userNaemTextField;
/** 密码输入框 */
@property (weak, nonatomic) IBOutlet UITextField *userPwdTextField;
/** 重复密码输入框 */
@property (weak, nonatomic) IBOutlet UITextField *repeatPwdTextField;
/** 注册按钮 */
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end
