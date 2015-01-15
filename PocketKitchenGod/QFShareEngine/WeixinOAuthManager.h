//
//  WeixinOAuthManager.h
//  BookShare
//
//  Created by yang on 1/11/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthManager.h"
#import "WXApi.h"

@interface WeixinOAuthManager : OAuthManager <WXApiDelegate> {
    ShareType _type;
}

@end
