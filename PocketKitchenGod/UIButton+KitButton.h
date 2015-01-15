//
//  UIButton+KitButton.h
//  NaviBarForKitchen
//
//  Created by Damon's on 14-2-16.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import <UIKit/UIKit.h>
//创建带字button的拓展
@interface UIButton (KitButton)
/**
 创建上面图,下面文字的button
 */
+ (UIButton *)createKitButtonWithBackgroundImageNameForNormal:(NSString *)imageName highlight:(NSString *)imageNameH bottomTitle:(NSString *)title;
/**
 创建上面图,下面文字的button
 */
+ (UIButton *)createKitButtonWithBackgroundImageForNormal:(UIImage *)image highlight:(UIImage *)imageH bottomTitle:(NSString *)title;

@end
