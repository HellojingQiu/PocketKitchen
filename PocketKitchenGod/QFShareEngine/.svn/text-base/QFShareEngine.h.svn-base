//
//  QFShareEngine.h
//  BookShare
//
//  Created by yang on 31/10/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QFShareType.h"

@interface QFShareEngine : NSObject

/**
 打开调试开关
 */
+ (void) enableDebug;
/* 未来会加入调试等级 */
+ (NSInteger) getDebugFlag;


/**
 *	@brief	连接新浪微博开放平台应用以使用相关功能，此应用需要引用
 *          http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址,无回调页面或者不需要返回回调时可以填写新浪默认回调页面：https://api.weibo.com/oauth2/default.html
 *                          但新浪开放平台中应用的回调地址必须填写此值
 */
+ (void)connectSinaWeiboWithAppKey:(NSString *)appKey
                    appSecret:(NSString *)appSecret
                    redirectUri:(NSString *)redirectUri;

/**
 *	@brief	连接腾讯微博开放平台应用以使用相关功能，此应用需要引用
 *          http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址，此地址则为应用地址。
 */
+ (void)connectTencentWeiboWithAppKey:(NSString *)appKey
                    appSecret:(NSString *)appSecret
                    redirectUri:(NSString *)redirectUri;

+ (void) connectWeiXinWithAppKey:(NSString *)appid;

+ (QFShareType *) getShareEngineType:(ShareType)type;
+ (QFShareType *) getSinaWeiboType;
+ (QFShareType *) getTencentWeiboType;

/**
 *	@brief 运行登陆界面
 *	@param 	type 	平台类型
 */
+ (void) showLoginInterface:(ShareType)type;

typedef void(^SEShowLoginInterfaceHandler) (ShareType type, BOOL end);
+ (void) showLoginInterface:(ShareType)type completion:(SEShowLoginInterfaceHandler)block;

+ (BOOL) hasAlreadyLogin:(ShareType)type;
+ (NSString *)getOAuthDomain:(ShareType)type;
+ (NSDictionary *)getPrivateDictionary:(ShareType)type;
+ (NSString *)getLoginUserID:(ShareType)type;


#pragma mark  简单的接口 直接发微博 
/**
 *	@brief	分享内容,此接口不需要弹出分享界面直接进行分享（除微信、QQ、Pinterest平台外，这些平台会调用客户端进行分享）。
 *
 *  @since  ver2.2.5
 *
 *	@param 	content 	内容对象
 *	@param 	type 	平台类型
 *  @param  statusBarTips   状态栏提示
 *	@param 	result 	返回事件
 */
typedef void(^SEPublishContentEventHandler) (ShareType type, ShareStatus status, NSError *error, NSData *data, BOOL end);
+ (BOOL)shareContent:(NSString *)content
                type:(ShareType)type
       statusBarTips:(BOOL)statusBarTips
              result:(SEPublishContentEventHandler)result;
// 发送带图片的文字weibo
+ (BOOL)shareImage:(UIImage *)image
           content:(NSString *)content
                type:(ShareType)type
       statusBarTips:(BOOL)statusBarTips
              result:(SEPublishContentEventHandler)result;
+ (BOOL) getFriendsList:(ShareType)type
              result:(SEPublishContentEventHandler)result;

#pragma mark  UI定制方面 定制上面的导航控制器内容
/* UI定制方面 
   定制上面的导航控制器内容.
 */
+ (void) setTopViewTitle:(NSString *)title;
+ (void) setTopViewCancelTitle:(NSString *)title;
+ (void) setTopView:(UIView *)view;


/**
 *	@brief	处理请求打开链接,如果集成新浪微博(SSO)、Facebook(SSO)、微信、QQ分享功能需要加入此方法
 *
 *	@param 	url 	链接
 *  @param  wxDelegate  微信委托,如果没有集成微信SDK，可以传入nil
 *
 *	@return	YES 表示接受请求 NO 表示不接受
 */
+ (BOOL)handleOpenURL:(NSURL *)url;
/**
 *	@brief	处理请求打开链接,如果集成新浪微博(SSO)、Facebook(SSO)、微信、QQ分享功能需要加入此方法
 *
 *	@param 	url 	链接
 *	@param 	sourceApplication 	源应用
 *	@param 	annotation 	源应用提供的信息
 *  @param  wxDelegate  微信委托,如果没有集成微信SDK，可以传入nil
 *
 *	@return	YES 表示接受请求，NO 表示不接受请求
 */
+ (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
           ;



@end
