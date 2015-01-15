//
//  LLCGodFoodView.m
//  只能选材
//
//  Created by yxx on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCGodFoodView.h"

#import "LLCGodFoodCell.h"

#import "LLCGodFoodModel.h"
#import "LLCSubFoodModel.h"
#import <QuartzCore/QuartzCore.h>

#define kColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]

#define kSingleNumber_Color kColorWithRGBA(226,222,208,1)
#define kDoubleNumber_Color kColorWithRGBA(226,216,202,1)
#define kFont_Color kColorWithRGBA(47,41,31,1)

#define kTableView_Width 141

@interface LLCGodFoodView ()
<UITableViewDataSource,
UITableViewDelegate>
@end

@implementation LLCGodFoodView

- (id)initWithFrame:(CGRect)frame andTableBackgroungColor:(UIColor *)color
{
  self = [super initWithFrame:frame];
  if (self) {
    [self layoutSelf:color];
  }
  return self;
}

#pragma mark - 布局
- (void)layoutSelf:(UIColor *)color {
  // 标题
  self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width, 30)];
  self.titleLabel.textColor = kFont_Color;
  self.titleLabel.backgroundColor = [UIColor clearColor];
  self.titleLabel.font = [UIFont systemFontOfSize:15];
  [self addSubview:self.titleLabel];
  
  // 表背景
  UIView *tableBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, self.titleLabel.frame.size.height+5, kTableView_Width, self.frame.size.height-self.titleLabel.frame.size.height-10)];
  tableBackgroundView.backgroundColor = color;
  [self addSubview:tableBackgroundView];
  tableBackgroundView.layer.cornerRadius = 4;
  
  // 表
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, tableBackgroundView.bounds.size.width, tableBackgroundView.bounds.size.height-5-5) style:UITableViewStylePlain];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.backgroundColor = [UIColor clearColor];
  self.tableView.separatorColor = [UIColor clearColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [tableBackgroundView addSubview:self.tableView];
}

#pragma mark - TableView DataSouce
#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSInteger number = self.dataArray.count;
  if (number % 2 == 0) {
    return number / 2 > 4 ? number / 2 : 5;
  } else {
    return (number + 1) / 2 > 4 ? (number + 1) / 2 : 5;
  }
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *LLCGodFoodCellIdentifier = @"GodFoodCell";
  LLCGodFoodCell *cell = [tableView dequeueReusableCellWithIdentifier:LLCGodFoodCellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"LLCGodFoodCell" owner:self options:nil] lastObject];
  }
  
  // 分左右取数据模型展示
  if (indexPath.row*2 < _dataArray.count) { // 左
    LLCSubFoodModel *modelLeft = [self.dataArray objectAtIndex:indexPath.row*2];
    
    cell.titleLeft.text = modelLeft.foodName;
    cell.pictureLeft.image = [UIImage imageNamed:modelLeft.foodImagName];
    
    if (!cell.backgroundImageViewLeft.userInteractionEnabled) {
      
      // 为图片加点击手势
      cell.backgroundImageViewLeft.userInteractionEnabled = YES;
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIt:)];
      [cell.backgroundImageViewLeft addGestureRecognizer:tap];
      cell.backgroundImageViewLeft.tag = indexPath.row*2;
    }
  }
  
  if (indexPath.row*2+1 < _dataArray.count) { // 右
    LLCSubFoodModel *modelRight = [self.dataArray objectAtIndex:indexPath.row*2+1];
    cell.titleRight.text = modelRight.foodName;
    //    cell.pictureRight.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:modelRight.foodImagName ofType:nil]];
    cell.pictureRight.image = [UIImage imageNamed:modelRight.foodImagName];
    if (!cell.backgroundImageViewRight.userInteractionEnabled) {
      cell.backgroundImageViewRight.userInteractionEnabled = YES;
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIt:)];
      [cell.backgroundImageViewRight addGestureRecognizer:tap];
      cell.backgroundImageViewRight.tag = indexPath.row*2+1;
    }
  }
  
  return cell;
}

- (void)reloadData {
  [self.tableView reloadData];
}

#pragma mark - TabelView Delegate
#pragma mark 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 71;
}

#pragma mark 选择cell
- (void)tapIt:(UITapGestureRecognizer *)tap {
  
  LLCSubFoodModel *model = [self.dataArray objectAtIndex:tap.view.tag];
  if (self.target && [self.target respondsToSelector:self.action]) {
    [self.target performSelector:self.action withObject:model];
  }
}

@end
