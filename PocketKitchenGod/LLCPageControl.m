//
//  LLCPageControl.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCPageControl.h"
#import <QuartzCore/QuartzCore.h>

#define kMovePoint_ImageName @"首页-页数选.png" // 移动点背景图片
#define kMoveAnimation_Duration 0.25          // 动画时长
#define kHPadding(x) (x+0.5)*2*2.15           // 两个点之间的距离

@interface LLCPageControl ()
{
  NSInteger       _currentPage;         // 当前页数
  CGFloat         _radius;              // 圆角半径
  CGFloat         _length;              // 控件长度
  NSInteger       _pageCount;
  
  NSMutableArray  *_points;             // 存储点
  
  UIImageView     *_movePoint;          // 可移动的点
  UILabel         *_currentPageLabel;   // 页数标签
}
@end

@implementation LLCPageControl

#pragma mark init
- (id)initWithFrame:(CGRect)frame
         pointCount:(NSUInteger)count
  pointCornerRadius:(CGFloat)radius {
  
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    
    // 点数组
    _points = [[NSMutableArray alloc] init];
    _radius = radius;
    
    UIImage *moveImage = [UIImage imageNamed:kMovePoint_ImageName];
    
    // 移动点
    _movePoint = [[UIImageView alloc] initWithImage:moveImage];
    
    CGSize size = moveImage.size;
    _movePoint.bounds = CGRectMake(0, 0, size.width/2.7, size.height/2.7); // 2.3
    _currentPage = 1;
    
    // 展示当前页数标签
    _currentPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _movePoint.bounds.size.width, _movePoint.bounds.size.height)];
    _currentPageLabel.textColor = [UIColor whiteColor];
    _currentPageLabel.backgroundColor = [UIColor clearColor];
    _currentPageLabel.textAlignment = NSTextAlignmentCenter;
    _currentPageLabel.font = [UIFont systemFontOfSize:10];
    [_movePoint addSubview:_currentPageLabel];
    [self displayPageNumber];
    
    [self layoutSelf:frame pointCornerRadius:radius pointCount:count];
  }
  return self;
}

#pragma mark 布局
- (void)layoutSelf:(CGRect)frame
 pointCornerRadius:(CGFloat)radius
        pointCount:(NSUInteger)pointCount{
  
  // 点布局
  for (int i = 0; i < pointCount; i++) {
    UIView *aPoint = [[UIView alloc] initWithFrame:CGRectMake(kHPadding(radius)*i,
                                                              0,
                                                              radius*2,
                                                              radius*2)];
    aPoint.layer.cornerRadius = radius;
    
    UIColor *lightColor = nil;
    if (i == 0) {
      lightColor = [UIColor whiteColor];
      
      [self addSubview:_movePoint];
      _movePoint.center = aPoint.center;
    } else {
      lightColor = [UIColor grayColor];
    }
    aPoint.backgroundColor = lightColor;
    [self addSubview:aPoint];
    [_points addObject:aPoint];
    
    if (i == pointCount-1) {
      _length = aPoint.frame.origin.x+aPoint.frame.size.width;
    }
  }
  
  [self bringSubviewToFront:_movePoint];
}

#pragma mark 展示当前页数
- (void)displayPageNumber {
  _currentPageLabel.text = [NSString stringWithFormat:@"%d", _currentPage];
}

#pragma mark 点亮之前的点
- (void)lightPointBeforePage:(NSInteger)page {
  
  if (_currentPage <= page) { // 展示页之后的点
    _currentPage = page+1;
    [self displayPageNumber];
    
    [self skipToPage:page completion:^{
      
      CGFloat fpage = (float)page/_pageCount*_points.count;
      fpage = fpage > _points.count ? _points.count : fpage;
      
      for (int i = 0; i < fpage; i++) {
        UIView *aPoint = (UIView *)[_points objectAtIndex:i];
        aPoint.backgroundColor = [UIColor whiteColor];
      }
    } animated:YES];
  } else { // 展示页之前的点
    _currentPage = page+1;
    [self displayPageNumber];
    
    [self skipToPage:page completion:^{
      
      CGFloat fpage = (float)page/_pageCount*_points.count;
      fpage = fpage > _points.count ? _points.count : fpage;
      
      for (int i = _points.count-1; i > fpage; i--) {
        UIView *aPoint = (UIView *)[_points objectAtIndex:i];
        aPoint.backgroundColor = [UIColor grayColor];
      }
    } animated:YES];
  }
}

#pragma mark 熄灭展示之后的点
- (void)extinguishPointsAfterPage:(NSInteger)page {
  
  CGFloat index = (float)page/_pageCount * _points.count;
  
  for (int i = (int)index+1; i < _points.count; i++) {
    UIView *aPoint = (UIView *)[_points objectAtIndex:i];
    aPoint.backgroundColor = [UIColor grayColor];
  }
}

#pragma mark 移到对应页数
- (void)skipToPage:(NSInteger)page completion:(void (^) (void))cb  animated:(BOOL)animated {
  
  CGFloat ratio = (double)page / self.pageCount;
  CGFloat offset = ratio * _length;
  
  CGRect frame = _movePoint.frame;
  frame.origin.x = offset;
  if (animated) {
    [UIView animateWithDuration:kMoveAnimation_Duration animations:^{
      _movePoint.frame = frame;
    } completion:^(BOOL finished) {
      if (cb) {
        cb();
      }
    }];
  } else {
    _movePoint.frame = frame;
    if (cb) {
      cb();
    }
  }
}

#pragma mark setter/getter
- (NSInteger)pageCount {
  return _pageCount;
}

- (void)setPageCount:(NSInteger)pageCount {
  if (_pageCount != 0) {
    NSInteger oldPage = _pageCount;
    _pageCount = pageCount;
    [self skipToPage:oldPage completion:nil animated:NO];
  } else {
    _pageCount = pageCount;
  }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  [super willMoveToSuperview:newSuperview];
  
  [self skipToPage:0 completion:nil animated:NO];
}

@end
