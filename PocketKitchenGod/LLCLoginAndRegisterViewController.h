//
//  LLCLoginAndRegisterViewController.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-20.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSubRootViewController.h"

@protocol LLCLoginAndRegisterViewDelegate;
/** 登陆/注册 界面 */
@interface LLCLoginAndRegisterViewController : DMPSubRootViewController

@property (nonatomic, assign) id<LLCLoginAndRegisterViewDelegate> llcLoginAndRegisterDelegate;
/** YES: 显示登陆界面/ NO:显示注册界面 */
@property (nonatomic, assign) BOOL isLogin;

/**
 @abstract
    初始化方法
 @param
    isLogin: YES: 显示登陆界面/ NO:显示注册界面
 @param
    isStore: YES: 通过收藏点击/ NO: 不是通过收藏点击. PS: 实测这个参数怎么设置无所谓
 */
- (id)initWithIsLogin:(BOOL)isLogin isStore:(BOOL)isStore;

@end


@protocol LLCLoginAndRegisterViewDelegate <NSObject>

/**
 @abstract
    登陆成功后, 将调用此代理方法
 @param
    userName: 用户名
 */
- (void)llcLoginSuccessedWithName:(NSString *)userName;

@end