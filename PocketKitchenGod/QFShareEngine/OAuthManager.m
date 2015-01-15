//
//  OAuthManager.m
//  BookShare
//
//  Created by Yang QianFeng on 02/07/2012.
//  Copyright (c) 2012 千锋3G www.mobiletrain.org. All rights reserved.
//

#import "OAuthManager.h"
#import "OAuthController.h"
#import "BSIFormDataRequest.h"


@implementation OAuthManager
@synthesize tokenModel = _tokenModel;

- (id) initWithOAuthManager:(WeiboType)weiboType {
    self = [super init];
    if (self) {
        
        _weiboType = weiboType;
        _oauthController = [[OAuthController alloc] init];
        [_oauthController setDelegate:self];
        [_oauthController setWeiboType:weiboType];
        _navController = [[UINavigationController alloc] initWithRootViewController:_oauthController];
        self.tokenModel = [self readTokenFromStorage];

    }
    return self;
}
- (void) logout {
    
}


- (void) showUI {
    UIViewController *wv = _navController;

    
    UIWindow* wnd = [[UIApplication sharedApplication] keyWindow];
    //CGRect windowRect = wnd.frame;
    id rootController = (UINavigationController*)wnd.rootViewController;
    UIViewController* vc = nil;
    if ([rootController isKindOfClass:[UINavigationController class]]) {
        vc = [[(UINavigationController*)rootController viewControllers] lastObject];
    } else if ([rootController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tc = (UITabBarController*)rootController;
        if ([tc.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* tmpNc = (UINavigationController*)tc.selectedViewController;
            vc = [tmpNc.viewControllers lastObject];
        } else {
            vc = tc.selectedViewController;
        }
    } else {
        vc = rootController;
    }
    
    [vc presentViewController:wv animated:YES completion:nil];
    /*
    wv.view.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
    UIViewController* vc = [wv.viewControllers objectAtIndex:0];
    
    for (UIView* view in vc.view.subviews) {
        if ([view isKindOfClass:[UIWebView class]]) {
            view.frame = CGRectMake(0, 0, 480, 320);
            vc.view.frame = CGRectMake(0, 0, 480, 320);
        }
    }
    
    CGRect origRect = windowRect;
    origRect.origin.y += windowRect.size.height;
    [wv.view setFrame:origRect];
    
    [wnd addSubview:wv.view];
    
    [UIView animateWithDuration:0.5 animations:^(void){
        [wv.view setFrame:windowRect];
    }];
     */
}
- (void) hiddenUI {
    UIViewController *wv = _navController;
    [wv dismissViewControllerAnimated:YES completion:nil];
    /*
    CGRect rect = wv.view.frame;
    CGRect newRect = rect;
    newRect.origin.y += newRect.size.height;
    [UIView animateWithDuration:0.5 animations:^(void){
            wv.view.frame = newRect;
        } completion:^(BOOL finished) {
            [wv.view removeFromSuperview];
        }
     ];    
     */
}

- (void) login {
    [self showUI];
}

- (void) oauthControllerDidFinished:(OAuthController *)oauthController {
    [self hiddenUI];
}
- (void) oauthControllerDidCancel:(OAuthController *)oauthController {
    [self hiddenUI];
}
- (void) oauthControllerSaveToken:(OAuthController *)oauthController withTokenModel:(TokenModel *)tokenModel {
    NSLog(@"token is save token %@ %@", tokenModel, tokenModel.accessToken);
    self.tokenModel = tokenModel;
    [self writeTokenToStorage:tokenModel];
}


- (BOOL) isAlreadyLogin {
    return _tokenModel.accessToken?YES:NO;
}

- (void) addPrivatePostParamsForASI:(BSIFormDataRequest *)request {
    NSDictionary *dict = [self getCommonParams];
    NSArray *keyArray = [dict allKeys];
    NSArray *valueArray = [dict allValues];
    for (int i = 0; i < [keyArray count]; i++) {
        [request setPostValue:[valueArray objectAtIndex:i] forKey:[keyArray objectAtIndex:i]];
    }
}

#pragma mark -
#pragma mark Abstract Method Override Function
- (void) writeTokenToStorage:(TokenModel *)tokenModel {
    NSLog(@"%s %s override me", __FILE__, __func__);
}
- (TokenModel *) readTokenFromStorage {
    NSLog(@"%s %s override me", __FILE__, __func__);
    return nil;
}

- (NSDictionary *) getCommonParams {
    NSLog(@"%s %s override me", __FILE__, __func__);
    /* 子类中实现 */
    return nil;
}

- (NSString *) getOAuthDomain {
    NSLog(@"%s %s override me", __FILE__, __func__);
    /* 子类中实现 */
    return nil;
}

- (void) setResult:(SEPublishContentEventHandler)result {
    [_saveResult release];
    _saveResult = [result copy];
}

- (void) dealloc {
    [_oauthController release], _oauthController = nil;
    [_navController release], _navController = nil;

    self.tokenModel= nil;
    [super dealloc];
}

- (BOOL)handleOpenURL:(NSURL *)url wxDelegate:(id)wxDelegate {
    return NO;
}
- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
           wxDelegate:(id)wxDelegate {
    return NO;
}

//- (void) addPrivatePostParamsForASI:(ASIFormDataRequest *)request withDict:(NSDictionary *)dict {
- (void) addPrivatePostParamsForASI:(BSIFormDataRequest *)request withDict:(NSDictionary *)dict {
    NSArray *keyArray = [dict allKeys];
    NSArray *valueArray = [dict allValues];
    for (int i = 0; i < [keyArray count]; i++) {
        [request setPostValue:[valueArray objectAtIndex:i] forKey:[keyArray objectAtIndex:i]];
    }
}

- (BOOL)shareContent:(NSString *)content
              result:(SEPublishContentEventHandler)result {
    return NO;
}

- (void) requestFinished:(ASIHTTPRequest *)request {
    if (_saveResult) {
        _saveResult(ShareTypeSinaWeibo, ShareStatusDidShare, nil, request.responseData, YES);
    }
}
- (void) requestFailed:(ASIHTTPRequest *)request {
    if (_saveResult) {
        NSError *err = [NSError errorWithDomain:@"网络状态问题" code:-1 userInfo:nil];
        _saveResult(ShareTypeSinaWeibo, ShareStatusErrorShare, err, request.responseData, NO);
    }
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return NO;
}
- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
    return NO;
}


@end
