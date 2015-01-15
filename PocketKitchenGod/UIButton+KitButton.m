//
//  UIButton+KitButton.m
//  NaviBarForKitchen
//
//  Created by Damon's on 14-2-16.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import "UIButton+KitButton.h"
#define KitButtonWidth 41
#define KitButtonHeight 40
@implementation UIButton (KitButton)

+ (UIButton *)createKitButtonWithBackgroundImageForNormal:(UIImage *)image highlight:(UIImage *)imageH bottomTitle:(NSString *)title {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, KitButtonWidth, KitButtonHeight);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:imageH forState:UIControlStateHighlighted];
    UILabel * label = [[UILabel alloc] init];
    label.text = title;
    [label sizeToFit];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:9.5];
    label.userInteractionEnabled = NO;
    label.center = CGPointMake(KitButtonWidth/2, KitButtonHeight - 8);
    [button addSubview:label];
    return button;
}

+ (UIButton *)createKitButtonWithBackgroundImageNameForNormal:(NSString *)imageName highlight:(NSString *)imageNameH bottomTitle:(NSString *)title {
  return [UIButton createKitButtonWithBackgroundImageForNormal:[UIImage imageNamed:imageName] highlight:[UIImage imageNamed:imageNameH] bottomTitle:title];
}
@end
