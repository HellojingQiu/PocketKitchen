//
//  DMPToolsManager.h
//  DoggiyWorld
//
//  Created by Damon's on 14-2-14.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//工具类
@interface DMPToolsManager : NSObject
/**
 DMPToolsManager 单例
 */
+ (DMPToolsManager *) shareToolsManager;

/**
 获取viewController相应存储了数据的字典
 */
- (NSDictionary *) getRespondingDictionaryWithController:(UIViewController *)vc;
/**
 获取数据字典根据keyName
*/
- (NSDictionary *) getRespondingDictionaryWithControllerClass:(Class)vcClass;
/**
 获取控件适应当前设备系统的高度差height
 */
- (NSInteger) getFitHeightForOS;

/**
 检测codeString是否适合app
 */
- (BOOL) isQRCodeStringFitForApp:(NSString *)codeString;
/**
 获取codeString中的index
 */
- (NSInteger) getIndexOfModelFromQRCodeString:(NSString *)codeString;
/**
 获取codeString的url
 */
- (NSString *)getUrlFromQRCodeString:(NSString *)codeString;

/**
 根据string和index获取一个codeString
 */
- (NSString *) getQRCodeStringWithUrl:(NSString * )string indexOfModel:(NSInteger)index;
@end
