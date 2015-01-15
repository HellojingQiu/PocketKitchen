//
//  QFShareType.h
//  BookShare
//
//  Created by yang on 31/10/13.
//  Copyright (c) 2013 千锋3G www.mobiletrain.org. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	@brief	分享类型
 */
typedef enum
{
    ShareTypeNull = 0,              /**< 空类型 */
	ShareTypeSinaWeibo = 1,         /**< 新浪微博 */
	ShareTypeTencentWeibo = 2,      /**< 腾讯微博 */
    ShareTypeWeixiSession = 22,     /**< 微信好友 */
	ShareTypeWeixiTimeline = 23,    /**< 微信朋友圈 */

    /* coming soon. */
	ShareTypeSohuWeibo = 3,         /**< 搜狐微博 */
    ShareType163Weibo = 4,          /**< 网易微博 */
	ShareTypeDouBan = 5,            /**< 豆瓣社区 */
	ShareTypeQQSpace = 6,           /**< QQ空间 */
	ShareTypeRenren = 7,            /**< 人人网 */
	ShareTypeKaixin = 8,            /**< 开心网 */
	ShareTypePengyou = 9,           /**< 朋友网 */
	ShareTypeFacebook = 10,         /**< Facebook */
	ShareTypeTwitter = 11,          /**< Twitter */
	ShareTypeEvernote = 12,         /**< 印象笔记 */
	ShareTypeFoursquare = 13,       /**< Foursquare */
	ShareTypeGooglePlus = 14,       /**< Google＋ */
	ShareTypeInstagram = 15,        /**< Instagram */
	ShareTypeLinkedIn = 16,         /**< LinkedIn */
	ShareTypeTumblr = 17,           /**< Tumbir */
    ShareTypeMail = 18,             /**< 邮件分享 */
	ShareTypeSMS = 19,              /**< 短信分享 */
	ShareTypeAirPrint = 20,         /**< 打印 */
	ShareTypeCopy = 21,             /**< 拷贝 */
    ShareTypeQQ = 24,               /**< QQ */
    ShareTypeInstapaper = 25,       /**< Instapaper */
    ShareTypePocket = 26,           /**< Pocket */
    ShareTypeYouDaoNote = 27,       /**< 有道云笔记 */
    ShareTypeSohuKan = 28,          /**< 搜狐随身看 */
    ShareTypePinterest = 30,        /**< Pinterest */
    ShareTypeFlickr = 34,           /**< Flickr */
    ShareTypeDropbox = 35,          /**< Dropbox */
    ShareTypeAny = 99               /**< 任意平台 */
}
ShareType;

typedef enum {
    ShareStatusNull = 0,
    ShareStatusWillShare = 1,
    ShareStatusDidShare = 2,
    ShareStatusErrorShare = 3,

    ShareStatusMax = 99,
}
ShareStatus;

#define PropertyCopy(TypeStr) @property (nonatomic, copy) TypeStr;
#define PropertyStringCopy(Str) @property (nonatomic, copy) NSString *Str;
#define PropertyAssign(Type) @property (nonatomic, assign) Type;

@interface QFShareType : NSObject {
    ShareType _type;
    NSString *_appKey;
    NSString *_appSecret;
    NSString *_redirectUri;
}
PropertyAssign(ShareType type);
PropertyStringCopy(appKey);
PropertyStringCopy(appSecret);
PropertyStringCopy(redirectUri);


@end

@interface QFShareQueue : NSObject {

}

+ (id) sharedInstance;
- (BOOL) addShareTypeToQueue:(QFShareType *)sType;
- (NSArray *) getShareTypeList;

@end



#define SAFELY_RELEASE(a) do { [(a) release]; (a) = nil; } while(0)
#define SAFELY_AUTORELEASE(a) [(a) autorelease];
#define SuperDealloc [super dealloc]


