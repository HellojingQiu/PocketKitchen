//
//  DMPMetrialView.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPMetrialView.h"
#import "DMPMetrialModel.h"
#import "DMPSearchDisPlayView.h"
@interface DMPMetrialView ()
@property (nonatomic, assign) CGFloat distanceToVerticalSide;           //距离垂直边框
@property (nonatomic, assign) CGFloat distanceToHorizontalSide;      //距离水平边框
@property (nonatomic, assign) CGFloat distanceBetweenForVertical;    //displayer垂直之间的间距
@property (nonatomic, assign) CGFloat distanceBetweenForHorizonal; //displayer水平之间的间距
@property (nonatomic, assign) CGSize displayerSize;                                    //displayer size
@property (nonatomic, copy) NSString * imgName;                               //图片名字
@property (nonatomic, strong) NSMutableArray * reuseArray;               //复用队列
@property (nonatomic, strong) NSMutableArray * activeArray;             //活跃队列

@property (nonatomic, strong) UILabel * placeHolder;                        //placeholder
@end

@implementation DMPMetrialView


- (id)initWithFrame:(CGRect)frame
            distanceToVerticalSide:(CGFloat)distanceV
            distanceToHorizontalSide:(CGFloat)distanceH
            displayerSize:(CGSize)displayerSize
            placeHolder:(NSString *)placeTitle
            backgroundImageName:(NSString *)name  {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.distanceToVerticalSide = distanceV;
        self.distanceToHorizontalSide = distanceH;
        self.displayerSize = displayerSize;
        self.imgName = name;
        self.reuseArray = [[NSMutableArray alloc] init];
        self.activeArray = [[NSMutableArray alloc] init];

        [self createBgView];
        [self createPlaceHolderWithString:placeTitle];
        [self reloadData];
    }
    return self;
}
//重写 displayerSize setter
- (void)setDisplayerSize:(CGSize)displayerSize {
    _displayerSize = displayerSize;
    self.distanceBetweenForHorizonal = (self.bounds.size.width - self.distanceToHorizontalSide * 2 - _displayerSize.width * 3)/2;
    self.distanceBetweenForVertical = self.bounds.size.height - self.distanceToVerticalSide * 2 - _displayerSize.height * 2;
}
//创建背景
- (void) createBgView {
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgView.image = [UIImage imageNamed:self.imgName];
    [self addSubview:bgView];
}
//创建省略字
- (void) createPlaceHolderWithString:(NSString *)string {

    self.placeHolder = [[UILabel alloc] init];
    _placeHolder.font = [UIFont systemFontOfSize:12];
    _placeHolder.textColor = [UIColor darkGrayColor];
    if (!string) {
        string = @"";
    }
    _placeHolder.text = string;
    [_placeHolder sizeToFit];
    _placeHolder.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _placeHolder.hidden = YES;
    [self addSubview:_placeHolder];
}
//重置数据
- (void)reloadData {
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[DMPSearchDisPlayView class]]) {
            [view removeFromSuperview];
        }
    }
    //每次重置数据,活跃队列中displayer要移到重用队列中
//    for (DMPSearchDisPlayView * displayer in self.activeArray) {
//        [self.reuseArray addObject:displayer];
//        [self.activeArray removeObject:displayer];
//    }
    //枚举不能做改变值操作
//    NSInteger activeCount = self.activeArray.count;
//    for (int i = 0; i < activeCount; i ++) {
//        DMPSearchDisPlayView * displayer = self.activeArray[i];
//        [self.reuseArray addObject:displayer];
        [self.reuseArray addObjectsFromArray:self.activeArray];
        [self.activeArray removeAllObjects];
  //  }
    //获取要显示的displayer 的个数
    NSInteger count;
    if ([self.delegate respondsToSelector:@selector(numberOfDisplayerForDmpMetrialView:)]) {
        count = [self.delegate numberOfDisplayerForDmpMetrialView:self];
    }else
        count = 0;
    
    // 如果要显示个数为0,显示placeHolder,否则继续隐藏
    if (!count) {
        self.placeHolder.hidden = NO;
    }else
        self.placeHolder.hidden = YES;
    
    // 获取要显示的displayer对象
    // 个数为0不执行
    for (int i = 0; i < count; i ++) {
        if ([self.delegate respondsToSelector:@selector(dmpMetrialView:displayerAtIndex:)]) {
            //获取displayer
            DMPSearchDisPlayView * displayer = [self.delegate dmpMetrialView:self displayerAtIndex:i];
        
            [displayer.searchCloseBtn addTarget:self action:@selector(displayerCloseBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            displayer.searchCloseBtn.tag = i;
            //将要添加的displayer 添加到活跃数组
            
            //如果是从重用队列中取出的,就要从中删除
            if ([self.reuseArray containsObject:displayer]) {
                [self.reuseArray removeObject:displayer];
            }
            //添加到活跃数组里
            [self.activeArray addObject:displayer];
        }
    }
    if (count) {
        [self layOutActiveDisplayer];
    }
}

//从重用队列中获取一个displayer,根据identifier
- (DMPSearchDisPlayView *) dequeueDisplayerWithidentifier:(NSString *)identifier {
    //取最后一个
    if (self.reuseArray.count) {
         DMPSearchDisPlayView * displayer = [self.reuseArray lastObject];
     //   [self.reuseArray removeLastObject];
        return displayer;
    }else
        return nil;     //重用队列里为空,就返回nil
}

//对displayer进行布局
- (void) layOutActiveDisplayer {
    for (int i = 0; i < self.activeArray.count; i ++) {
        DMPSearchDisPlayView * displayer = self.activeArray[i];

        displayer.frame = CGRectMake(self.distanceToHorizontalSide + i%3 * (self.displayerSize.width + self.distanceBetweenForHorizonal), self.distanceToVerticalSide + i/3 *(self.distanceBetweenForVertical + self.displayerSize.height), self.displayerSize.width, self.displayerSize.height);
        [self addSubview:displayer];
    }
}

// 点击删除时
- (void) displayerCloseBtnPress:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(dmpMetrialView:DeleteDisplayerAtIndex:)]) {
        [self.delegate dmpMetrialView:self DeleteDisplayerAtIndex:btn.tag];
    }
    //重置数据
    [self reloadData];
}

@end
