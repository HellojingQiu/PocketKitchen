//
//  DMPNavigationBar.m
//  NaviBarForKitchen
//
//  Created by Damon's on 14-2-16.
//  Copyright (c) 2014年 Damon's. All rights reserved.
//

#import "DMPNavigationBar.h"

typedef enum {
    DmpDivisionAtRight = 111,
    DmpDivisionAtLeft,
    DmpTitleViewAtMiddle
}dmpLocation;

@implementation DMPNavigationBar
{
    UIImageView * _bgImgView;
    UILabel * _title;
    UIImageView * _titleImageView;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBackImageView];
        [self createTitleView];
    }
    return self;
}

//重写BackgroundImage 的 setter
- (void) setDmpBackgroundImage:(UIImage *)dmpBackgroundImage {
    if (dmpBackgroundImage) {
        _dmpBackgroundImage = dmpBackgroundImage;
        _bgImgView.image = dmpBackgroundImage;
    }
}
//重写divisionImage 的 setter
- (void) setDmpDivisionImage:(UIImage *)dmpDivisionImage {
    if (dmpDivisionImage) {
        _dmpDivisionImage = dmpDivisionImage;
        for (UIView * view in self.subviews) {
            if (view.tag == DmpDivisionAtLeft || view.tag == DmpDivisionAtRight) {
                UIImageView * division = (UIImageView *)view;
                division.image = _dmpDivisionImage;
            }
        }
    }
}
//创建背景图片的View
- (void) createBackImageView {
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _bgImgView.image = self.dmpBackgroundImage;
    [self addSubview:_bgImgView];
}
//创建titleVIew
- (void) createTitleView {
    _title = [[UILabel alloc] init];
    _title.font = [UIFont systemFontOfSize:15];
    _title.textColor = [UIColor whiteColor];
    _titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
    _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_title];
    [self addSubview:_titleImageView];
}
//添加Views到Bar上
- (void)setItemsWithCustomViewFromArray:(NSArray *)array isLeft:(BOOL)isLeft {
    [self removeDivisionsAtLeft:isLeft];
    NSInteger count = array.count;
    //记录最后一个item的x坐标
    CGFloat pointX;
    if (array && count) {
        if (!isLeft) {
            pointX = self.bounds.size.width;
            for (int i = count - 1;i >= 0; i --) {
                UIView * item = array[i];
                CGRect frame = item.frame;
                frame.origin.x = pointX - frame.size.width;
                frame.origin.y = 0;
                item.frame = frame;
                pointX = frame.origin.x;
                UIImageView * division = [self createDivisionImageViewWithPointX:pointX + frame.size.width WithHeight:frame.size.height];
                division.tag = DmpDivisionAtRight;
                [self addSubview:item];
                [self addSubview:division];
                
            }
        }else {
            pointX = 0;
            BOOL FirstOnLeft = YES;
            for (UIView * item in array) {
                CGRect frame = item.frame;
                frame.origin.x = pointX;
                frame.origin.y = 0;
                item.frame = frame;
                pointX = frame.origin.x;
                UIImageView * division = [self createDivisionImageViewWithPointX:pointX + frame.size.width WithHeight:frame.size.height];
                division.tag = DmpDivisionAtLeft;
                [self addSubview:division];
                if (FirstOnLeft) {
                    division = [self createDivisionImageViewWithPointX:pointX WithHeight:frame.size.height];
                    division.tag = DmpDivisionAtLeft;
                    FirstOnLeft = NO;
                }
                [self addSubview:item];
                [self addSubview:division];
            }
        }
    }
}

//创建分隔imageView
- (UIImageView *) createDivisionImageViewWithPointX:(CGFloat)pointX WithHeight:(CGFloat)height {
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(pointX ,0,1.5, height)];
    imageView.image = self.dmpDivisionImage;
    return imageView;
}
//设置title和signImageView
- (void)setKitTitleViewWithTitle:(NSString *)title signImage:(UIImage *)image {
    _title.hidden = YES;
    _titleImageView.hidden = YES;
    CGFloat distanceH = 7;
    CGFloat distanceV = 2;
    if (image && title) {
        _titleImageView.image = image;
        _title.text = title;
        [_title sizeToFit];
        CGFloat width = _titleImageView.bounds.size.width + _title.bounds.size.width + distanceH;
        CGFloat pointX = (self.bounds.size.width - width) / 2;
        _titleImageView.center = CGPointMake(pointX + _titleImageView.bounds.size.width/2, self.bounds.size.height/2 - distanceV);
        _title.center = CGPointMake(_titleImageView.frame.origin.x + _titleImageView.bounds.size.width + distanceH + _title.bounds.size.width/2, self.bounds.size.height/2 - distanceV);
        _titleImageView.hidden = NO;
        _title.hidden = NO;
    }else if(image && !title) {
        _titleImageView.image = image;
        _titleImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - distanceV);
        _titleImageView.hidden = NO;
    }else if(!image && title){
        _title.text = title;
        [_title sizeToFit];
        _title.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - distanceV);
        _title.hidden = NO;
    }
    
}
//根据方位去除division分隔图
- (void) removeDivisionsAtLeft:(BOOL)isLeft {
    dmpLocation location = (isLeft == YES ? DmpDivisionAtLeft:DmpDivisionAtRight);
    for (UIView * division in self.subviews) {
        if(division.tag == location)
            [division removeFromSuperview];
    }
}
#pragma mark 外部调用
-(void)setDMPNaviBarItemsWithArray:(NSArray *)array isLeft:(BOOL)isleft {
    [self setItemsWithCustomViewFromArray:array isLeft:isleft];
}
- (void)setDMPNaviBarTitleViewWithTitle:(NSString *)title signImageName:(NSString *)imageName {
    [self setKitTitleViewWithTitle:title signImage:[UIImage imageNamed:imageName]];
}
- (void)setDMPNaviBarTitleViewSignImageViewSize:(CGSize)size {
    _titleImageView.bounds = CGRectMake(0, 0, size.width, size.height);
}
@end
