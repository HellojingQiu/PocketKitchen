//
//  WeixinOAuthManager.m
//  BookShare
//
//  Created by yang on 1/11/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "WeixinOAuthManager.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIImage+QFThumbnai.h"
#import "NSObject+QFWeixin.h"

@implementation WeixinOAuthManager

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL) isAlreadyLogin {
    // 判断时候有微信
    if ([WXApi isWXAppInstalled]) return YES;
    return NO;
}

- (BOOL)shareContent:(NSString *)content
            type:(ShareType)type
            statusBarTips:(BOOL)statusBarTips
            result:(SEPublishContentEventHandler)result
{
    [self setResult:result];
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.text = content;
    req.bText = YES;
    _type = type;
    if (type == ShareTypeWeixiTimeline) {
        req.scene = WXSceneTimeline;
    } else if (type == ShareTypeWeixiSession) {
        req.scene = WXSceneSession;
    } else {
        return NO;
    }
    return [WXApi sendReq:req];
}

static NSData * imgToData(UIImage *img) {
    NSData *d = UIImageJPEGRepresentation(img, 0.8);
    if (d == nil) {
        d = UIImagePNGRepresentation(img);
    }
    return d;
}
static UIImage * toThumbImage(UIImage *img) {
    CGSize size = img.size;
    float h = 80.0f;
//    float w = (h/size.height) * size.width;
    float w = 80.0f;
    return [img qfResizedImage:CGSizeMake(w, h)];
}

- (BOOL) shareImage:(UIImage *)image content:(NSString *)content type:(ShareType)type statusBarTips:(BOOL)statusBarTips result:(SEPublishContentEventHandler)result {
    [self setResult:result];
    WXMediaMessage *message = [WXMediaMessage message];
    UIImage *thumbImg = toThumbImage(image);
    [message setThumbImage:thumbImg];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = imgToData(image);
    message.mediaObject = ext;
        
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    req.message = message;
    _type = type;
    if (type == ShareTypeWeixiTimeline) {
        req.scene = WXSceneTimeline;
    } else if (type == ShareTypeWeixiSession) {
        req.scene = WXSceneSession;
    } else {
        return NO;
    }
    return [WXApi sendReq:req];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [self handleOpenURL:url sourceApplication:nil annotation:nil];
}
- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

-(void) onReq:(BaseReq*)req {
    NSLog(@"function is %@", NSStringFromSelector(_cmd));
}
-(void) onResp:(BaseResp*)resp {
    if (_saveResult) {
        NSString *err = resp.errStr;
        int errCode = resp.errCode;
        NSError *error = nil;
        if (errCode) {
            if (err == nil) {
                err = @"取消了分享";
            }
            error = [NSError errorWithDomain:err code:errCode userInfo:nil];
        }
        _saveResult(_type, ShareStatusDidShare, error, nil, YES);
    }
}


#pragma mark -


@end
