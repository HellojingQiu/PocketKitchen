//
//  LLCWoderlfulTabBar.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCWoderlfulTabBar.h"

#import "LLCWonderfulButton.h"
#import "LLCWonderfulBottomBar.h"
#import "LLCWonderfulBottomButton.h"

#import "LLCButtonModel.h"
#import "LLCSubButtonModel.h"

#import "UIImageView+WebCache.h"

#define kScrollView_Height 44
#define kButton_Width 80

#define kAnimation_Duration 0.25

@interface LLCWoderlfulTabBar ()
{
  UIScrollView *_scrollView;            // 滚动视图
  UIView *_shadowView;                  // 遮盖层
  LLCWonderfulBottomBar *_bar;          // 展示具体食材的view
  
  NSMutableArray *_models;              // 数据源
  NSMutableArray *_buttons;             // 存储按钮
  
  BOOL _isUp;                           // 是否已经弹出
  NSInteger _currentButtonModelIndex;   // 当前选中按钮
}
@end

@implementation LLCWoderlfulTabBar

const int kBaseNumber = 300; // 一个tag基数

- (id)initWithFrame:(CGRect)frame buttonModels:(NSArray *)models {
  if (self = [super initWithFrame:frame]) {
    
    _currentButtonModelIndex = 0;
    _isUp = NO;
    _models = [models mutableCopy];
    _buttons = [[NSMutableArray alloc] init];
    [self layoutSelf];
  }
  return self;
}

#pragma mark 布局
- (void)layoutSelf {
  
  // 遮盖View
  CGFloat barsHeight = 0;
  if (kIsIOS7) {
    barsHeight = 20 + 44;
  } else {
    barsHeight = 44;
  }
  _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, barsHeight, kScreenWidth, kScreenHeight-44-20-44)];
  _shadowView.backgroundColor = [UIColor clearColor];
  _shadowView.hidden = YES;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewPressed:)];
  [_shadowView addGestureRecognizer:tap];
  
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  [window addSubview:_shadowView];
  
  // 滚动视图
  _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               self.frame.size.width,
                                                               kScrollView_Height)];
  _scrollView.contentSize = CGSizeMake(_models.count*kButton_Width, kScrollView_Height);
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.showsVerticalScrollIndicator = NO;
  _scrollView.bounces = NO;
  
  [self addSubview:_scrollView];
  
  // 菜单栏
  _bar = [[[NSBundle mainBundle] loadNibNamed:@"LLCWonderfulBottomBar" owner:self options:nil] lastObject];
  _bar.center = CGPointMake(self.frame.size.width/2, kScrollView_Height+_bar.bounds.size.height/2);
  [self addSubview:_bar];
  
  // 类别按钮布局
  for (int i = 0; i < _models.count; i++) {
    LLCWonderfulButton *aButton = [[[NSBundle mainBundle] loadNibNamed:@"LLCWonderfulButton"
                                                                 owner:self
                                                               options:nil] lastObject];
    CGPoint center = CGPointMake(kButton_Width/2+i*kButton_Width, kScrollView_Height/2);
    aButton.center = center;
    [_scrollView addSubview:aButton];
    LLCButtonModel *buttonModel = [_models objectAtIndex:i];
    aButton.titleLabel.text = buttonModel.caralogName;
    [aButton.titleImageView setImageWithURL:[NSURL URLWithString:buttonModel.imagePathName]];
    [aButton.theButton addTarget:self action:@selector(callDetail:) forControlEvents:UIControlEventTouchUpInside];
    aButton.theButton.tag = kBaseNumber + i;
    
    [_buttons addObject:aButton.theButton];
  }
}

#pragma mark 类别按钮被点中, 展示类别内具体选项
- (void)callDetail:(UIButton *)button {
  _currentButtonModelIndex = button.tag - kBaseNumber;
  for (UIButton *aBtn in _buttons) {
    if (aBtn.tag - kBaseNumber == _currentButtonModelIndex) {
      aBtn.selected = YES;
    } else {
      aBtn.selected = NO;
    }
  }
  
  // 获取选中类别内的食材数据模型
  LLCButtonModel *aButtonModel = [_models objectAtIndex:button.tag - kBaseNumber];
  NSArray *subModelsArray = aButtonModel.subCaralogArray;
  NSArray *buttonsArray = _bar.buttons;
  // 以食材数据模型对食材按钮布局
  for (int i = 0; i < 8; i++) {
    LLCSubButtonModel *aSubModel = [subModelsArray objectAtIndex:i];

    LLCWonderfulBottomButton *bottomButton = [buttonsArray objectAtIndex:i];
    if (subModelsArray.count < 9) {
      bottomButton.bottomTitle.text = aSubModel.childCatalogName;
    } else {
      bottomButton.bottomTitle.text = @"";
    }
    
    [bottomButton.bottomImage setImageWithURL:[NSURL URLWithString:aSubModel.imagePathName]];
    bottomButton.bottonButton.tag = i;
    [bottomButton.bottonButton addTarget:self action:@selector(loadDetailFood:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  [self standUp];
}

#pragma mark - 具体食材被点中, 读取对应数据
- (void)loadDetailFood:(UIButton *)bottonItem {
  
  [self sitDown:^{
    [self reset];
  }];
  LLCButtonModel *buttonModel = [_models objectAtIndex:_currentButtonModelIndex];
  LLCSubButtonModel *subButtonModel = [buttonModel.subCaralogArray objectAtIndex:bottonItem.tag];
  if ([self.llcWonderfulTabBarDelegate respondsToSelector:
       @selector(selectedCategoryID:)]) {
    [self.llcWonderfulTabBarDelegate selectedCategoryID:subButtonModel.catalogId];
  }
  
  if ([self.llcWonderfulTabBarDelegate respondsToSelector:
       @selector(selectedCategoryID:CategoryName:foodName:)]) {
    [self.llcWonderfulTabBarDelegate selectedCategoryID:subButtonModel.vegetableChildCatalogId CategoryName:buttonModel.caralogName foodName:subButtonModel.childCatalogName];
  }
}

#pragma mark - 遮盖层被点中, 收回tabBar
- (void)shadowViewPressed:(UITapGestureRecognizer *)tap {
  [self sitDown:^{
    [self reset];
  }];
}

#pragma mark - 重置选中状态
- (void)reset {
  _shadowView.hidden = YES;
  CGRect frame = _shadowView.frame;
  frame.size.height += 96;
  _shadowView.frame = frame;
  
  for (UIButton *aBtn in _buttons) {
    aBtn.selected = NO;
  }
}

#pragma mark - tabBar展现
- (void)standUp {
  if (_isUp) {
    return;
  }
  
  _isUp = !_isUp;
  CGRect frame = self.frame;
  frame.origin.y -= _bar.frame.size.height;
  [UIView animateWithDuration:kAnimation_Duration animations:^{
    self.frame = frame;
  }];
  
  CGRect shadowFrame = _shadowView.frame;
  shadowFrame.size.height -= 96;
  _shadowView.frame = shadowFrame;
  _shadowView.hidden = NO;
}

#pragma mark - tabBar收回
- (void)sitDown:(void (^) (void))compeletion {
  _isUp = !_isUp;
  CGRect frame = self.frame;
  frame.origin.y += _bar.frame.size.height;
  [UIView animateWithDuration:kAnimation_Duration animations:^{
    self.frame = frame;
  } completion:^(BOOL finished) {
    if (compeletion) {
      compeletion();
    }
  }];
}

@end
