//
//  DMPNetMenuView.h
//  PocketKitchenGod
//
//  Created by Damon on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMPMenuTableView.h"

typedef enum{
    DMPMenuMainTableView = 889, //主菜单
    DMPMenuSubTableView,                //子菜单
}DMPMenuTableViewType;

//双层菜单类 点击主菜单展开子菜单
@class DMPNetMenuView;
@class DMPMenuTableView;




@protocol DMPNetMenuViewDelegate <NSObject>
@required
/**
 确定菜单级数的代理方法,确定是那个菜单通过菜单的tag来确定DMPMenuTableViewType中的哪一个
 */
- (NSInteger)numberOfRowsForMenuTableView:(DMPMenuTableView *)menu menuView:(DMPNetMenuView*)menuView;
/**
 确定菜单cell布局的代理方法,确定是那个菜单通过菜单的tag来确定DMPMenuTableViewType中的哪一个
 */
- (UITableViewCell *)dmpMenuTableView:(DMPMenuTableView *)mainMenu cellForRowAtIndexPath:(NSIndexPath *)indexPath menuView:(DMPNetMenuView*)menuView ;
/**
 确定菜单cell高度的代理方法,确定是那个菜单通过菜单的tag来确定DMPMenuTableViewType中的哪一个
 */
- (CGFloat)dmpMenuTableView:(DMPMenuTableView *)menu heightForRowAtIndexPath:(NSIndexPath *)indexPath menuView:(DMPNetMenuView*)menuView;

@optional
/**
点击菜单cell触发的代理方法,确定是那个菜单通过菜单的tag来确定DMPMenuTableViewType中的哪一个
 */
- (void)dmpMenuView:(DMPNetMenuView *)menuView dmpMenuTableView:(DMPMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end

@interface DMPNetMenuView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) id<DMPNetMenuViewDelegate>dmpDelegate;

/**
 主菜单重置数据
 */
- (void) mainMenuReload;
/**
 子菜单重置数据
 */
- (void) subMenuReload;
/**
 菜单折叠
 */
- (void) menuFold;
/**
 菜单展开
 */
- (void) menuUnfold;

@end
