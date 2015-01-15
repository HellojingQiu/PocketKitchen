//
//  DMPNavigationBar.h
//  NaviBarForKitchen
//
//  Created by Damon's on 14-2-16.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMPNavigationBar : UIView
@property (nonatomic, strong) UIImage * dmpBackgroundImage;   // 背景图片;
@property (nonatomic, strong) UIImage * dmpDivisionImage;          // 分隔图片

/**
 设置DMPNaviBar上的items
 */
- (void) setDMPNaviBarItemsWithArray:(NSArray *)array isLeft:(BOOL)isleft;
/**
 设置DMPNaviBar的title和signImage;
 */
- (void) setDMPNaviBarTitleViewWithTitle:(NSString * )title signImageName:(NSString *)imageName;
/**
 设置titleView中signImageVIew的尺寸
 */
- (void) setDMPNaviBarTitleViewSignImageViewSize:(CGSize)size;
@end
