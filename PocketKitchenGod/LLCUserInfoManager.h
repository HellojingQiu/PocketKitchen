//
//  LLCUserInfoManager.h
//  PocketKitchenGod
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLCUserInfoManager : NSObject

/** 用户ID, 请求数据的url中可能需要此参数 */
@property (nonatomic, copy) NSString *userID;
/** 用户的账号(邮箱) */
@property (nonatomic, copy) NSString *userName;
/** 用户密码 */
@property (nonatomic, copy) NSString *userPasswd;
/** 用户名, 登陆后需要在"我的"界面展示 */
@property (nonatomic, copy) NSString *displayName;

/** 暂时记录的用户名和密码, 在用户点击"记住密码时"登陆时暂时先记录 */
@property (nonatomic, copy) NSString *tempUserName;
@property (nonatomic, copy) NSString *tempUserPwd;

/** 用户是否已经的登陆 */
@property (nonatomic, assign) BOOL hasLogin;
/** 是否记住密码 */
@property (nonatomic, assign) BOOL isRemmberPassword;

/** 获取单例 */
+ (id)sharedUserInfo;
/** 更新是否需要记住密码 */
- (void)updateIsRemmberPassword:(BOOL)isRemmberPassword;
/** 设置用户暂时的账号和密码 */
- (void)setTempUserName:(NSString *)tempUserName
         andTempUserPwd:(NSString *)pwd;
/** 更新用户信息, 在用户点击"记住密码"登录, 并登录成功后, 将暂时账号和密码转赋给userName和userPasswd */
- (void)updateUserInfo;
/** 清空所记录的所有的用户名和密码 */
- (void)cleanPasswordBox;

@end



