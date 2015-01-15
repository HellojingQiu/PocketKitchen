//
//  LLCLoginWidget.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 登录界面 */
@interface LLCLoginWidget : UIView

/** 站好输入框 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
/** 密码输入框 */
@property (weak, nonatomic) IBOutlet UITextField *userPwdTextField;
/** "记住密码"按钮 */
@property (weak, nonatomic) IBOutlet UIButton *remmeberButton;
/** "忘记密码"按钮 */
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
/** "登录" 按钮" */
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

/** 用户是否选择了记住密码 */
@property (nonatomic, assign) BOOL isRemmberPwd;

@end
