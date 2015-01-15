//
//  DMPSearchTypeButton.h
//  PocketKitchenGod
//
//  Created by Damon on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>
//DMPSearchTypeScrollView中的Button类
@interface DMPSearchTypeButton : UIView
/**
 设置DMPSearchTypeButton的属性
 @prama name 常态图片名
 @prama nameH 高亮态图片名
 @prama title button标题
 @prama target 点击事件的对象
 @prama action 点击事件的触发的方法
 @prama tag 标识值
 */
- (void)setDmpNormalImageName:(NSString *)name
         selectedImageName:(NSString *)nameH
                                        title:(NSString *)title
                                     target:(id)target
                       action:(SEL)action tag:(NSInteger)tag;
/**
 设置DMPSearchTypeButton被是否被选中状态
 */
- (void) setdmpSearchButtonSeleted:(BOOL)isSelected;
@end
