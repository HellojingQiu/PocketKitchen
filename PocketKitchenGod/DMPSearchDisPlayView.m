//
//  DMPSearchDisPlayView.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSearchDisPlayView.h"

@implementation DMPSearchDisPlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//当displayer的frame改变时,调用此方法
- (void)layoutSubviews {
    self.searchBgView.frame = self.bounds;
    self.searchNameLabel.frame = CGRectMake(5, 0, self.bounds.size.width * 0.7, self.bounds.size.height);
    self.searchCloseBtn.center = CGPointMake(self.bounds.size.width - self.searchCloseBtn.bounds.size.width / 2, self.bounds.size.height/2);

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
