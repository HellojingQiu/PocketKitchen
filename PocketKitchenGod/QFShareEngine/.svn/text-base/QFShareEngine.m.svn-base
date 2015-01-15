//
//  QFShareEngine.m
//  BookShare
//
//  Created by yang on 31/10/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "QFShareEngine.h"

#import "SinaOAuthManager.h"
#import "TencentOAuthManager.h"
#import "WeixinOAuthManager.h"


@implementation QFShareEngine

static int _debugMode;
+ (void) enableDebug {
    _debugMode = 1;
}
+ (NSInteger) getDebugFlag {
    return _debugMode;
}

static SinaOAuthManager *sinaOAuthManager;
static TencentOAuthManager *tencentOAuthManager;

static WeixinOAuthManager *weixinOAuthManager;

static OAuthManager * getOAuthMangerByType(ShareType type) {
    if (type == ShareTypeSinaWeibo) {
        return sinaOAuthManager;
    } else if (type == ShareTypeTencentWeibo) {
        return tencentOAuthManager;
    } else if (type == ShareTypeWeixiTimeline || type == ShareTypeWeixiSession) {
        return weixinOAuthManager;
    }
    return nil;
}

+ (void) showLoginInterface:(ShareType)type {
    return [[self class] showLoginInterface:type completion:nil];
}
+ (void) showLoginInterface:(ShareType)type completion:(SEShowLoginInterfaceHandler)block {
    OAuthManager *manager = getOAuthMangerByType(type);
    [manager login];
}

+ (BOOL) hasAlreadyLogin:(ShareType)type {
    OAuthManager *manager = getOAuthMangerByType(type);
    return [manager isAlreadyLogin];
}

+ (NSString *)getOAuthDomain:(ShareType)type {
    OAuthManager *manager = getOAuthMangerByType(type);
    return [manager getOAuthDomain];
}
+ (NSDictionary *)getPrivateDictionary:(ShareType)type {
    OAuthManager *manager = getOAuthMangerByType(type);
    return [manager getCommonParams];
}

+ (NSString *)getLoginUserID:(ShareType)type {
    return nil;
}

+ (void)connectSinaWeiboWithAppKey:(NSString *)appKey
                         appSecret:(NSString *)appSecret
                       redirectUri:(NSString *)redirectUri {
    QFShareType *weibo = [[QFShareType alloc] init];
    weibo.type = ShareTypeSinaWeibo;
    weibo.appKey = appKey;
    weibo.appSecret = appSecret;
    weibo.redirectUri = redirectUri;
    [[QFShareQueue sharedInstance] addShareTypeToQueue:weibo];
    SAFELY_RELEASE(weibo);
    
    sinaOAuthManager = [[SinaOAuthManager alloc] init];
}

+ (void)connectTencentWeiboWithAppKey:(NSString *)appKey
                            appSecret:(NSString *)appSecret
                          redirectUri:(NSString *)redirectUri {
    QFShareType *weibo = [[QFShareType alloc] init];
    weibo.type = ShareTypeTencentWeibo;
    weibo.appKey = appKey;
    weibo.appSecret = appSecret;
    weibo.redirectUri = redirectUri;
    [[QFShareQueue sharedInstance] addShareTypeToQueue:weibo];
    SAFELY_RELEASE(weibo);
    tencentOAuthManager = [[TencentOAuthManager alloc] init];
}

+ (void) connectWeiXinWithAppKey:(NSString *)appid {
    weixinOAuthManager = [[WeixinOAuthManager alloc] init];

    [WXApi registerApp:appid withDescription:@"千锋Winxin测试"];
}

+ (QFShareType *) getSinaWeiboType {
    return [[self class] getShareEngineType:ShareTypeSinaWeibo];
}
+ (QFShareType *) getTencentWeiboType {
    return [[self class] getShareEngineType:ShareTypeTencentWeibo];
}

+ (QFShareType *) getShareEngineType:(ShareType)type {
    NSArray *arr = [[QFShareQueue sharedInstance] getShareTypeList];
    for (QFShareType *s in arr) {
        if (s.type == type) {
            return s;
        }
    }
    return nil;
}

#pragma mark 一站式发送weibo接口
+ (BOOL)shareContent:(NSString *)content
                type:(ShareType)type
       statusBarTips:(BOOL)statusBarTips
              result:(SEPublishContentEventHandler)result {
    NSError *err = nil;
    ShareStatus status = ShareStatusNull;
    BOOL ret = NO;
    if (![QFShareEngine hasAlreadyLogin:type]) {
        if (result) {
            err = [NSError errorWithDomain:@"还没有账号登陆请登陆" code:-1 userInfo:nil];
        }
        goto end;
    }
    if (content == nil) {
        err = [NSError errorWithDomain:@"你发的文字为空" code:-1 userInfo:nil];
        goto end;
    }
    
    status = ShareStatusWillShare;
    OAuthManager *manager = getOAuthMangerByType(type);
    [manager shareContent:content type:type statusBarTips:statusBarTips result:result];

    ret = YES;
end:
    if (result) {
        result(type, status, err, nil, ret);
    }
    return ret;
}

// 发送带图片的文字weibo
+ (BOOL)shareImage:(UIImage *)image
           content:(NSString *)content
              type:(ShareType)type
     statusBarTips:(BOOL)statusBarTips
            result:(SEPublishContentEventHandler)result {    
    NSError *err = nil;
    ShareStatus status = ShareStatusNull;
    BOOL ret = NO;
    if (![QFShareEngine hasAlreadyLogin:type]) {
        if (result) {
            err = [NSError errorWithDomain:@"还没有账号登陆请登陆sina weibo" code:-1 userInfo:nil];
        }
        goto end;
    }
    if (content == nil || image == nil) {
        err = [NSError errorWithDomain:@"你发的文字/图片为空" code:-1 userInfo:nil];
        goto end;
    }
    
    status = ShareStatusWillShare;
    OAuthManager *manager = getOAuthMangerByType(type);
    [manager shareImage:image content:content type:type statusBarTips:statusBarTips result:result];    
    ret = YES;
end:
    if (result) {
        result(type, status, err, nil, ret);
    }
    return ret;
}

+ (BOOL) getFriendsList:(ShareType)type
                 result:(SEPublishContentEventHandler)result {
    NSError *err = nil;
    ShareStatus status = ShareStatusNull;
    BOOL ret = NO;
    if (![QFShareEngine hasAlreadyLogin:type]) {
        if (result) {
            err = [NSError errorWithDomain:@"还没有账号登陆请登陆sina weibo" code:-1 userInfo:nil];
        }
        goto end;
    }
    status = ShareStatusWillShare;
    OAuthManager *manager = getOAuthMangerByType(type);
    [manager getFriendsList:type result:result];
    ret = YES;
end:
    if (result) {
        result(type, status, err, nil, ret);
    }
    return ret;

}

#pragma mark 定制UI界面部分
+ (void) setTopViewTitle:(NSString *)title {
    NSDictionary* dic = [NSDictionary dictionaryWithObject:title forKey:@"title"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTitle" object:nil userInfo:dic];
}
+ (void) setTopViewCancelTitle:(NSString *)title {
    NSDictionary* dic = [NSDictionary dictionaryWithObject:title forKey:@"title"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeCancelTitle" object:nil userInfo:dic];
}
+ (void) setTopView:(UIView *)view {
    NSDictionary* dic = [NSDictionary dictionaryWithObject:view forKey:@"title"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTitleView" object:nil userInfo:dic];
}


#pragma mark 处理URL
+ (BOOL)handleOpenURL:(NSURL *)url {
    if (!weixinOAuthManager) return NO;
    return [weixinOAuthManager handleOpenURL:url];
}
+ (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
    if (!weixinOAuthManager) return NO;
    return [weixinOAuthManager handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}



@end
