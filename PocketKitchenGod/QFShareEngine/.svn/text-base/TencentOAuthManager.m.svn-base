//
//  TencentOAuthManager.m
//  BookShare
//
//  Created by Yang QianFeng on 21/9/12.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "TencentOAuthManager.h"

@implementation TencentOAuthManager

- (id) init {
    self = [super initWithOAuthManager:TENCENT_WEIBO];
    if (self) {
        
    }
    return self;
}

- (NSDictionary *) getCommonParams {
    NSDictionary *dict = nil;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            _tokenModel.userName, @"name", 
            _tokenModel.accessToken, @"access_token",
            _tokenModel.openID, @"openid",
            _tokenModel.openKey, @"openkey",
            TENCENT_APP_KEY, @"oauth_consumer_key",
            @"2.a", @"oauth_version",
            @"221.223.249.130", @"clientip",
            nil];
    return dict;
}

- (NSString *) getOAuthDomain {
    return TENCENT_V2_DOMAIN;
}


- (void) writeTokenToStorage:(TokenModel *)tokenModel {
    [[NSUserDefaults standardUserDefaults] setObject:tokenModel.accessToken 
                                              forKey:TENCENT_USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:tokenModel.expireTime 
                                              forKey:TENCENT_USER_STORE_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] setObject:tokenModel.userName 
                                              forKey:TENCENT_USER_STORE_USER_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:tokenModel.userID 
                                              forKey:TENCENT_USER_STORE_USER_ID];
    [[NSUserDefaults standardUserDefaults] setObject:tokenModel.openID 
                                              forKey:TENCENT_USER_STORE_OPENID];
    [[NSUserDefaults standardUserDefaults] setObject:tokenModel.openKey 
                                              forKey:TENCENT_USER_STORE_OPENKEY];
    [[NSUserDefaults standardUserDefaults] setObject:tokenModel.extraInfo 
                                              forKey:TENCENT_USER_STORE_OAUTH2];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (TokenModel *) readTokenFromStorage {
    TokenModel *tokenModel = [[[TokenModel alloc] init] autorelease];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    tokenModel.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:TENCENT_USER_STORE_ACCESS_TOKEN];
    tokenModel.expireTime = [[NSUserDefaults standardUserDefaults] objectForKey:TENCENT_USER_STORE_EXPIRATION_DATE];
    tokenModel.userName = [[NSUserDefaults standardUserDefaults] objectForKey:TENCENT_USER_STORE_USER_NAME];
    tokenModel.userID = [[NSUserDefaults standardUserDefaults] objectForKey:TENCENT_USER_STORE_USER_ID];
    tokenModel.openID = [[NSUserDefaults standardUserDefaults] objectForKey:TENCENT_USER_STORE_OPENID];
    tokenModel.openKey = [[NSUserDefaults standardUserDefaults] objectForKey:TENCENT_USER_STORE_OPENKEY];
    tokenModel.extraInfo = [[NSUserDefaults standardUserDefaults] objectForKey:TENCENT_USER_STORE_OAUTH2];
    if (tokenModel.accessToken == nil || [tokenModel.accessToken isEqualToString:@""])
        return nil;
    return tokenModel;
}

- (BOOL)shareContent:(NSString *)content
            type:(ShareType)type
            statusBarTips:(BOOL)statusBarTips
            result:(SEPublishContentEventHandler)result {
    [self setResult:result];
    // https://open.t.qq.com/api/t/add
    NSString *path = [NSString stringWithFormat:@"%@/%@", [QFShareEngine getOAuthDomain:ShareTypeTencentWeibo], @"t/add"];
    // path = @"https://open.t.qq.com/api/t/add";
    NSURL *url = [NSURL URLWithString:path];
    
    BSIFormDataRequest *postTextWeibo = [BSIFormDataRequest requestWithURL:url];
    [postTextWeibo setPostValue:@"json"
                         forKey:@"format"];
    [postTextWeibo setPostValue:content
                         forKey:@"content"];
    [postTextWeibo setPostValue:@"40.034753"
                         forKey:@"latitude"];
    [postTextWeibo setPostValue:@"116.311435"
                         forKey:@"longitude"];
    [postTextWeibo setPostValue:@"0"
                         forKey:@"syncflag"];
    [postTextWeibo setPostValue:@"221.223.249.130"
                         forKey:@"clientip"];
    
    //    [postTextWeibo addPostValue:@"aaa.22" forKey:@"clientip"];
    
    NSDictionary *dict = [QFShareEngine getPrivateDictionary:ShareTypeTencentWeibo];
    [self addPrivatePostParamsForASI:postTextWeibo withDict:dict];
    
    [postTextWeibo setDelegate:self];
    [postTextWeibo setTag:101];
    [postTextWeibo startAsynchronous];
    return TRUE;
}

- (BOOL)shareImage:(UIImage *)image
           content:(NSString *)content
              type:(ShareType)type
     statusBarTips:(BOOL)statusBarTips
            result:(SEPublishContentEventHandler)result {
    
    [self setResult:result];
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    // 照片是jpeg
    
    // https://open.t.qq.com/api/t/add_pic
    NSString *path = [NSString stringWithFormat:@"%@/%@", [QFShareEngine getOAuthDomain:ShareTypeTencentWeibo], @"t/add_pic"];
    NSURL *url = [NSURL URLWithString:path];
    BSIFormDataRequest *postPicWeibo = [BSIFormDataRequest requestWithURL:url];
    
    [postPicWeibo setPostValue:@"json" forKey:@"format"];
    [postPicWeibo setPostValue:content forKey:@"content"];
    [postPicWeibo addData:data withFileName:@"test2xx.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
    [postPicWeibo setPostValue:@"40.034753" forKey:@"latitude"];
    [postPicWeibo setPostValue:@"116.311435" forKey:@"longitude"];
    [postPicWeibo setPostValue:@"0" forKey:@"syncflag"];
    
    
    NSDictionary *dict = [QFShareEngine getPrivateDictionary:ShareTypeTencentWeibo];
    [self addPrivatePostParamsForASI:postPicWeibo withDict:dict];
    
    [postPicWeibo setDelegate:self];
    [postPicWeibo setTag:102];
    [postPicWeibo startAsynchronous];
    return TRUE;
}

/* http://open.t.qq.com/api_docs/20_84.html
 腾讯weibo头像，图片不可用的解决方法  Fuck Tencent
 5.头像地址不可用
 在返回的头像地址后面加上 /20 /30 /40 /50 /100 返回相应大小的图片。
 6.图片地址不可用
 返回图片地址请在后面加上 /120 /160 /460 /2000。
 */
- (BOOL) getFriendsList:(ShareType)type
                 result:(SEPublishContentEventHandler)result {
    [self setResult:result];
    // https://open.t.qq.com/api/statuses/home_timeline
    NSMutableDictionary  *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"json", @"format",
                                    @"0", @"pageflag",
                                    @"0", @"contenttype",
                                    @"0", @"pagetime",
                                    @"70", @"reqnum",
                                    nil];
    NSDictionary *privDict = [QFShareEngine getPrivateDictionary:ShareTypeTencentWeibo];
    [params addEntriesFromDictionary:privDict];
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@/%@", [QFShareEngine getOAuthDomain:ShareTypeTencentWeibo], @"statuses/home_timeline"];
    NSURL *url = [self generateURL:baseUrl params:params];
    
    BSIHTTPRequest *request = [BSIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setTag:100];
    [request startAsynchronous];
    return TRUE;
}

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
    // baseURL: https://api.weibo.com/2/statuses/friends_timeline
    // params :
    /*
     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
     @"100", @"count",
     @"0", @"page",
     @"ABC#@#@#@#$$#FS", @"access_token", nil];
     */
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
            // count=100
            // page=0
            // access_token=ABC#@#@#@#$$#FS
		}
		
		NSString *query = [pairs componentsJoinedByString:@"&"];
        //query = @"count=100&page=0&access_token=ABC#@#@#@#$$#FS";
		NSString *url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
        // https://api.weibo.com/2/statuses/friends_timeline?count=100&page=0&access_token=ABC#@#@#@#$$#FS
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}


@end
