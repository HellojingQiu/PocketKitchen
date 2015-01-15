//
//  DMPToolsManager.m
//  DoggiyWorld
//
//  Created by Damon's on 14-2-14.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import "DMPToolsManager.h"
#define QRCodeStringRecognizer @"||||"

@implementation DMPToolsManager
+ (DMPToolsManager *)shareToolsManager {
    static DMPToolsManager * manager = nil;
    @synchronized(self) {
        if (!manager) {
            manager = [[DMPToolsManager alloc] init];
        }
    }
    return manager;
}

- (NSDictionary *)getRespondingDictionaryWithController:(UIViewController *)vc {
   return [self getRespondingDictionaryWithControllerClass:[vc class]];
}

- (NSDictionary *)getRespondingDictionaryWithControllerClass:(Class)vcClass {
    NSString * className = NSStringFromClass(vcClass);
    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"handleKitchen" ofType:@"plist"]];
    dic = dic[className];
    return dic;
}

- (NSInteger) getFitHeightForOS {
    if ([[UIDevice currentDevice].systemVersion hasPrefix:@"7"]) {
        return 64;
    }else
        return 0;
}

- (NSString *)getQRCodeStringWithUrl:(NSString *)string indexOfModel:(NSInteger)index {
    return [NSString stringWithFormat:@"%@%@%d",string,QRCodeStringRecognizer,index];
}

- (BOOL) isQRCodeStringFitForApp:(NSString *)codeString {
    if ([codeString rangeOfString:QRCodeStringRecognizer].location == NSNotFound) {
        return NO;
    }else
        return YES;
}
- (NSString *)getUrlFromQRCodeString:(NSString *)codeString {
   NSArray * array = [codeString componentsSeparatedByString:QRCodeStringRecognizer];
    return array[0];
}
- (NSInteger)getIndexOfModelFromQRCodeString:(NSString *)codeString {
    NSArray * array = [codeString componentsSeparatedByString:QRCodeStringRecognizer];
    NSString * indexString = [array lastObject];
    return indexString.integerValue;
}
@end
