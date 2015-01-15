//
//  LLCSTScrollView.h
//  和讯新闻
//
//  Created by yxx on 14-1-9.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLCRequestModel;

/** 展示烹饪详细信息的滚动视图 */
@protocol LLCSTScrollViewDelegate;
@interface LLCSTScrollView : UIScrollView
<UIScrollViewDelegate>

{
  NSMutableArray *_subViewsArray; // 子视图们
}

@property (nonatomic, assign) id<LLCSTScrollViewDelegate> llcSTscrollViewDelegate;
/** 当前页 */
@property (nonatomic, assign) NSInteger currentPage;
/** 存放表示图的数组 */
@property (nonatomic, retain, readonly) NSMutableArray *subViewsArray;

/** 以frame和子视图个数的初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame
                SubviewsCount:(NSInteger)count;

/** 子视图数组setter/getter方法 */
- (void)setSubViewsArray:(NSMutableArray *)subViewsArray;
- (NSMutableArray *)subViewsArray;

/** 展现指定页数 */
- (void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

@end

// protocol
@protocol LLCSTScrollViewDelegate <NSObject>

@optional
/** 改变页数时调用此代理方法 */
- (void)llcSTScrollView:(LLCSTScrollView *)scrollView
     changeItemWithPage:(NSInteger)page;

@end
