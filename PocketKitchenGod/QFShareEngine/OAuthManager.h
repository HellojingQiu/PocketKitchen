//
//  OAuthManager.h
//  BookShare
//
//  Created by Yang QianFeng on 02/07/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSIHTTPRequest.h"
#import "BSIFormDataRequest.h"

#import "WeiboHTTPManager.h"
#import "OAuthController.h"
#import "TokenModel.h"

#import "QFShareEngine.h"

@protocol OAuthControllerDelegate;
@class OAuthController;

@interface OAuthManager : NSObject 
<OAuthControllerDelegate>
{
    WeiboType _weiboType;
    
    TokenModel *_tokenModel;
    
    UIViewController *_navController;
    OAuthController *_oauthController;
    
    SEPublishContentEventHandler _saveResult;
}
- (void) setResult:(SEPublishContentEventHandler)result;

@property (nonatomic, retain) TokenModel *tokenModel;

- (id) initWithOAuthManager:(WeiboType)weiboType;

- (void) logout;
- (void) login;
- (BOOL) isAlreadyLogin;
- (void) addPrivatePostParamsForASI:(BSIFormDataRequest *)request;

/* 子类必须要重写该方法 abstract method */
- (NSDictionary *) getCommonParams;
- (NSString *) getOAuthDomain;

- (TokenModel *) readTokenFromStorage;
- (void) writeTokenToStorage:(TokenModel *)tokenModel;

- (void) addPrivatePostParamsForASI:(BSIFormDataRequest *)request withDict:(NSDictionary *)dict;


- (BOOL)shareContent:(NSString *)content
            type:(ShareType)type
            statusBarTips:(BOOL)statusBarTips
            result:(SEPublishContentEventHandler)result
              ;
- (BOOL)shareImage:(UIImage *)image
           content:(NSString *)content
              type:(ShareType)type
     statusBarTips:(BOOL)statusBarTips
            result:(SEPublishContentEventHandler)result
            ;

- (BOOL) getFriendsList:(ShareType)type
            result:(SEPublishContentEventHandler)result
            ;


- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation;

@end
