//
//  DMPFoodCell.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPFoodCell.h"

@implementation DMPFoodCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
  }
  return self;
}
- (void)foodCellSetAllImgViewAppear {
  self.foodCollectImgView.hidden = NO;
  self.foodImgView.hidden = NO;
  self.foodEdgeView.hidden = NO;
  self.foodTypeView.hidden = NO;
  self.ClickCountView.hidden = NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
  self.freeLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
  CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI / 6);
  self.freeLabel.transform = trans;
}

@end
