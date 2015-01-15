//
//  SinaOAuthManager.m
//  BookShare
//
//  Created by Yang QianFeng on 21/9/12.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "SinaOAuthManager.h"
#import "QFShareEngine.h"
#import "BSIHTTPRequest.h"
#import "BSIFormDataRequest.h"

@implementation SinaOAuthManager

- (id) init {
    self = [super initWithOAuthManager:SINA_WEIBO];
    if (self) {
        
    }
    return self;
}

- (NSDictionary *) getCommonParams {
    NSDictionary *dict = nil;
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            _tokenModel.accessToken, @"access_token", 
            nil];
    return dict;
}

- (NSString *) getOAuthDomain {
    return SINA_V2_DOMAIN;
}

/* 读写存放的token */
- (void) writeTokenToStorage:(TokenModel *)tokenModel {
    [[NSUserDefaults standardUserDefaults] setObject:tokenModel.accessToken 
                                              forKey:SINA_USER_STORE_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:tokenModel.expireTime 
                                              forKey:SINA_USER_STORE_EXPIRATION_DATE];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (TokenModel *) readTokenFromStorage {
    TokenModel *tokenModel = [[[TokenModel alloc] init] autorelease];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    tokenModel.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_USER_STORE_ACCESS_TOKEN];
    tokenModel.expireTime = [[NSUserDefaults standardUserDefaults] objectForKey:SINA_USER_STORE_EXPIRATION_DATE];
    if (tokenModel.accessToken == nil || [tokenModel.accessToken isEqualToString:@""])
        return nil;
    return tokenModel;
}

- (BOOL)shareContent:(NSString *)content
                type:(ShareType)type
        statusBarTips:(BOOL)statusBarTips
        result:(SEPublishContentEventHandler)result {
    [self setResult:result];
    // https://api.weibo.com/2/statuses/update.json
    NSString *path = [NSString stringWithFormat:@"%@/%@", [QFShareEngine getOAuthDomain:ShareTypeSinaWeibo], @"statuses/update.json"];
    
    NSURL *url = [NSURL URLWithString:path];
//    ASIFormDataRequest *postTextWeibo = [ASIFormDataRequest requestWithURL:url];
    BSIFormDataRequest *postTextWeibo = [BSIFormDataRequest requestWithURL:url];
    // 根据url得到一个POST的请求
    NSString *text = content;
    // text 就是上面文字的内容
    
    [postTextWeibo setPostValue:text forKey:@"status"];
    [postTextWeibo setPostValue:@"40.034753" forKey:@"lat"];
    [postTextWeibo setPostValue:@"116.311435" forKey:@"long"];
    
    NSDictionary *dict = [QFShareEngine getPrivateDictionary:ShareTypeSinaWeibo];
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
    
    //https://api.weibo.com/2/statuses/upload.json
    NSString *path = [NSString stringWithFormat:@"%@/%@", [QFShareEngine getOAuthDomain:ShareTypeSinaWeibo], @"statuses/upload.json"];
    // https://api.weibo.com/2/statuses/upload.json
    NSURL *url = [NSURL URLWithString:path];
//    ASIFormDataRequest *postPicWeibo = [ASIFormDataRequest requestWithURL:url];
    BSIFormDataRequest *postPicWeibo = [BSIFormDataRequest requestWithURL:url];
    
    [postPicWeibo setPostValue:content forKey:@"status"];
    [postPicWeibo addData:data withFileName:@"test.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
    [postPicWeibo setPostValue:@"40.034753" forKey:@"lat"];
    [postPicWeibo setPostValue:@"116.311435" forKey:@"long"];
    
    NSDictionary *dict = [QFShareEngine getPrivateDictionary:ShareTypeSinaWeibo];
    [self addPrivatePostParamsForASI:postPicWeibo withDict:dict];
    
    [postPicWeibo setDelegate:self];
    [postPicWeibo setTag:102];
    [postPicWeibo startAsynchronous];
    return TRUE;
}

- (BOOL) getFriendsList:(ShareType)type
                 result:(SEPublishContentEventHandler)result {
    //https://api.weibo.com/2/statuses/public_timeline.json
    [self setResult:result];
    int count = 100;
    int page = 1;
    NSString *countString = [NSString stringWithFormat:@"%d",count];
    NSString *pageString = [NSString stringWithFormat:@"%d",page];
    
    NSMutableDictionary  *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    countString, @"count",
                                    pageString,  @"page",
                                    nil];
    // params
    NSDictionary *privDict = [QFShareEngine getPrivateDictionary:ShareTypeSinaWeibo];
    
    /*
     NSDictionary *privDict = [NSDictionary dictionaryWithObjectsAndKeys:
     @"ABC2323$#%$@FDDFS", @"access_token", nil];
     */
    [params addEntriesFromDictionary:privDict];
    // 把privDict字典里面所有内容加入到params字典中
    // privDict就有三项
    // count, page, access_token
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@/%@", [QFShareEngine getOAuthDomain:ShareTypeSinaWeibo],  @"statuses/friends_timeline.json"];
    // https://api.weibo.com/2/statuses/friends_timeline
    
    // https://api.weibo.com/2/statuses/friends_timeline.json
    // https://api.weibo.com/2/statuses/friends_timeline.json?count=100&page=0&access_token=2.00d4s_SC6hIGaC3bab299e1f5nHSDC
    NSURL *url = [self generateURL:baseUrl params:params];
    
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
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
