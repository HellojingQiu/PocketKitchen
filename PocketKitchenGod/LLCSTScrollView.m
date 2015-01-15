//
//  LLCSTScrollView.m
//  和讯新闻
//
//  Created by yxx on 14-1-9.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCSTScrollView.h"
#import "LLCRequestModel.h"

@interface LLCSTScrollView ()
{
}

@end

@implementation LLCSTScrollView

- (instancetype)initWithFrame:(CGRect)frame
                SubviewsCount:(NSInteger)count {
  
  if (self = [super initWithFrame:frame]) {
    
  }
  return self;
}

#pragma mark - UIScrollView Delegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView.contentOffset.x / 320 != _currentPage) {
    _currentPage = scrollView.contentOffset.x / 320;
    
    if ([self.llcSTscrollViewDelegate respondsToSelector:@selector(llcSTScrollView:changeItemWithPage:)]) {
      [self.llcSTscrollViewDelegate llcSTScrollView:self changeItemWithPage:_currentPage];
      
    }
  }
}

#pragma mark - Private
- (void)scrollViewConfig {
  self.delegate = self;
  
  self.contentSize = CGSizeMake(_subViewsArray.count * 320,
                                self.frame.size.height);
  
  self.showsHorizontalScrollIndicator = NO;
  self.pagingEnabled = YES;
  self.bounces = NO;
}

- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
  [self setContentOffset:CGPointMake(page*320, self.frame.origin.x) animated:animated];
}

- (NSMutableArray *)subViewsArray {
  return _subViewsArray;
}

- (void)setSubViewsArray:(NSMutableArray *)subViewsArray {
  
  if (_subViewsArray == nil) {
    _subViewsArray = [[NSMutableArray alloc] init];
  }
  
  if (_subViewsArray != subViewsArray) {
    _subViewsArray = nil;
    _subViewsArray = subViewsArray;
    
    [self scrollViewConfig];
    for (UIView *aView in _subViewsArray) {
      [self addSubview:aView];
    }
  }
}

- (NSInteger)currentPage {
  return _currentPage;
}

#if ! __has_feature(objc_arc)
- (void)dealloc {
  
  [super dealloc];
}
#endif

@end




