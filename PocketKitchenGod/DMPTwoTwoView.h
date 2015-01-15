//
//  DMPTwoTwoView.h
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    DMPTwoTwoStyleInDependent,
    DMPTwoTwoStyleDependent
}DMPTwoTwoStyle;

@protocol DMPTwoTwoViewDelegate;
@interface DMPTwoTwoView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) DMPTwoTwoStyle dmpTwoTwoStyle;
@property (nonatomic, weak) id<DMPTwoTwoViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame style:(DMPTwoTwoStyle)style;
//autoAdjust默认 关闭,只支持cell高度一致
- (id)initWithFrame:(CGRect)frame style:(DMPTwoTwoStyle)style autoAdjust:(BOOL)autoAdjust;
/**
 设置TwoTwoView上两个tableVIew之间间隔图片
 */
- (void) setTwoTwoViewDivisionWithImageName:(NSString *)name;
/**
 重置某一边的数据
 */
- (void) reloadDataOnLeft:(BOOL)left;
/**
 重置两边的数据
 */
- (void) reloadDataBoth;
@end




@protocol DMPTwoTwoViewDelegate <NSObject>
/**
 确定cell的class和重用标识,每次确定cell时调用,返回Class类型
 */
- (Class) dmpTwoTwoView:(DMPTwoTwoView *)view classOfCellAndIdentifier:(NSString *)identifier ;
/**
 设置cell的布局的代理,确定cell时调用
 @note 直接类强转,进行自己对应cell类型布局
 @param isLeft 位置参数,标识是那一边
 @param index cell下标
 */
- (void) dmpTwoTwoView:(DMPTwoTwoView *)view Cell:(id)cell ForRowIndex:(NSInteger)index isLeft:(BOOL)isLeft;
/**
 cell的个数
 */
- (NSInteger)dmpTwoTwoView:(DMPTwoTwoView *)view numberOfRowIsLeft:(BOOL)isLeft;
/**
cell的高度
 */
- (CGFloat)dmpTwoTwoView:(DMPTwoTwoView *)view HeightForIndex:(NSInteger)index isLeft:(BOOL)isLeft;
/**
 cell被点击时调用此代理
 */
- (void)dmpTwoTwoView:(DMPTwoTwoView *)view DidSeletedAtIndex:(NSInteger)index isLeft:(BOOL)isLeft;
/**
 位移足以达到loadMore条件,调用此代理告知
 */
- (BOOL)dmpTwoTwoView:(DMPTwoTwoView *)view needToLoadMoreIsLeft:(BOOL)isLeft;

@end