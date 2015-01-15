//
//  DMPShakeResultView.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-21.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPShakeResultView.h"

@implementation DMPShakeResultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)layoutSubviews {
    self.imgView.frame = self.bounds;
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
